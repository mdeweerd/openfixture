#!/bin/bash
#
# Wrapper around python wrapper to generate fixture with my geometry
# Only argument is .kicad_board file
#

# Can set KICAD_PYTHON in environment to change path.
KICAD_PYTHON=${KICAD_PYTHON:=python}
BOARD="$1"
OUTPUT=$(basename ${BOARD%.*})

# PCB thickness
PCB=1.6
LAYER='B.Cu'
REV='rev.2.2'

# Nearest opposite side component to border
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

# Defaults
LOGO_WIDTH=1.7
LOGO_HEIGHT=1.7

# convert logo
LOGO_DXF=${LOGO_SVG%.*}.dxf
if [ -r $LOGO_SVG -a $LOGO_SVG -nt $LOGO_DXF ] ; then
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



  if [ $NHAS_MAGICK == 0 ] ; then
    LOGO_HEIGHT=$(magick identify -format "%h" ${LOGO_SVG})
    LOGO_WIDTH=$(magick identify -format "%h" ${LOGO_SVG})
    HAS_LOGO_SIZE=1
  elif [ $NHAS_INKSCAPE == 0 ] ; then
    LOGO_WIDTH=$(echo "scale = 4; $(inkscape ${LOGO_SVG} -W 2>/dev/null) / 90.0 * 25.4" | bc)
    LOGO_HEIGHT=$(echo "scale = 4; $(inkscape ${LOGO_SVG} -H 2>/dev/null) / 90.0 * 25.4" | bc)
    HAS_LOGO_SIZE=1
  fi
fi

echo $LOGO_WIDTH x $LOGO_HEIGHT


# Call python wrapper - KiCAD's Python is just 'python'.
${KICAD_PYTHON} GenFixture.py --flayer $LAYER $LOGO_OPT --render --board $BOARD --layer $LAYER --rev $REV --mat_th $MAT --pcb_th $PCB --out $OUTPUT --screw_len $SCREW_LEN --screw_d $SCREW_D --washer_th $WASHER_TH --nut_th $NUT_TH --nut_f2f $NUT_F2F --nut_c2c $NUT_C2C --border $BORDER
