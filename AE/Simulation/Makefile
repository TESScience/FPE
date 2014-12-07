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

PumpTest : PumpTest.cir Pump.cir
	$(NGSPICE) PumpTest.cir Pump.cir irfr9120n.spi irfru220n.spi \
		MMBT2222A.mod MMBT2907A.mod DG403.mod 1N914B.mod

Pump.sch : ../Schematic/Pump.sch
	cp $< $@

BoosterTest : BoosterTest.cir Booster.cir
	$(NGSPICE) BoosterTest.cir Booster.cir irfr9120n.spi irfru220n.spi MMBT2222A.mod MMBT2907A.mod

Booster.sch : ../Schematic/Booster.sch
	cp $< $@

chnoise : chnoise.cir
	$(NGSPICE) chnoise.cir bf545c.mod

ChainNoise : ChainNoise.cir Chain.cir max4636.cir max4636sw.cir \
		MAX4594.cir
	$(NGSPICE) ChainNoise.cir Chain.cir max4636.cir max4636sw.cir \
		bf545c.mod LM6142A.MOD

ChainTest : ChainTest.cir Chain.cir max4636.cir max4636sw.cir \
		MAX4594.cir
	$(NGSPICE) ChainTest.cir Chain.cir max4636.cir max4636sw.cir \
		bf545c.mod LM6142A.MOD  Ad8038.cir MAX4452.mod 1N914B.mod J309.mod

opNoise : opNoise.cir
	$(NGSPICE) opNoise.cir 

DampReg : DampReg.cir
	$(NGSPICE) DampReg.cir LM6142A.MOD

Chain.1.sch : ../Schematic/Chain.1.sch
	cp $< $@

Chain.2.sch : ../Schematic/Chain.2.sch
	cp $< $@

Chain.cir : Chain.1.sch Chain.2.sch
	$(GNET) Chain.1.sch Chain.2.sch -o Chain.cir

ArtixPower.sch : ../Schematic/ArtixPower.sch
	cp $< $@

AP : AP.cir ArtixPower.cir
	$(NGSPICE) AP.cir ArtixPower.cir LM6142A.MOD REF43.cir MMBT2222A.mod MMBT2907A.mod

APSC : APSC.cir ArtixPower.cir
	$(NGSPICE) APSC.cir ArtixPower.cir LM6142A.MOD REF43.cir MMBT2222A.mod MMBT2907A.mod

clean :
	rm -f *.cir *.ps *.pdf \#* *~ Pump.sch Booster.sch Chain.1.sch Chain.2.sch ArtixPower.sch
