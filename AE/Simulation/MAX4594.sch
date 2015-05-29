v 20110115 2
C 6200 84400 1 0 0 spice-vc-switch-1.sym
{
T 7100 85600 5 12 1 1 0 0 1
refdes=S1
T 6900 84550 5 8 1 1 0 0 1
model-name=mod4594
}
C 400 79000 0 0 0 Noqsi-title-B.sym
{
T 10400 79500 15 10 1 1 0 0 1
date=$Date: 2006/08/09 14:59:04 $
T 14300 79500 15 10 1 1 0 0 1
rev=$Revision: 1.2 $
T 15800 79200 15 10 1 1 0 0 1
auth=$Author: jpd $
T 10600 79800 15 8 1 1 0 0 1
fname=$Source: /cvs/MIT/hybrid/simulation/max4594.sch,v $
T 13600 80200 15 14 1 1 0 4 1
title=MAX4594 Simulation Model
}
C 6300 84500 1 0 0 gnd-1.sym
C 13100 81000 1 0 0 spice-subcircuit-LL-1.sym
{
T 13200 81400 5 10 1 1 0 0 1
refdes=As
T 13200 81100 5 10 1 1 0 0 1
model-name=MAX4594
}
C 7700 85100 1 0 0 spice-subcircuit-IO-1.sym
{
T 8550 85350 5 10 1 1 0 0 1
refdes=P2
}
C 7700 84500 1 0 0 spice-subcircuit-IO-1.sym
{
T 8550 84750 5 10 1 1 0 0 1
refdes=P1
}
C 4600 85800 1 0 1 spice-subcircuit-IO-1.sym
{
T 3750 86050 5 10 1 1 0 6 1
refdes=P3
}
C 4900 85200 1 0 0 capacitor-1.sym
{
T 5100 85700 5 10 1 1 0 0 1
refdes=Cpd
T 5600 85200 5 10 1 1 0 0 1
value=5pF
}
C 4900 86000 1 0 0 resistor-1.sym
{
T 5100 86300 5 10 1 1 0 0 1
refdes=Rpd
T 5600 86200 5 10 1 1 0 0 1
value=5k
}
C 4800 85100 1 0 0 gnd-1.sym
N 6400 85400 5800 85400 4
N 5800 85400 5800 86100 4
C 7000 83600 1 0 0 capacitor-1.sym
{
T 7200 84100 5 10 1 1 0 0 1
refdes=C3
T 6900 83600 5 10 1 1 0 0 1
value=0.7pF
}
C 7900 83600 1 0 0 capacitor-1.sym
{
T 8100 84100 5 10 1 1 0 0 1
refdes=C4
T 7900 83600 5 10 1 1 0 0 1
value=7pF
}
C 8700 83500 1 0 0 gnd-1.sym
N 7900 83800 7900 84800 4
N 7000 83800 4600 83800 4
N 4600 83800 4600 86100 4
N 4400 86100 4900 86100 4
C 7000 86400 1 0 0 capacitor-1.sym
{
T 7200 86900 5 10 1 1 0 0 1
refdes=C1
T 6900 86400 5 10 1 1 0 0 1
value=0.7pF
}
C 7900 86400 1 0 0 capacitor-1.sym
{
T 8100 86900 5 10 1 1 0 0 1
refdes=C2
T 7900 86400 5 10 1 1 0 0 1
value=7pF
}
C 8700 86300 1 0 0 gnd-1.sym
N 7900 86600 7900 85400 4
N 7000 86600 4700 86600 4
N 4700 86600 4700 86100 4
T 10900 79200 9 10 1 0 0 0 1
1
T 12300 79200 9 10 1 0 0 0 1
1
T 5800 83000 8 10 1 1 0 0 1
spice-epilog=.model mod4594 sw(vt=1.6 ron=10)
C 4700 82200 1 0 1 spice-subcircuit-IO-1.sym
{
T 3850 82450 5 10 1 1 0 6 1
refdes=P5
}
C 4700 81200 1 0 1 spice-subcircuit-IO-1.sym
{
T 3850 81450 5 10 1 1 0 6 1
refdes=P4
}
C 4600 81200 1 0 0 gnd-1.sym
N 4500 81500 5400 81500 4
C 4500 82400 1 0 0 resistor-1.sym
{
T 4700 82700 5 10 1 1 0 0 1
refdes=Rp
T 5200 82600 5 10 1 1 0 0 1
value=100k
}
N 5400 82500 5400 81500 4
