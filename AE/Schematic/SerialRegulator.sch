v 20130925 2
C 40000 40000 0 0 0 Noqsi-title-B.sym
{
T 50000 40500 5 10 1 1 0 0 1
date=20141202
T 53900 40500 5 10 1 1 0 0 1
rev=6.0
T 55400 40200 5 10 1 1 0 0 1
auth=jpd
T 50200 40800 5 8 1 1 0 0 1
fname=SerialRegulator.sch
T 53200 41200 5 14 1 1 0 4 1
title=Serial Clock Regulator
}
C 45900 48200 1 180 0 pnp.sym
{
T 45300 47700 5 10 1 1 180 0 1
refdes=Q2
T 45900 48200 5 10 0 0 0 0 1
model-name=MMBT2907A
T 45900 48200 5 10 0 0 0 0 1
value=MMBT2907A
}
C 46300 47700 1 180 1 pnp.sym
{
T 46900 47200 5 10 1 1 180 6 1
refdes=Q3
T 46300 47700 5 10 0 0 0 0 1
model-name=MMBT2907A
T 46300 47700 5 10 0 0 0 0 1
value=MMBT2907A
}
C 46900 47700 1 90 0 resistor.sym
{
T 47200 48500 5 10 1 1 180 0 1
refdes=R9
T 46900 48000 5 10 1 1 0 0 1
value=16.9
}
N 44500 47200 46300 47200 4
{
T 45800 47200 5 10 1 1 0 0 1
netname=b
}
N 45900 47700 46800 47700 4
N 44500 48600 54400 48600 4
N 45400 48600 45400 48200 4
N 45400 45000 45000 45000 4
C 48100 43300 1 90 0 bypass.sym
{
T 48300 44100 5 10 1 1 180 0 1
refdes=C3
T 47200 43300 5 10 0 0 90 0 1
symversion=20131108
T 48500 43600 5 10 1 1 180 0 1
value=1uF
T 46100 42300 5 10 0 1 90 0 1
spec=25WVDC X7R
T 47000 43300 5 10 0 0 90 0 1
footprint=1712
}
C 46900 42200 1 90 0 resistor.sym
{
T 47200 43000 5 10 1 1 180 0 1
refdes=R6
T 46900 42600 5 10 1 1 0 0 1
value=20k
}
N 46800 43100 46800 46700 4
C 45100 43000 1 0 0 resistor.sym
{
T 45300 43300 5 10 1 1 0 0 1
refdes=R5
T 45300 42800 5 10 1 1 0 0 1
value=301k
}
C 42900 43000 1 0 0 resistor.sym
{
T 43100 43300 5 10 1 1 0 0 1
refdes=R4
T 43100 42800 5 10 1 1 0 0 1
value=32.4k
}
N 43800 43100 45100 43100 4
C 42000 43000 1 0 0 resistor.sym
{
T 42200 43300 5 10 1 1 0 0 1
refdes=R3
T 42200 42800 5 10 1 1 0 0 1
value=1k
}
C 43100 41800 1 90 0 smallbypass.sym
{
T 43300 42600 5 10 1 1 180 0 1
refdes=C2
T 42200 41800 5 10 0 0 90 0 1
symversion=20131108
T 43400 42100 5 10 1 1 180 0 1
value=0.1uF
}
N 42900 42700 42900 43100 4
N 44000 43100 44000 44800 4
C 41900 45100 1 0 0 resistor.sym
{
T 42100 45400 5 10 1 1 0 0 1
refdes=R1
T 42100 44900 5 10 1 1 0 0 1
value=34.0k
}
C 41900 44400 1 0 0 resistor.sym
{
T 42100 44700 5 10 1 1 0 0 1
refdes=R2
T 42100 44200 5 10 1 1 0 0 1
value=26.7k
}
N 44000 45200 42800 45200 4
C 42800 41500 1 0 0 gnd-1.sym
C 47800 43000 1 0 0 gnd-1.sym
N 46000 43100 46800 43100 4
C 41800 44200 1 0 0 gnd-1.sym
N 42800 44500 42800 45200 4
C 44600 47400 1 90 0 resistor.sym
{
T 44900 48200 5 10 1 1 180 0 1
refdes=R8
T 44600 47700 5 10 1 1 0 0 1
value=10k
}
N 44500 47200 44500 47400 4
N 44500 48600 44500 48300 4
C 46900 49200 1 0 0 gp_opamp_dual_pwr.sym
{
T 47100 51200 5 8 0 0 0 0 1
symversion=1.0
T 47550 49750 5 10 1 1 0 0 1
refdes=U1
}
C 47100 48900 1 0 0 gnd-1.sym
C 48400 49400 1 90 0 smallbypass.sym
{
T 48600 50200 5 10 1 1 180 0 1
refdes=C5
T 47500 49400 5 10 0 0 90 0 1
symversion=20131108
T 48800 49700 5 10 1 1 180 0 1
value=0.1uF
}
C 48100 49100 1 0 0 gnd-1.sym
N 46800 50300 49000 50300 4
N 47200 50300 47200 50100 4
C 45900 50200 1 0 0 resistor.sym
{
T 46100 50500 5 10 1 1 0 0 1
refdes=R10
T 46100 50000 5 10 1 1 0 0 1
value=49.9
}
C 50400 46400 1 180 1 gp_opamp_dual.sym
{
T 51100 45700 5 10 1 1 180 6 1
refdes=U1
T 50700 43700 5 8 0 0 180 6 1
symversion=1.0nicer
T 50400 46400 5 10 0 0 180 6 1
slot=2
}
N 45900 50300 45400 50300 4
N 42000 43100 41400 43100 4
N 41900 45200 41500 45200 4
N 47700 45000 46800 45000 4
C 46000 43600 1 90 0 resistor.sym
{
T 46300 44400 5 10 1 1 180 0 1
refdes=R7
T 46000 44000 5 10 1 1 0 0 1
value=499
}
C 45400 44500 1 0 0 npn.sym
{
T 46000 45000 5 10 1 1 0 0 1
refdes=Q1
T 45400 44500 5 10 0 0 0 0 1
model-name=MMBT2222A
T 45400 44500 5 10 0 0 0 0 1
value=MMBT2222A
}
C 45800 43300 1 0 0 gnd-1.sym
N 45900 45500 45900 47200 4
C 43900 44600 1 0 0 gp_opamp_dual.sym
{
T 44600 45300 5 10 1 1 0 0 1
refdes=U1
T 44200 47300 5 8 0 0 0 0 1
symversion=1.0nicer
}
C 45100 44400 1 180 0 smallbypass.sym
{
T 44300 44400 5 10 1 1 0 0 1
refdes=C1
T 45100 43500 5 10 0 0 180 0 1
symversion=20131108
T 44800 43900 5 10 1 1 0 0 1
value=4.7pF
T 45100 43000 5 10 0 1 180 0 1
spec=100WVDC NP0
}
N 44200 44200 44000 44200 4
N 45100 44200 45100 45000 4
C 46800 44100 1 0 0 resistor.sym
{
T 47000 44400 5 10 1 1 0 0 1
refdes=R11
T 47000 43900 5 10 1 1 0 0 1
value=10
}
N 47700 44200 47900 44200 4
C 44800 50200 1 0 0 in-1.sym
{
T 44800 50500 5 10 0 0 0 0 1
device=INPUT
T 44500 50200 5 10 1 1 0 0 1
refdes=+5
}
C 40900 48000 1 0 0 SerialRegulator.sym
{
T 42700 50300 5 10 1 1 0 6 1
refdes=X?
T 42200 48700 5 10 0 0 0 0 1
graphical=1
}
C 40900 45100 1 0 0 in-1.sym
{
T 40900 45400 5 10 0 0 0 0 1
device=INPUT
T 40300 45100 5 10 1 1 0 0 1
refdes=VDAC
}
C 40800 43000 1 0 0 in-1.sym
{
T 40800 43300 5 10 0 0 0 0 1
device=INPUT
T 40200 43000 5 10 1 1 0 0 1
refdes=DACp
}
C 47700 44900 1 0 0 out-1.sym
{
T 47700 45100 5 10 1 1 0 0 1
refdes=Vp
}
C 43900 48500 1 0 0 in-1.sym
{
T 43900 48800 5 10 0 0 0 0 1
device=INPUT
T 43600 48500 5 10 1 1 0 0 1
refdes=V+
}
C 46200 41900 1 0 0 in-1.sym
{
T 46200 42200 5 10 0 0 0 0 1
device=INPUT
T 45900 41900 5 10 1 1 0 0 1
refdes=V-
}
N 46800 42000 46800 42200 4
C 50500 47600 1 0 0 resistor.sym
{
T 50700 47900 5 10 1 1 0 0 1
refdes=R15
T 50700 47400 5 10 1 1 0 0 1
value=301k
}
N 50500 45800 43900 45800 4
N 43900 45800 43900 45200 4
C 51400 47100 1 180 0 smallbypass.sym
{
T 50600 47100 5 10 1 1 0 0 1
refdes=C6
T 51400 46200 5 10 0 0 180 0 1
symversion=20131108
T 51100 46600 5 10 1 1 0 0 1
value=4.7pF
T 51400 45700 5 10 0 1 180 0 1
spec=100WVDC NP0
}
N 50500 46200 50500 47700 4
C 49600 47600 1 0 0 resistor.sym
{
T 49800 47900 5 10 1 1 0 0 1
refdes=R14
T 49800 47400 5 10 1 1 0 0 1
value=32.4k
}
C 48700 47600 1 0 0 resistor.sym
{
T 48900 47900 5 10 1 1 0 0 1
refdes=R13
T 48900 47400 5 10 1 1 0 0 1
value=1k
}
C 49800 46400 1 90 0 smallbypass.sym
{
T 50000 47200 5 10 1 1 180 0 1
refdes=C7
T 48900 46400 5 10 0 0 90 0 1
symversion=20131108
T 50100 46700 5 10 1 1 180 0 1
value=0.1uF
}
N 49600 47300 49600 47700 4
C 49500 46100 1 0 0 gnd-1.sym
N 48700 47700 48600 47700 4
C 48000 47600 1 0 0 in-1.sym
{
T 48000 47900 5 10 0 0 0 0 1
device=INPUT
T 47400 47600 5 10 1 1 0 0 1
refdes=DACn
}
C 51800 46500 1 180 1 pnp.sym
{
T 52400 46000 5 10 1 1 180 6 1
refdes=Q4
T 51800 46500 5 10 0 0 0 0 1
model-name=MMBT2907A
T 51800 46500 5 10 0 0 0 0 1
value=MMBT2907A
}
N 51800 46000 51500 46000 4
N 51400 46900 51800 46900 4
N 51800 46900 51800 46000 4
C 52400 46500 1 90 0 resistor.sym
{
T 52800 47100 5 10 1 1 180 0 1
refdes=R17
T 52500 46700 5 10 1 1 0 0 1
value=499
}
C 53600 47700 1 90 0 resistor.sym
{
T 54000 48500 5 10 1 1 180 0 1
refdes=R16
T 53700 48100 5 10 1 1 0 0 1
value=20k
}
N 53500 47700 51400 47700 4
N 49000 50300 49000 49000 4
N 49000 49000 52300 49000 4
N 52300 49000 52300 47400 4
C 53000 44000 1 0 0 npn.sym
{
T 53600 44500 5 10 1 1 0 0 1
refdes=Q5
T 53000 44000 5 10 0 0 0 0 1
model-name=MMBT2222A
T 53000 44000 5 10 0 0 0 0 1
value=MMBT2222A
}
C 53600 43100 1 90 0 resistor.sym
{
T 53900 43900 5 10 1 1 180 0 1
refdes=R19
T 53600 43400 5 10 1 1 0 0 1
value=16.9
}
C 53000 43500 1 0 1 npn.sym
{
T 52400 44000 5 10 1 1 0 6 1
refdes=Q6
T 53000 43500 5 10 0 0 0 6 1
model-name=MMBT2222A
T 53000 43500 5 10 0 0 0 0 1
value=MMBT2222A
}
C 51600 43600 1 90 0 resistor.sym
{
T 51900 44400 5 10 1 1 180 0 1
refdes=R18
T 51600 43900 5 10 1 1 0 0 1
value=10k
}
N 53000 44500 51500 44500 4
N 52300 45500 52300 44500 4
N 53500 43100 53500 43000 4
N 53500 43000 51500 43000 4
N 51500 42000 51500 43600 4
N 51500 42000 46800 42000 4
N 52500 43500 52500 43000 4
N 53000 44000 53500 44000 4
N 53500 45000 53500 47700 4
C 54800 44400 1 90 0 bypass.sym
{
T 55000 45200 5 10 1 1 180 0 1
refdes=C8
T 53900 44400 5 10 0 0 90 0 1
symversion=20131108
T 55200 44700 5 10 1 1 180 0 1
value=1uF
T 52800 43400 5 10 0 1 90 0 1
spec=25WVDC X7R
T 53700 44400 5 10 0 0 90 0 1
footprint=1712
}
C 54500 44100 1 0 0 gnd-1.sym
C 53500 45200 1 0 0 resistor.sym
{
T 53700 45500 5 10 1 1 0 0 1
refdes=R20
T 53700 45000 5 10 1 1 0 0 1
value=10
}
N 54400 45300 54600 45300 4
C 54000 46200 1 0 0 out-1.sym
{
T 54000 46400 5 10 1 1 0 0 1
refdes=Vn
}
N 54000 46300 53500 46300 4
C 46200 41400 1 0 0 in-1.sym
{
T 46200 41700 5 10 0 0 0 0 1
device=INPUT
T 45900 41400 5 10 1 1 0 0 1
refdes=GND
}
C 46700 41200 1 0 0 gnd-1.sym
C 43400 44300 1 90 0 smallbypass.sym
{
T 43600 45100 5 10 1 1 180 0 1
refdes=C4
T 42500 44300 5 10 0 0 90 0 1
symversion=20131108
T 43800 44600 5 10 1 1 180 0 1
value=0.1uF
}
C 43100 44000 1 0 0 gnd-1.sym
C 53200 42100 1 90 0 bypass.sym
{
T 53400 42900 5 10 1 1 180 0 1
refdes=C9
T 52300 42100 5 10 0 0 90 0 1
symversion=20131108
T 53600 42400 5 10 1 1 180 0 1
value=1uF
T 51200 41100 5 10 0 1 90 0 1
spec=25WVDC X7R
T 52100 42100 5 10 0 0 90 0 1
footprint=1712
}
C 52900 41800 1 0 0 gnd-1.sym
C 54600 47700 1 90 0 bypass.sym
{
T 54800 48500 5 10 1 1 180 0 1
refdes=C10
T 53700 47700 5 10 0 0 90 0 1
symversion=20131108
T 55000 48000 5 10 1 1 180 0 1
value=1uF
T 52600 46700 5 10 0 1 90 0 1
spec=25WVDC X7R
T 53500 47700 5 10 0 0 90 0 1
footprint=1712
}
C 54300 47400 1 0 0 gnd-1.sym
C 46800 46300 1 0 0 resistor.sym
{
T 47000 46600 5 10 1 1 0 0 1
refdes=R21
T 47000 46100 5 10 1 1 0 0 1
value=604k
}
C 47700 46300 1 0 0 out-1.sym
{
T 47700 46500 5 10 1 1 0 0 1
refdes=HKp
}
C 53500 46900 1 0 0 resistor.sym
{
T 53700 47200 5 10 1 1 0 0 1
refdes=R22
T 53700 46700 5 10 1 1 0 0 1
value=604k
}
C 54400 46900 1 0 0 out-1.sym
{
T 54400 47100 5 10 1 1 0 0 1
refdes=HKn
}
T 50600 40100 9 10 1 0 0 0 1
1
T 51900 40100 9 10 1 0 0 0 1
1
