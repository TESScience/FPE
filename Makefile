.PHONY: all manual clean test
MANUAL_DIR=FPE/Documentation
SCHEMATIC_DIR=FPE/Schematic

all: manual

manual: $(MANUAL_DIR)/FPE.pdf

$(MANUAL_DIR)/FPE.pdf: $(MANUAL_DIR)/FPE.tex
	make -C $(dir $@) $(notdir $@)

test:
	./tessfpe/__init__.py

clean:
	make -C $(MANUAL_DIR) clean
	make -C $(SCHEMATIC_DIR) clean
