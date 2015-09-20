#!/usr/bin/env python
"""
This python module compiles a sequence specified in the FPE DSL to a
1024x36 array suitable for uploading to the TESS FPE Observatory Simulator
"""

sequencer_bits = {
  "P1-U" : 35,
  "P2-U" : 34,
  "P3-U" : 33,
  "P1-IA-4" : 32,
  "P2-IA-4" : 31,
  "P3-IA-4" : 30,
  "P1-IA-3" : 29,
  "P2-IA-3" : 28,
  "P3-IA-3" : 27,
  "P1-IA-2" : 26,
  "P2-IA-2" : 25,
  "P3-IA-2" : 24,
  "P1-IA-1" : 23,
  "P2-IA-1" : 22,
  "P3-IA-1" : 21,
  "P1-FS-4" : 20,
  "P2-FS-4" : 19,
  "P3-FS-4" : 18,
  "P1-FS-3" : 17,
  "P2-FS-3" : 16,
  "P3-FS-3" : 15,
  "P1-FS-2" : 14,
  "P2-FS-2" : 13,
  "P3-FS-2" : 12,
  "P1-FS-1" : 11,
  "P2-FS-1" : 10,
  "P3-FS-1" : 9,
  "P1-OR" : 8,
  "P2-OR" : 7,
  "P3-OR" : 6,
  "RG" : 5,
  "ID" : 4,
  "Int" : 3,
  "DeInt" : 2,
  "Clamp" : 1,
  "CNV" : 0
}

def sequence_to_int(s,current_value=0):
    out = current_value
    for n,v in s.iteritems():
        if v == "high":
            out |= 1 << sequencer_bits[n]
        if v == "low":
            out &= (2**36 - 1) ^ (1 << sequencer_bits[n])  
    return out

def compile_sequences(ast):
    """Compile a dictionary of sequences into a 1024x36 array"""
    default_value = sequence_to_int(ast["defaults"])
    out = [default_value for _ in range(1024)]
    sequences = ast["sequences"] if "sequences" in ast else ast
    for x in sequences.itervalues():
        idx = x["start"]
        val = out[idx]
        for s in x["sequence"]:
            if "steps" in s:
                for _ in range(s["steps"]):
                    out[idx] = val
                    idx += 1
            else:
                val = sequence_to_int(s, current_value=val)
                out[idx] = val
    return out

def compile_sequences_from_file(file_name):
    """Compile sequences from a file name"""
    from parse import parse_file
    return compile_sequences(parse_file(file_name))

def binary(i):
    """The binary equivalent of the `hex` function"""
    # TODO: optional number of 0 padding
    return "0b{0:036b}".format(i)

if __name__ == "__main__":
    from sys import argv
    ast = compile_sequences_from_file(argv[1])
    print '['
    for i in out[:-1]:
        print '    {},'.format(binary(i))
    print '    {}'.format(binary(i))
    print ']'
