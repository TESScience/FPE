.PHONY: all manual install_testsuite clean test version
MANUAL_DIR=FPE/Documentation
SCHEMATIC_DIR=FPE/Schematic
VERSION=$(shell git describe --abbrev=0 --tags)
# Determine the remote that corresponds to the TESScience/FPE repo
GITHUB_REMOTE=$(shell for i in $(shell git remote) ; do \
   if [[ `git config --get remote.$$i.url` == "git@github.com:TESScience/FPE.git" ]] ; then \
      echo $$i ; \
   fi ; \
done) 

all: manual tessfpe/sequencer_dsl/SequencerDSLParser.py docs/_build/html

version:
	@echo $(VERSION)

docs/_build/html:
	make -C docs html

manual: $(MANUAL_DIR)/FPE.pdf

$(MANUAL_DIR)/FPE.pdf: $(MANUAL_DIR)/FPE.tex
	make -C $(dir $@) $(notdir $@) > /dev/null

setup.py: templates/setup.py.template
	sed -e "s/<TAG>/$(VERSION)/g" $< > $@

tessfpe/sequencer_dsl/SequencerDSLParser.py: 
	make -C $(dir $@) $(notdir $@)

install_testsuite: setup.py testsuite/venv tessfpe/sequencer_dsl/SequencerDSLParser.py
	@[ -d testsuite/venv/lib/python2.7/site-packages/tessfpe-*.egg ] \
        || testsuite/venv/bin/python setup.py install

reinstall_testsuite:
	rm -rf testsuite/venv
	make install_testsuite

testsuite/venv:
	make -C testsuite venv

test:
	make -C tessfpe test

clean:
	rm -rf setup.py MANIFEST dist/ tessfpe.egg-info/
	make -C docs clean
	make -C tessfpe clean
	make -C $(MANUAL_DIR) clean
	make -C $(SCHEMATIC_DIR) clean
	make -C testsuite clean
