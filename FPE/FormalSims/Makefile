GNET=gnetlist -g spice-noqsi -m ../Schematic/censor-fix.scm
# NGSPICE=/usr/local/ngspice-24/bin/ngspice
NGSPICE=ngspice

%.cir : %.sch
	$(GNET) $< -o $@

S2PS=gschem -p -o $@ -s ../Schematic/print.scm $<

%.sym.ps : %.sym
	$(S2PS)

%.ps : %.sch
	$(S2PS)

PS2PDF=ps2pdf -sPAPERSIZE=letter

%.pdf : %.ps
	$(PS2PDF) $<

products : fs_loaded.pdf ia_loaded.pdf fs_unloaded.pdf ia_unloaded.pdf

PARFILES=Booster.cir ParallelPair.cir ParallelReg.cir \
	lm195.cir old-ic.mod MMBT2222A.mod MMBT2907A.mod DG403.cir \
	LM6142A.MOD irfr9120n.spi  irfru220n.spi LT1078.mod Par3.cir L3.cir

fs_loaded.ps ia_loaded.ps: ParallelTest.cir IA_FS_loaded.control $(PARFILES)
	$(NGSPICE) $^

fs_unloaded.ps ia_unloaded.ps: ParallelUnloaded.cir IA_FS_unloaded.control $(PARFILES)
	$(NGSPICE) $^

ParallelPair.sch : ../Schematic/ParallelPair.sch
	cp $< $@

ParallelReg.sch : ../Schematic/ParallelReg.sch
	cp $< $@

Booster.sch : ../Schematic/Booster.sch
	cp $< $@

DG403.cir : DG403.1.sch DG403.2.sch
	$(GNET) DG403.1.sch DG403.2.sch -o DG403.cir

clean :
	rm -f *.cir *.ps *.pdf \#* *~ Pump.sch Booster.sch Chain.1.sch Chain.2.sch \
		ArtixPower.sch SerialRegulator.sch SerialDriver.sch parallelstress.txt \
		Reset.sch *.ps *.pdf ParallelPair.sch ParallelReg.sch 
