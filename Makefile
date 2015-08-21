.PHONY: all manual clean test
MANUAL_DIR=FPE/Documentation
SCHEMATIC_DIR=FPE/Schematic

all: manual

manual: FPE.pdf

FPE.pdf: $(MANUAL_DIR)/FPE.pdf
	rm -f $@ ; ln -s $< $@

$(MANUAL_DIR)/FPE.pdf: $(MANUAL_DIR)/FPE.tex
	make -C $(dir $@) $(notdir $@)

test:
	./tessfpe/__init__.py

clean:
	rm -f FPD.pdf
	make -C $(MANUAL_DIR) clean
	make -C $(SCHEMATIC_DIR) clean
