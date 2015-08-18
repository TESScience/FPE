.PHONY: all manual clean test

all: manual

manual: FPE/Documentation/FPE.pdf

FPE/Documentation/FPE.pdf: FPE/Documentation/FPE.tex
	make -C $(dir $@) $(notdir $@)

test:
	./tessfpe.py

clean:
	make -C FPE/Documentation clean
	make -C FPE/Schematic clean
