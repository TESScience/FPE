# "Standard Boilerplate"
# Definitions to generate the drawings

GNET=gnetlist -m ../Schematic/censor-fix.scm

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
	awk -f ../Schematic/pins2gsch.awk $^ >$@


# And definitions to assemble the documentation

A2PS=a2ps -1 --medium=letter --toc -o $@ $^
PS2PDF=ps2pdf -sPAPERSIZE=letter
COLUMN=column -ts '	'

%.pdf : %.ps
	$(PS2PDF) $<

%.txt : %.tsv
	$(COLUMN) $< >$@ 

Breakout.allegro Breakout.devfiles: Breakout.sch J1.psch J2.psch J3.psch J4.psch
	rm -rf devfiles Breakout.devfiles
	$(GNET) -L ../Schematic -l ../Schematic/backward-compat.scm -g allegro -o $@ Breakout.sch J1.psch J2.psch J3.psch J4.psch
	mv devfiles Breakout.devfiles

Stack.psch : ../Schematic/Stack.txt
	awk -f ../Schematic/pins2gsch.awk $^ >$@

clean : 
	rm -rf *.allegro *devfiles *.psch *.ps *.pdf *~ \#*
