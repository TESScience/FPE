.PHONY: all clean
all:
	make -C sequencer_dsl all

test:
	./__init__.py
	make -C sequencer_dsl test

clean:
	rm -f *.pyc */*.pyc
	make -C sequencer_dsl clean
