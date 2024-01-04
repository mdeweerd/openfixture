@echo off
SETLOCAL
SET PRJ_DIR="yardstick_demo"
if NOT EXIST %PRJ_DIR%\yardstickone.kicad_pcb (
  mkdir %PRJ_DIR% 2>nul
  REM REQUIRES CURL
  (
   SETLOCAL
   cd %PRJ_DIR%
   curl -O https://raw.githubusercontent.com/greatscottgadgets/yardstick/master/yardstickone/yardstickone.kicad_pcb
   ENDLOCAL
  )
)


(
ECHO PINS="J1-1,J1-2,J1-3,J1-4,P1-1,P1-2,P1-3,P1-4,P1-5,P1-6,P1-7,P1-8,P1-9,P1-10,P1-11,P1-12,P1-13,P1-14"
ECHO #EXCLUDE_SIZE_REFS=QR1,QR2,Q3,BRD1
ECHO REV="DEMO"
ECHO #PCB_H=50
) > %PRJ_DIR%\fixture.conf

genfixture.BAT %PRJ_DIR%\yardstickone.kicad_pcb

ENDLOCAL
