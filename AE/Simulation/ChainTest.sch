v 20130925 2
C 40000 40000 0 0 0 Noqsi-title-B.sym
{
T 50000 40500 5 10 1 1 0 0 1
date=20140728
T 53900 40500 5 10 1 1 0 0 1
rev=1.1
T 55400 40200 5 10 1 1 0 0 1
auth=jpd
T 50200 40800 5 8 1 1 0 0 1
fname=ChainTest.sch
T 53200 41200 5 14 1 1 0 4 1
title=Chain simulation fixture
}
C 47200 46700 1 0 0 vdc-1.sym
{
T 47900 47350 5 10 1 1 0 0 1
refdes=Vcc
T 47900 47150 5 10 1 1 0 0 1
value=DC 5V
}
C 47300 47900 1 0 0 vcc-1.sym
C 47400 46400 1 0 0 gnd-1.sym
C 42100 44400 1 0 0 vpulse-1.sym
{
T 42800 45050 5 10 1 1 0 0 1
refdes=Vp3
T 42800 44450 5 10 1 1 0 0 3
value=pulse {-vv} 0
+ {3*step} {tos} {tos}
+ {(15-3)*step-tos} {48*step}
}
C 46200 41500 1 0 0 vpulse-1.sym
{
T 46900 42150 5 10 1 1 0 0 1
refdes=Vhold2
T 46900 41550 5 10 1 1 0 0 3
value=pulse 0 3.3 
+ {16*step} 5ns 5ns
+ {(22-16)*step-5ns} {24*step}
}
C 50300 41900 1 0 0 vpulse-1.sym
{
T 51000 42550 5 10 1 1 0 0 1
refdes=Vint
T 51000 41950 5 10 1 1 0 0 3
value=pulse 3.3 0
+ {7*step} 5ns 5ns
+ {(15-7)*step-5ns} {24*step}
}
C 50500 41600 1 0 0 gnd-1.sym
N 44000 45600 50900 45600 4
{
T 44500 45700 5 10 1 1 0 0 1
netname=OS
}
N 46500 43900 46500 44700 4
{
T 46400 44100 5 10 1 1 90 0 1
netname=HOLDn
}
N 50600 43100 50600 44100 4
{
T 50700 43400 5 10 1 1 0 0 1
netname=Int
}
C 43100 45500 1 0 0 resistor-1.sym
{
T 43300 45800 5 10 1 1 0 0 1
refdes=Ros
T 43800 45700 5 10 1 1 0 0 1
value=300
}
N 43100 45600 42400 45600 4
{
T 42600 45800 5 10 1 1 0 0 1
netname=oq
}
C 42100 43200 1 0 0 vpulse-1.sym
{
T 41800 43950 5 10 1 1 0 0 1
refdes=Vrg
T 42800 43650 5 10 1 1 0 0 3
value=pulse 0 0.1 
+ {1*step} {tos} {tos} 
+ {(7-1)*step-tos} {24*step}
}
C 51000 47500 1 0 0 spice-options-1.sym
{
T 51100 47900 5 10 1 1 0 0 1
refdes=A3
T 51100 47600 5 10 1 1 0 0 1
value=reltol=0.003
}
C 46400 41200 1 0 0 gnd-1.sym
C 50800 44600 1 0 0 chain.sym
{
T 53000 46300 5 10 1 1 0 6 1
refdes=Xut
}
N 50600 44100 51700 44100 4
N 51700 44100 51700 44700 4
N 46500 44700 51400 44700 4
C 51500 46500 1 0 0 vcc-1.sym
N 52300 46500 53300 46500 4
N 53300 44700 53300 46500 4
N 53300 44700 52300 44700 4
C 53200 44400 1 0 0 gnd-1.sym
T 40400 50800 8 10 1 1 0 2 18
spice-epilog=
* ccd output response time
.param tos=100ns
* sequencer step size
.param step=1/15Meg
* video voltage
.param vv=1.0
.csparam vv={vv}
.control
tran 10n 3.5u
linearize
print vv
* print differential ADC input at 3.25 us
print xut.inp[325]-xut.inm[325]
* quit
.endc


C 42100 42000 1 0 0 vdc-1.sym
{
T 42800 42650 5 10 1 1 0 0 1
refdes=Vvb
T 42800 42450 5 10 1 1 0 0 1
value=DC 13V
}
C 42300 41700 1 0 0 gnd-1.sym
C 50900 46200 1 0 0 gnd-1.sym
N 51000 46500 51400 46500 4
N 52000 44100 52000 44700 4
{
T 52200 44200 5 10 1 1 90 0 1
netname=Clamp
}
C 51700 42900 1 0 0 vpulse-1.sym
{
T 52400 43550 5 10 1 1 0 0 1
refdes=Vclamp
T 52400 42950 5 10 1 1 0 0 3
value=pulse 0 3.3 
+ {2*step} 5ns 5ns
+ {(9-2)*step-5ns} {24*step}
}
C 51900 42600 1 0 0 gnd-1.sym
C 54000 45600 1 0 0 vdc-1.sym
{
T 54700 46250 5 10 1 1 0 0 1
refdes=Vref
T 54700 46050 5 10 1 1 0 0 1
value=DC 2.5V
}
C 54200 45300 1 0 0 gnd-1.sym
N 54300 46800 54300 46900 4
N 54300 46900 52000 46900 4
N 52000 46900 52000 46500 4
C 46200 42700 1 0 0 vpulse-1.sym
{
T 46900 43350 5 10 1 1 0 0 1
refdes=Vhold1
T 46900 42750 5 10 1 1 0 0 3
value=pulse 0 3.3 
+ {9*step} 5ns 5ns
+ {(15-9)*step-5ns} {24*step}
}
