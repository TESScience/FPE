#!/usr/bin/env python


def is_prompt(text):
    """Determines if the text contains an FPE prompt"""
    return "FPE1> " in text or \
           "FPE2> " in text or \
           "FPE3> " in text or \
           "FPE4> " in text


class FPESocketConnection(object):
    """An object for encapsulating an open socket connection with the Observatory Simulator"""

    def __init__(self, port):
        import socket
        self.port = port
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, 0)
        self.socket.connect(('192.168.100.1', int(self.port)))
        self.get_prompt()
        self.ready = True

    def close(self):
        """Close the FPE Socket Connection"""
        return self.socket.close()

    def __enter__(self):
        """Return the context guard (in this case, just `self`)"""
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Cleanup for object in `with` context"""
        return self.close()

    def send(self, command):
        """Send a string to the FPE DHU controller"""
        self.socket.sendall((b'\n' + command + b'\n').encode())

    def send_command(self, command, chars=1024):
        """Send a command to the FPE"""
        if not self.ready:
            self.wait_for_prompt()
            self.ready = True
        self.send(command)
        data = self.socket.recv(chars)
        return repr(data)

    def wait_for_prompt(self):
        """Dumps output waiting for the FPE Prompt"""
        out = ""
        while not is_prompt(out):
            out = repr(self.socket.recv(1024)).encode()

    def get_prompt(self):
        """Gets the FPE prompt"""
        # Send return and wait for the prompt to show up
        self.send("")
        self.wait_for_prompt()