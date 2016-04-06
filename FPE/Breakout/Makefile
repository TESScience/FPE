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

%.psch : %.tsv
	awk -f ../Schematic/pins2gsch.awk $^ >$@


# And definitions to assemble the documentation

A2PS=a2ps -1 --medium=letter --toc -o $@ $^
PS2PDF=ps2pdf -sPAPERSIZE=letter
COLUMN=column -ts '	'

%.pdf : %.ps
	$(PS2PDF) $<

%.txt : %.tsv
	$(COLUMN) $< >$@ 

all : Breakout.allegro Breakout-doc.pdf

Breakout.allegro: Breakout.sch J1.psch J2.psch J3.psch J4.psch Stack.psch
	rm -rf devfiles Breakout.devfiles
	$(GNET) -L ../Schematic -l ../Schematic/backward-compat.scm -g allegro -o $@ Breakout.sch J1.psch J2.psch J3.psch J4.psch Stack.psch
	mv devfiles Breakout.devfiles

Breakout-doc.ps : Breakout.ps J1.txt J2.txt J3.txt J4.txt
	$(A2PS)

Stack.psch : ../Schematic/Stack.txt
	awk -f ../Schematic/pins2gsch.awk $^ >$@

../Schematic/Stack.txt : 
	make -C ../Schematic Stack.txt

clean : 
	rm -rf *.allegro *devfiles *.psch *.ps *.pdf *~ \#*
