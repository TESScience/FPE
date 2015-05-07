v 20130925 2
C 40000 40000 0 0 0 Noqsi-title-B.sym
{
T 50000 40500 5 10 1 1 0 0 1
date=20150325
T 53900 40500 5 10 1 1 0 0 1
rev=6.1
T 55400 40200 5 10 1 1 0 0 1
auth=jpd
T 50200 40800 5 8 1 1 0 0 1
fname=DriverSet.1.sch
T 53200 41200 5 14 1 1 0 4 1
title=Driver Set
}
T 50500 40200 9 10 1 0 0 0 1
1
C 50300 42000 1 0 0 ParallelPair.sym
{
T 52000 44900 5 10 1 1 0 6 1
refdes=X4
}
C 44500 41300 1 0 0 ParallelPair.sym
{
T 46200 44200 5 10 1 1 0 6 1
refdes=X3
}
C 48600 45900 1 0 0 ParallelPair.sym
{
T 50300 48800 5 10 1 1 0 6 1
refdes=X2
}
C 43300 46600 1 0 0 ParallelReg.sym
{
T 44750 48850 5 10 1 1 0 6 1
refdes=X1
}
N 48600 48200 46200 48200 4
N 45000 47500 45900 47500 4
N 45900 46700 48600 46700 4
N 45900 45200 45900 47500 4
N 43000 45200 43000 42100 4
N 43000 42100 44500 42100 4
N 50300 42800 48900 42800 4
N 48900 42800 48900 45200 4
N 43000 45200 48900 45200 4
N 46200 48200 46200 45500 4
N 49500 45500 49500 44300 4
N 49500 44300 50300 44300 4
N 43800 45500 49500 45500 4
N 43800 43600 43800 45500 4
N 43800 43600 44500 43600 4
C 49800 45600 1 0 1 gnd-1.sym
C 51500 41700 1 0 1 gnd-1.sym
C 44000 46300 1 0 1 gnd-1.sym
U 42500 40600 47950 40600 10 0
U 50000 49400 42500 49400 10 1
U 50000 49400 53700 49400 10 0
U 53700 49400 53700 41950 10 -1
U 47950 40600 48500 40600 10 0
U 48500 40600 48500 44800 10 -1
N 45600 44400 48300 44400 4
{
T 48000 44200 5 10 1 1 0 0 1
netname=+5
}
C 48300 44400 1 270 0 busripper-1.sym
C 45700 41000 1 0 1 gnd-1.sym
N 45200 41300 42700 41300 4
{
T 42800 41350 5 10 1 1 0 0 1
netname=-12
}
C 42700 41300 1 90 0 busripper-1.sym
N 51000 42000 48700 42000 4
{
T 49300 41800 5 10 1 1 0 0 1
netname=-12
}
C 48700 42000 1 180 0 busripper-1.sym
N 42700 45900 49300 45900 4
{
T 42750 45950 5 10 1 1 0 0 1
netname=-12
}
C 42700 45900 1 90 0 busripper-1.sym
N 51400 45100 53500 45100 4
{
T 53100 44900 5 10 1 1 0 0 1
netname=+5
}
C 53500 45100 1 270 0 busripper-1.sym
N 43300 48100 42700 48100 4
{
T 42800 48150 5 10 1 1 0 0 1
netname=DACPP
}
C 42700 48100 1 90 0 busripper-1.sym
N 43300 47500 42700 47500 4
{
T 42850 47550 5 10 1 1 0 0 1
netname=DACPN
}
C 42700 47500 1 90 0 busripper-1.sym
N 44200 49100 44200 49200 4
{
T 44250 49100 5 10 1 1 0 0 1
netname=+5
}
C 44200 49200 1 0 0 busripper-1.sym
N 45000 48400 45000 49200 4
{
T 45100 49100 5 10 1 1 270 0 1
netname=HKPP
}
C 45000 49200 1 0 0 busripper-1.sym
N 45000 47200 45500 47200 4
N 45500 47200 45500 49200 4
{
T 45600 49100 5 10 1 1 270 0 1
netname=HKPN
}
C 45500 49200 1 0 0 busripper-1.sym
C 49700 49200 1 0 0 busripper-1.sym
N 49700 49000 49700 49200 4
{
T 49750 49100 5 10 1 1 0 0 1
netname=+5
}
T 45150 50100 9 20 1 0 0 0 1
Parallel Clock Drivers
N 44400 45900 44400 46600 4
N 49300 49000 49300 49200 4
{
T 49350 49100 5 10 1 1 0 0 1
netname=+5
}
C 49300 49200 1 0 0 busripper-1.sym
N 51000 45500 53500 45500 4
{
T 53100 45300 5 10 1 1 0 0 1
netname=+5
}
C 53500 45500 1 270 0 busripper-1.sym
N 51000 45100 51000 45500 4
N 45200 44800 48300 44800 4
{
T 47900 44600 5 10 1 1 0 0 1
netname=+5
}
C 48300 44800 1 270 0 busripper-1.sym
N 45200 44400 45200 44800 4
U 42500 40600 42500 49400 10 0
N 45000 48100 46200 48100 4
C 48000 47600 1 0 0 in-1.sym
{
T 47400 47700 5 10 1 1 0 0 1
refdes=SP1IA
}
C 50600 47600 1 0 0 out-1.sym
{
T 51200 47700 5 10 1 1 0 0 1
refdes=P1-IA
}
C 50600 47100 1 0 0 out-1.sym
{
T 51200 47200 5 10 1 1 0 0 1
refdes=P1-FS
}
C 52300 43700 1 0 0 out-1.sym
{
T 52900 43800 5 10 1 1 0 0 1
refdes=P2-IA
}
C 52300 43200 1 0 0 out-1.sym
{
T 52900 43300 5 10 1 1 0 0 1
refdes=P2-FS
}
C 46500 43000 1 0 0 out-1.sym
{
T 47100 43100 5 10 1 1 0 0 1
refdes=P3-IA
}
C 46500 42500 1 0 0 out-1.sym
{
T 47100 42600 5 10 1 1 0 0 1
refdes=P3-FS
}
C 48000 47100 1 0 0 in-1.sym
{
T 47400 47200 5 10 1 1 0 0 1
refdes=SP1FS
}
C 49700 43700 1 0 0 in-1.sym
{
T 49100 43800 5 10 1 1 0 0 1
refdes=SP2IA
}
C 49700 43200 1 0 0 in-1.sym
{
T 49100 43300 5 10 1 1 0 0 1
refdes=SP2FS
}
C 43900 43000 1 0 0 in-1.sym
{
T 43300 43100 5 10 1 1 0 0 1
refdes=SP3IA
}
C 43900 42500 1 0 0 in-1.sym
{
T 43300 42600 5 10 1 1 0 0 1
refdes=SP3FS
}
T 51900 40200 9 10 1 0 0 0 1
5
