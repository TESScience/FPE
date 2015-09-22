PDFLATEX=cat /dev/null | pdflatex
SCH=../Schematic
DATA=../Data

PINTEX= CCD-51pin.tex TempConn.tex Interface.U4.tex \
	Interface.J8.tex Stack.tex

TSVTEX=BiasGroup.tex ClockDriverGroup.tex HKmap.tex \
	HeaterGroup.tex ThermalGroup.tex InterfaceGroup.tex

PDFS=Figs/ArtixPower.pdf Figs/Booster.pdf Figs/Chain.1.pdf \
     Figs/Chain.2.pdf Figs/DrainRegulator.pdf Figs/Driver.1.pdf \
     Figs/Driver.2.pdf Figs/Driver.3.pdf Figs/DriverSet.1.pdf \
     Figs/DriverSet.2.pdf Figs/DriverSet.3.pdf Figs/DriverSet.4.pdf Figs/DriverSet.5.pdf \
     Figs/Interface.1.pdf Figs/Interface.2.pdf Figs/Interface.3.pdf\
     Figs/Interface.4.pdf Figs/Interface.5.pdf Figs/Interface.6.pdf\
     Figs/Interface.7.pdf Figs/Interface.pdf Figs/ParallelPair.pdf\
     Figs/ParallelReg.pdf Figs/PerChip.1.pdf Figs/PerChip.2.pdf\
     Figs/PerChip.3.pdf Figs/PerChip.4.pdf Figs/PerChip.5.pdf\
     Figs/PerChip.6.pdf Figs/PerChip.7.pdf Figs/PerChip.8.pdf\
     Figs/Pump.pdf Figs/SerialDriver.pdf Figs/SerialRegulator.pdf\
     Figs/Video.1.pdf Figs/Video.2.pdf Figs/Video.3.pdf Figs/Video.4.pdf\
     Figs/Video.5.pdf Figs/Video.6.pdf Figs/Video.7.pdf Figs/Video.8.pdf

.PHONY: pdfs all clean

all: FPE.pdf
pdfs: $(PDFS)

Figs/%.pdf :
	make -C $(dir $@) $(notdir $@)

FPE.pdf : FPE.tex $(PINTEX) stamp.tex date.txt tag.tex $(wildcard Figs/*.pdf) StackMap.tex $(TSVTEX) $(PDFS)
	$(PDFLATEX) FPE.tex
	$(PDFLATEX) FPE.tex
	$(PDFLATEX) FPE.tex

$(SCH)/%.txt:
	make -C $(SCH) $(notdir $@)

$(PINTEX) : $(patsubst %.tex, $(SCH)/%.txt, $(PINTEX))
	gawk -f pins2tex.awk < $(SCH)/$(@:.tex=.txt) >$@

$(TSVTEX) :
	gawk -f tsv2tex.awk < $(DATA)/$(@:.tex=.tsv) >$@

StackMap.tex: $(SCH)/StackMap.txt
	tr '\t' '&' < $< | sed -e 's/\\_\([^\\]*\)\\_/$$\\overline{\\textup{\1}}$$/g' \
                               -e 's/&&&/\&\\multicolumn{2}{l|}{}\&/g' \
                               -e 's/&&$$/\&\\multicolumn{2}{l|}{}/' \
                               -e 's/^&&/\\multicolumn{2}{|l|}{}\&/' \
                               -e 's/$$/\&\\\\[2ex]ⓝ\\hline/' \
                         | tr 'ⓝ' '\n' > $@

date.txt :
	git log -1 --format="%cd" > $@

stamp.tex :
	echo "Version  $(shell git describe --tags) \\\\\\\\" > $@

# tag.tex :
#	if [ "$(shell git describe --tags $(shell git log -1 --format="%h"))" = \
#             "$(shell git describe --tags --abbrev=0 $(shell git log -1 --format="%h"))" ] ; then \
#           echo "Tag $(shell git describe --tags --abbrev=0 $(shell git log -1 --format="%h")) \\\\\\\\" ; \
#        fi > $@

clean :
	make -C Figs clean
	rm -f $(PINTEX) $(TSVTEX) *.out *.aux *.log stamp.tex date.txt StackMap.tex tag.tex FPE.pdf *.toc *.lof *.lot *.synctex.gz
