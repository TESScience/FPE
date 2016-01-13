# "Standard Boilerplate"
# Definitions to generate the drawings

GNET=gnetlist -m ../Schematic/censor-fix.scm

# Use xvfb-run if present (works on both Macs and Linux then)
GSCHEM=$(shell [ -x "$(shell which xvfb-run)" ] && echo xvfb-run ; echo gschem)
DATE=$(shell git log -1 --format="%cd")
REV=$(shell git describe --tags)
S2PS=sed -e "s/date=.*$$/date=$(DATE)/" -e "s/rev=.*$$/rev=$(REV)/" $< >tmp.sch; \
	$(GSCHEM) -p -o $@ -s ../Schematic/print.scm tmp.sch; \
	rm tmp.sch

%.sym.ps : %.sym
	$(S2PS)

%.ps : %.sch
	$(S2PS)

%.psch : %.txt
	awk -f ../Schematic/pins2gsch.awk $^ >$@


# And definitions to assemble the documentation

A2PS=a2ps -1 --medium=letter --toc -o $@ $^
PS2PDF=ps2pdf -sPAPERSIZE=letter

%.pdf : %.ps
	$(PS2PDF) $<

SCH=DummyCCD.1.sch	Pclock.sch	Sclock2.sch	Sclock4.sch

MERGE=J1.psch J2.psch

PINS=J1.txt	J2.txt
	
PS=DummyCCD.1.ps	Pclock.ps	Sclock2.ps	Sclock4.ps

BOM=DummyCCD.bom.txt DummyCCD.counts.txt

products : DummyCCD.pdf

DummyCCD.ps : $(PS) $(PINS) $(BOM)
	$(A2PS)

DummyCCD.bom.txt : $(SCH) $(MERGE)
	$(GNET) -g bom -o $@ DummyCCD.1.sch $(MERGE)

DummyCCD.counts.txt : DummyCCD.bom.txt
	awk -f ../Schematic/countem.awk DummyCCD.bom.txt | sort -nr >$@

check-duplicates: DummyCCD.1.sch $(MERGE)
	$(GNET) -L ../Schematic -g check-duplicates DummyCCD.1.sch $(MERGE)

check-pincount: DummyCCD.1.sch $(MERGE)
	$(GNET) -L ../Schematic -g check-pincount \
		-m ../Schematic/FPE-footprint-pins.scm DummyCCD.1.sch $(MERGE)

clean :
	rm -rf *.ps *.pdf *.bom*.txt *devfiles *counts.txt *.psch tmp.sch *~ \#*
