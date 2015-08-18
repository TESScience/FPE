v 20130925 2
C 40000 40000 0 0 0 Noqsi-title-B.sym
{
T 50000 40500 5 10 1 1 0 0 1
date=20141207
T 53900 40500 5 10 1 1 0 0 1
rev=1
T 55400 40200 5 10 1 1 0 0 1
auth=jpd
T 50200 40800 5 8 1 1 0 0 1
fname=3phase.sch
T 53200 41200 5 14 1 1 0 4 1
title=Three Phase Clock Model
}
C 46900 46300 1 0 0 capacitor-1.sym
{
T 47100 47200 5 10 0 0 0 0 1
symversion=0.1
T 47100 46800 5 10 1 1 0 0 1
refdes=C1s
T 47100 46000 5 10 1 1 0 0 1
value={m*ccs}
}
C 47800 47200 1 0 0 capacitor-1.sym
{
T 48000 48100 5 10 0 0 0 0 1
symversion=0.1
T 48000 47700 5 10 1 1 0 0 1
refdes=C2s
T 48000 46900 5 10 1 1 0 0 1
value={m*ccs}
}
C 47800 45400 1 0 0 capacitor-1.sym
{
T 48000 46300 5 10 0 0 0 0 1
symversion=0.1
T 48000 45900 5 10 1 1 0 0 1
refdes=C3s
T 48000 45100 5 10 1 1 0 0 1
value={m*ccs}
}
N 47800 47400 47800 45600 4
C 46900 47800 1 0 0 capacitor-1.sym
{
T 47100 48700 5 10 0 0 0 0 1
symversion=0.1
T 47100 48300 5 10 1 1 0 0 1
refdes=C12
T 47100 47500 5 10 1 1 0 0 1
value={m*ccc}
}
C 46900 44600 1 0 0 capacitor-1.sym
{
T 47100 45500 5 10 0 0 0 0 1
symversion=0.1
T 47100 45100 5 10 1 1 0 0 1
refdes=C31
T 47100 44300 5 10 1 1 0 0 1
value={m*ccc}
}
N 46900 48000 46900 44800 4
N 47800 44800 49000 44800 4
N 48700 44800 48700 45600 4
N 47800 48000 49000 48000 4
N 48700 46500 48700 48000 4
C 48700 46300 1 0 0 capacitor-1.sym
{
T 48900 47200 5 10 0 0 0 0 1
symversion=0.1
T 48900 46800 5 10 1 1 0 0 1
refdes=C23
T 48900 46000 5 10 1 1 0 0 1
value={m*ccc}
}
N 48700 45600 49600 45600 4
N 49600 45600 49600 46500 4
T 40200 49900 8 10 1 1 0 0 5
spice-prolog=.subckt clocks3 %up ccc=25pF ccs=80pF m=4
* Three phase clock set
* ccc is clock-clock capacitance per segment
* ccs is clock-channel stop capacitance per segment
* m is number of segments
C 45900 47900 1 0 0 in-1.sym
{
T 45900 48200 5 10 1 1 0 0 1
refdes=P1
}
N 46500 48000 46900 48000 4
C 46000 45500 1 0 0 in-1.sym
{
T 46000 45800 5 10 1 1 0 0 1
refdes=CS
}
N 47800 45600 46600 45600 4
C 49600 47900 1 0 1 in-1.sym
{
T 49600 48200 5 10 1 1 0 6 1
refdes=P2
}
C 49600 44700 1 0 1 in-1.sym
{
T 49600 45000 5 10 1 1 0 6 1
refdes=P3
}
T 50600 40200 9 10 1 0 0 0 1
1
T 51900 40200 9 10 1 0 0 0 1
1
