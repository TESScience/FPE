.Subckt ADA4805 100 101 102 103 104 106
* ADA4805 SPICE Macro-model
* Function: Amplifier
*
* Revision History:
* Rev. 2.0 Jul 2014 -BP
* Copyright 2014 by Analog Devices
*
* Refer to http://www.analog.com/Analog_Root/static/techSupport/designTools/spicemodels/license
* for License Statement. Use of this model indicates your acceptance
* of the terms and provisions in the License Staement.
*
* Tested on MultiSim, SiMetrix(NGSpice), PSICE
*
* Not modeled: Distortion, PSRR, Overload recovery, Slew Rate Enhancment,
*                       ShutDown Turn On/Turn Off time
*
* Parameters modeled include: 
*   Vos, Ibias, Input CM limits and Typ output voltge swing over full supply range, CMRR,
*   Open Loop Gain & Phase, Slew Rate, Output current limits, Voltage & Current Noise over temp,
*   Quiescent and dynamic supply currents,Shut Down pin functionality, 
*   Single supply & offset supply functionality.
*
* Node Assignments
*			Non-Inverting Input         
*			|	Inverting Input
*			|	|	Positive supply
*			|	|	|	Negative supply
*			|	|	|	|	Output                      
*			|	|	|	|	|	ShutDown BAR
*			|	|	|	|	|	|    
*Subckt ADA4805 	100	101	102	103	104	106 
*
*
***Power Supplies***
Ibias	102	103	dc	7.4e-6
DzPS	98	102	diode
Iquies	102	98	dc	562.6e-6
S1	98	103	106	113	Switch
R1	102	99	1e7	noisy=0
R2	99	103	1e7	noisy=0
e1	111	110	102	110	1
e2	110	112	110	103	1
e3	110	0	99	0	1
*
*
***Inputs***
S2	1	100	106	113	Switch
S3	9	101	106	113	Switch
VOS	1	2	dc	9e-6
IbiasP	110	2	dc	470e-9
IbiasN	110	9	dc	470e-9
RinCMP	110	2	5e7	noisy=0
RinCMN	9	110	5e7	noisy=0
CinCMP	110	2	1e-15
CinCMN	9	110	1e-15
IOS	9	2	dc	4e-10
RinDiff	9	2	260e3	noisy=0
CinDiff	9	2	1e-012
*
*
***Non-Inverting Input with Clamp***
g1	3	110	110	2	0.001
RInP	3	110	1e3	noisy=0
RX1	40	3	0.001	noisy=0
DInP	40	41	diode
DInN	42	40	diode
VinP	111	41	dc	1.55
VinN	42	112	dc	0.45
*
*
***Vnoise***
hVn	6	5	Vmeas1	707.1067812
Vmeas1	20	110	DC	0
Vvn	21	110	dc	0.65
Dvn	21	20	DVnoisy
hVn1	6	7	Vmeas2	707.1067812
Vmeas2	22	110	DC	0
Vvn1	23	110	dc	0.65
Dvn1	23	22	DVnoisy
*
*
***Inoise***
FnIN	9	110	Vmeas3	0.70710678
Vmeas3	51	110	dc	0
VnIN	50	110	dc	0.65
DnIN	50	51	DINnoisy
FnIN1	110	9	Vmeas4	0.70710678
Vmeas4	53	110	dc	0
VnIN1	52	110	dc	0.65
DnIN1	52	53	DINnoisy
*
FnIP	2	110	Vmeas5	0.70710678
Vmeas5	31	110	dc	0
VnIP	30	110	dc	0.65
DnIP	30	31	DIPnoisy
FnIP1	110	2	Vmeas6	0.70710678
Vmeas6	33	110	dc	0
VnIP1	32	110	dc	0.65
DnIP1	32	33	DIPnoisy
*
*
***CMRR***
RcmrrP	3	10	1e7	noisy=0
RcmrrN	10	9	1e7	noisy=0
g10	11	110	10	110	6e-11
Lcmrr	11	12	5e-3
Rcmrr	12	110	1E3	noisy=0
e4	5	3	11	110	1
*
*
***Power Down***
VPD	110	80	dc	0.8
VPD1	81	0	dc	0.4
RPD	110	106	5.4e6	noisy=0
ePD	80	113	82	0	1
RDP1	82	0	1e3	noisy=0
CPD	82	0	1e-10
S5	81	82	106	113	Switch
*
*
***Feedback Pin***
*RF	105	104	0.001	noisy=0
*
*
***VFB Stage***
g200	200	110	7	9	1
R200	200	110	250	noisy=0
DzSlewP	201	200	DzSlewP
DzSlewN	201	110	DzSlewN
*
*
***1st Pole***
g210	210	110	200	110	928.1e-9
R210	210	110	1.0827e9	noisy=0
C210	210	110	1e-012
*
*
***Output Voltage Clamp-1***
RX2	60	210	0.001	noisy=0
DzVoutP	61	60	DzVoutP
DzVoutN	60	62	DzVoutN
DVoutP	61	63	diode
DVoutN	64	62	diode
VoutP	65	63	dc	5.1
VoutN	64	66	dc	5.1
e60	65	110	111	110	1.05
e61	66	110	112	110	1.05
*
*
*** 11 frequency stages ***
g220	220	110	210	110	0.001
R220	220	110	1000	noisy=0
C220	220	110	0.9947e-12
*
g230	230	110	220	110	0.001
R230	230	110	1000	noisy=0
C230	230	110	0.7579e-12
*
g240	240	110	230	110	0.001
R240	240	110	1000	noisy=0
C240	240	110	0.6366e-12
*
g245	245	110	240	110	0.001
R245	245	110	1000	noisy=0
C245	245	110	0.6121e-12
*
g250	250	110	245	110	0.001
R250	250	110	1000	noisy=0
C250	250	110	0.6121e-12
*
g255	255	110	250	110	0.001
R255	255	110	1000	noisy=0
C255	255	110	1e-15
*
g260	260	110	255	110	0.001
R260	260	110	1000	noisy=0
C260	260	110	1e-15
*
g265	265	110	260	110	0.001
R265	265	110	1000	noisy=0
C265	265	110	1e-15
*
g270	270	110	265	110	0.001
R270	270	110	1000	noisy=0
C270	270	110	1e-15
*
e280	280	110	270	110	1
R280	280	285	1	noisy=0
L280	285	281	1e-12
C280	281	282	1e-15
R281	282	110	1e3	noisy=0
*
e290	290	110	285	110	1
R290	290	292	10	noisy=0
L290	290	291	3.36e-9
C290	291	292	227.4e-12
R291	292	110	3.3545	noisy=0
e295	295	110	292	110	3.9811
*
*
***Output Stage***
g300	300	110	295	110	0.001
R300	300	110	1000	noisy=0
e301	301	110	300	110	1
Rout	301	302	50	noisy=0
Lout	302	310	1e-009
Cout	310	110	6e-012
*
*
***Output Current Limit***
VIoutP	71	310	dc	3.65
VIoutN	310	72	dc	2.97
DIoutP	70	71	diode
DIoutN	72	70	diode
Rx3	70	300	0.001	noisy=0
*
*
***Output Clamp-2***
VoutP1	111	73	dc	0.71
VoutN1	74	112	dc	0.71
DVoutP1	75	73	diode
DVoutN1	74	75	diode
RX4	75	310	0.001	noisy=0
*
*
***Supply Currents***
FIoVcc	314	110	Vmeas8	1
Vmeas8	310	311	DC	0
R314	110	314	1e9	noisy=0
DzOVcc	110	314	diode
DOVcc	102	314	diode
RX5	311	312	0.001	noisy=0
FIoVee	315	110	Vmeas9	1
Vmeas9	312	313	DC	0
R315	315	110	1e9	noisy=0
DzOVee	315	110	diode
DOVee	315	103	diode
*
*
***Output Switch***
S4	104	313	106	113	Switch
*
*
*** Common models***
.model	diode	d(bv=100)
* .model	Switch	vswitch(Von=0.401,Voff=0.399,ron=0.001,roff=1e6)
.model	Switch sw vt=0.4 vh=0.002 ron=0.001 roff=1e6
.model	DzVoutP	D(BV=4.3)
.model	DzVoutN	D(BV=4.3)
.model	DzSlewP	D(BV=181.24)
.model	DzSlewN D(BV=181.24)
.model	DVnoisy	D(IS=1.03e-015 KF=8.94e-018)
.model	DINnoisy	D(IS=1.86e-017 KF=9.41e-017)
.model	DIPnoisy	D(IS=1.86e-017 KF=9.41e-017)
* .model	Rideal	res(T_ABS=-273)
*
.ends
