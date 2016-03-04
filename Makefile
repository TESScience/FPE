.PHONY: all manual clean version
MANUAL_DIR=FPE/Documentation
SCHEMATIC_DIR=FPE/Schematic
VERSION=$(shell git describe --abbrev=0 --tags)
# Determine the remote that corresponds to the TESScience/FPE repo
GITHUB_REMOTE=$(shell for i in $(shell git remote) ; do \
   if [[ `git config --get remote.$$i.url` == "git@github.com:TESScience/FPE.git" ]] ; then \
      echo $$i ; \
   fi ; \
done) 

all: manual

version:
	@echo $(VERSION)

manual: $(MANUAL_DIR)/FPE.pdf

$(MANUAL_DIR)/FPE.pdf: $(MANUAL_DIR)/FPE.tex
	make -C $(dir $@) $(notdir $@) > /dev/null

clean:
	make -C $(MANUAL_DIR) clean
	make -C $(SCHEMATIC_DIR) clean
