PDFLATEX=cat /dev/null | pdflatex
SCH=../../Schematic
PDFS= ArtixPower.pdf Booster.pdf DriverSet.1.pdf DriverSet.2.pdf DriverSet.3.pdf DriverSet.4.pdf DriverSet.5.pdf\
      Interface.1.pdf Interface.pdf Interface.2.pdf Interface.3.pdf Interface.4.pdf Interface.5.pdf \
      Interface.6.pdf Interface.7.pdf ParallelPair.pdf \
      ParallelReg.pdf Pump.pdf SerialDriver.pdf SerialRegulator.pdf DrainRegulator.pdf \
      Chain.1.pdf Chain.2.pdf PerChip.1.pdf PerChip.2.pdf PerChip.3.pdf PerChip.4.pdf \
      PerChip.5.pdf PerChip.6.pdf PerChip.7.pdf PerChip.8.pdf Video.1.pdf Video.2.pdf \
      Video.3.pdf Video.4.pdf Video.5.pdf Video.6.pdf Video.7.pdf Video.8.pdf \
      Driver.1.pdf Driver.2.pdf Driver.3.pdf

SCHPSS=$(patsubst %.pdf, $(SCH)/%.ps, $(PDFS))

.PHONY: pdfs
pdfs: $(PDFS)

$(PDFS) :
	make -C $(SCH) $(@:.pdf=.ps)
	ps2pdf $(SCH)/$(@:.pdf=.ps) $@

clean :
	rm -f $(PDFS)
