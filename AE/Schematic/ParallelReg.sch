v 20110115 2
C 40000 40000 0 0 0 Noqsi-title-B.sym
{
T 50000 40500 5 10 1 1 0 0 1
date=20140125
T 53900 40500 5 10 1 1 0 0 1
rev=5.0
T 55400 40200 5 10 1 1 0 0 1
auth=jpd
T 50200 40800 5 8 1 1 0 0 1
fname=ParallelReg.sch
T 53200 41200 5 14 1 1 0 4 1
title=Parallel Clock Regulator
}
C 40500 44000 1 0 0 ParallelReg.sym
{
T 41700 44600 5 10 0 1 0 0 1
graphical=1
T 42250 46050 5 10 1 1 0 6 1
refdes=X?
}
C 43600 47900 1 0 0 gp_opamp_dual.sym
{
T 44300 48600 5 10 1 1 0 0 1
refdes=U1
T 43900 50600 5 8 0 0 0 0 1
symversion=1.0nicer
}
C 43700 47400 1 0 0 resistor.sym
{
T 43900 47700 5 10 1 1 0 0 1
refdes=R4
T 43900 47200 5 10 1 1 0 0 1
value=301k
}
C 42800 47400 1 0 0 resistor.sym
{
T 43000 47700 5 10 1 1 0 0 1
refdes=R3
T 43000 47200 5 10 1 1 0 0 1
value=54.9k
}
N 43700 48100 43700 47500 4
N 44600 47500 44700 47500 4
N 44700 47500 44700 48300 4
C 42500 48400 1 0 0 resistor.sym
{
T 42700 48700 5 10 1 1 0 0 1
refdes=R1
T 42700 48200 5 10 1 1 0 0 1
value=54.9k
}
C 41600 48400 1 0 0 in-1.sym
{
T 41600 48700 5 10 0 0 0 0 1
device=INPUT
T 41000 48400 5 10 1 1 0 0 1
refdes=DACs
}
C 43600 43100 1 0 0 gp_opamp_dual.sym
{
T 44300 43800 5 10 1 1 0 0 1
refdes=U2
T 43900 45800 5 8 0 0 0 0 1
symversion=1.0nicer
}
C 43700 42600 1 0 0 resistor.sym
{
T 43900 42900 5 10 1 1 0 0 1
refdes=R14
T 43900 42400 5 10 1 1 0 0 1
value=301k
}
C 42800 42600 1 0 0 resistor.sym
{
T 43000 42900 5 10 1 1 0 0 1
refdes=R13
T 43000 42400 5 10 1 1 0 0 1
value=75k
}
N 43700 43300 43700 42700 4
C 42400 43400 1 0 0 gnd-1.sym
N 44600 42700 44700 42700 4
N 44700 42700 44700 46700 4
C 42800 43600 1 0 0 resistor.sym
{
T 43000 43900 5 10 1 1 0 0 1
refdes=R11
T 43000 43400 5 10 1 1 0 0 1
value=60.4k
}
N 42200 48500 42500 48500 4
N 42600 42700 42800 42700 4
N 42500 43700 42800 43700 4
C 44700 48200 1 0 0 resistor.sym
{
T 44900 48500 5 10 1 1 0 0 1
refdes=R5
T 44900 48000 5 10 1 1 0 0 1
value=10k
}
C 44700 43400 1 0 0 resistor.sym
{
T 44900 43700 5 10 1 1 0 0 1
refdes=R15
T 44900 43200 5 10 1 1 0 0 1
value=10k
}
C 45800 47400 1 90 0 smallbypass.sym
{
T 46000 48200 5 10 1 1 180 0 1
refdes=C3
T 44900 47400 5 10 0 0 90 0 1
symversion=20131108
T 46200 47700 5 10 1 1 180 0 1
value=22nF
T 44400 47400 5 10 0 1 90 0 1
spec=50WVDC
}
C 45500 47100 1 0 0 gnd-1.sym
C 45800 42600 1 90 0 smallbypass.sym
{
T 46000 43400 5 10 1 1 180 0 1
refdes=C4
T 44900 42600 5 10 0 0 90 0 1
symversion=20131108
T 46200 42900 5 10 1 1 180 0 1
value=22nF
T 44400 42600 5 10 0 1 90 0 1
spec=50WVDC
}
C 45500 42300 1 0 0 gnd-1.sym
C 46500 47700 1 0 0 gp_opamp_dual.sym
{
T 47200 48400 5 10 1 1 0 0 1
refdes=U1
T 46800 50400 5 8 0 0 0 0 1
symversion=1.0nicer
T 46500 47700 5 10 0 0 0 0 1
slot=2
}
C 47500 47400 1 180 0 smallbypass.sym
{
T 46700 47400 5 10 1 1 0 0 1
refdes=C5
T 47500 46500 5 10 0 0 180 0 1
symversion=20131108
T 47200 46900 5 10 1 1 0 0 1
value=330pF
T 47500 46000 5 10 0 1 180 0 1
spec=50WVDC
}
C 46600 46400 1 0 0 resistor.sym
{
T 46800 46700 5 10 1 1 0 0 1
refdes=R7
T 46800 46200 5 10 1 1 0 0 1
value=10k
}
N 46600 47900 46600 46500 4
C 46700 45000 1 0 0 resistor.sym
{
T 46900 45300 5 10 1 1 0 0 1
refdes=R17
T 46900 44800 5 10 1 1 0 0 1
value=10k
}
N 46600 43500 45600 43500 4
N 46600 48300 45600 48300 4
N 47600 43700 47600 44400 4
N 47500 47200 47600 47200 4
N 47600 47200 47600 48100 4
C 48500 47600 1 0 0 LM395K.sym
{
T 49100 48100 5 10 1 1 0 0 1
refdes=Q1
}
C 47600 48000 1 0 0 resistor.sym
{
T 47800 48300 5 10 1 1 0 0 1
refdes=R6
T 47800 47800 5 10 1 1 0 0 1
value=10k
}
C 47600 44600 1 180 0 smallbypass.sym
{
T 46800 44600 5 10 1 1 0 0 1
refdes=C6
T 47600 43700 5 10 0 0 180 0 1
symversion=20131108
T 47300 44500 5 10 1 1 0 0 1
value=330pF
T 47600 43200 5 10 0 1 180 0 1
spec=50WVDC
}
C 42000 42600 1 0 0 in-1.sym
{
T 42000 42900 5 10 0 0 0 0 1
device=INPUT
T 41400 42600 5 10 1 1 0 0 1
refdes=DACn
}
C 42700 47200 1 0 0 gnd-1.sym
N 43400 48500 43700 48500 4
C 42500 46600 1 0 0 resistor.sym
{
T 42700 46900 5 10 1 1 0 0 1
refdes=R2
T 42700 46400 5 10 1 1 0 0 1
value=301k
}
N 43400 46700 44700 46700 4
N 42500 46700 42500 48000 4
N 42500 48000 43400 48000 4
N 43400 48000 43400 48500 4
C 49200 45800 1 90 0 bypass.sym
{
T 49400 46600 5 10 1 1 180 0 1
refdes=C8
T 48300 45800 5 10 0 0 90 0 1
symversion=20131108
T 49600 46100 5 10 1 1 180 0 1
value=1uF
T 47200 44800 5 10 0 1 90 0 1
spec=25WVDC
T 48100 45800 5 10 0 0 90 0 1
footprint=1812
}
C 49100 46700 1 90 0 resistor.sym
{
T 48900 47200 5 10 1 1 180 0 1
refdes=R8
T 49300 47100 5 10 1 1 180 0 1
value=10
T 48200 47600 5 10 0 0 90 0 1
footprint=2512
T 48500 47300 5 10 0 0 90 0 1
spec=1% 1W
}
C 48900 45500 1 0 0 gnd-1.sym
C 51300 47500 1 0 0 out-1.sym
{
T 51300 47700 5 10 1 1 0 0 1
refdes=Vp
}
N 48200 47600 51300 47600 4
N 47500 46500 48200 46500 4
N 48200 46500 48200 47600 4
C 48900 44200 1 180 1 pnp.sym
{
T 49500 43700 5 10 1 1 180 6 1
refdes=Q3
T 48900 44200 5 10 0 0 0 0 1
model-name=MMBT2907A
T 48900 44200 5 10 0 0 0 0 1
value=MMBT2907A
}
C 47600 43600 1 0 0 resistor.sym
{
T 47800 43900 5 10 1 1 0 0 1
refdes=R16
T 47800 43400 5 10 1 1 0 0 1
value=4.99k
}
C 49400 43100 1 180 0 smallbypass.sym
{
T 48600 43100 5 10 1 1 0 0 1
refdes=C7
T 49400 42200 5 10 0 0 180 0 1
symversion=20131108
T 49100 42600 5 10 1 1 0 0 1
value=47pF
T 49400 41700 5 10 0 1 180 0 1
spec=50WVDC
}
N 48500 42900 48500 43700 4
N 48500 43700 48900 43700 4
N 49400 42900 49400 43200 4
C 49700 42400 1 0 0 LM395K.sym
{
T 50300 42900 5 10 1 1 0 0 1
refdes=Q2
}
C 49800 41900 1 90 0 resistor.sym
{
T 49600 42400 5 10 1 1 180 0 1
refdes=R12
T 49600 42200 5 10 1 1 180 0 1
value=33.2k
T 49200 42500 5 10 0 0 90 0 1
spec=1% 1W
}
N 50200 42400 50200 41900 4
N 47500 41900 53500 41900 4
N 50200 43400 50200 44200 4
N 49400 44200 51300 44200 4
C 51100 42400 1 90 0 bypass.sym
{
T 51300 43200 5 10 1 1 180 0 1
refdes=C9
T 50200 42400 5 10 0 0 90 0 1
symversion=20131108
T 51500 42700 5 10 1 1 180 0 1
value=1uF
T 49100 41400 5 10 0 1 90 0 1
spec=25WVDC
T 50000 42400 5 10 0 0 90 0 1
footprint=1812
}
C 51000 43300 1 90 0 resistor.sym
{
T 50800 43800 5 10 1 1 180 0 1
refdes=R18
T 51200 43700 5 10 1 1 180 0 1
value=10
T 50100 44200 5 10 0 0 90 0 1
footprint=2512
T 50400 43900 5 10 0 0 90 0 1
spec=1% 1W
}
C 50800 42100 1 0 0 gnd-1.sym
C 51300 44100 1 0 0 out-1.sym
{
T 51300 44300 5 10 1 1 0 0 1
refdes=Vn
}
N 49400 42900 49700 42900 4
N 49700 42900 49700 42800 4
C 46500 44100 1 180 1 gp_opamp_dual.sym
{
T 47200 43400 5 10 1 1 180 6 1
refdes=U2
T 46800 41400 5 8 0 0 180 6 1
symversion=1.0nicer
T 46500 44100 5 10 0 0 0 0 1
slot=2
}
N 46700 44400 46600 44400 4
N 46600 43900 46600 45100 4
N 46600 45100 46700 45100 4
N 47600 45100 49900 45100 4
C 54900 45600 1 0 0 gp_opamp_dual_pwr.sym
{
T 55100 47600 5 8 0 0 0 0 1
symversion=1.0
T 55550 46150 5 10 1 1 0 0 1
refdes=U1
}
C 56100 45500 1 0 0 gnd-1.sym
N 55200 46700 55200 46500 4
C 56400 45800 1 90 0 smallbypass.sym
{
T 56600 46600 5 10 1 1 180 0 1
refdes=C1
T 55500 45800 5 10 0 0 90 0 1
symversion=20131108
T 56800 46100 5 10 1 1 180 0 1
value=22nF
T 55000 45800 5 10 0 1 90 0 1
spec=50WVDC
}
N 54400 46700 56200 46700 4
C 50400 48300 1 0 0 resistor.sym
{
T 50600 48600 5 10 1 1 0 0 1
refdes=R10
T 50600 48100 5 10 1 1 0 0 1
value=604k
}
N 50400 48400 50400 47600 4
C 51300 48300 1 0 0 out-1.sym
{
T 51300 48500 5 10 1 1 0 0 1
refdes=HKp
}
C 49900 45000 1 0 0 resistor.sym
{
T 50100 45300 5 10 1 1 0 0 1
refdes=R20
T 50100 44800 5 10 1 1 0 0 1
value=604k
}
C 51300 45000 1 0 0 out-1.sym
{
T 51300 45200 5 10 1 1 0 0 1
refdes=HKn
}
N 51300 45100 50800 45100 4
N 49400 45100 49400 44200 4
C 42000 40900 1 0 0 in-1.sym
{
T 42000 41200 5 10 0 0 0 0 1
device=INPUT
T 41600 40900 5 10 1 1 0 0 1
refdes=GND
}
C 42500 40700 1 0 0 gnd-1.sym
C 49900 48400 1 90 0 bypass.sym
{
T 50100 49200 5 10 1 1 180 0 1
refdes=C10
T 49000 48400 5 10 0 0 90 0 1
symversion=20131108
T 50300 48700 5 10 1 1 180 0 1
value=1uF
T 47900 47400 5 10 0 1 90 0 1
spec=25WVDC
T 48800 48400 5 10 0 0 90 0 1
footprint=1812
}
C 49600 48100 1 0 0 gnd-1.sym
N 53300 49300 49000 49300 4
N 49000 49300 49000 48600 4
C 48400 49200 1 0 0 in-1.sym
{
T 48400 49500 5 10 0 0 0 0 1
device=INPUT
T 48100 49200 5 10 1 1 0 0 1
refdes=V+
}
C 48000 41000 1 90 0 bypass.sym
{
T 48200 41800 5 10 1 1 180 0 1
refdes=C13
T 47100 41000 5 10 0 0 90 0 1
symversion=20131108
T 48400 41300 5 10 1 1 180 0 1
value=1uF
T 46000 40000 5 10 0 1 90 0 1
spec=25WVDC
T 46900 41000 5 10 0 0 90 0 1
footprint=1812
}
C 47700 40700 1 0 0 gnd-1.sym
C 46900 41800 1 0 0 in-1.sym
{
T 46900 42100 5 10 0 0 0 0 1
device=INPUT
T 46600 41800 5 10 1 1 0 0 1
refdes=V-
}
C 54900 44000 1 0 0 gp_opamp_dual_pwr.sym
{
T 55100 46000 5 8 0 0 0 0 1
symversion=1.0
T 55550 44550 5 10 1 1 0 0 1
refdes=U2
}
C 56100 43900 1 0 0 gnd-1.sym
N 55200 45100 55200 44900 4
C 56400 44200 1 90 0 smallbypass.sym
{
T 56600 45000 5 10 1 1 180 0 1
refdes=C2
T 55500 44200 5 10 0 0 90 0 1
symversion=20131108
T 56800 44500 5 10 1 1 180 0 1
value=22nF
T 55000 44200 5 10 0 1 90 0 1
spec=50WVDC
}
N 54700 45100 54700 46700 4
N 54700 45100 56200 45100 4
N 54400 43800 55200 43800 4
N 55200 43800 55200 44000 4
N 54400 41900 54400 45400 4
N 53400 45400 55200 45400 4
N 55200 45400 55200 45600 4
C 55400 42900 1 90 0 smallbypass.sym
{
T 55600 43700 5 10 1 1 180 0 1
refdes=C12
T 54500 42900 5 10 0 0 90 0 1
symversion=20131108
T 55800 43200 5 10 1 1 180 0 1
value=22nF
T 54000 42900 5 10 0 1 90 0 1
spec=50WVDC
}
C 55100 42600 1 0 0 gnd-1.sym
C 53600 44500 1 90 0 smallbypass.sym
{
T 53800 45300 5 10 1 1 180 0 1
refdes=C11
T 52700 44500 5 10 0 0 90 0 1
symversion=20131108
T 54000 44800 5 10 1 1 180 0 1
value=22nF
T 52200 44500 5 10 0 1 90 0 1
spec=50WVDC
}
C 53300 44200 1 0 0 gnd-1.sym
T 50600 40100 9 10 1 0 0 0 1
1
T 51900 40100 9 10 1 0 0 0 1
1
C 53500 41700 1 0 0 zener-1.sym
{
T 53800 42200 5 10 1 1 0 0 1
refdes=Z2
T 53500 41700 5 10 0 0 0 0 1
footprint=SOD80C
T 53500 41700 5 10 0 0 0 0 1
value=BZV55-B3V3
}
C 54400 46500 1 0 1 zener-1.sym
{
T 54100 47000 5 10 1 1 0 6 1
refdes=Z1
T 54400 46500 5 10 0 0 0 6 1
footprint=SOD80C
T 54400 46500 5 10 0 0 0 6 1
value=BZV55-B3V3
}
N 53500 46700 53300 46700 4
N 53300 46700 53300 49300 4
