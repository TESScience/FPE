#!/usr/bin/env python

import os
import tempfile
import uuid


def timing(file_name, sequence_names=None, sequencer_bits=None, debug=False):
    "Create an image of the timing diagrams in an fpe program"
    from wand.image import Image
    return Image(filename=timing_pdf(file_name,
                                     sequence_names=sequence_names,
                                     sequencer_bits=sequencer_bits,
                                     debug=debug))


def timing_pdf(file_name, sequence_names=None, sequencer_bits=None, debug=False):
    """Create a pdf image of the timing diagrams in an fpe program"""
    from ..parse import parse_file
    ast = parse_file(file_name)
    if sequence_names is None:
        sequence_names = ast["sequences"].keys()
    timings = timing_ast(ast, sequence_names, sequencer_bits=sequencer_bits, debug=debug)
    return compile_tikz_timing_diagram(timings, debug=debug)


def timing_ast(ast, sequence_names, sequencer_bits=None, debug=False):
    """Outputs a dictionary of sequences and their timings as lists"""
    return {name: tikz_timing_sequence(ast, name, sequencer_bits=sequencer_bits, debug=debug)
            for name in sequence_names}


def tikz_timing_sequence(ast, sequence_name, sequencer_bits=None, debug=False):
    """Outputs the timings ast list for a particular sequence in an AST."""
    sequence = ast["sequences"][sequence_name]["sequence"]
    if sequencer_bits is None:
        sequencer_bits = list(set(k for i in sequence
                                  for k in i.keys() if k != "steps"))
        sequencer_bits.sort()
        if debug:
            print "No sequencer bits specified, using: {}".format(sequencer_bits)
    if isinstance(sequencer_bits, basestring):
        sequencer_bits = [sequencer_bits]
    defaults = ast["defaults"]
    return (timing_for_bit(sequence, bit, get_default_value(defaults, bit))
            for bit in sequencer_bits)


def tikz_timing_letter(voltage_level):
    """Converts a voltage level to the appropriate tikz timing letter"""
    if voltage_level == "low":
        return "L"
    if voltage_level == "high":
        return "H"
    else:
        raise Exception('Specified voltage level must be either "high" or "low", was: ' + voltage_level)


def get_default_value(defaults, sequencer_bit):
    return tikz_timing_letter(defaults[sequencer_bit]) \
        if sequencer_bit in defaults else "X"


def timing_for_bit(sequence, sequencer_bit, default_value="X"):
    """Create a TikZ timing diagram for sequencer AST for a given sequencer bit"""
    values = []
    level = default_value
    for s in sequence:
        if "steps" in s:
            for _ in range(s["steps"]):
                values.append(level)
        if sequencer_bit in s:
            level = tikz_timing_letter(s[sequencer_bit])
    return (sequencer_bit,
            (default_value if default_value != "X" else "") +
            "".join(values))


def write_tikz_timing_table_file(table_string, file_name=tempfile.mktemp(suffix="tex", prefix="unknown_sequence")):
    """Write a TikZ timing table to a file"""
    with open(file_name, 'w') as f:
        f.write(table_string)
    return file_name


def write_tikz_toplevel_file(table_file_name):
    """Write a LaTeX file for formatting a TikZ timing table"""
    output = """
    \\documentclass[varwidth=\maxdimen]{{standalone}}[2011/12/21]
    \\usepackage{{tikz-timing}}
    \\usetikztiminglibrary{{nicetabs}}

    \\begin{{document}}
    \\input{{"{}"}}
    \\end{{document}}
    """.format(os.path.basename(table_file_name))
    file_name = os.path.join(os.path.dirname(table_file_name), str(uuid.uuid4()) + ".tex")
    with open(file_name, 'w') as f:
        f.write(output)
    return file_name


def write_latex_makefile(latex_file):
    """Write a Makefile for building a LaTeX file using pdflatex"""
    cur_dir = os.path.dirname(os.path.realpath(__file__))
    makefile_template_file_name = os.path.join(cur_dir, "Makefile.template")
    with open(makefile_template_file_name) as f:
        template_text = f.read()
    (base_name, _) = os.path.splitext(os.path.basename(latex_file))
    output = "PDF={}.pdf\n{}".format(base_name, template_text)
    makefile_name = os.path.join(os.path.dirname(latex_file), "Makefile")
    with open(makefile_name, 'w') as f:
        f.write(output)
    return makefile_name


def tikz_timings_diagram(tikz_timings):
    output_rows = ('{} & {} \\\\'.format(b, t) for (b, t) in tikz_timings)
    return """
    \\begin{{tikztimingtable}}
    {}
    \\extracode
    \\tablegrid[black!25,step=1]
    \\end{{tikztimingtable}}
    """.format("\n".join(output_rows))


def named_tikz_timings_diagram(sequence_name, tikz_timings):
    return "\n\\texttt{{" + sequence_name + ":}}\n\n\\par\\bigskip\n" + \
           tikz_timings_diagram(tikz_timings)


def compile_tikz_timing_diagram(tikz_timings,
                                work_dir=tempfile.mkdtemp(),
                                debug=False):
    from sh import make
    output = "".join(named_tikz_timings_diagram(name, timing)
                     for name, timing in tikz_timings.iteritems())
    # tikz_timings_diagram(timing_pairs[0][1])
    table_file_name = os.path.join(work_dir, "tikz_timing_table.tex")
    write_tikz_timing_table_file(output, table_file_name)
    if debug:
        print "Wrote: " + table_file_name
    tikz_tex = write_tikz_toplevel_file(table_file_name)
    if debug:
        print "Wrote: " + tikz_tex
    make_file = write_latex_makefile(tikz_tex)
    if debug:
        print "Wrote: " + make_file
    make_output = make('-C', work_dir)
    if debug:
        print make_output
    return os.path.splitext(tikz_tex)[0] + ".pdf"


if __name__ == "__main__":
    from sys import argv

    print timing_pdf(argv[1], [argv[2]] if len(argv) >= 3 else None, argv[3] if len(argv) >= 4 else None, debug=True)
