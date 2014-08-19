GNET=gnetlist -g spice-noqsi -m ../Schematic/censor-fix.scm
# NGSPICE=/usr/local/ngspice-24/bin/ngspice
NGSPICE=ngspice

%.cir : %.sch
	$(GNET) $< -o $@

ChainTest : ChainTest.cir Chain.cir max4636.cir max4636sw.cir \
		MAX4594.cir
	$(NGSPICE) ChainTest.cir chain.cir max4636.cir max4636sw.cir \
		bf545c.mod LM6142A.MOD

Chain.1.sch : ../Schematic/Chain.1.sch
	cp $< $@

Chain.2.sch : ../Schematic/Chain.2.sch
	cp $< $@

Chain.cir : Chain.1.sch Chain.2.sch
	$(GNET) Chain.1.sch Chain.2.sch -o Chain.cir

clean :
	rm -f *.cir *.ps *.pdf \#* *~
