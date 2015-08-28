.PHONY: all clean
all: sequencer_dsl/SequencerDSLParser.py

sequencer_dsl/SequencerDSLParser.py:
	make -C $(dir $@) $(notdir $@)

test: sequencer_dsl/SequencerDSLParser.py
	./__init__.py
	./simulator.py
	make -C sequencer_dsl test

clean:
	rm -f *.pyc */*.pyc
	make -C sequencer_dsl clean
