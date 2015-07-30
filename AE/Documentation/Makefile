PDFLATEX=pdflatex
SCH=../Schematic
DATA=../Data
PDFS= ArtixPower.pdf Booster.pdf DriverSet.1.pdf DriverSet.2.pdf DriverSet.3.pdf DriverSet.4.pdf \
	Interface.1.pdf Interface.pdf Interface.2.pdf Interface.3.pdf Interface.4.pdf Interface.5.pdf \
	Interface.6.pdf Interface.7.pdf ParallelPair.pdf \
	ParallelReg.pdf Pump.pdf SerialDriver.pdf SerialRegulator.pdf DrainRegulator.pdf \
	Chain.1.pdf Chain.2.pdf PerChip.1.pdf PerChip.2.pdf PerChip.3.pdf PerChip.4.pdf \
	PerChip.5.pdf PerChip.6.pdf PerChip.7.pdf PerChip.8.pdf Video.1.pdf Video.2.pdf \
	Video.3.pdf Video.4.pdf Video.5.pdf Video.6.pdf Video.7.pdf Video.8.pdf \
	Driver.1.pdf Driver.2.pdf Driver.3.pdf

SCHPSS=$(patsubst %.pdf, $(SCH)/%.ps, $(PDFS))

PINTEX= CCD-51pin.tex TempConn.tex Interface.U4.tex \
	Interface.J8.tex Stack.tex

TSVTEX=BiasGroup.tex ClockDriverGroup.tex HKmap.tex \
	HeaterGroup.tex ThermalGroup.tex InterfaceGroup.tex

AE.pdf : AE.tex $(PINTEX) stamp.tex date.txt tag.tex $(PDFS) StackMap.tex $(TSVTEX)
	$(PDFLATEX) AE.tex
	$(PDFLATEX) AE.tex
	$(PDFLATEX) AE.tex

.PHONY: pdfs
pdfs: $(PDFS)

$(PDFS) :
	make -C $(SCH) $(@:.pdf=.ps)
	ps2pdf $(SCH)/$(@:.pdf=.ps) $@

$(PINTEX) :
	gawk -f pins2tex.awk < $(SCH)/$(@:.tex=.txt) >$@

$(TSVTEX) :
	gawk -f tsv2tex.awk < $(DATA)/$(@:.tex=.tsv) >$@

StackMap.tex: $(SCH)/StackMap.txt
	tr '\t' '&' < $< | sed -e 's/\\_\([^\\]*\)\\_/$$\\overline{\\textup{\1}}$$/g' \
                               -e 's/&&&/\&\\multicolumn{2}{l|}{}\&/g' \
                               -e 's/&&$$/\&\\multicolumn{2}{l|}{}/' \
                               -e 's/^&&/\\multicolumn{2}{|l|}{}\&/' \
                               -e 's/$$/\&\ \\\\[2ex]\'$$'\n''\\hline/' > $@

date.txt :
	git log -1 --format="%cd" > $@

stamp.tex :
	echo "Version  $(shell git describe --tags) \\\\\\\\" > $@

tag.tex :
	if [ "$(shell git describe --tags $(shell git log -1 --format="%h"))" = \
             "$(shell git describe --tags --abbrev=0 $(shell git log -1 --format="%h"))" ] ; then \
           echo "Tag $(shell git describe --tags --abbrev=0 $(shell git log -1 --format="%h")) \\\\\\\\" ; \
        fi > $@

clean :
	rm -f MPU.pdf $(PDFS) $(PINTEX) $(TSVTEX) *.out *.aux *.log stamp.tex date.txt StackMap.tex tag.tex AE.pdf *.toc
