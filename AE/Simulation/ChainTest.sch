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
value=pulse 0 {-vv}
+ {14*step} {tos} {tos}
+ {(24-14)*step-tos} {48*step}
}
C 46200 44400 1 0 0 gnd-1.sym
N 44000 46800 50900 46800 4
{
T 44500 46900 5 10 1 1 0 0 1
netname=OS
}
N 46300 45900 52000 45900 4
{
T 49700 46000 5 10 1 1 0 0 1
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
+ {0*step} {tos} {tos} 
+ {(5-1)*step-tos} {24*step}
}
C 51000 48700 1 0 0 spice-options-1.sym
{
T 51100 49100 5 10 1 1 0 0 1
refdes=A3
T 51100 48800 5 10 1 1 0 0 1
value=reltol=0.003
}
C 50800 45800 1 0 0 chain.sym
{
T 53400 47500 5 10 1 1 0 6 1
refdes=Xut
}
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
.param vv=1.4
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
+ {1*step} 5ns 5ns
+ {(7-2)*step-5ns} {24*step}
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
C 48900 42200 1 0 0 gnd-1.sym
N 52300 45900 52300 43700 4
N 52300 43700 49000 43700 4
{
T 49700 43800 5 10 1 1 0 0 1
netname=DeInt
}
C 48700 42500 1 0 0 vpulse-1.sym
{
T 49400 43150 5 10 1 1 0 0 1
refdes=Vdeint
T 49400 42550 5 10 1 1 0 0 3
value=pulse 0 3.3
+ {8*step} 5ns 5ns
+ {(14-8)*step-5ns} {24*step}
}
C 46000 44700 1 0 0 vpulse-1.sym
{
T 46700 45350 5 10 1 1 0 0 1
refdes=Vint
T 46700 44750 5 10 1 1 0 0 3
value=pulse 0 3.3
+ {16*step} 5ns 5ns
+ {(22-16)*step-5ns} {24*step}
}
