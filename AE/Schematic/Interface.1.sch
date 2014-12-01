v 20130925 2
C 40000 40000 0 0 0 Noqsi-title-B.sym
{
T 50000 40500 5 10 1 1 0 0 1
date=20140129
T 53900 40500 5 10 1 1 0 0 1
rev=5.0
T 55400 40200 5 10 1 1 0 0 1
auth=jpd
T 50200 40800 5 8 1 1 0 0 1
fname=Interface.1.sch
T 53200 41200 5 14 1 1 0 4 1
title=Interface Board
}
T 40500 49740 5 10 0 0 0 0 1
device=SN74LVC139AD
T 40500 49540 5 10 0 0 0 0 1
footprint=SO16
T 40200 47600 5 10 0 0 0 0 1
slot=2
T 50400 40200 9 10 1 0 0 0 1
1
T 52000 40200 9 10 1 0 0 0 1
10
C 49700 48200 1 0 0 Artix.sym
{
T 49700 49600 5 10 0 1 0 0 1
symversion=20141030
T 50500 48800 5 10 1 1 0 0 1
refdes=U4
}
T 51000 48300 9 10 1 0 0 0 2
See ArtixPinout.csv and Artix-signal-map.tsv for
Artix connections.
N 52700 42200 52700 44200 4
N 51100 45300 51100 43800 4
N 49000 43800 51300 43800 4
{
T 49300 43900 5 10 1 1 0 0 1
netname=TMS
}
N 51100 45800 50900 45800 4
N 50900 45800 50900 43400 4
N 51100 46300 50700 46300 4
N 50700 46300 50700 43000 4
N 51100 46800 50500 46800 4
N 50500 46800 50500 42600 4
C 52000 46700 1 0 1 resistor.sym
{
T 51400 47300 5 10 0 0 0 6 1
spec=5% 1/10W
T 51300 46900 5 10 1 1 0 6 1
refdes=R97
T 52200 46900 5 10 1 1 0 6 1
value=4.7k
}
C 52000 46200 1 0 1 resistor.sym
{
T 51400 46800 5 10 0 0 0 6 1
spec=5% 1/10W
T 51300 46400 5 10 1 1 0 6 1
refdes=R96
T 52200 46400 5 10 1 1 0 6 1
value=4.7k
}
C 52000 45700 1 0 1 resistor.sym
{
T 51400 46300 5 10 0 0 0 6 1
spec=5% 1/10W
T 51300 45900 5 10 1 1 0 6 1
refdes=R95
T 52200 45900 5 10 1 1 0 6 1
value=4.7k
}
C 52000 45200 1 0 1 resistor.sym
{
T 51400 45800 5 10 0 0 0 6 1
spec=5% 1/10W
T 51300 45400 5 10 1 1 0 6 1
refdes=R94
T 52200 45400 5 10 1 1 0 6 1
value=4.7k
}
N 52300 47800 49000 47800 4
{
T 49000 47500 5 10 1 1 0 0 1
netname=+3.3F
}
N 52300 45300 52300 47800 4
N 51300 45000 51300 44200 4
N 52000 45800 52300 45800 4
N 52000 46300 52300 46300 4
N 52000 46800 52300 46800 4
N 51300 45000 52000 45000 4
N 52000 45000 52000 45300 4
C 52700 41600 1 0 1 ArtixJTAG.sym
{
T 52100 44500 5 10 1 1 0 6 1
refdes=J1
}
N 49000 42600 51300 42600 4
{
T 49300 42700 5 10 1 1 0 0 1
netname=TDI
}
N 49000 43400 51300 43400 4
{
T 49300 43500 5 10 1 1 0 0 1
netname=TCK
}
N 49000 43000 51300 43000 4
{
T 49300 43100 5 10 1 1 0 0 1
netname=TDO
}
C 53100 41900 1 0 0 gnd-1.sym
N 53200 42200 52700 42200 4
N 52300 45300 52000 45300 4
C 46000 40500 1 0 0 DS26C32-1.sym
{
T 46000 40500 5 10 0 0 0 0 1
footprint=SO16
T 46872 44100 5 10 1 1 0 0 1
refdes=U9
T 46872 44000 5 8 1 1 0 1 1
device=DS26LV32AT
}
N 46000 42600 46000 40500 4
N 46000 40500 46400 40500 4
C 46300 40200 1 0 0 gnd-1.sym
N 46400 44100 46400 49800 4
{
T 46500 49700 5 10 1 1 0 0 1
netname=+3.3F
}
C 45300 44600 1 0 0 bypass10V.sym
{
T 45300 45500 5 10 0 0 0 0 1
symversion=20131216
T 45800 45000 5 10 1 1 0 0 1
refdes=C99
T 45200 44900 5 10 1 1 0 0 1
value=0.1uF
}
N 46200 44800 46400 44800 4
C 45200 44500 1 0 0 gnd-1.sym
C 40600 45500 1 180 1 DB9-1.sym
{
T 41600 42600 5 10 0 0 180 6 1
device=MDM9S
T 40600 45500 5 10 0 0 0 0 1
footprint=MDM9S
T 40600 45500 5 10 0 0 0 0 1
class=IO
T 40800 42300 5 10 1 1 180 6 1
refdes=J3
}
N 41800 43400 46000 43400 4
N 46000 43600 41900 43600 4
N 43000 42900 46000 42900 4
N 41800 43100 46000 43100 4
N 43000 42900 43000 42800 4
N 43000 42800 41800 42800 4
N 41900 43600 41900 43700 4
N 41900 43700 41800 43700 4
C 42000 43700 1 0 0 gnd-1.sym
N 42100 44000 41800 44000 4
N 41800 45200 42900 45200 4
{
T 41900 45300 5 10 1 1 0 0 1
netname=\_DATA-A\_
}
N 41800 44900 42900 44900 4
{
T 41900 45000 5 10 1 1 0 0 1
netname=DATA-A
}
N 41800 44600 42900 44600 4
{
T 41900 44700 5 10 1 1 0 0 1
netname=\_DATA-B\_
}
N 41800 44300 42900 44300 4
{
T 41900 44400 5 10 1 1 0 0 1
netname=DATA-B
}
N 47500 43500 48600 43500 4
{
T 47700 43600 5 10 1 1 0 0 1
netname=C422
}
N 47500 43000 48600 43000 4
{
T 47700 43100 5 10 1 1 0 0 1
netname=D422
}
C 47200 45900 1 0 0 gnd-1.sym
N 47300 47400 47300 47900 4
C 48400 47700 1 0 1 bypass10V.sym
{
T 48400 48600 5 10 0 0 0 6 1
symversion=20131216
T 47900 48100 5 10 1 1 0 6 1
refdes=C88
T 48500 48000 5 10 1 1 0 6 1
value=0.1uF
}
N 47500 47900 47300 47900 4
C 48500 47600 1 0 1 gnd-1.sym
N 48400 46600 48600 46600 4
{
T 48100 46300 5 10 1 1 0 0 1
netname=osc_clk
}
C 46800 46200 1 0 0 smdoscinh.sym
{
T 46800 46200 5 10 0 0 0 0 1
value=KC3225A60.0000C3GE00
T 48200 47900 5 10 0 0 0 0 1
footprint=KYOCERA-KC3225A-C3
T 47700 47200 5 10 1 1 0 0 1
device=OSC
T 47700 47400 5 10 1 1 0 0 1
refdes=U8
}
C 46700 46500 1 0 0 gnd-1.sym
T 40200 41300 9 10 1 0 0 0 3
Note:
Pairs (DATA-A, \_DATA-A\_) and (DATA-B, \_DATA-B\_)
should be 100 ohm controlled impedance with equal trace lengths.
C 44900 48200 1 0 0 resistor.sym
{
T 45500 48800 5 10 0 0 0 0 1
spec=5% 1/10W
T 45600 48400 5 10 1 1 0 0 1
refdes=R90
T 44700 48400 5 10 1 1 0 0 1
value=1k
}
C 44900 47600 1 0 0 resistor.sym
{
T 45500 48200 5 10 0 0 0 0 1
spec=5% 1/10W
T 45600 47800 5 10 1 1 0 0 1
refdes=R89
T 44700 47800 5 10 1 1 0 0 1
value=1k
}
C 44900 47000 1 0 0 resistor.sym
{
T 45500 47600 5 10 0 0 0 0 1
spec=5% 1/10W
T 45600 47200 5 10 1 1 0 0 1
refdes=R88
T 44700 47200 5 10 1 1 0 0 1
value=1k
}
N 43300 48300 44900 48300 4
{
T 44500 48400 5 10 1 1 0 6 1
netname=M0_0
}
N 43300 47700 44900 47700 4
{
T 44500 47800 5 10 1 1 0 6 1
netname=M1_0
}
N 43300 47100 44900 47100 4
{
T 44500 47200 5 10 1 1 0 6 1
netname=M2_0
}
N 45800 47100 46400 47100 4
N 46400 48300 45800 48300 4
N 45800 47700 46400 47700 4
C 44900 46400 1 0 0 resistor.sym
{
T 45500 47000 5 10 0 0 0 0 1
spec=5% 1/10W
T 45600 46600 5 10 1 1 0 0 1
refdes=R87
T 44700 46600 5 10 1 1 0 0 1
value=4.7k
}
N 45800 46500 46400 46500 4
N 43300 46500 44900 46500 4
{
T 44500 46600 5 10 1 1 0 6 1
netname=\_INIT\_
}
U 43100 44100 43100 50000 10 1
C 42900 44300 1 0 0 busripper-1.sym
C 42900 44600 1 0 0 busripper-1.sym
C 42900 44900 1 0 0 busripper-1.sym
C 42900 45200 1 0 0 busripper-1.sym
U 43100 50000 48800 50000 10 -1
U 48800 50000 48800 42100 10 1
C 48600 43500 1 0 0 busripper-1.sym
C 48600 43000 1 0 0 busripper-1.sym
C 46400 49800 1 90 0 busripper-1.sym
N 47300 47400 46400 47400 4
C 48600 46600 1 0 0 busripper-1.sym
U 49700 48500 48800 48500 10 0
C 43300 46500 1 90 0 busripper-1.sym
C 43300 47100 1 90 0 busripper-1.sym
C 43300 47700 1 90 0 busripper-1.sym
C 43300 48300 1 90 0 busripper-1.sym
C 49000 43800 1 90 0 busripper-1.sym
C 49000 43400 1 90 0 busripper-1.sym
C 49000 43000 1 90 0 busripper-1.sym
C 49000 42600 1 90 0 busripper-1.sym
C 49000 47800 1 90 0 busripper-1.sym
N 43300 48900 44900 48900 4
{
T 44500 49100 5 10 1 1 0 6 1
netname=\_PROGRAM\_
}
C 44900 48800 1 0 0 resistor.sym
{
T 45500 49400 5 10 0 0 0 0 1
spec=5% 1/10W
T 45600 49000 5 10 1 1 0 0 1
refdes=R91
T 44700 49000 5 10 1 1 0 0 1
value=4.7k
}
N 45800 48900 46400 48900 4
C 43300 48900 1 90 0 busripper-1.sym
N 41600 49600 42900 49600 4
{
T 41900 49700 5 10 1 1 0 0 1
netname=Cam_ID-0
}
C 42900 49600 1 0 0 busripper-1.sym
C 40700 49500 1 0 0 resistor.sym
{
T 41300 50100 5 10 0 0 0 0 1
spec=5% 1/10W
T 41400 49700 5 10 1 1 0 0 1
refdes=R80
T 40500 49700 5 10 1 1 0 0 1
value=DNP
}
C 40600 49300 1 0 0 gnd-1.sym
N 41600 48800 42900 48800 4
{
T 41900 48900 5 10 1 1 0 0 1
netname=Cam_ID-1
}
C 42900 48800 1 0 0 busripper-1.sym
C 40700 48700 1 0 0 resistor.sym
{
T 41300 49300 5 10 0 0 0 0 1
spec=5% 1/10W
T 41400 48900 5 10 1 1 0 0 1
refdes=R81
T 40500 48900 5 10 1 1 0 0 1
value=DNP
}
C 40600 48500 1 0 0 gnd-1.sym
N 41600 48000 42900 48000 4
{
T 41900 48100 5 10 1 1 0 0 1
netname=Cam_ID-2
}
C 42900 48000 1 0 0 busripper-1.sym
C 40700 47900 1 0 0 resistor.sym
{
T 41300 48500 5 10 0 0 0 0 1
spec=5% 1/10W
T 41400 48100 5 10 1 1 0 0 1
refdes=R82
T 40500 48100 5 10 1 1 0 0 1
value=DNP
}
C 40600 47700 1 0 0 gnd-1.sym
N 41600 47200 42900 47200 4
{
T 41900 47300 5 10 1 1 0 0 1
netname=Cam_ID-3
}
C 42900 47200 1 0 0 busripper-1.sym
C 40700 47100 1 0 0 resistor.sym
{
T 41300 47700 5 10 0 0 0 0 1
spec=5% 1/10W
T 41400 47300 5 10 1 1 0 0 1
refdes=R83
T 40500 47300 5 10 1 1 0 0 1
value=DNP
}
C 40600 46900 1 0 0 gnd-1.sym
T 40600 50100 9 10 1 0 0 0 4
Encode board serial number
by populating selected R80-R83
with zero-ohm resistors for
each binary zero.
C 48300 41600 1 0 0 Header.sym
{
T 49100 42200 5 10 1 1 0 0 1
refdes=J4
T 48300 43000 5 10 0 1 0 0 1
symversion=20141030
T 48300 42400 5 10 0 0 0 0 1
footprint=HEADER16
}
T 54100 46900 9 15 1 0 0 0 1
FPGA I/O
