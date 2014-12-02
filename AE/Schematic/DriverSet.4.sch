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
fname=DriverSet.4.sch
T 53200 41200 5 14 1 1 0 4 1
title=Driver Set
}
C 45000 44300 1 0 0 AD5308.sym
{
T 46800 48400 5 10 1 1 0 6 1
refdes=U2
T 45900 46700 5 10 0 0 0 0 1
device=AD5328
T 45900 46900 5 10 0 0 0 0 1
footprint=TSSOP16
}
N 47100 47900 48100 47900 4
{
T 47300 48100 5 10 1 1 0 1 1
netname=DACPP
}
N 47100 47500 48100 47500 4
{
T 47300 47700 5 10 1 1 0 1 1
netname=DACPN
}
N 47100 47100 48100 47100 4
{
T 47300 47300 5 10 1 1 0 1 1
netname=DACSP
}
N 47100 46700 48100 46700 4
{
T 47300 46900 5 10 1 1 0 1 1
netname=DACSN
}
N 47100 46300 48100 46300 4
{
T 47300 46500 5 10 1 1 0 1 1
netname=DACRP
}
N 47100 45900 48100 45900 4
{
T 47300 46100 5 10 1 1 0 1 1
netname=DACRN
}
C 45000 44800 1 0 0 gnd-1.sym
N 43700 46300 45100 46300 4
N 43700 45900 45100 45900 4
N 43700 45500 45100 45500 4
C 48100 45900 1 0 0 busripper-1.sym
C 48100 46300 1 0 0 busripper-1.sym
C 48100 46700 1 0 0 busripper-1.sym
C 48100 47100 1 0 0 busripper-1.sym
C 48100 47500 1 0 0 busripper-1.sym
C 48100 47900 1 0 0 busripper-1.sym
C 46000 44100 1 0 0 gnd-1.sym
N 47100 45500 48100 45500 4
{
T 47300 45700 5 10 1 1 0 1 1
netname=DACIDP
}
N 47100 45100 48100 45100 4
{
T 47300 45300 5 10 1 1 0 1 1
netname=DACIDN
}
C 48100 45100 1 0 0 busripper-1.sym
C 48100 45500 1 0 0 busripper-1.sym
C 49900 47100 1 0 0 gnd-1.sym
N 50500 47400 50000 47400 4
C 52000 48500 1 0 0 gnd-1.sym
N 51300 47400 51300 47900 4
C 50900 48600 1 0 0 capacitor.sym
{
T 51100 49100 5 10 1 1 0 0 1
refdes=C31
T 51100 49500 5 10 0 0 0 0 1
symversion=0.1
T 51500 48600 5 10 1 1 0 0 1
value=22nF
T 50900 48600 5 10 0 1 0 0 1
footprint=0603
T 50900 48600 5 10 0 1 0 0 1
spec=50WVDC X7R
}
N 51800 48800 52100 48800 4
N 50900 47400 50900 48800 4
C 49900 44000 1 0 0 MUX08.sym
{
T 51600 47200 5 10 1 1 0 0 1
refdes=U3
}
N 51000 42400 51000 44000 4
N 50700 43100 50700 44000 4
N 51300 41700 51300 44000 4
N 48500 44900 49900 44900 4
{
T 48500 44700 5 10 1 1 0 0 1
netname=HKIDP
}
C 52400 47600 1 0 0 gnd-1.sym
C 51300 47700 1 0 0 capacitor.sym
{
T 51500 48200 5 10 1 1 0 0 1
refdes=C32
T 51500 48600 5 10 0 0 0 0 1
symversion=0.1
T 51900 47700 5 10 1 1 0 0 1
value=22nF
T 51300 47700 5 10 0 1 0 0 1
footprint=0603
T 51300 47700 5 10 0 1 0 0 1
spec=50WVDC X7R
}
N 52200 47900 52500 47900 4
N 51300 47900 50700 47900 4
N 48500 47900 49800 47900 4
{
T 49000 48000 5 10 1 1 0 0 1
netname=-12
}
N 48500 48800 50000 48800 4
{
T 48900 49000 5 10 1 1 0 0 1
netname=+15
}
U 48300 42200 48300 50700 10 -1
N 49900 46700 48500 46700 4
{
T 48500 46500 5 10 1 1 0 0 1
netname=HKPP
}
C 48500 46700 1 180 0 busripper-1.sym
N 49900 46400 48500 46400 4
{
T 48500 46200 5 10 1 1 0 0 1
netname=HKPN
}
C 48500 46400 1 180 0 busripper-1.sym
N 49900 46100 48500 46100 4
{
T 48500 45900 5 10 1 1 0 0 1
netname=HKSP
}
C 48500 46100 1 180 0 busripper-1.sym
N 49900 45800 48500 45800 4
{
T 48500 45600 5 10 1 1 0 0 1
netname=HKSN
}
C 48500 45800 1 180 0 busripper-1.sym
N 49900 45500 48500 45500 4
{
T 48500 45300 5 10 1 1 0 0 1
netname=HKRP
}
C 48500 45500 1 180 0 busripper-1.sym
N 49900 45200 48500 45200 4
{
T 48500 45000 5 10 1 1 0 0 1
netname=HKRN
}
C 48500 45200 1 180 0 busripper-1.sym
C 48500 44900 1 180 0 busripper-1.sym
C 48500 44600 1 180 0 busripper-1.sym
N 48500 44600 49900 44600 4
{
T 48500 44400 5 10 1 1 0 0 1
netname=HKIDN
}
C 49800 43700 1 0 0 in-1.sym
{
T 49700 44000 5 10 1 1 0 0 1
refdes=HKA0
}
C 49800 43000 1 0 0 in-1.sym
{
T 49700 43300 5 10 1 1 0 0 1
refdes=HKA1
}
C 49800 42300 1 0 0 in-1.sym
{
T 49700 42600 5 10 1 1 0 0 1
refdes=HKA2
}
C 49800 41600 1 0 0 in-1.sym
{
T 49700 41900 5 10 1 1 0 0 1
refdes=HKSEL
}
N 50400 41700 51300 41700 4
N 50400 42400 51000 42400 4
N 50400 43100 50700 43100 4
N 50400 43800 50400 44000 4
C 51800 45600 1 0 0 out-1.sym
{
T 52000 45800 5 10 1 1 0 0 1
refdes=HKCOM
}
C 48500 47900 1 180 0 busripper-1.sym
C 48500 48800 1 180 0 busripper-1.sym
C 44500 47000 1 90 0 smallbypass.sym
{
T 44700 47800 5 10 1 1 180 0 1
refdes=C6
T 43600 47000 5 10 0 0 90 0 1
symversion=20131108
T 44900 47300 5 10 1 1 180 0 1
value=0.1uF
}
C 44200 46700 1 0 0 gnd-1.sym
N 43600 47900 45100 47900 4
N 45100 47900 45100 47500 4
C 43000 47800 1 0 0 in-1.sym
{
T 42900 48100 5 10 1 1 0 0 1
refdes=Ref
}
N 43600 47900 43600 50400 4
N 43600 50400 48100 50400 4
{
T 47100 50500 5 10 1 1 0 0 1
netname=+3.3DAC
}
C 48100 50400 1 270 0 busripper-1.sym
C 46500 49400 1 0 0 resistor.sym
{
T 46700 49700 5 10 1 1 0 0 1
refdes=R10
T 46800 49200 5 10 1 1 0 0 1
value=49.9
}
N 47400 49500 48100 49500 4
{
T 47700 49600 5 10 1 1 0 0 1
netname=+5
}
C 48100 49500 1 270 0 busripper-1.sym
C 45100 48600 1 90 0 smallbypass.sym
{
T 45300 49400 5 10 1 1 180 0 1
refdes=C7
T 44200 48600 5 10 0 0 90 0 1
symversion=20131108
T 45500 48900 5 10 1 1 180 0 1
value=0.1uF
}
N 44900 49500 46500 49500 4
N 46100 49500 46100 48600 4
C 44800 48300 1 0 0 gnd-1.sym
C 50000 48700 1 0 0 resistor.sym
{
T 50200 49000 5 10 1 1 0 0 1
refdes=R11
T 49800 48600 5 10 1 1 0 0 1
value=3.74k
}
C 49800 47800 1 0 0 resistor.sym
{
T 50000 48100 5 10 1 1 0 0 1
refdes=R12
T 49600 47700 5 10 1 1 0 0 1
value=3.74k
}
C 43100 46200 1 0 0 in-1.sym
{
T 42700 46200 5 10 1 1 0 0 1
refdes=DD
}
C 43100 45800 1 0 0 in-1.sym
{
T 42700 45800 5 10 1 1 0 0 1
refdes=DCK
}
C 43100 45400 1 0 0 in-1.sym
{
T 42700 45400 5 10 1 1 0 0 1
refdes=DS
}
C 46800 43400 1 0 0 in-1.sym
{
T 46400 43400 5 10 1 1 0 0 1
refdes=+15
}
C 46800 43000 1 0 0 in-1.sym
{
T 46400 43000 5 10 1 1 0 0 1
refdes=+5
}
C 46800 42600 1 0 0 in-1.sym
{
T 46400 42600 5 10 1 1 0 0 1
refdes=-12
}
N 47400 43500 48100 43500 4
{
T 47600 43600 5 10 1 1 0 0 1
netname=+15
}
C 48100 43500 1 270 0 busripper-1.sym
N 47400 43100 48100 43100 4
{
T 47700 43200 5 10 1 1 0 0 1
netname=+5
}
C 48100 43100 1 270 0 busripper-1.sym
N 47400 42700 48100 42700 4
{
T 47700 42800 5 10 1 1 0 0 1
netname=-12
}
C 48100 42700 1 270 0 busripper-1.sym
C 46800 41900 1 0 0 in-1.sym
{
T 46400 41900 5 10 1 1 0 0 1
refdes=GND
}
C 47300 41700 1 0 0 gnd-1.sym
T 50300 40100 9 10 1 0 0 0 1
4
T 52000 40100 9 10 1 0 0 0 1
4
