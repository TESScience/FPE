#!/usr/bin/python

import struct
import sys

usage="""./checkramp.py <namepattern> <starting frame>
for example: ./checkramp.py ./frames/obssim-%d.bin 39
"""
if len(sys.argv) < 3:
    print usage
    sys.exit(-1)

fileno=int(sys.argv[2])
ramp=-1

while True:
    fname = sys.argv[1] % (fileno,)
    try:
        print "checking",fname
        fp = file(fname)
        data = fp.read(2)
        while data:
            (dataval,) = struct.unpack("<H",data)
            if ramp < 0:
                ramp = dataval + 1
            else:
                if dataval <> ramp:
                    print "File: %s Ramp error: data=%04x expected=%04x" \
                        % (fname,ramp,dataval)
                    ramp = dataval
                ramp = ramp + 1
            ramp = ramp & 0xffff
            data = fp.read(2)
        fileno = fileno + 1
    except:
        raise
