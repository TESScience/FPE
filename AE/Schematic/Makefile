VIDEOPRODUCTS = Video.pdf Video.allegro Video.devfiles Video.bom.txt \
	Video.bom2.txt Video.counts.txt Video-Cirrexx.tsv Video.pads Video.osmond \
	Video.stats.txt

INTERFACEPRODUCTS = Interface.pdf Interface.allegro Interface.devfiles \
	Interface.bom.txt Interface.bom2.txt Interface.counts.txt \
	Interface-Cirrexx.tsv Interface.pads Interface.osmond Interface.stats.txt

DRIVERPRODUCTS = Driver.pdf Driver.allegro Driver.devfiles Driver.bom.txt \
	Driver.bom2.txt Driver.counts.txt Driver-Cirrexx.tsv Driver.pads \
	Driver.osmond Driver.stats.txt

PRODUCTS = $(VIDEOPRODUCTS) $(INTERFACEPRODUCTS) $(DRIVERPRODUCTS) \
	../Documentation/AE.pdf

all : $(PRODUCTS)

release : $(PRODUCTS)
	mkdir -p ../../Releases/$(REV)
	mv $(PRODUCTS) ../../Releases/$(REV)
	cp Source_of_release_README ../../Releases/$(REV)/README
	zip -r ../../Releases/$(REV).zip ../../Releases/$(REV)

../Documentation/AE.pdf : ../Documentation/AE.tex $(VIDEODOCS) $(INTERFACEDOCS) \
	$(DRIVERDOCS)
	make -C ../Documentation AE.pdf

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

TESTDOCS=\
	Video.chaintest.1.ps Video.chaintest.6.ps\
	PerChip.1.ps PerChip.test.ps\
	Chain.1.ps Chain.2.ps 

TESTTOP=Video.chaintest.1.sch Video.chaintest.6.sch

TESTSUB=\
	PerChip.1.sch PerChip.test.sch\
	Chain.1.sch Chain.2.sch

TESTMERGE=Test-connectors.psch

Test-connectors.psch : \
	CCD-51pin.tsv Stack.txt
	awk -f pins2gsch.awk $^ >$@

Test.net.txt : $(TESTSCH) $(TESTMERGE) $(TESTSUB)
	$(GNET) -g osmond -o $@ $(TESTTOP) $(TESTMERGE)

Test.bom.txt : $(TESTSCH) $(TESTSUB) attribs
	$(GNET) -g bom -o $@ $(TESTTOP)

Test.bom2.txt : $(TESTSCH) $(TESTSUB) attribs
	$(GNET) -g bom2 -o $@ $(TESTTOP)

Test.counts.txt : Test.bom.txt
	awk -f countem.awk Test.bom.txt | sort -nr >$@

Test.ps : $(TESTDOCS)
	$(A2PS)


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

Stack.txt: StackMap.txt
	awk -f mkStack.awk $< >$@
	
Video-connectors.psch : \
	CCD-connectors.txt TempConn.txt Stack.txt
	awk -f pins2gsch.awk $^ >$@

Video.allegro Video.devfiles: $(VIDEOSCH) $(VIDEOMERGE)
	rm -rf devfiles Video.devfiles
	$(GNET) -L . -l backward-compat.scm -g allegro -o $@ $(VIDEOTOP) $(VIDEOMERGE)
	mv devfiles Video.devfiles

Video.osmond : $(VIDEOSCH) $(VIDEOMERGE)
	$(GNET) -g osmond -o $@ $(VIDEOTOP) $(VIDEOMERGE)

Video.pads : $(VIDEOSCH) $(VIDEOMERGE)
	$(GNET) -m map-footprints.scm -m SDPCB-footprints.scm -g pads -o $@ $(VIDEOTOP) $(VIDEOMERGE)

Video.stats.txt : $(VIDEOSCH) $(VIDEOMERGE)
	$(GNET) -L . -g stats -o $@ $(VIDEOTOP) $(VIDEOMERGE)

Video.bom.txt : $(VIDEOSCH) attribs
	$(GNET) -g bom -o $@ $(VIDEOTOP)

Video.bom2.txt : $(VIDEOSCH) attribs
	$(GNET) -g bom2 -o $@ $(VIDEOTOP)

Video.counts.txt : Video.bom.txt
	awk -f countem.awk Video.bom.txt | sort -nr >$@

Video-Cirrexx.tsv : Video.bom2.txt CirrexxBOM.awk partnumbers.tsv
	awk -f CirrexxBOM.awk partnumbers.tsv Video.bom2.txt >Video-Cirrexx.tsv

Video.drc.txt: $(VIDEOSCH) $(VIDEOMERGE)
	$(GNET) -g drc2 -o $@ $(VIDEOTOP) $(VIDEOMERGE)

# Screaming Circuits BOM as a tsv

Video.bom.tsv : Video.bom.txt $(PARTDB) video-omit.tsv
	awk -f partcheck.awk $(PARTDB) video-omit.tsv bom=1 Video.bom.txt \
	&& (awk -f screamBOM.awk $(PARTDB) bom=1 Video.bom.txt >Video.bom.tsv)

# Partially populated version

Video-1-CCD.bom.tsv : Video.bom.tsv
	awk 'BEGIN{ FS="\t"}(!match($$2,"^J[2-4]$$"))&&(!match($$2,"^X[2-4]/")){print}' \
		<Video.bom.tsv >Video-1-CCD.bom.tsv

Video.ps : $(VIDEODOCS)
	$(A2PS)

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
	Stack.psch \
	Interface.U4.psch \


INTERFACESCH= $(INTERFACETOP) $(INTERFACESUB) $(INTERFACEMERGE)

Interface : Interface.pdf Interface.allegro Interface.bom.txt Interface.counts.txt Interface.bom2.txt

Interface.U4.txt: makeFPGApinmap.awk Artix-signal-map.tsv ArtixPinout.csv
	awk -f makeFPGApinmap.awk Artix-signal-map.tsv ArtixPinout.csv >$@

Interface.osmond : $(INTERFACESCH) $(INTERFACEMERGE)
	$(GNET) -g osmond -o $@ $(INTERFACETOP) $(INTERFACEMERGE)

Interface.pads : $(INTERFACESCH) $(INTERFACEMERGE)
	$(GNET) -m map-footprints.scm -m SDPCB-footprints.scm -g pads -o $@ $(INTERFACETOP) $(INTERFACEMERGE)

Interface.stats.txt : $(INTERFACESCH)
	$(GNET) -L . -g stats -o $@ $(INTERFACETOP) $(INTERFACEMERGE)

Interface.allegro Interface.devfiles: $(INTERFACESCH) $(ITERFACEMERGE)
	rm -rf devfiles Interface.devfiles
	$(GNET) -L . -l backward-compat.scm -g allegro -o $@ $(INTERFACETOP) $(INTERFACEMERGE)
	mv devfiles Interface.devfiles

Interface.bom.txt: $(INTERFACESCH) attribs
	$(GNET) -g bom -o $@ $(INTERFACETOP)

Interface.bom2.txt : $(INTERFACESCH) attribs
	$(GNET) -g bom2 -o $@ $(INTERFACETOP)

Interface.counts.txt : Interface.bom.txt
	awk -f countem.awk Interface.bom.txt | sort -nr >$@
	
Interface-Cirrexx.tsv : Interface.bom2.txt CirrexxBOM.awk partnumbers.tsv
	awk -f CirrexxBOM.awk partnumbers.tsv Interface.bom2.txt >Interface-Cirrexx.tsv

Interface.drc.txt: $(INTERFACESCH) $(INTERFACEMERGE)
	$(GNET) -g drc2 -o $@ $(INTERFACETOP) $(INTERFACEMERGE)

Interface.ps: $(INTERFACEDOCS)
	$(A2PS)

# Screaming Circuits BOM as a tsv

Interface.bom.tsv : Interface.bom.txt $(PARTDB) Interface-omit.tsv
	awk -f partcheck.awk $(PARTDB) Interface-omit.tsv bom=1 Interface.bom.txt \
	&& (awk -f screamBOM.awk $(PARTDB) bom=1 Interface.bom.txt >Interface.bom.tsv)

clean : 
	rm -rf *.ps *.pdf *.bom.txt *.bom.tsv *.drc.txt *.net.txt \
		*.xls \#* *~ *.psch *.log *devfiles *.counts.txt *.stats.txt tmp.sch

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

DRIVERMERGE=Stack.psch

Driver: Driver.pdf Driver.allegro Driver.bom.txt Driver.bom2.txt Driver.counts.txt

Driver.allegro Driver.devfiles: $(DRIVERTOP) $(DRIVERSUB) $(DRIVERMERGE)
	rm -rf devfiles Driver.devfiles
	$(GNET) -L . -l backward-compat.scm -g allegro -o $@ $(DRIVERTOP) $(DRIVERMERGE)
	mv devfiles Driver.devfiles

Driver.osmond : $(DRIVERSCH) $(DRIVERMERGE)
	$(GNET) -g osmond -o $@ $(DRIVERTOP) $(DRIVERMERGE)

Driver.pads : $(DRIVERSCH) $(DRIVERMERGE)
	$(GNET) -m map-footprints.scm -m SDPCB-footprints.scm -g pads -o $@ $(DRIVERTOP) $(DRIVERMERGE)

Driver.bom.txt : $(DRIVERTOP) $(DRIVERSUB) attribs
	$(GNET) -g bom -o $@ $(DRIVERTOP)

Driver.bom2.txt : $(DRIVERTOP) $(DRIVERSUB) attribs
	$(GNET) -g bom2 -o $@ $(DRIVERTOP)

Driver-Cirrexx.tsv : Driver.bom2.txt CirrexxBOM.awk partnumbers.tsv
	awk -f CirrexxBOM.awk partnumbers.tsv Driver.bom2.txt >Driver-Cirrexx.tsv

Driver.counts.txt : Driver.bom.txt
	awk -f countem.awk Driver.bom.txt | sort -nr >$@

Driver.ps : $(DRIVERDOCS)
	$(A2PS)

Driver.drc.txt: $(DRIVERTOP) $(DRIVERSUB) $(DRIVERMERGE)
	$(GNET) -g drc2 -o $@ $(DRIVERTOP) $(DRIVERMERGE)

Driver.stats.txt : $(DRIVERTOP) $(DRIVERSUB) $(DRIVERMERGE)
	$(GNET) -L . -g stats -o $@ $(DRIVERTOP) $(VIDEOMERGE)
