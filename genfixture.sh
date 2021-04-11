#!/bin/bash
#
# Wrapper around python wrapper to generate fixture with specific geometry
# Only argument is .kicad_board file
#

# Can set KICAD_PYTHON in environment to change path.
KICAD_PYTHON=${KICAD_PYTHON:=python}
BOARD="$1"
BOARD_AND_CLI_OPTION="$*"
OUTPUT=$(basename ${BOARD%.*})

# PCB thickness
PCB=1.6
LAYER='B.Cu'
REV='rev.1.0'

PINS=${PINS:=J2-1,J2-2,T1-10,T1-6,P1-1,J3-1,J3-2,J1-1,J1-2,J7-1,J7-2,J7-3,J7-4,J7-5,J7-6,J7-7,J7-8,J9-1,J9-2,J9-3,J9-4,J9-5,J9-6,J9-7,J9-8,J11-1,J11-2,J11-3,J11-4,J11-5,J11-6,J14-1,J14-2,J14-3,J18-1,J18-2,J18-3,J18-4,J18-5,J18-6,J18-7,J18-8,J18-9,J18-10,J18-11,J18-12,J4-1,J4-2,U8-1,U8-2,U8-3,U8-4,U8-5,U8-6,U8-7,U8-8,U10-1,U10-2,U10-3,U10-4,U10-5,U10-6,U10-7,U10-8}
# Nearest opposite side component to border
EXCLUDE_SIZE_REFS=QR1,QR2,Q3,BRD1
BORDER=0.8

# Material dimensions
MAT=3.0
SCREW_LEN=16.0
SCREW_D=3.0
WASHER_TH=1.0
NUT_TH=3.85
NUT_F2F=5.45
NUT_C2C=6.10

NHAS_MAGICK=$(which magick >&/dev/null ; echo $?)
NHAS_INKSCAPE=$(which inkscape >&/dev/null ; echo $?)
NHAS_PSTOEDIT=$(which pstoedit >&/dev/null ; echo $?)
NHAS_POTRACE=$(which potrace >&/dev/null ; echo $?)
HAS_LOGO_SIZE=0
LOGO_SVG=logo.svg

# Default targets
LOGO_WIDTH=50
LOGO_HEIGHT=20

# convert logo
LOGO_DXF=${LOGO_SVG%.*}.dxf
if [ -r $LOGO_SVG ] ; then
  # Conversion to DXF disabled - OPENSCAD reads SVG directly
  if [ 0 == 1 -a $LOGO_SVG -nt $LOGO_DXF ] ; then
    if [ $NHAS_MAGICK == 0 -a $NHAS_POTRACE ] ; then
      # Tentative conversion, not fully tested yet:
      rm "$LOGO_DXF" >& /dev/null
      magick "$LOGO_SVG" "$LOGO_DXF"
      LOGO_OPT="--logo '${LOGO_DXF}'"
    elif [ $NHAS_INKSCAPE == 0 && $NHAS_PSTOEDIT == 0 ] ; then
      rm "$LOGO_DXF" >& /dev/null
      inkscape $LOGO_SVG -E logo.eps
      pstoedit -dt -f "dxf:-polyaslines -mm" logo.eps $LOGO_DXF
      rm logo.eps
      LOGO_OPT="--logo "${LOGO_DXF}
    fi
  fi

  if [ $NHAS_MAGICK == 0 ] ; then
    REAL_LOGO_HEIGHT=$(magick identify -format "%h" ${LOGO_SVG})
    REAL_LOGO_WIDTH=$(magick identify -format "%w" ${LOGO_SVG})
    HAS_LOGO_SIZE=1
  elif [ $NHAS_INKSCAPE == 0 ] ; then
    REAL_LOGO_WIDTH=$(echo "scale = 4; $(inkscape ${LOGO_SVG} -W 2>/dev/null) / 90.0 * 25.4" | bc)
    REAL_LOGO_HEIGHT=$(echo "scale = 4; $(inkscape ${LOGO_SVG} -H 2>/dev/null) / 90.0 * 25.4" | bc)
    HAS_LOGO_SIZE=1
  fi

  if [ $HAS_LOGO_SIZE == 1 ] ; then
    RATIO_TARGET=$((LOGO_WIDTH / LOGO_HEIGHT))
    RATIO_REAL=$((REAL_LOGO_WIDTH / REAL_LOGO_HEIGHT))
    if [ $RATIO_REAL -gt $RATIO_TARGET ] ; then 
      # Need to fit according to height
      LOGO_WIDTH=$((RATIO_TARGET * LOGO_HEIGHT))
    else
      LOGO_HEIGHT=$((RATIO_TARGET * LOGO_HEIGHT))
    fi
  fi
  echo $LOGO_WIDTH x $LOGO_HEIGHT
  LOGO_OPT="--logo ${LOGO_SVG} --logo-w $LOGO_WIDTH --logo-h $LOGO_HEIGHT"
fi



#RENDER=--render

# Call python wrapper - KiCAD's Python is just 'python'.
${KICAD_PYTHON} GenFixture.py $LOGO_OPT $RENDER --layer $LAYER --pins=${PINS} --exclude-size=${EXCLUDE_SIZE_REFS} --rev $REV --mat_th $MAT --pcb_th $PCB --out $OUTPUT --screw_len $SCREW_LEN --screw_d $SCREW_D --washer_th $WASHER_TH --nut_th $NUT_TH --nut_f2f $NUT_F2F --nut_c2c $NUT_C2C --border $BORDER --board ${BOARD_AND_CLI_OPTION}
