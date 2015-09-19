FPE_SCRIPTS=$(wildcard examples/*.fpe)
FPE_TESTS=$(patsubst examples/%.fpe, %_test, $(FPE_SCRIPTS))
.PHONY: all clean test

all: SequencerDSLParser.py DefaultsParser.py SequencesParser.py ProgramsParser.py

%_test: examples/%.fpe SequencerDSLParser.py
	./parse.py $<
	./sequence.py $<
	./program.py $<

test: $(FPE_TESTS) 

SequencerDSLParser.py: SequencerDSL.ebnf
	grako $< -o $@

%_standalone_grammer.ebnf: %.ebnf
	echo '@@comments :: ?/\/\*.*?\*\//?' > $@
	echo '@@eol_comments :: ?/\/\/.*?$$/?' >> $@
	echo '#include :: "Terms.ebnf"' >> $@
	echo '#include :: "State_Changes.ebnf"' >> $@
	echo '#include :: "$<"' >> $@

%Parser.py: %_standalone_grammer.ebnf
	grako $< -o $@

clean:
	rm -rf *Parser.py *_standalone_grammar.ebnf *.pyc
