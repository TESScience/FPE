v 20130925 2
C 40000 40000 0 0 0 Noqsi-title-B.sym
{
T 50000 40500 5 10 1 1 0 0 1
date=$Date: 2009-01-11 18:02:03 $
T 53900 40500 5 10 1 1 0 0 1
rev=$Revision: 1.1 $
T 55400 40200 5 10 1 1 0 0 1
auth=$Author: jpd $
T 50200 40800 5 8 1 1 0 0 1
fname=$Source: /cvs/MIT/TESS/AE/minisys/components/symbols/Noqsi-title-B.sym,v $
T 53200 41200 5 14 1 1 0 4 1
title=TITLE
}
C 42100 47100 1 0 0 vpulse-1.sym
{
T 42800 47750 5 10 1 1 0 0 1
refdes=Vin
T 42800 47550 5 10 1 1 0 0 1
value=pulse 0 1 10n 10n 10n 160n 320n
}
C 45900 47900 1 0 0 tline.sym
{
T 46950 47850 5 10 1 1 0 0 1
refdes=Tc
T 46300 48600 5 10 1 1 0 0 1
value=TD=10ns Z0=100
}
N 43100 48300 42400 48300 4
C 46200 47600 1 0 0 gnd-1.sym
C 47600 47600 1 0 0 gnd-1.sym
C 42300 46800 1 0 0 gnd-1.sym
C 48800 47100 1 0 0 capacitor-1.sym
{
T 49000 47600 5 10 1 1 0 0 1
refdes=Ct
T 49000 48000 5 10 0 0 0 0 1
symversion=0.1
T 49400 47100 5 10 1 1 0 0 1
value=100pF
}
C 48800 48200 1 0 0 resistor-1.sym
{
T 49000 48500 5 10 1 1 0 0 1
refdes=Rt
T 49100 48000 5 10 1 1 0 0 1
value=100
}
N 48800 48300 48100 48300 4
{
T 48300 48400 5 10 1 1 0 0 1
netname=t
}
C 48700 47000 1 0 0 gnd-1.sym
N 49700 48300 49700 47300 4
{
T 49800 47800 5 10 1 1 0 0 1
netname=out
}
C 43100 48200 1 0 0 resistor-1.sym
{
T 43300 48500 5 10 1 1 0 0 1
refdes=Rin
T 43400 48000 5 10 1 1 0 0 1
value=30
}
N 44000 48300 45900 48300 4
{
T 44700 48500 5 10 1 1 0 0 1
netname=in
}
