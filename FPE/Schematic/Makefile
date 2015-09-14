
PRODUCTS = Flex.allegro Flex.devfiles \
	Flex.bom.txt Flex.bom2.txt Flex.counts.txt
	
#	Flex-Cirrexx.tsv Flex.pads Flex.osmond Flex.stats.txt \
#	../Documentation/FPE.pdf

all : $(PRODUCTS)

release : $(PRODUCTS)
	mkdir -p ../../Releases/$(REV)
	mv $(PRODUCTS) ../../Releases/$(REV)
	cp Source_of_release_README ../../Releases/$(REV)/README
	zip -r ../../Releases/$(REV).zip ../../Releases/$(REV)

../Documentation/FPE.pdf : ../Documentation/FPE.tex $(VIDEODOCS) $(INTERFACEDOCS) \
	$(DRIVERDOCS)
	make -C ../Documentation FPE.pdf

# "Standard Boilerplate"
# Definitions to generate the drawings

GNET=gnetlist -m censor-fix.scm

# Use xvfb-run if present (works on both Macs and Linux then)
GSCHEM=$(shell [ -x "$(shell which xvfb-run)" ] && echo xvfb-run ; echo gschem)
DATE=$(shell git log -1 --format="%cd")
REV=$(shell git describe --tags)
S2PS=sed -e "s/date=.*$$/date=$(DATE)/" -e "s/rev=.*$$/rev=$(REV)/" $< >tmp.sch; \
	$(GSCHEM) -p -o $@ -s print.scm tmp.sch; \
	rm tmp.sch

%.sym.ps : %.sym
	$(S2PS)

%.ps : %.sch
	$(S2PS)

%.psch : %.txt
	awk -f pins2gsch.awk $^ >$@


# And definitions to assemble the documentation

A2PS=a2ps -1 --medium=letter --toc -o $@ $^
PS2PDF=ps2pdf -sPAPERSIZE=letter

%.pdf : %.ps
	$(PS2PDF) $<


# Files making up the part # database

PARTDB=digikey.tsv maxim.tsv


VIDEODOCS= \
	Chain.1.ps \
	Chain.2.ps \
	DrainRegulator.ps \
	PerChip.1.ps \
	PerChip.2.ps \
	PerChip.3.ps \
	PerChip.4.ps \
	PerChip.5.ps \
	PerChip.6.ps \
	PerChip.7.ps \
	PerChip.8.ps \
	Pump.ps \
	Video.1.ps \
	Video.2.ps \
	Video.3.ps \
	Video.4.ps \
	Video.5.ps \
	Video.6.ps \
	Video.7.ps \
	Video.8.ps \
	Video.bom.txt

VIDEOTOP= Video.1.sch Video.2.sch Video.3.sch Video.4.sch \
	Video.5.sch Video.6.sch Video.7.sch Video.8.sch

VIDEOSUB= PerChip.1.sch PerChip.2.sch PerChip.3.sch \
	PerChip.4.sch PerChip.5.sch PerChip.6.sch \
	PerChip.7.sch PerChip.8.sch Chain.1.sch Chain.2.sch DrainRegulator.sch \
	Pump.sch


# pseudo-schematics to be merged in
# In this case, connector pin maps

VIDEOMERGE= Video-connectors.psch

VIDEOSCH= $(VIDEOTOP) $(VIDEOSUB) $(VIDEOMERGE)

Video : Video.pdf Video.allegro Video.bom.txt Video.bom2.txt Video.counts.txt Video-Cirrexx.tsv

CCD-connectors.txt : CCD-51pin.txt
	awk -f expand51.awk $< >$@

Video-connectors.psch : \
	CCD-connectors.txt TempConn.txt
	awk -f pins2gsch.awk $^ >$@

INTERFACEDOCS= \
	Booster.ps \
	ParallelPair.ps \
	ParallelReg.ps \
	SerialDriver.ps \
	SerialRegulator.ps \
	DriverSet.1.ps \
	DriverSet.2.ps \
	DriverSet.3.ps \
	DriverSet.4.ps \
	DriverSet.5.ps \
	ArtixPower.ps \
	Interface.1.ps \
	Interface.2.ps \
	Interface.3.ps \
	Interface.4.ps \
	Interface.5.ps \
	Interface.6.ps \
	Interface.7.ps \
	Interface.J8.txt \
	Interface.U4.txt \
	Interface.bom.txt

INTERFACETOP= \
	Interface.1.sch \
	Interface.2.sch \
	Interface.3.sch \
	Interface.4.sch \
	Interface.5.sch \
	Interface.6.sch \
	Interface.7.sch

INTERFACESUB= \
	ParallelPair.sch \
	Booster.sch \
	SerialDriver.sch \
	ParallelReg.sch \
	SerialRegulator.sch \
	ParallelPair.sch \
	DriverSet.1.sch \
	DriverSet.2.sch \
	DriverSet.3.sch \
	DriverSet.4.sch \
	DriverSet.5.sch \
	ArtixPower.sch

INTERFACEMERGE= \
	Interface.J8.psch \
	Interface.U4.psch \


INTERFACESCH= $(INTERFACETOP) $(INTERFACESUB) $(INTERFACEMERGE)

Interface.U4.txt: makeFPGApinmap.awk Artix-signal-map.tsv ArtixPinout.csv
	awk -f makeFPGApinmap.awk Artix-signal-map.tsv ArtixPinout.csv >$@

clean : 
	rm -rf *.ps *.pdf *.bom*.txt *.bom.tsv *.drc.txt *.net.txt \
        *.xls *.psch *.log *devfiles *counts.txt CCD-connectors.txt Stack.txt \
        *.stats.txt tmp.sch *.U*.txt *~ \#* 

##########################

DRIVERSUB=\
	Booster.sch \
	ParallelPair.sch \
	ParallelReg.sch \
	SerialDriver.sch \
	SerialRegulator.sch \
	DriverSet.1.sch \
	DriverSet.2.sch \
	DriverSet.3.sch \
	DriverSet.4.sch \
	DriverSet.5.sch \

DRIVERDOCS=$(DRIVERSUB:.sch=.ps)

DRIVERTOP=\
	Driver.1.sch \
	Driver.2.sch \
	Driver.3.sch

DRIVERMERGE=

FLEXSUB=$(VIDEOSUB) $(INTERFACESUB) $(DRIVERSUB)
FLEXDOCS=$(VIDEODOCS) $(INTERFACEDOCS) $(DRIVERDOCS)
FLEXTOP=$(VIDEOTOP) $(INTERFACETOP) $(DRIVERTOP)
FLEXMERGE=$(VIDEOMERGE) $(INTERFACEMERGE) $(DRIVERMERGE)

Flex.allegro Flex.devfiles: $(FLEXTOP) $(FLEXSUB) $(FLEXMERGE)
	rm -rf devfiles Flex.devfiles
	$(GNET) -L . -l backward-compat.scm -m map-footprints.scm -m Flexdude-footprints.scm -g allegro -o $@ $(FLEXTOP) $(FLEXMERGE)
	mv devfiles Flex.devfiles

Flex.osmond : $(FLEXSCH) $(FLEXMERGE)
	$(GNET) -g osmond -o $@ $(FLEXTOP) $(FLEXMERGE)

Flex.pads : $(FLEXSCH) $(FLEXMERGE)
	$(GNET) -m map-footprints.scm -m SDPCB-footprints.scm -g pads -o $@ $(FLEXTOP) $(FLEXMERGE)

Flex.bom.txt : $(FLEXTOP) $(FLEXSUB) attribs
	$(GNET) -g bom -o $@ $(FLEXTOP)

Flex.bom2.txt : $(FLEXTOP) $(FLEXSUB) attribs
	$(GNET) -g bom2 -o $@ $(FLEXTOP)

Flex-Cirrexx.tsv : Flex.bom2.txt CirrexxBOM.awk partnumbers.tsv
	awk -f CirrexxBOM.awk partnumbers.tsv Flex.bom2.txt >Flex-Cirrexx.tsv

Flex.counts.txt : Flex.bom.txt
	awk -f countem.awk Flex.bom.txt | sort -nr >$@

Flex.ps : $(FLEXDOCS)
	$(A2PS)

Flex.drc.txt: $(FLEXTOP) $(FLEXSUB) $(FLEXMERGE)
	$(GNET) -g drc2 -o $@ $(FLEXTOP) $(FLEXMERGE)

Flex.stats.txt : $(FLEXTOP) $(FLEXSUB) $(FLEXMERGE)
	$(GNET) -L . -g stats -o $@ $(FLEXTOP) $(VIDEOMERGE)
