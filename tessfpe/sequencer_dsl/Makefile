FPE_SCRIPTS=$(wildcard examples/*.fpe)
FPE_TESTS=$(patsubst examples/%.fpe, %_test, $(FPE_SCRIPTS))
.PHONY: all clean test

all: SequencerDSLParser.py

%_test: examples/%.fpe SequencerDSLParser.py
	./parse.py $<
	./sequence.py $<
	./program.py $<

test: $(FPE_TESTS) 

SequencerDSLParser.py: SequencerDSL.ebnf
	grako $< -o $@

SequenceParser.py: Sequenc

clean:
	rm -rf SequencerDSLParser.py *.pyc
