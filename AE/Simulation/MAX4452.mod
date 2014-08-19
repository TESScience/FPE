* ------------------------------
* Revision 0, 9/2003
* ------------------------------
* The MAX4452 family of op amps combine high speed performance with ultra low power 
* consumption and are unity gain stable. These amplifiers operate from a +2.7 to +5.25 
* single supply and feature Rail to Rail outputs.
* ------------------------------
* Connections
*          1  = OUT
*          2  = VEE
*          3  = IN+
*          4  = IN- 
*          5  = VCC
*****************************
.SUBCKT MAX4452 1 2 3 4 5  
 XHFAMP1 5 2 3 4 1 HFAMP
.ENDS
*****************************

*****************************
.SUBCKT HFAMP 10 18 17 16 75
* 10 = VCC
* 18 = VEE
* 17 = IN+
* 16 = IN-
* 75 = OUT
*****************
VS1 10 11 0V
IBIAS 11 12 440U 
DBIAS 18 12 DA
QI1 13 15 91 QP1         
*INPUT BIAS CURRENT AND OFFSET    
QI2 14 16 92 QP2
RE1 12 91 81    
RE2 12 92 81  
RID 15 16 120K           
*DIFFERENTIAL INPUT RESISTANCE
RIN1 15 20 30MEG         
*COMMON MODE INPUT RESISTANCE 
RIN2 16 20 30MEG         
DIN1 15 10 DB
DIN2 18 15 DB
DIN3 16 10 DB
DIN4 18 16 DB
CIN1 15 18 2P
CIN2 16 18 2P 
VOS 17 32 0.4M           
*INPUT OFFSET VOLTAGE
ERR1 32 15 111 20 1     
*DC PSRR AND CMRR
RC1 13 18 200   
RC2 14 18 200 
C1 13 19 0.3P            
RZ 19 14 250 
FSUP 18 10 VS1 1         
*TO COMPENSATE SUPPLY CURRENT
*****************
GP 20 101 14 13 2.5M     
RP 101 20 400
CP 101 102 35.0P
RZ1 102 20 3.2K
*****************
*GAIN STAGE              
*80dB GAIN    
GA 21 20 101 20 12.57M    
RO1 21 20 795.77
GB 22 20 21 20 1
RO2 22 20 1K
EF 23 20 22 20 1
CC 23 21 10P              
*DOMINANT POLE AT 20KHZ
EG 20 18 10 18 0.5
GCP 22 20 110 20 10      
*CMRR AND PSRR AC RESPONSE 
*****
DVL1 22 33 DA             
*OUTPUT VOLTAGE LIMITING
VMIN1 59 33 0.0
DVL2 34 22 DA
VMIN2 34 60 0.0 
ELIM2 59 61 10 18 0.5
ELIM1 63 60 10 18 0.5
ECOMP2 62 20 65 66 1
ECOMP1 64 20 65 66 1
HCOMP2 62 61 VIS3 77.59
HCOMP1 64 63 VIS3 31 
*****************
EOUT 65 20 22 20 1       
*VOLTAGE FOLLOWER
ROUT1 65 66 1M           
VIS3 66 67 0V            
*OUTPUT CURRENT SENSE 
*****************
*CURRENT LIMIT
DSC1 67 68 DA
DSC2 69 67 DA
DSC3 69 70 DA
DSC4 70 68 DA
ISC1 68 69 24MA          
*LIMITING CURRENT T0 17MA
RSC 67 70 1MEG           
*****************
*AC OUTPUT IMPEDENCE
ROUT2 70 75 0.1M     
RLOAD 75 20 10MEG
*****************
*SUPPLY CURRENT
*BIAS CURRENT 
DSUP 18 10 DB
ISUP 10 18 620UA           
*BIAS CURRENT  
*LOAD CURRENT
FSUP1 20 77 VIS3 1
CSUP 77 20 1P
DSUP1 20 77 DB
DSUP2 77 78 DB
VIS4 78 20 0V
FSUP2 10 18 VIS4 1
*****************
**PSRR DC AND AC 
ESUP1 79 20 10 18 1
CPSRR 79 80 120P
RPSRR 80 20 80
GPSRR1 20 110 80 20 0.015  
*AC
GPSRR2 20 111 79 20 316U   
*DC -70dB
RRR1 111 20 1
RRR 110 20 1
*****************
**CMRR DC AND AC
ECM1 20 81 18 12 1
CCM 81 82 20P
RCM 82 20 5.0
ECM 31 20 82 20 1
RCM1 31 30 20
CCM1 30 20 1200P
GCM1 20 110 30 20 0.07    
*AC
GCM2 20 111 81 20 10U     
*DC -100dB
*****************
*MAX COMMON MODE INPUT VCC-2.4V
DIL 12 83 DA
RIL 83 84 62.5
VIL 85 84 1.0V
EIL 85 18 10 18 1
*****************
**MINIMUM SUPPLY VOLTAGE SET AT +2.7V
DVL3 18 12 DA
DVL4 12 86 DA 
FVL 86 18 VIS5 1
VVL 87 18 2.7V
VIS5 87 88 0V
DVL5 88 89 DA
RVL 89 90 300
EVL1 90 18 10 18 1
**********************************************************
.MODEL QP1 PNP(IS=16E-15 BF=275)
.MODEL QP2 PNP(IS=16E-15 BF=245)
* DA seems to be an attempt to simulate an ideal diode
* by setting the emission coefficient very low.
* In the original model N=0.1M, but that makes ngspice die on a bad timestep.
* 10/2/2013 jpd
.MODEL DA D(N=0.01)
.MODEL DB D(IS=100E-14)
**********************************************************
.ENDS
