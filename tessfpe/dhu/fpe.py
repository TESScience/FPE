#!/usr/bin/env python2.7
from ops import OperatingParameters

import os
import house_keeping
import binary_files


def ping():
    """Ping the Observation Simulator to make sure it is alive"""
    from sh import ping
    out = ping('-c', '1', '-t', '1', '192.168.100.1')

    return ('1 packets transmitted, 1 packets received' in str(out) or  # MacOSX
            '1 packets transmitted, 1 received' in str(out))  # Centos


def reverse_bytes32(n):
    """Reverses the bytes of a 32 bit integer"""
    return reduce(lambda x, i: x + (((n >> 8 * i) & 0xFF) << (8 * (3 - i))), range(4), 0)


class FPE(object):
    """An object for interacting with an FPE in an Observatory Simulator"""

    def __init__(self,
                 number,
                 debug=False,
                 sanity_checks=True):
        from fpesocketconnection import FPESocketConnection
        from unit_tests import check_house_keeping_voltages

        # First sanity check: ping the observatory simulator
        if not ping():
            raise Exception("Cannot ping 192.168.100.1")
        self._debug = debug
        self._dir = os.path.dirname(os.path.realpath(__file__))
        self._reset_in_progress = False
        self.fpe_number = number
        self.connection = FPESocketConnection(5554 + number, self._debug)

        # self.ops implemented with lazy getter
        self._ops = None

        # Second sanity check: check if frames are running, get the observatory simulator version
        original_frames_running_status = None
        if sanity_checks:
            try:
                original_frames_running_status = self.frames_running_status
            except Exception as e:
                raise type(e)(
                    "Could not read if frames are running on the Observatory Simulator... {0}\n".format(str(e)) +
                    "Are you sure the firmware for the Observatory Simulator is properly installed?")
            try:
                version = self.version
                if self._debug:
                    print version
            except Exception as e:
                raise type(e)("Could not read Observatory Simulator version... {0}\n".format(str(e)) +
                              "Are you sure you firmware for the Observatory Simulator is properly installed?")

        # Run sanity checks on the FPE to make sure basic functions are working (if specified)
        if sanity_checks:
            check_house_keeping_voltages(self)
            if original_frames_running_status is not None:
                self.frames_running_status = original_frames_running_status

    def load_wrapper(self, wrapper_version='6.1t.4'):
        import os.path
        from unit_tests import check_house_keeping_voltages, UnexpectedHousekeeping
        from fpesocketconnection import TimeOutError
        fpe_wrapper_bin = os.path.join(self._dir, "MemFiles",
                                       "FPE_Wrapper-{version}.bin".format(version=wrapper_version))

        assert os.path.isfile(fpe_wrapper_bin), "Wrapper does not exist for version {}".format(wrapper_version)
        status = self.frames_running_status
        try:
            self.frames_running_status = False
            self.cmd_hsk(retries=1)
            check_house_keeping_voltages(self)
            return "House keeping reports sane values for reference voltages," \
                   " *NOT* loading wrapper (tried to load version {})".format(wrapper_version)
        except (UnexpectedHousekeeping, TimeOutError):
            self.cmd_rst(upload=False, sanity_checks=False)
            # assert "Cam FPGA done." in self.cmd_fpga_rst(), "Could not reset the FPGA"
            assert "Resetting Cam FPGA" in self.cmd_fpga_rst(), "Could not reset the FPGA"
            assert self.upload_fpe_wrapper_bin(fpe_wrapper_bin), "Could not load wrapper: {}".format(fpe_wrapper_bin)
            assert self.cmd_rst(upload=True, sanity_checks=False), "Could not reset camera"
            # Set the housekeeping memory to the identity map
            assert self.upload_housekeeping_memory(
                binary_files.write_hskmem(
                    house_keeping.identity_map)), "Could not load house keeping memory: {}".format(house_keeping_memory)
            # Set the operating parameters to their defaults
            assert self.ops.reset_to_defaults(), "Could not send operating parameters"
            check_house_keeping_voltages(self)
            return "Wrapper version {} loaded successfully".format(wrapper_version)
        finally:
            self.frames_running_status = status

    def close(self):
        """Close the fpe object (namely its socket connection)"""
        return self.connection.close()

    def __enter__(self):
        """Enter the python object, used for context management.  See: https://www.python.org/dev/peps/pep-0343/"""
        return self

    def __exit__(self, *_):
        """Exit the python object, used for context management.  See: https://www.python.org/dev/peps/pep-0343/"""
        return self.close()

    def tftp_put(self, file_name, destination):
        """Upload a file to the FPE"""
        from sh import tftp, ErrorReturnCode_1
        import re
        import os.path
        assert os.path.isfile(file_name), "Could not find file for TFTP upload: {}".format(file_name)
        tftp_mode = "mode binary"
        tftp_port = "connect 192.168.100.1 {}".format(68 + self.fpe_number)
        tftp_file = "put {} {}".format(file_name, destination)
        tftp_command = "\n" + tftp_mode + "\n" + tftp_port + "\n" + tftp_file

        status = self.frames_running_status
        try:
            if self._debug:
                print "Running:\ntftp <<EOF\n", \
                    tftp_command, "\n", \
                    "EOF"
            self.frames_running_status = False
            try:
                tftp(_in=tftp_command)
            except ErrorReturnCode_1 as e:
                # tftp *always* fails on OS X because it's awesome
                # so just check that it reports in stdout it sent the thing
                if self._debug:
                    print e
                if not re.match(r'Sent [0-9]+ bytes in [0-9]+\.[0-9]+ seconds',
                                e.stdout):
                    raise e
            # Wait for the fpe to report the load is complete
            self.connection.wait_for_pattern(r'.*Load complete\n\r')
            return True
        finally:
            self.frames_running_status = status

    def cmd_rst(self, upload=True, sanity_checks=True):
        """Reset the camera after running frames"""
        from unit_tests import check_house_keeping_voltages
        if self._reset_in_progress:
            return False
        self._reset_in_progress = True
        self.cmd_stop_frames()
        assert 'FPE Reset complete' in self.connection.send_command(
            'camrst',
            reply_pattern='FPE Reset complete'), "Could not successfully issue camera reset command"
        # Clear cam_control
        self.control_status = 1
        status = self.control_status
        assert status is 0, "camera control status memory could not zeroed, was {}".format(hex(status))
        if sanity_checks or upload:
            register_memory = os.path.join(self._dir, 'MemFiles', 'Reg.bin')
            assert self.upload_register_memory(register_memory), \
                'Could not load register memory: {}'.format(register_memory)
        if sanity_checks:
            check_house_keeping_voltages(self)
        self._reset_in_progress = False
        return True

    def cmd_status(self):
        """Get the camera status"""
        response = self.connection.send_command(
            "cam_status",
            reply_pattern="cam_status = 0x[0-9a-f]+")[13:]
        return int(response, 16)

    def cmd_control(self, val=None):
        """Get the camera control status"""
        response = self.connection.send_command(
            "cam_control" if val is None else "cam_control = {}".format(val),
            reply_pattern="cam_control = 0x[0-9a-f]+")[14:]
        return int(response, 16)

    def cmd_version(self):
        """Get the version of the Observatory Simulator DHU software"""
        import re
        # Frames must be stopped to read version, otherwise the observatory simulator will not respond
        status = self.frames_running_status
        try:
            self.frames_running_status = False
            return \
                re.sub(r'FPE[0-9]>', '',
                       self.connection.send_command(
                           "version",
                           reply_pattern="Observatory Simulator Version .*"))
        finally:
            self.frames_running_status = status

    def cmd_fpga_rst(self):
        """Reset the FPGA so that another wrapper can be uploaded"""
        assert self.cmd_rst(upload=False, sanity_checks=False), "Could not reset camera"
        return self.connection.send_command(
            "cam_fpga_rst",
            # TODO: switch on "Cam FPGA done."
            reply_pattern="Resetting Cam FPGA",
            timeout=3
        )

    def cmd_start_frames(self):
        """Start running frames"""
        if self.frames_running_status is True:
            return "Control status indicates frames are already running"
        return self.connection.send_command(
            "cam_start_frames",
            reply_pattern="(Starting frames...|Frames already enabled)"
        )

    def cmd_stop_frames(self):
        """Stop running frames"""
        if self.frames_running_status is False:
            return "Control status indicates frames are already stopped;" \
                   " however the FPE may not be safely in debug mode"
        assert "Frames Stopped..." in self.connection.send_command(
            "cam_stop_frames",
            reply_pattern="Frames Stopped...")
        self.cmd_rst()
        assert self._reset_in_progress is False, "Reset should no longer be in progress"
        return "Frames have been stopped and the FPE has been placed in debug mode"

    def cmd_hsk(self, retries=None):
        """Get the camera housekeeping data, outputs an array of the housekeeping data"""
        import re
        channels = 128
        # TODO: switch on whether frames have been started and use obsim
        status = self.frames_running_status
        try:
            self.frames_running_status = False
            out = self.connection.send_command(
                "cam_hsk",
                reply_pattern="Hsk\[[0-9]+\] = 0x[0-9a-f]+",
                matches=channels,
                retries=retries
            )
            return [int(n, 16) for n in re.findall('0x[0-9a-f]+', out)]
        finally:
            self.frames_running_status = status

    def cmd_clv(self):
        """Get the clock voltage memory, returns the twelve bit values"""
        import re
        entries = 64
        status = self.frames_running_status
        try:
            self.frames_running_status = False
            out = self.connection.send_command(
                "cam_clv",
                reply_pattern="FpeClv\[[0-9]+\] = 0x[0-9a-f]+",
                matches=entries
            )
            return [(reverse_bytes32(int(n, 16)) >> shift) & mask
                    for n in re.findall('0x[0-9a-f]+', out)
                    for (mask, shift) in [(0x0FFF, 16), (0x00000FFF, 0)]]
        finally:
            self.frames_running_status = status

    def compile_and_load_fpe_program(self, program):
        """Loads the program code using tftp"""
        from ..sequencer_dsl.program import compile_programs
        from ..sequencer_dsl.sequence import compile_sequences
        from ..sequencer_dsl.parse import parse_file
        ast = parse_file(program)
        sequencer_byte_code = binary_files.write_seqmem(compile_sequences(ast))
        program_byte_code = binary_files.write_prgmem(compile_programs(ast))
        return self.upload_sequencer_memory(sequencer_byte_code) and self.upload_program_memory(program_byte_code)

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
    def house_keeping(self):
        """Return the house keeping as a map"""
        hsk = self.cmd_hsk()
        # Create a dictionary of the analogue outputs
        analogue = house_keeping.hsk_to_analogue_dictionary(hsk)
        # Create array of digital outs
        digital = house_keeping.hsk_to_digital_dictionary(
            [k for i in range(0, 128, 32)
             for j in hsk[17 + i:24 + i]
             for k in house_keeping.unpack_pair(j)])
        return {"analogue": analogue,
                "digital": digital}

    @property
    def analogue_house_keeping_with_units(self):
        hsk = self.cmd_hsk()
        return house_keeping.hsk_to_analogue_dictionary_with_units(hsk)

    @property
    def version(self):
        """Version property for the Observatory Simulator DHU software"""
        return self.cmd_version()

    @property
    def status(self):
        """Get the camera status for the Observatory Simulator for a particular FPE"""
        return self.cmd_status()

    @property
    def control_status(self):
        """Get the camera control status for the Observatory Simulator for a particular FPE"""
        return self.cmd_control()

    @control_status.setter
    def control_status(self, val):
        "Set the camera control status for the Observatority Simulator for a particular FPE"
        self.cmd_control(val)

    @property
    def expected_housekeeping(self):
        """Report the expected values for the housekeeping"""
        from copy import deepcopy
        from ..data.housekeeping_channels import housekeeping_channels
        from ..dhu.unit_tests import voltage_reference_values, temperature_sensor_calibration_values
        expected_values = deepcopy(self.ops.values)
        for k in housekeeping_channels:
            if 'bias' in k:
                expected_values[k] = 0
        for v in voltage_reference_values:
            expected_values[v] = voltage_reference_values[v]
        for v in temperature_sensor_calibration_values:
            expected_values[v] = temperature_sensor_calibration_values[v]
        return expected_values

    @property
    def ops(self):
        if self._ops is None:
            self._ops = OperatingParameters(self)
        return self._ops

    @property
    def frames_running_status(self):
        """Check if frames are being run or not"""
        return (0b10 & self.control_status) == 0b10

    @frames_running_status.setter
    def frames_running_status(self, value):
        """Set if frames are running or not"""
        if value is self.frames_running_status:
            pass
        elif value is True and self.frames_running_status is not True:
            self.cmd_start_frames()
        elif value is False and self.frames_running_status is not False:
            self.cmd_stop_frames()
        else:
            raise Exception("Trying to set frames_running_status to value that is not boolean: {0}".format(value))

    def upload_fpe_wrapper_bin(self, fpe_wrapper_bin):
        """Upload the FPE Wrapper binary file to the FPE"""
        return self.tftp_put(
            fpe_wrapper_bin,
            "bitmem" + str(self.fpe_number))

    def upload_sequencer_memory(self, sequencer_memory):
        """Upload the Sequencer Memory to the FPE"""
        return self.tftp_put(
            sequencer_memory,
            "seqmem" + str(self.fpe_number))

    def upload_register_memory(self, register_memory):
        """Upload the Register Memory to the FPE"""
        return self.tftp_put(
            register_memory,
            "regmem" + str(self.fpe_number))

    def upload_program_memory(self, program_memory):
        """Upload the Program Memory to the FPE"""
        return self.tftp_put(
            program_memory,
            "prgmem" + str(self.fpe_number))

    def upload_operating_parameter_memory(self, operating_parameter_memory):
        """Upload the Operating Parameter Memory to the FPE"""
        return self.tftp_put(
            operating_parameter_memory,
            "clvmem" + str(self.fpe_number))

    def upload_housekeeping_memory(self, hsk_memory):
        """Upload the Operating Parameter Memory to the FPE"""
        return self.tftp_put(
            hsk_memory,
            "hskmem" + str(self.fpe_number))
