#!/usr/bin/env python
from ops import OperatingParameters

import house_keeping
import binary_files


class FPE(object):
    """An object for interacting with an FPE in an Observatory Simulator"""

    def __init__(self, number, hsk_data=house_keeping.bit_data, debug=False, preload=True):
        from fpesocketconnection import FPESocketConnection
        import os
        if not self.ping():
            raise Exception("Cannot ping 192.168.100.1")
        self._debug = debug
        self.fpe_number = number
        self.connection = FPESocketConnection(5554 + number, self._debug)
        _dir = os.path.dirname(os.path.realpath(__file__))

        # Default memory configuration files
        self.fpe_wrapper_bin = os.path.join(_dir, "MemFiles", "FPE_Wrapper.bin")

        # TODO: Sunset these
        self.sequencer_memory = os.path.join(_dir, "MemFiles", "Seq.bin")
        self.register_memory = os.path.join(_dir, "MemFiles", "Reg.bin")
        self.program_memory = os.path.join(_dir, "MemFiles", "Prg.bin")

        # Set the House Keeping and Operating Parameters
        self.hsk_data = hsk_data
        self.ops = OperatingParameters(self)

        if preload:
            self.upload_fpe_wrapper_bin(self.fpe_wrapper_bin)
        self.upload_sequencer_memory(self.sequencer_memory)
        self.upload_register_memory(self.register_memory)
        self.upload_program_memory(self.program_memory)
        self.ops.send()
        self.upload_housekeeping_memory(binary_files.write_hskmem(self.hsk_data))

    def tftp_put(self, file_name, destination):
        """Upload a file to the FPE"""
        from sh import tftp, ErrorReturnCode_1
        import re
        tftp_command = "put {} {}".format(file_name, destination)

        if self._debug:
            print "Running:\ntftp -e 192.168.100.1 69 <<EOF\n", \
                tftp_command, "\n", \
                "EOF"
        try:
            tftp('-e', '192.168.100.1', '69', _in=tftp_command)
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

    def camrst(self):
        """Reset the camera after running frames"""
        # Is it just me, or shouldn't this be "Reset" not "Rest"?
        return self.connection.send_command("camrst", pattern='FPE Rest complete')

    def get_cam_status(self):
        """Get the camera status"""
        return int(self.connection.send_command("cam_status")[13:], 16)

    def get_version(self):
        """Get the version of the Observatory Simulator DHU software"""
        return self.connection.send_command("version")

    def get_cam_hsk(self):
        """Get the camera HSK"""
        import re
        from ..data.housekeeping_channels import housekeeping_channel_memory_map
        channels = 114
        out = self.connection.send_command(
            "cam_hsk",
            pattern="Hsk\[[0-9]+\] = 0x[0-9a-f]+",
            matches=channels
        )
        vals = [int(n, 16) for n in re.findall('0x[0-9a-f]+', out)]
        return dict(zip(housekeeping_channel_memory_map, vals))

    @property
    def version(self):
        """Version property for the Observatory Simulator DHU software"""
        return self.get_version()

    @property
    def cam_status(self):
        """Get the camera status for the Observatory Simulator for a particular FPE"""
        return self.get_cam_status()

    def upload_fpe_wrapper_bin(self, fpe_wrapper_bin):
        """Upload the FPE Wrapper binary file to the FPE"""
        return self.tftp_put(
            fpe_wrapper_bin,
            "bitmem" + str(self.fpe_number))

    def upload_sequencer_memory(self, sequencer_memory):
        """Upload the Sequencer Memory to the FPE"""
        # self.camrst()
        return self.tftp_put(
            sequencer_memory,
            "seqmem" + str(self.fpe_number))

    def upload_register_memory(self, register_memory):
        """Upload the Register Memory to the FPE"""
        # self.camrst()
        return self.tftp_put(
            register_memory,
            "regmem" + str(self.fpe_number))

    def upload_program_memory(self, program_memory):
        """Upload the Program Memory to the FPE"""
        # self.camrst()
        return self.tftp_put(
            program_memory,
            "prgmem" + str(self.fpe_number))

    def upload_operating_parameter_memory(self, operating_parameter_memory):
        """Upload the Operating Parameter Memory to the FPE"""
        # self.camrst()
        return self.tftp_put(
            operating_parameter_memory,
            "clvmem" + str(self.fpe_number))

    def upload_housekeeping_memory(self, hsk_memory):
        """Upload the Operating Parameter Memory to the FPE"""
        # self.camrst()
        return self.tftp_put(
            hsk_memory,
            "hskmem" + str(self.fpe_number))


if __name__ == "__main__":
    # Note, to run this diagnostic the computer needs to be hooked up
    fpe1 = FPE(1, debug=True, preload=False)
    print fpe1.version
    print hex(fpe1.cam_status)
    print '--------------------\n', fpe1.get_cam_hsk()
    # fpe2 = FPE(2, debug=True, preload=True)
    # print fpe2.version
    # print hex(fpe2.cam_status)
    # print fpe2.get_cam_hsk()
