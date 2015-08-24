.PHONY: all clean
all: SequencerDSLParser.py

SequencerDSLParser.py: SequencerDSL.ebnf
	grako $< -o $@

clean:
	rm -rf SequencerDSLParser.py *.pyc
