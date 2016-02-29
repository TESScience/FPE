#!/usr/bin/env python2.7

import signal


class TimeOutError(Exception):
    pass


class TimeOut:
    def __init__(self, seconds=0.001, error_message='Timeout'):
        self.seconds = seconds
        self.error_message = error_message

    def handle_timeout(self, signum, frame):
        raise TimeOutError(self.error_message)

    def __enter__(self):
        signal.signal(signal.SIGALRM, self.handle_timeout)
        signal.setitimer(signal.ITIMER_REAL, self.seconds)

    def __exit__(self, *_):
        signal.setitimer(signal.ITIMER_REAL, 0)


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

    def __exit__(self, *_):
        """Cleanup for object in `with` context"""
        return self.close()

    def send(self, command):
        """Send a string to the FPE DHU controller"""
        self.socket.sendall((b'\n' + command + b'\n').encode())

    def send_command(self, command, reply_pattern, chars=1024, matches=1, timeout=0.1, retries=8):
        """Send a command to the FPE"""
        from time import sleep
        t = None
        sleep_time = 0.03125
        for trial in range(retries):
            try:
                with TimeOut(seconds=timeout,
                             error_message="Timeout on trial {}".format(trial + 1)):
                    self.socket.sendall((command + b'\n').encode())
                    data = self.wait_for_pattern(
                        reply_pattern,
                        matches=matches,
                        chars=chars)
                    return data.rstrip('\n\r')
            except TimeOutError as e:
                sleep(sleep_time * 2**trial)
                t = e
        raise t

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
