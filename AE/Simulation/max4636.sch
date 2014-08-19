v 20110115 2
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
C 45000 45400 1 0 0 max4636sw.sym
{
T 45200 46600 5 10 1 1 0 0 1
refdes=X1
}
C 49000 45400 1 0 0 max4636sw.sym
{
T 49200 46600 5 10 1 1 0 0 1
refdes=X2
}
C 46200 45500 1 0 0 spice-subcircuit-IO-1.sym
{
T 47050 45750 5 10 1 1 0 0 1
refdes=P9
}
C 44900 45700 1 0 1 spice-subcircuit-IO-1.sym
{
T 44050 45950 5 10 1 1 0 6 1
refdes=P10
}
N 44700 46000 45000 46000 4
N 46400 45800 46200 45800 4
C 46200 45900 1 0 0 spice-subcircuit-IO-1.sym
{
T 47050 46150 5 10 1 1 0 0 1
refdes=P2
}
N 46400 46200 46200 46200 4
C 44900 45100 1 0 1 spice-subcircuit-IO-1.sym
{
T 44050 45350 5 10 1 1 0 6 1
refdes=P3
}
N 44700 45400 49600 45400 4
C 50200 45900 1 0 0 spice-subcircuit-IO-1.sym
{
T 51050 46150 5 10 1 1 0 0 1
refdes=P4
}
N 50400 46200 50200 46200 4
C 49000 45700 1 0 1 spice-subcircuit-IO-1.sym
{
T 48150 45950 5 10 1 1 0 6 1
refdes=P6
}
N 48800 46000 49000 46000 4
C 45800 47200 1 0 1 spice-subcircuit-IO-1.sym
{
T 44950 47450 5 10 1 1 0 6 1
refdes=P1
}
N 45600 47500 45600 46600 4
C 49800 47200 1 0 1 spice-subcircuit-IO-1.sym
{
T 48950 47450 5 10 1 1 0 6 1
refdes=P5
}
N 49600 47500 49600 46600 4
C 50200 45500 1 0 0 spice-subcircuit-IO-1.sym
{
T 51050 45750 5 10 1 1 0 0 1
refdes=P7
}
N 50400 45800 50200 45800 4
C 45700 48200 1 0 1 spice-subcircuit-IO-1.sym
{
T 44850 48450 5 10 1 1 0 6 1
refdes=P8
}
C 45500 48400 1 0 0 resistor-1.sym
{
T 45700 48700 5 10 1 1 0 0 1
refdes=R1
T 45700 48200 5 10 1 1 0 0 1
value=999k
}
N 46400 48500 47700 48500 4
N 47700 48500 47700 45400 4
T 43700 49700 8 10 1 1 0 0 1
spice-prolog=.subckt MAX4636 %io
