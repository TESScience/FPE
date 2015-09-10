#!/usr/bin/env python

data_type_codes = {
    "no_data": 0b10,
    "pixel_data": 0b00
}

def compile_do_program(prog, sequences):
    "Compile a do loop program into a number"
    res = []
    for p in prog["body"]:
        out = 0
        start = sequences[p["sequence"]]["start"]
        end = sequences[p["sequence"]]["end"]
        out |= start << 37
        out |= end << 27
        out |= p["RPT"] << 13
        out |= data_type_codes[p["DATA_TYPE"]] << 1
        out |= 1 if "frame" in prog else 0
        res.append(out)
    out = 0
    out |= 1 << 26
    out |= prog["do"] << 13
    out |= prog["body"][0]["idx"] << 4
    out |= 0b10 << 1
    out |= 1 if "frame" in prog else 0
    res.append(out)
    return res

def compile_ordinary_program(prog, sequences):
    "Compile a program into a number"
    if prog["sequence"] not in sequences:
        raise Exception("Unknown sequence: " + prog["sequence"])
    out = 0
    start = sequences[prog["sequence"]]["start"]
    end = sequences[prog["sequence"]]["end"]
    out |= start << 37
    out |= end << 27
    out |= prog["RPT"] << 13
    out |= data_type_codes[prog["DATA_TYPE"]] << 1
    out |= 1 if "frame" in prog else 0
    return [out]

def compile_program(prog, sequences):
    "Compile a program, either a do program or a regular program"
    if "do" in prog:
        return compile_do_program(prog, sequences)
    else:
        return compile_ordinary_program(prog, sequences)

def hold_program(sequence_name, sequences):
    "Compile a hold program into a number"
    if sequence_name not in sequences:
        raise Exception("Unknown sequence: " + sequence_name)
    out = 0
    start = sequences[sequence_name]["start"]
    end = sequences[sequence_name]["end"]
    out |= start << 37
    out |= end << 27
    out |= 1 << 3 # hold bit
    out |= data_type_codes["no_data"] << 1
    return [out]

def number_programs(programs):
    idx = 0
    for i in range(len(programs)):
        p = dict(programs[i])
        if "do" in p:
            for j in range(len(p["body"])):
                q = dict(p["body"][j])
                q["idx"] = idx
                idx += 1
                p["body"][j] = q
        p["idx"] = idx
        idx += 1
        programs[i] = p

def compile_programs(ast):
    "Compile a list of programs in an ast into a list of numbers"
    sequences = ast["sequences"]
    number_programs(ast["programs"])
    return [y for x in ast["programs"]
	      for y in compile_program(x, sequences)] + \
	   hold_program(ast["hold"], sequences)

if __name__ == "__main__":
    from parse import parse_file
    from sys import argv
    from pprint import pprint
    ast = parse_file(argv[1])
    out = compile_programs(ast)
    pprint(out)
