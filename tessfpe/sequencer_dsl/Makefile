.PHONY: all clean test

all: SequencerDSLParser.py

test: SequencerDSLParser.py
	@for ex in $(CURDIR)/examples/*.fpe ; do \
		echo Testing $(notdir $$ex) ; \
		./__init__.py $$ex && echo $(notdir $$ex) okay ; \
	done

SequencerDSLParser.py: SequencerDSL.ebnf
	grako $< -o $@

clean:
	rm -rf SequencerDSLParser.py *.pyc
