#!/usr/bin/env python


class FPE(object):
    """An object for interacting with an FPE in an Observatory Simulator"""

    def __init__(self, port):
        from fpesocketconnection import FPESocketConnection
        if not self.ping():
            raise Exception("Cannot ping 192.168.100.1")
        self.connection = FPESocketConnection(port)

    @staticmethod
    def ping():
        """Ping the Observation Simulator to make sure it is alive"""
        from sh import ping
        out = ping('-c', '1', '-t', '1', '192.168.100.1')
        return '1 packets transmitted, 1 packets received' in str(out)

    def cam_status(self):
        """Get the camera status"""
        return self.connection.send_command("cam_status")

    def cam_return(self):
        """Get the camera status"""
        return self.connection.send_command("")


if __name__ == "__main__":
    fpe1 = FPE(5555)
    print fpe1.ping()
#    print fpe1.cam_status()
    #print fpe1.cam_return()
