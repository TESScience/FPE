
all : Interface.pdf Interface.net.txt

# "Standard Boilerplate"
# Definitions to generate the drawings

S2PS=gschem -p -o $@ -s print.scm $<

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
	chain.ps \
	drain_regulator.ps \
	reset_regulator.ps \
	OG_regulator.ps \
	perchip.ps \
	Video.1.ps \
	Video.2.ps \
	Video.bom.txt

VIDEOTOP= Video.1.sch Video.2.sch

VIDEOSUB= chain.sch drain_regulator.sch reset_regulator.sch \
	OG_regulator.sch perchip.sch

# pseudo-schematics to be merged in
# In this case, connector pin maps

VIDEOMERGE= Video-connectors.psch

VIDEOSCH= $(VIDEOTOP) $(VIDEOSUB) $(VIDEOMERGE)

CCD-connectors.txt : CCD-37pin.tsv
	awk -f expand37.awk $< >$@

Video-connectors.psch : \
	CCD-connectors.txt TempConn.txt video_interconnect.txt
	awk -f pins2gsch.awk $^ >$@

Video.net.txt : $(VIDEOSCH) $(VIDEOMERGE)
	gnetlist -g osmond -o $@ $(VIDEOTOP) $(VIDEOMERGE)

Video.bom.txt : $(VIDEOSCH) attribs
	gnetlist -g bom -o $@ $(VIDEOTOP)

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

INTERFACEDOCS= ParallelPair.ps \
	SerialDriver.ps \
	ParallelReg.ps \
	SerialRegulator.ps \
	reset_regulator.ps \
	ParallelPair.ps \
	DriverSet.1.ps \
	DriverSet.2.ps \
	DriverSet.3.ps \
	DriverSet.4.ps \
	Interface.1.ps \
	Interface.2.ps \
	Interface.3.ps \
	Interface.4.ps \
	Interface.5.ps \
	Interface.6.ps \
	Interface.7.ps \
	Interface.8.ps \
	Interface.9.ps \
	Interface.10.ps \
	Interface.J1.txt \
	Interface.J2.txt \
	Interface.J3.txt \
	Interface.J4.txt \
	video_interconnect.txt \
	Interface.J7.txt \
	Interface.U4.txt \
	Interface.bom.txt

INTERFACETOP= \
	Interface.1.sch \
	Interface.2.sch \
	Interface.3.sch \
	Interface.4.sch \
	Interface.5.sch \
	Interface.6.sch \
	Interface.7.sch \
	Interface.8.sch \
	Interface.9.sch \
	Interface.10.sch

INTERFACESUB= \
	ParallelPair.sch \
	SerialDriver.sch \
	ParallelReg.sch \
	SerialRegulator.sch \
	reset_regulator.sch \
	ParallelPair.sch \
	DriverSet.1.sch \
	DriverSet.2.sch \
	DriverSet.3.sch \
	DriverSet.4.sch

INTERFACEMERGE= \
	Interface.J1.psch \
	Interface.J2.psch \
	Interface.J3.psch \
	Interface.J4.psch \
	video_interconnect.psch \
	Interface.J7.psch \
	Interface.U4.psch \


INTERFACESCH= $(INTERFACETOP) $(INTERFACESUB) $(INTERFACEMERGE)

Interface.net.txt : $(INTERFACESCH)
	gnetlist -g osmond -o $@ $(INTERFACETOP) $(INTERFACEMERGE)

Interface.bom.txt: $(INTERFACESCH) attribs
	gnetlist -g bom -o $@ $(INTERFACETOP)

Interface.drc.txt: $(INTERFACESCH) $(INTERFACEMERGE)
	gnetlist -g drc2 -o $@ $(INTERFACETOP) $(INTERFACEMERGE)

Interface.ps: $(INTERFACEDOCS)
	$(A2PS)

# Screaming Circuits BOM as a tsv

Interface.bom.tsv : Interface.bom.txt $(PARTDB) Interface-omit.tsv
	awk -f partcheck.awk $(PARTDB) Interface-omit.tsv bom=1 Interface.bom.txt \
	&& (awk -f screamBOM.awk $(PARTDB) bom=1 Interface.bom.txt >Interface.bom.tsv)

clean : 
	rm -f *.ps *.pdf *.bom.txt *.bom.tsv *.drc.txt *.net.txt \
		*.xls \#* *~ *.psch *.log

# $Log: Makefile,v $
# Revision 1.5  2009-02-16 17:26:58  jpd
# First release of Interface board.
#
# Revision 1.4  2009-02-04 20:20:38  jpd
# Automate screaming BOM
#
# Revision 1.3  2009-01-24 01:44:13  jpd
# First complete video board design.
#
# Revision 1.2  2009-01-16 03:09:35  jpd
# Build driver stuff.
#
# Revision 1.1  2009-01-16 03:03:38  jpd
# Added drivers.
#
