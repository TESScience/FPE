#!/usr/bin/env python
def compile_sequencer_dsl(text):
    """Compile a string containing Sequencer DSL code to:
        - AST
        - Sequence Code
        - Program Code
    """
    from parse import parse
    from sequence import compile_sequences
    from program import compile_programs
    import collections
    ast = parse(text)
    sequences = compile_sequences(ast)
    programs = compile_programs(ast)
    return collections.namedtuple(
        "FPECompilation",
        ["ast", "sequences", "programs"])(ast, sequences, programs)


def compile_sequencer_dsl_file(file_name):
    """Compiles a named file containing Sequencer DSL code to:
        - AST
        - Sequence Code
        - Program Code
    """
    with open(file_name) as f:
        return compile_sequencer_dsl(f.read())

if __name__ == "__main__":
    from pprint import pprint
    from sys import argv
    pprint(dict(
        compile_sequencer_dsl_file(argv[1]).__dict__))
