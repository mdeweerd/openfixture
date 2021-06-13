@echo off 
REM  Wrapper around python wrapper to generate fixture with my geometry
REM Only argument is .kicad_board file

setlocal

REM Patch to openscad
IF EXIST "C:\Program Files\OpenSCAD" SET PATH=%PATH%;"C:\Program Files\OpenSCAD\"

set BOARD=%1

REM PCB thickness
set PCB=0.8
set LAYER=B.Cu
set REV=rev_11
set OUTPUT=fixture-%REV%

REM Nearest opposite side component to border
set BORDER=0.8

REM Material dimensions
set MAT=2.45
set SCREW_LEN=16.0
set SCREW_D=3.0
set WASHER_TH=1.0
set NUT_TH=2.4
set NUT_F2F=5.45
set NUT_C2C=6.10
set POGO_UNCOMPRESSED_LENGTH=16

"c:\Program Files\KiCad\bin\python.exe" GenFixture.py --board %BOARD% --layer %LAYER% --rev %REV% --mat_th %MAT% --pcb_th %PCB% --out %OUTPUT% --screw_len %SCREW_LEN% --screw_d %SCREW_D% --washer_th %WASHER_TH% --nut_th %NUT_TH% --nut_f2f %NUT_F2F% --nut_c2c %NUT_C2C% --border %BORDER% --pogo-uncompressed-length %POGO_UNCOMPRESSED_LENGTH%


