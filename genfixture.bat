REM @echo off 
ECHO ON
REM  Wrapper around python wrapper to generate fixture with my geometry
REM Only argument is .kicad_board file
REM Note: Not as elaborated as genfixture.sh

SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

REM Path to openscad
IF EXIST "C:\Program Files\OpenSCAD" SET PATH=%PATH%;"C:\Program Files\OpenSCAD\"

IF Not Defined %KICAD_PYTHON (
 IF EXIST "C:\Program Files\KiCad\bin\python.exe" (
    SET KICAD_PYTHON="C:\Program Files\KiCad\bin\python.exe"
 ) else (
    echo "KICAD PYTHON NOT FOUND"
    EXIT
 )
)

SET BOARD=%1
SET BASENAME=%~n1

REM PCB thickness
SET PCB=0.8
SET LAYER=B.Cu
SET REV=rev_11
SET OUTPUT=%BASENAME%-%REV%

REM Nearest opposite side component to border
SET BORDER=0.8

REM Material dimensions
SET MAT=2.45
SET SCREW_LEN=16.0
SET SCREW_D=3.0
SET WASHER_TH=1.0
SET NUT_TH=2.4
SET NUT_F2F=5.45
SET NUT_C2C=6.10
SET POGO_UNCOMPRESSED_LENGTH=16

"c:\Program Files\KiCad\bin\python.exe" GenFixture.py --board %BOARD% --layer %LAYER% --rev %REV% --mat_th %MAT% --pcb_th %PCB% --out %OUTPUT% --screw_len %SCREW_LEN% --screw_d %SCREW_D% --washer_th %WASHER_TH% --nut_th %NUT_TH% --nut_f2f %NUT_F2F% --nut_c2c %NUT_C2C% --border %BORDER% --pogo-uncompressed-length %POGO_UNCOMPRESSED_LENGTH%


REM TO ENABLE OPENING SCAD FILE DIRECTLY FROM EXPLORER:
COPY glaser-stencil-d.ttf %OUTPUT%\
COPY osh_logo.dxf %OUTPUT%\



ENDLOCAL
