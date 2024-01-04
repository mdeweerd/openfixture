EESchema Schematic File Version 5
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "yardstickone-Test generated schematic (PogoJig v0.1)"
Date "19 Apr 2021"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
Comment5 ""
Comment6 ""
Comment7 ""
Comment8 ""
Comment9 ""
$EndDescr
$Comp
L Connector:Conn_01x01_Female J1
U 1 1 23440001
P 1000 1000
F 0 "J1" H 950 1050 50  0000 R CNN
F 1 "pogopin" H 1050 1000 50  0000 L CNN
F 2 "None" H 1000 1000 50  0001 C CNN
F 3 "~" H 1000 1000 50  0001 C CNN
        1    1000 1000
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 1000 1300 1000
Text GLabel 1300 1000 2    50  BiDi ~ 0
Net-(FB1-Pad2)
$Comp
L Connector:Conn_01x01_Female J1-2
U 1 1 23440002
P 1000 1200
F 0 "J1-2" H 950 1250 50  0000 R CNN
F 1 "pogopin" H 1050 1200 50  0000 L CNN
F 2 "None" H 1000 1200 50  0001 C CNN
F 3 "~" H 1000 1200 50  0001 C CNN
        1    1000 1200
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 1200 1300 1200
Text GLabel 1300 1200 2    50  BiDi ~ 0
Net-(J1-Pad2)
$Comp
L Connector:Conn_01x01_Female J1-3
U 1 1 23440003
P 1000 1400
F 0 "J1-3" H 950 1450 50  0000 R CNN
F 1 "pogopin" H 1050 1400 50  0000 L CNN
F 2 "None" H 1000 1400 50  0001 C CNN
F 3 "~" H 1000 1400 50  0001 C CNN
        1    1000 1400
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 1400 1300 1400
Text GLabel 1300 1400 2    50  BiDi ~ 0
Net-(J1-Pad3)
$Comp
L Connector:Conn_01x01_Female J1-4
U 1 1 23440004
P 1000 1600
F 0 "J1-4" H 950 1650 50  0000 R CNN
F 1 "pogopin" H 1050 1600 50  0000 L CNN
F 2 "None" H 1000 1600 50  0001 C CNN
F 3 "~" H 1000 1600 50  0001 C CNN
        1    1000 1600
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 1600 1300 1600
Text GLabel 1300 1600 2    50  BiDi ~ 0
GND
$Comp
L Connector:Conn_01x01_Female P1
U 1 1 23440005
P 1000 1800
F 0 "P1" H 950 1850 50  0000 R CNN
F 1 "pogopin" H 1050 1800 50  0000 L CNN
F 2 "None" H 1000 1800 50  0001 C CNN
F 3 "~" H 1000 1800 50  0001 C CNN
        1    1000 1800
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 1800 1300 1800
Text GLabel 1300 1800 2    50  BiDi ~ 0
DD
$Comp
L Connector:Conn_01x01_Female P1-2
U 1 1 23440006
P 1000 2000
F 0 "P1-2" H 950 2050 50  0000 R CNN
F 1 "pogopin" H 1050 2000 50  0000 L CNN
F 2 "None" H 1000 2000 50  0001 C CNN
F 3 "~" H 1000 2000 50  0001 C CNN
        1    1000 2000
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 2000 1300 2000
Text GLabel 1300 2000 2    50  BiDi ~ 0
3V3
$Comp
L Connector:Conn_01x01_Female P1-3
U 1 1 23440007
P 1000 2200
F 0 "P1-3" H 950 2250 50  0000 R CNN
F 1 "pogopin" H 1050 2200 50  0000 L CNN
F 2 "None" H 1000 2200 50  0001 C CNN
F 3 "~" H 1000 2200 50  0001 C CNN
        1    1000 2200
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 2200 1300 2200
Text GLabel 1300 2200 2    50  BiDi ~ 0
P0_5
$Comp
L Connector:Conn_01x01_Female P1-4
U 1 1 23440008
P 1000 2400
F 0 "P1-4" H 950 2450 50  0000 R CNN
F 1 "pogopin" H 1050 2400 50  0000 L CNN
F 2 "None" H 1000 2400 50  0001 C CNN
F 3 "~" H 1000 2400 50  0001 C CNN
        1    1000 2400
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 2400 1300 2400
Text GLabel 1300 2400 2    50  BiDi ~ 0
3V3
$Comp
L Connector:Conn_01x01_Female P1-5
U 1 1 23440009
P 1000 2600
F 0 "P1-5" H 950 2650 50  0000 R CNN
F 1 "pogopin" H 1050 2600 50  0000 L CNN
F 2 "None" H 1000 2600 50  0001 C CNN
F 3 "~" H 1000 2600 50  0001 C CNN
        1    1000 2600
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 2600 1300 2600
Text GLabel 1300 2600 2    50  BiDi ~ 0
RESET_N
$Comp
L Connector:Conn_01x01_Female P1-6
U 1 1 2344000A
P 1000 2800
F 0 "P1-6" H 950 2850 50  0000 R CNN
F 1 "pogopin" H 1050 2800 50  0000 L CNN
F 2 "None" H 1000 2800 50  0001 C CNN
F 3 "~" H 1000 2800 50  0001 C CNN
        1    1000 2800
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 2800 1300 2800
Text GLabel 1300 2800 2    50  BiDi ~ 0
P0_4
$Comp
L Connector:Conn_01x01_Female P1-7
U 1 1 2344000B
P 1000 3000
F 0 "P1-7" H 950 3050 50  0000 R CNN
F 1 "pogopin" H 1050 3000 50  0000 L CNN
F 2 "None" H 1000 3000 50  0001 C CNN
F 3 "~" H 1000 3000 50  0001 C CNN
        1    1000 3000
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 3000 1300 3000
Text GLabel 1300 3000 2    50  BiDi ~ 0
DC
$Comp
L Connector:Conn_01x01_Female P1-8
U 1 1 2344000C
P 1000 3200
F 0 "P1-8" H 950 3250 50  0000 R CNN
F 1 "pogopin" H 1050 3200 50  0000 L CNN
F 2 "None" H 1000 3200 50  0001 C CNN
F 3 "~" H 1000 3200 50  0001 C CNN
        1    1000 3200
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 3200 1300 3200
Text GLabel 1300 3200 2    50  BiDi ~ 0
P0_3
$Comp
L Connector:Conn_01x01_Female P1-9
U 1 1 2344000D
P 1000 3400
F 0 "P1-9" H 950 3450 50  0000 R CNN
F 1 "pogopin" H 1050 3400 50  0000 L CNN
F 2 "None" H 1000 3400 50  0001 C CNN
F 3 "~" H 1000 3400 50  0001 C CNN
        1    1000 3400
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 3400 1300 3400
Text GLabel 1300 3400 2    50  BiDi ~ 0
GND
$Comp
L Connector:Conn_01x01_Female P1-10
U 1 1 2344000E
P 1000 3600
F 0 "P1-10" H 950 3650 50  0000 R CNN
F 1 "pogopin" H 1050 3600 50  0000 L CNN
F 2 "None" H 1000 3600 50  0001 C CNN
F 3 "~" H 1000 3600 50  0001 C CNN
        1    1000 3600
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 3600 1300 3600
Text GLabel 1300 3600 2    50  BiDi ~ 0
P0_2
$Comp
L Connector:Conn_01x01_Female P1-11
U 1 1 2344000F
P 1000 3800
F 0 "P1-11" H 950 3850 50  0000 R CNN
F 1 "pogopin" H 1050 3800 50  0000 L CNN
F 2 "None" H 1000 3800 50  0001 C CNN
F 3 "~" H 1000 3800 50  0001 C CNN
        1    1000 3800
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 3800 1300 3800
Text GLabel 1300 3800 2    50  BiDi ~ 0
P0_1
$Comp
L Connector:Conn_01x01_Female P1-12
U 1 1 23440010
P 1000 4000
F 0 "P1-12" H 950 4050 50  0000 R CNN
F 1 "pogopin" H 1050 4000 50  0000 L CNN
F 2 "None" H 1000 4000 50  0001 C CNN
F 3 "~" H 1000 4000 50  0001 C CNN
        1    1000 4000
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 4000 1300 4000
Text GLabel 1300 4000 2    50  BiDi ~ 0
P0_0
$Comp
L Connector:Conn_01x01_Female P1-13
U 1 1 23440011
P 1000 4200
F 0 "P1-13" H 950 4250 50  0000 R CNN
F 1 "pogopin" H 1050 4200 50  0000 L CNN
F 2 "None" H 1000 4200 50  0001 C CNN
F 3 "~" H 1000 4200 50  0001 C CNN
        1    1000 4200
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 4200 1300 4200
Text GLabel 1300 4200 2    50  BiDi ~ 0
P1_7
$Comp
L Connector:Conn_01x01_Female P1-14
U 1 1 23440012
P 1000 4400
F 0 "P1-14" H 950 4450 50  0000 R CNN
F 1 "pogopin" H 1050 4400 50  0000 L CNN
F 2 "None" H 1000 4400 50  0001 C CNN
F 3 "~" H 1000 4400 50  0001 C CNN
        1    1000 4400
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 4400 1300 4400
Text GLabel 1300 4400 2    50  BiDi ~ 0
P1_6
$Comp
L Connector:Conn_01x01_Female P2-2
U 1 1 23440013
P 1000 4600
F 0 "P2-2" H 950 4650 50  0000 R CNN
F 1 "pogopin" H 1050 4600 50  0000 L CNN
F 2 "None" H 1000 4600 50  0001 C CNN
F 3 "~" H 1000 4600 50  0001 C CNN
        1    1000 4600
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 4600 1300 4600
Text GLabel 1300 4600 2    50  BiDi ~ 0
GND
$Comp
L Connector:Conn_01x01_Female P2-2
U 1 1 23440014
P 1000 4800
F 0 "P2-2" H 950 4850 50  0000 R CNN
F 1 "pogopin" H 1050 4800 50  0000 L CNN
F 2 "None" H 1000 4800 50  0001 C CNN
F 3 "~" H 1000 4800 50  0001 C CNN
        1    1000 4800
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 4800 1300 4800
Text GLabel 1300 4800 2    50  BiDi ~ 0
GND
$Comp
L Connector:Conn_01x01_Female P3
U 1 1 23440015
P 1000 5000
F 0 "P3" H 950 5050 50  0000 R CNN
F 1 "pogopin" H 1050 5000 50  0000 L CNN
F 2 "None" H 1000 5000 50  0001 C CNN
F 3 "~" H 1000 5000 50  0001 C CNN
        1    1000 5000
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 5000 1300 5000
Text GLabel 1300 5000 2    50  BiDi ~ 0
RESET_N
$Comp
L Connector:Conn_01x01_Female P4
U 1 1 23440016
P 1000 5200
F 0 "P4" H 950 5250 50  0000 R CNN
F 1 "pogopin" H 1050 5200 50  0000 L CNN
F 2 "None" H 1000 5200 50  0001 C CNN
F 3 "~" H 1000 5200 50  0001 C CNN
        1    1000 5200
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 5200 1300 5200
Text GLabel 1300 5200 2    50  BiDi ~ 0
DD
$Comp
L Connector:Conn_01x01_Female P5
U 1 1 23440017
P 1000 5400
F 0 "P5" H 950 5450 50  0000 R CNN
F 1 "pogopin" H 1050 5400 50  0000 L CNN
F 2 "None" H 1000 5400 50  0001 C CNN
F 3 "~" H 1000 5400 50  0001 C CNN
        1    1000 5400
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 5400 1300 5400
Text GLabel 1300 5400 2    50  BiDi ~ 0
DC
$Comp
L Connector:Conn_01x01_Female P6
U 1 1 23440018
P 1000 5600
F 0 "P6" H 950 5650 50  0000 R CNN
F 1 "pogopin" H 1050 5600 50  0000 L CNN
F 2 "None" H 1000 5600 50  0001 C CNN
F 3 "~" H 1000 5600 50  0001 C CNN
        1    1000 5600
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 5600 1300 5600
Text GLabel 1300 5600 2    50  BiDi ~ 0
Net-(P6-Pad1)
$Comp
L Connector:Conn_01x01_Female P7
U 1 1 23440019
P 1000 5800
F 0 "P7" H 950 5850 50  0000 R CNN
F 1 "pogopin" H 1050 5800 50  0000 L CNN
F 2 "None" H 1000 5800 50  0001 C CNN
F 3 "~" H 1000 5800 50  0001 C CNN
        1    1000 5800
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 5800 1300 5800
Text GLabel 1300 5800 2    50  BiDi ~ 0
GND
$Comp
L Connector:Conn_01x01_Female R13-2
U 1 1 2344001A
P 1000 6000
F 0 "R13-2" H 950 6050 50  0000 R CNN
F 1 "pogopin" H 1050 6000 50  0000 L CNN
F 2 "None" H 1000 6000 50  0001 C CNN
F 3 "~" H 1000 6000 50  0001 C CNN
        1    1000 6000
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 6000 1300 6000
Text GLabel 1300 6000 2    50  BiDi ~ 0
Net-(P6-Pad1)
$Comp
L Connector:Conn_01x01_Female R13
U 1 1 2344001B
P 1000 6200
F 0 "R13" H 950 6250 50  0000 R CNN
F 1 "pogopin" H 1050 6200 50  0000 L CNN
F 2 "None" H 1000 6200 50  0001 C CNN
F 3 "~" H 1000 6200 50  0001 C CNN
        1    1000 6200
        -1   0    0    1
$EndComp
Wire Wire Line
        1200 6200 1300 6200
Text GLabel 1300 6200 2    50  BiDi ~ 0
3V3
$EndSCHEMATC
