#!/usr/bin/env python
"""
A module that wraps grako's generated parser as well
as the associated grammatical semantics for the FPE DSL.
"""

from __future__ import print_function

def parse(text):
    "Parses some SequencerDSL text into an AST"
    from SequencerDSLParser import SequencerDSLParser
    from ast import strip_block_comments, Semantics
    comment_stripped_text = strip_block_comments(text)
    parser = SequencerDSLParser(whitespace='\t ;\n')
    semantics = Semantics()
    ast = parser.parse(comment_stripped_text, 
                       rule_name='readout',
                       semantics=semantics)
    ast["parameters"] = semantics.parameters
    ast["sequences"] = semantics.sequences
    return ast

def parse_file(file_name):
    "Parses a file containing SequencerDSL text into an AST"
    with open(file_name) as f:
        return parse(f.read())

if __name__ == "__main__":
    from sys import argv
    import json
    ast = parse_file(argv[1])
    print(json.dumps(ast, indent=2))
