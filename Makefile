.PHONY: all manual clean test
MANUAL_DIR=FPE/Documentation
SCHEMATIC_DIR=FPE/Schematic
VERSION=$(shell git describe --abbrev=0 --tags)
# Determine the remote that corresponds to the TESScience/FPE repo
GITHUB_REMOTE=$(shell for i in $(shell git remote) ; do \
   if [[ `git config --get remote.$$i.url` == "git@github.com:TESScience/FPE.git" ]] ; then \
      echo $$i ; \
   fi ; \
done) 

all: manual tessfpe/sequencer_dsl/SequencerDSLParser.py

manual: $(MANUAL_DIR)/FPE.pdf

$(MANUAL_DIR)/FPE.pdf: $(MANUAL_DIR)/FPE.tex
	make -C $(dir $@) $(notdir $@) > /dev/null

setup.py: templates/setup.py.template
	sed -e "s/<TAG>/$(VERSION)/g" $< > $@

tessfpe/sequencer_dsl/SequencerDSLParser.py: 
	make -C $(dir $@) $(notdir $@)

release: setup.py manual tessfpe/sequencer_dsl/SequencerDSLParser.py
	# Commit the tagged release to github if necessary
	if ! curl -s --head https://codeload.github.com/TESScience/FPE/legacy.tar.gz/$(VERSION) | head -n 1 | grep "HTTP/1.[01] [23].." > /dev/null ; then \
		if [[ $(GITHUB_REMOTE) == *[!\ ]* ]] ; then \
			echo "Making release $(VERSION)" ; \
			git push $(GITHUB_REMOTE) $(VERSION) ; \
		else \
			echo "Could not find a remote that goes with git@github.com:TESScience/FPE.git to push tag $(VERSION) to" > /dev/stderr ; \
		fi \
	fi
	# Upload the release to pypi if necessary
	if ! curl -s --head https://pypi.python.org/pypi/tessfpe/$(VERSION) | head -n 1 | grep "HTTP/1.[01] [23].." > /dev/null ; then \
		rm -rf dist/ tessfpe.egg-info/ ; \
		python setup.py sdist upload -r pypi ; \
	fi

test:
	make -C tessfpe test

clean:
	rm -rf setup.py MANIFEST dist/ tessfpe.egg-info/ 
	make -C tessfpe clean
	make -C $(MANUAL_DIR) clean
	make -C $(SCHEMATIC_DIR) clean
