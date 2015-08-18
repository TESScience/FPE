.PHONY: all manual clean

all: manual

manual: FPE/Documentation/FPE.pdf

FPE/Documentation/FPE.pdf: FPE/Documentation/FPE.tex
	make -C $(dir $@) $(notdir $@)

clean:
	make -C FPE/Documentation clean
	make -C FPE/Schematic clean
