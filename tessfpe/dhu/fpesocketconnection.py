#!/usr/bin/env python


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

    def send_command(self, command, chars=1024, matches=1, prompt_skips=10, pattern=None):
        """Send a command to the FPE"""
        import re
        self.socket.sendall((command + b'\n').encode())
        data = ''
        if pattern:
            data = self.wait_for_pattern(
                pattern,
                matches=matches,
                chars=chars)
        else:
            for _ in range(prompt_skips):
                # Skip the prompt until we get real data
                data = self.socket.recv(chars)
                if self._debug:
                    print data,
                if not re.match(r'FPE[1-9]> ', data):
                    break
        return data.rstrip('\n\r')

    def wait_for_pattern(self, pattern, matches=1, chars=1024, seperator='\n'):
        """Dumps output waiting for a specified regex pattern"""
        import re
        out = []
        while len(out) < matches:
            data = None
            while data is None or \
                    not re.match(pattern, data):
                data = str(self.socket.recv(chars)).encode()
                if self._debug:
                    print data,
            out += re.findall(pattern, data)
        return seperator.join(out)

    def wait_for_prompt(self, chars=1024):
        """Dumps output waiting for the FPE Prompt"""
        return self.wait_for_pattern(r'FPE[1-9]> ', chars=chars)

    def get_prompt(self):
        """Gets the FPE prompt"""
        # Send return and wait for the prompt to show up
        self.send("")
        self.wait_for_prompt()