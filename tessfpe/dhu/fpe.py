#!/usr/bin/env python


class FPE(object):
    """An object for interacting with an FPE in an Observatory Simulator"""

    def __init__(self, number, debug=False, initialize=True):
        from fpesocketconnection import FPESocketConnection
        import os
        if not self.ping():
            raise Exception("Cannot ping 192.168.100.1")
        self._debug = debug
        self.fpe_number = number
        self.connection = FPESocketConnection(5554+number, self._debug)
        _dir = os.path.dirname(os.path.realpath(__file__))

        # Default memory configuration files
        self.fpe_wrapper_bin = os.path.join(_dir, "MemFiles", "FPE_Wrapper.bin")
        self.sequencer_memory = os.path.join(_dir, "MemFiles", "Seq.bin")
        self.register_memory = os.path.join(_dir, "MemFiles", "Reg.bin")
        self.program_memory = os.path.join(_dir, "MemFiles", "Prg.bin")
        self.operating_parameter_memory = os.path.join(_dir, "MemFiles", "CLV.bin")
        self.housekeeping_memory = os.path.join(_dir, "MemFiles", "Hsk.bin")
        if initialize:
            self.preload()

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
        # Wait for the fpe to give you a prompt after sending the file
        self.connection.wait_for_prompt()

    @staticmethod
    def ping():
        """Ping the Observation Simulator to make sure it is alive"""
        from sh import ping
        out = ping('-c', '1', '-t', '1', '192.168.100.1')
        return '1 packets transmitted, 1 packets received' in str(out)

    def get_cam_status(self):
        """Get the camera status"""
        return int(self.connection.send_command("cam_status")[13:], 16)

    def get_version(self):
        """Get the version of the Observatory Simulator DHU software"""
        return self.connection.send_command("version")

    @property
    def version(self):
        """Version property for the Observatory Simulator DHU software"""
        return self.get_version()

    @property
    def cam_status(self):
        """Get the camera status for the Observatory Simulator for a particular FPE"""
        return self.get_cam_status()

    def upload_fpe_wrapper_bin(self):
        """Upload the FPE Wrapper binary file to the FPE"""
        return self.tftp_put(
            self.fpe_wrapper_bin,
            "bitmem" + str(self.fpe_number))

    def upload_sequencer_memory(self):
        """Upload the Sequencer Memory to the FPE"""
        return self.tftp_put(
            self.sequencer_memory,
            "seqmem" + str(self.fpe_number))

    def upload_register_memory(self):
        """Upload the Register Memory to the FPE"""
        return self.tftp_put(
            self.register_memory,
            "regmem" + str(self.fpe_number))

    def upload_program_memory(self):
        """Upload the Program Memory to the FPE"""
        return self.tftp_put(
            self.program_memory,
            "prgmem" + str(self.fpe_number))

    def upload_operating_parameter_memory(self):
        """Upload the Operating Parameter Memory to the FPE"""
        return self.tftp_put(
            self.program_memory,
            "clvmem" + str(self.fpe_number))

    def upload_housekeeping_memory(self):
        """Upload the Operating Parameter Memory to the FPE"""
        return self.tftp_put(
            self.housekeeping_memory,
            "hskmem" + str(self.fpe_number))

    def preload(self):
        """Preload all of the memory to the FPE"""
        self.upload_fpe_wrapper_bin()
        self.upload_sequencer_memory()
        self.upload_register_memory()
        self.upload_program_memory()
        self.upload_operating_parameter_memory()
        self.upload_housekeeping_memory()


if __name__ == "__main__":
    fpe1 = FPE(1, debug=True)
    fpe2 = FPE(2, debug=True)
