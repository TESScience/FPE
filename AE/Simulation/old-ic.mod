* Nondescript diode model
*
.MODEL DND D(IS=2P RS=5 BV=40 CJO=3P TT=6N)

* rcapnp model created using Parts version 5.1 on 07/21/92 at 11:56
* substrate capacitance added 7/21/92 jpd
.model latpnp   PNP(level=1
+		Is=50f Xti=3 Eg=1.11 Vaf=80 Bf=100 Ise=130f Ne=1.5 Ikf=1m
+               Xtb=1.5 Br=1 Isc=0 Nc=2 Ikr=0 Rc=0 Cjc=4p Mjc=.3333
+               Vjc=.75 Fc=.5 Cje=1.4p Mje=.3333 Vje=.75 Tr=500n Tf=23n Itf=.1
+               Xtf=1 Vtf=10 Cjs=5.5p Mjs=.3333 Vjs=.75)

* rcanpn model created using Parts version 5.1 on 07/21/92 at 12:01
* substrate capacitance added 7/21/92 jpd
.model vertnpn   NPN(level=1
+		Is=21.48f Xti=3 Eg=1.11 Vaf=80 Bf=550 Ise=50f Ne=1.5
+               Ikf=10m Xtb=1.5 Br=.1 Isc=10f Nc=2 Ikr=3m Rc=10 Cjc=800f
+               Mjc=.3333 Vjc=.75 Fc=.5 Cje=1.3p Mje=.3333 Vje=.75 Tr=30n
+               Tf=400p Itf=30m Xtf=1 Vtf=10 Cjs=5.8p Mjs=.3333 Vjs=.75)
