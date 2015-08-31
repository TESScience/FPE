#!/usr/bin/env python

import os.path


class Simulator(object):
    """An object for orchestrating communication with the TESS Focal Plane Electronics Observatory Simulator"""

    def __init__(self,
                 program=os.path.join("data", "files", "default_program.fpe")):
        with open(program) as f:
            self._program = f.read()
        self._compile()

    def _compile(self):
        """Compile the observatory simulator program in Sequencer DSL"""
        from sequencer_dsl import compile_sequencer_dsl
        self._compiled_code = compile_sequencer_dsl(self.program)

    @property
    def ast(self):
        """The Abstract Syntax Tree (AST) for the Sequencer DSL program"""
        return self._compiled_code.ast

    @property
    def compiled_sequences(self):
        """The compiled sequences for the Sequencer DSL program"""
        return self._compiled_code.sequences

    @property
    def compiled_programs(self):
        """The compiled programs for the Sequencer DSL program"""
        return self._compiled_code.programs

    @property
    def program(self):
        """The observatory simulator program"""
        return self._program

    @program.setter
    def program(self, value):
        if self._program == value:
            pass
        else:
            self._program = value
            self._compile()

    @program.deleter
    def program(self):
        del self._program

if __name__ == "__main__":
    sim = Simulator()
    from pprint import pprint
    pprint(sim.program)
    pprint(sim.ast)
    pprint(sim.compiled_programs)
    pprint(sim.compiled_sequences)