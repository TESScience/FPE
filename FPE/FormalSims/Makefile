GNET=gnetlist -g spice-noqsi -m ../Schematic/censor-fix.scm
# NGSPICE=/usr/local/ngspice-24/bin/ngspice
NGSPICE=ngspice
SEQ2SPICE=../../../tessfpe/testsuite/venv/bin/fpe2spicetiming

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

PARFILES=Booster.cir ParallelPair.cir ParallelReg.cir \
	lm195.cir old-ic.mod MMBT2222A.mod MMBT2907A.mod DG403.cir \
	LM6142A.MOD irfr9120n.spi  irfru220n.spi LT1078.mod Par3.cir L3.cir

SERFILES=SerialRegulator.cir SerialDriver.cir \
	MMBT2222A.mod MMBT2907A.mod DG403.cir LM6142A.MOD 3phase.cir

PRODUCTS=fs_loaded.pdf ia_loaded.pdf fs_unloaded.pdf ia_unloaded.pdf \
or_loaded.pdf or_unloaded.pdf

products : $(PRODUCTS)
	mkdir -p products
	mv $(PRODUCTS) products

fs_loaded.ps ia_loaded.ps: ParallelTest.cir IA_FS_loaded.control $(PARFILES)
	$(NGSPICE) $^

fs_unloaded.ps ia_unloaded.ps: ParallelUnloaded.cir IA_FS_unloaded.control $(PARFILES)
	$(NGSPICE) $^

or_loaded.ps : SerialTest.cir SerialTest.stim OR_loaded.control  $(SERFILES)
	$(NGSPICE) $^ 

or_unloaded.ps : SerialUnloaded.cir OR_unloaded.control  $(SERFILES)
	$(NGSPICE) $^ 

SerialRegulator.sch : ../Schematic/SerialRegulator.sch
	cp $< $@

SerialDriver.sch : ../Schematic/SerialDriver.sch
	cp $< $@

ParallelPair.sch : ../Schematic/ParallelPair.sch
	cp $< $@

ParallelReg.sch : ../Schematic/ParallelReg.sch
	cp $< $@

Booster.sch : ../Schematic/Booster.sch
	cp $< $@

DG403.cir : DG403.1.sch DG403.2.sch
	$(GNET) DG403.1.sch DG403.2.sch -o DG403.cir

SerialTest.stim: test.fpe
	$(SEQ2SPICE) --sequence pixcycle $< >$@

clean :
	rm -rf *.cir *.ps *.pdf \#* *~ Pump.sch Booster.sch Chain.1.sch Chain.2.sch \
		ArtixPower.sch SerialRegulator.sch SerialDriver.sch parallelstress.txt \
		Reset.sch *.ps *.pdf ParallelPair.sch ParallelReg.sch products \
		SerialRegulator.sch SerialDriver.sch
