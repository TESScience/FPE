#!/usr/bin/env python
from ops import OperatingParameters

import house_keeping
import binary_files


class FPE(object):
    """An object for interacting with an FPE in an Observatory Simulator"""

    def __init__(self, number, debug=False, preload=False, hsk_byte_array=house_keeping.identity_map):
        from fpesocketconnection import FPESocketConnection
        import os
        if not self.ping():
            raise Exception("Cannot ping 192.168.100.1")
        self._debug = debug
        self.fpe_number = number
        self.connection = FPESocketConnection(5554 + number, self._debug)
        self._dir = os.path.dirname(os.path.realpath(__file__))

        # Default memory configuration files
        self.fpe_wrapper_bin = os.path.join(self._dir, "MemFiles", "FPE_Wrapper.bin")

        self._program_file = os.path.join(self._dir, "..", "data", "files", "default_program.fpe")

        # TODO: Sunset this
        self.register_memory = os.path.join(self._dir, "MemFiles", "Reg.bin")

        # Set the House Keeping and Operating Parameters
        self.hsk_byte_array = hsk_byte_array
        self.ops = OperatingParameters(self)

        self._safe_to_load_FPE = None

        if preload:
            self.upload_fpe_wrapper_bin(self.fpe_wrapper_bin)
        self.upload_register_memory(self.register_memory)
        self.upload_housekeeping_memory(
            binary_files.write_hskmem(self.hsk_byte_array))
        self.ops.send()
        self.load_code()

    def tftp_put(self, file_name, destination):
        """Upload a file to the FPE"""
        from sh import tftp, ErrorReturnCode_1
        import re
        tftp_mode = "mode binary"
        tftp_port = "connect 192.168.100.1 {}".format(68 + self.fpe_number)
        tftp_file = "put {} {}".format(file_name, destination)
        tftp_command = tftp_mode + "\n" + tftp_port + "\n" + tftp_file

        if self._debug:
            print "Running:\ntftp <<EOF\n", \
                tftp_command, "\n", \
                "EOF"
        try:
            tftp(_in=tftp_command)
        except ErrorReturnCode_1 as e:
            # tftp *always* fails because it's awesome
            # so just check that it reports in stdout it sent the thing
            if self._debug:
                print e
            if not re.match(r'Sent [0-9]+ bytes in [0-9]+\.[0-9]+ seconds',
                            e.stdout):
                raise e

        # Wait for the fpe to report the load is complete
        self.connection.wait_for_pattern(r'.*Load complete\n\r')

    @staticmethod
    def ping():
        """Ping the Observation Simulator to make sure it is alive"""
        from sh import ping
        out = ping('-c', '1', '-t', '1', '192.168.100.1')
        return '1 packets transmitted, 1 packets received' in str(out)

    def cmd_camrst(self):
        """Reset the camera after running frames"""
        # Is it just me, or shouldn't this be "Reset" not "Rest"?
        return self.connection.send_command("camrst", reply_pattern='FPE Rest complete')

    def cmd_cam_status(self):
        """Get the camera status"""
        response = self.connection.send_command(
            "cam_status",
            reply_pattern="cam_status = 0x[0-9a-f]+")[13:]
        val = int(response, 16)
        return val

    def cmd_version(self):
        """Get the version of the Observatory Simulator DHU software"""
        import re
        return \
            re.sub(r'FPE[0-9]>', '',
                   self.connection.send_command(
                       "version",
                       reply_pattern="Observatory Simulator Version .*"))

    def cmd_start_frames(self):
        return self.connection.send_command(
            "cam_start_frames",
            reply_pattern="(Starting frames...|Frames already enabled)"
        )

    def cmd_stop_frames(self):
        return self.connection.send_command(
            "cam_stop_frames",
            reply_pattern="Frames Stopped..."
        )

    def cmd_cam_hsk(self):
        """Get the camera housekeeping data, outputs an array of the housekeeping data"""
        import re
        channels = 128
        # TODO: switch on whether frames have been started
        out = self.connection.send_command(
            "cam_hsk",
            reply_pattern="Hsk\[[0-9]+\] = 0x[0-9a-f]+",
            matches=channels
        )
        return [int(n, 16) for n in re.findall('0x[0-9a-f]+', out)]

    def load_code(self):
        """Loads the program code using tftp"""
        self.upload_sequencer_memory(
            binary_files.write_seqmem(self.sequences_byte_array))
        self.upload_program_memory(
            binary_files.write_prgmem(self.programs_byte_array))

    def capture_frames(self, n):
        """Capture frames"""
        import subprocess
        import os.path
        self.cmd_start_frames()
        proc = subprocess.Popen(
            [os.path.join(self._dir, "..", "fits_capture", "tess_obssim", "tess_obssim"), '-n', str(n)],
            shell=False)
        proc.communicate()
        self.cmd_stop_frames()

    @property
    def sequences_byte_array(self):
        """A byte array representing the sequences set by the program code"""
        from ..sequencer_dsl.sequence import compile_sequences
        return compile_sequences(self._ast)

    @property
    def programs_byte_array(self):
        """A byte array representing the programs set by the program code"""
        from ..sequencer_dsl.program import compile_programs
        return compile_programs(self._ast)

    @property
    def _ast(self):
        from ..sequencer_dsl.parse import parse_file
        return parse_file(self._program_file)

    @property
    def code(self):
        """The program code"""
        with open(self._program_file) as f:
            return "// File: {filename}\n\n{code}".format(
                file=self._program_file,
                code=f.read())

    @property
    def house_keeping(self):
        hsk = self.cmd_cam_hsk()
        # Create a dictionary of the analogue outputs
        analogue = house_keeping.hsk_to_analogue_dictionary(hsk)
        # Create array of digital outs
        digital = [k for i in range(0, 128, 32)
                   for j in hsk[17 + i:24 + i]
                   for k in house_keeping.unpack_pair(j)]
        return {"analogue": analogue,
                "digital": digital}

    @property
    def parameters(self):
        """The parameters set by the program code"""
        return self._ast["parameters"]

    @property
    def hold(self):
        """The hold instruction set by the program code"""
        return self._ast["hold"]

    @property
    def sequences(self):
        """The sequences set by the program code"""
        return self._ast["sequences"]

    @property
    def defaults(self):
        """The sequencer default values set by the program code"""
        return self._ast["defaults"]

    @property
    def version(self):
        """Version property for the Observatory Simulator DHU software"""
        return self.cmd_version()

    @property
    def cam_status(self):
        """Get the camera status for the Observatory Simulator for a particular FPE"""
        return self.cmd_cam_status()

    def upload_fpe_wrapper_bin(self, fpe_wrapper_bin):
        """Upload the FPE Wrapper binary file to the FPE"""
        return self.tftp_put(
            fpe_wrapper_bin,
            "bitmem")

    def upload_sequencer_memory(self, sequencer_memory):
        """Upload the Sequencer Memory to the FPE"""
        # self.camrst()
        return self.tftp_put(
            sequencer_memory,
            "seqmem")

    def upload_register_memory(self, register_memory):
        """Upload the Register Memory to the FPE"""
        return self.tftp_put(
            register_memory,
            "regmem")

    def upload_program_memory(self, program_memory):
        """Upload the Program Memory to the FPE"""
        return self.tftp_put(
            program_memory,
            "prgmem")

    def upload_operating_parameter_memory(self, operating_parameter_memory):
        """Upload the Operating Parameter Memory to the FPE"""
        return self.tftp_put(
            operating_parameter_memory,
            "clvmem")

    def upload_housekeeping_memory(self, hsk_memory):
        """Upload the Operating Parameter Memory to the FPE"""
        return self.tftp_put(
            hsk_memory,
            "hskmem")
