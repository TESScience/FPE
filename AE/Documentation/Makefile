PDFLATEX=/usr/texbin/pdflatex
SCH=../Schematic
SCHPDF= ArtixPower.pdf Booster.pdf DriverSet.1.pdf DriverSet.2.pdf DriverSet.3.pdf DriverSet.4.pdf \
	Interface.1.pdf Interface.10.pdf Interface.2.pdf Interface.3.pdf Interface.4.pdf Interface.5.pdf \
	Interface.6.pdf Interface.7.pdf Interface.8.pdf Interface.9.pdf ParallelPair.pdf \
	ParallelReg.pdf Pump.pdf SerialDriver.pdf SerialRegulator.pdf DrainRegulator.pdf \
	Chain.1.pdf Chain.2.pdf PerChip.1.pdf PerChip.2.pdf PerChip.3.pdf PerChip.4.pdf \
	PerChip.5.pdf PerChip.6.pdf PerChip.7.pdf PerChip.8.pdf Video.1.pdf Video.2.pdf \
	Video.3.pdf Video.4.pdf Video.5.pdf Video.6.pdf Video.7.pdf Video.8.pdf 
	
PINTEX= CCD-51pin.tex TempConn.tex Interface.U4.tex \
	Interface.J1.tex Interface.J4.tex video_interconnect.tex

AE.pdf : AE.tex $(SCHPDF) $(PINTEX) stamp.txt date.txt
	$(PDFLATEX) AE.tex
	$(PDFLATEX) AE.tex

$(SCHPDF) : 
	ps2pdf $(SCH)/`basename $@ pdf`ps $@

$(PINTEX) :
	gawk -f pins2tex.awk <$(SCH)/`basename $@ tex`txt >$@

stamp.txt :
	git log -1 --format="%h" >stamp.txt

date.txt :
	git log -1 --format="%cd" >date.txt

clean :
	rm -f MPU.pdf $(SCHPDF) $(PINTEX) *.out *.aux *.log stamp.txt date.txt
