GNET=gnetlist -m censor-fix.scm

all : Interface.pdf Interface.net.txt Video.pdf Video.net.txt

# "Standard Boilerplate"
# Definitions to generate the drawings

# Use xvfb-run if present (works on both Macs and Linux then)
GSCHEM=$(shell [ -x "$(shell which xvfb-run)" ] && echo xvfb-run ; echo gschem)

S2PS=$(GSCHEM) -p -o $@ -s print.scm $<

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

Video.allegro : $(VIDEOSCH) $(VIDEOMERGE)
	rm -rf devfiles
	$(GNET) -L . -l backward-compat.scm -g allegro -o $@ $(VIDEOTOP) $(VIDEOMERGE)

Video.net.txt : $(VIDEOSCH) $(VIDEOMERGE)
	$(GNET) -g osmond -o $@ $(VIDEOTOP) $(VIDEOMERGE)

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
	Interface.J6.txt \
	Interface.J7.txt \
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
	Interface.J6.psch \
	Interface.J7.psch \
	Interface.J8.psch \
	Stack.psch \
	Interface.U4.psch \


INTERFACESCH= $(INTERFACETOP) $(INTERFACESUB) $(INTERFACEMERGE)

Interface : Interface.pdf Interface.allegro Interface.bom.txt Interface.counts.txt Interface.bom2.txt

Interface.U4.txt: makeFPGApinmap.awk Artix-signal-map.tsv ArtixPinout.csv
	awk -f makeFPGApinmap.awk Artix-signal-map.tsv ArtixPinout.csv >$@

Interface.net.txt : $(INTERFACESCH)
	$(GNET) -g osmond -o $@ $(INTERFACETOP) $(INTERFACEMERGE)

Interface.stats.txt : $(INTERFACESCH)
	$(GNET) -L . -g stats -o $@ $(INTERFACETOP) $(INTERFACEMERGE)

Interface.allegro : $(INTERFACESCH) $(ITERFACEMERGE)
	rm -rf devfiles
	$(GNET) -L . -l backward-compat.scm -g allegro -o $@ $(INTERFACETOP) $(INTERFACEMERGE)

Interface.bom.txt: $(INTERFACESCH) attribs
	$(GNET) -g bom -o $@ $(INTERFACETOP)

Interface.bom2.txt : $(INTERFACESCH) attribs
	$(GNET) -g bom2 -o $@ $(INTERFACETOP)

Interface.counts.txt : Interface.bom.txt
	awk -f countem.awk Interface.bom.txt | sort -nr >$@
	
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
		*.xls \#* *~ *.psch *.log *devfiles

ATESTDOCS=\
	ArtixPower.ps ArtixTest.1.ps ArtixTest.2.ps \
	ArtixTest.3.ps ArtixTest.4.ps ArtixTest.5.ps \
	TestJmp.txt Artix-signal-map.tsv

ATESTTOP= \
	ArtixTest.1.sch ArtixTest.2.sch ArtixTest.3.sch \
	ArtixTest.4.sch ArtixTest.5.sch

ATESTSUB=ArtixPower.sch

ATESTMERGE=ArtixTest-connectors.psch Interface.U4.psch

ArtixTest-connectors.psch : TestJmp.txt
	awk -f pins2gsch.awk $^ >$@

ArtixTest.allegro ArtixTest.devfiles: $(ATESTTOP) $(ATESTSUB) $(ATESTMERGE)
	rm -rf devfiles ArtixTest.devfiles
	$(GNET) -L . -l backward-compat.scm -g allegro -o $@ $(ATESTTOP) $(ATESTMERGE)
	mv devfiles ArtixTest.devfiles

ArtixTest.bom.txt : $(ATESTTOP) $(ATESTSUB) attribs
	$(GNET) -g bom -o $@ $(ATESTTOP)

ArtixTest.bom2.txt : $(ATESTTOP) $(ATESTSUB) attribs
	$(GNET) -g bom2 -o $@ $(ATESTTOP)

ArtixTest.counts.txt : ArtixTest.bom.txt
	awk -f countem.awk ArtixTest.bom.txt | sort -nr >$@

ArtixTest.ps : $(ATESTDOCS)
	$(A2PS)
