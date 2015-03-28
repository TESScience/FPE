PDFLATEX=pdflatex
SCH=../Schematic
PDFS= ArtixPower.pdf Booster.pdf DriverSet.1.pdf DriverSet.2.pdf DriverSet.3.pdf DriverSet.4.pdf \
	Interface.1.pdf Interface.pdf Interface.2.pdf Interface.3.pdf Interface.4.pdf Interface.5.pdf \
	Interface.6.pdf Interface.7.pdf ParallelPair.pdf \
	ParallelReg.pdf Pump.pdf SerialDriver.pdf SerialRegulator.pdf DrainRegulator.pdf \
	Chain.1.pdf Chain.2.pdf PerChip.1.pdf PerChip.2.pdf PerChip.3.pdf PerChip.4.pdf \
	PerChip.5.pdf PerChip.6.pdf PerChip.7.pdf PerChip.8.pdf Video.1.pdf Video.2.pdf \
	Video.3.pdf Video.4.pdf Video.5.pdf Video.6.pdf Video.7.pdf Video.8.pdf 

SCHPSS=$(patsubst %.pdf, $(SCH)/%.ps, $(PDFS))

PINTEX= CCD-51pin.tex TempConn.tex Interface.U4.tex \
	Interface.J8.tex Stack.tex

AE.pdf : AE.tex $(PINTEX) stamp.txt date.txt tag.tex $(PDFS) StackMap.tex
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

StackMap.tex: $(SCH)/StackMap.txt
	tr '\t' '&' < $< | sed -e 's/&&&/\&\\multicolumn{2}{l|}{}\&/g' \
                               -e 's/&&$$/\&\\multicolumn{2}{l|}{}/' \
                               -e 's/^&&/\\multicolumn{2}{|l|}{}\&/' \
                               -e 's/$$/\\\\\\hline/'   >$@

stamp.txt :
	git log -1 --format="%h" > $@

date.txt :
	git log -1 --format="%cd" > $@

tag.tex :
	if [ "$(shell git describe --tags $(shell git log -1 --format="%h"))" = \
             "$(shell git describe --tags --abbrev=0 $(shell git log -1 --format="%h"))" ] ; then \
           echo "Tag $(shell git describe --tags --abbrev=0 $(shell git log -1 --format="%h")) \\\\\\\\" ; \
        fi > $@

clean :
	rm -f MPU.pdf $(PDFS) $(PINTEX) *.out *.aux *.log stamp.txt date.txt StackMap.tex tag.tex AE.pdf
