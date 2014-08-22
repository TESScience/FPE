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
C 40500 40600 1 0 0 vdc-1.sym
{
T 41200 41250 5 10 1 1 0 0 1
refdes=Vcc
T 41200 41050 5 10 1 1 0 0 1
value=DC 5V
}
C 40600 41800 1 0 0 vcc-1.sym
C 40700 40300 1 0 0 gnd-1.sym
C 42100 45600 1 0 0 vpulse-1.sym
{
T 42800 46250 5 10 1 1 0 0 1
refdes=Vp3
T 42800 45650 5 10 1 1 0 0 3
value=pulse {-vv} 0
+ {3*step} {tos} {tos}
+ {(15-3)*step-tos} {48*step}
}
C 46200 41900 1 0 0 vpulse-1.sym
{
T 46900 42550 5 10 1 1 0 0 1
refdes=Vhold2
T 46900 41950 5 10 1 1 0 0 3
value=pulse 0 3.3 
+ {16*step} 5ns 5ns
+ {(22-16)*step-5ns} {24*step}
}
C 49700 41900 1 0 0 vpulse-1.sym
{
T 50400 42550 5 10 1 1 0 0 1
refdes=Vint
T 50400 41950 5 10 1 1 0 0 3
value=pulse 3.3 0
+ {7*step} 5ns 5ns
+ {(15-7)*step-5ns} {24*step}
}
C 49900 41600 1 0 0 gnd-1.sym
N 44000 46800 50900 46800 4
{
T 44500 46900 5 10 1 1 0 0 1
netname=OS
}
N 46500 44300 46500 46100 4
{
T 46400 44300 5 10 1 1 90 0 1
netname=HOLDn
}
N 50000 43100 50000 44900 4
{
T 50100 44600 5 10 1 1 0 0 1
netname=Int
}
C 43100 46700 1 0 0 resistor-1.sym
{
T 43300 47000 5 10 1 1 0 0 1
refdes=Ros
T 43800 46900 5 10 1 1 0 0 1
value=300
}
N 43100 46800 42400 46800 4
{
T 42600 47000 5 10 1 1 0 0 1
netname=oq
}
C 42100 44400 1 0 0 vpulse-1.sym
{
T 41800 45150 5 10 1 1 0 0 1
refdes=Vrg
T 42800 44850 5 10 1 1 0 0 3
value=pulse 0 0.1 
+ {1*step} {tos} {tos} 
+ {(7-1)*step-tos} {24*step}
}
C 51000 48700 1 0 0 spice-options-1.sym
{
T 51100 49100 5 10 1 1 0 0 1
refdes=A3
T 51100 48800 5 10 1 1 0 0 1
value=reltol=0.003
}
C 46400 41600 1 0 0 gnd-1.sym
C 50800 45800 1 0 0 chain.sym
{
T 53000 47500 5 10 1 1 0 6 1
refdes=Xut
}
N 50000 44900 52000 44900 4
N 52000 44900 52000 45900 4
C 51500 47700 1 0 0 vcc-1.sym
N 52300 47700 53600 47700 4
N 53600 45900 53600 47700 4
N 53600 45900 52900 45900 4
C 53200 45600 1 0 0 gnd-1.sym
T 40400 50800 8 10 1 1 0 2 18
spice-epilog=
* ccd output response time
.param tos=100ns
* sequencer step size
.param step=1/15Meg
* video voltage
.param vv=2.0
.csparam vv={vv}
.control
tran 10n 3.5u
linearize
print vv
* print differential ADC input at 3.25 us
print xut.inp[325]-xut.inm[325]
* quit
.endc


C 42100 43200 1 0 0 vdc-1.sym
{
T 42800 43850 5 10 1 1 0 0 1
refdes=Vvb
T 42800 43650 5 10 1 1 0 0 1
value=DC 13V
}
C 42300 42900 1 0 0 gnd-1.sym
C 50900 47400 1 0 0 gnd-1.sym
N 51000 47700 51400 47700 4
N 52600 44000 52600 45900 4
{
T 52800 45400 5 10 1 1 90 0 1
netname=Clamp
}
C 52300 42800 1 0 0 vpulse-1.sym
{
T 53000 43450 5 10 1 1 0 0 1
refdes=Vclamp
T 53000 42850 5 10 1 1 0 0 3
value=pulse 0 3.3 
+ {2*step} 5ns 5ns
+ {(9-2)*step-5ns} {24*step}
}
C 52500 42500 1 0 0 gnd-1.sym
C 54000 46800 1 0 0 vdc-1.sym
{
T 54700 47450 5 10 1 1 0 0 1
refdes=Vref
T 54700 47250 5 10 1 1 0 0 1
value=DC 2.5V
}
C 54200 46500 1 0 0 gnd-1.sym
N 54300 48000 54300 48100 4
N 54300 48100 52000 48100 4
N 52000 48100 52000 47700 4
C 46200 43100 1 0 0 vpulse-1.sym
{
T 46900 43750 5 10 1 1 0 0 1
refdes=Vhold1
T 46900 43150 5 10 1 1 0 0 3
value=pulse 0 3.3 
+ {9*step} 5ns 5ns
+ {(15-9)*step-5ns} {24*step}
}
C 49400 45200 1 0 0 gnd-1.sym
N 46500 45100 51700 45100 4
N 51700 45100 51700 45900 4
C 50500 43200 1 0 0 vcvs-1.sym
{
T 51100 44050 5 10 1 1 0 0 1
refdes=Eint
T 50700 44450 5 10 0 0 0 0 1
symversion=0.1
T 51200 43150 5 10 1 0 0 5 1
value=-1
}
N 52000 43900 52300 43900 4
N 52300 43900 52300 45900 4
{
T 52300 44300 5 10 1 1 90 0 1
netname=Intn
}
C 51900 43000 1 0 0 gnd-1.sym
C 50400 43000 1 0 0 gnd-1.sym
N 50500 43900 50000 43900 4
C 48000 45400 1 0 0 vcvs-1.sym
{
T 48600 46250 5 10 1 1 0 0 1
refdes=Ehold
T 48200 46650 5 10 0 0 0 0 1
symversion=0.1
T 48700 45350 5 10 1 0 0 5 1
value=-1
}
N 48000 46100 46500 46100 4
N 49500 46100 50400 46100 4
{
T 49900 46200 5 10 1 1 0 0 1
netname=Hold
}
N 50400 46100 50400 45900 4
N 50400 45900 51400 45900 4
C 47900 45200 1 0 0 gnd-1.sym
