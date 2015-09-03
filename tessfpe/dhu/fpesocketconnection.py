#!/usr/bin/env python

def is_prompt(text):
    """Checks to see if text is an FPE prompt, returns a match object if so"""
    import re
    return re.match(r'FPE[1-9]> ', text)


class FPESocketConnection(object):
    """An object for encapsulating an open socket connection with the Observatory Simulator"""

    def __init__(self, port, debug=False):
        import socket
        self.port = port
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, 0)
        self.socket.connect(('192.168.100.1', int(self.port)))
        self._debug = debug
        self.get_prompt()

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

    def send_command(self, command, chars=1024, prompt_skips=10):
        """Send a command to the FPE"""
        self.socket.sendall((command + b'\n').encode())
        data = ''
        for _ in range(prompt_skips):
            # Skip the prompt until we get real data
            data = self.socket.recv(chars)
            if self._debug:
                print data,
            if not is_prompt(data):
                break
        return data.rstrip('\n\r')

    def wait_for_prompt(self, chars=1024):
        """Dumps output waiting for the FPE Prompt"""
        out = ""
        while not is_prompt(out):
            out = str(self.socket.recv(chars)).encode()
            if self._debug:
                print out,

    def get_prompt(self):
        """Gets the FPE prompt"""
        # Send return and wait for the prompt to show up
        self.send("")
        self.wait_for_prompt()