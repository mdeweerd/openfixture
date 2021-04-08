#!/bin/sh
#
# Wrapper around python wrapper to generate fixture with my geometry
# Only argument is .kicad_board file
#

BOARD=$1
OUTPUT="fixture-can-filter-v2.2"

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

# convert logo
if [ $NHAS_MAGICK == 0 -a $NHAS_POTRACE ] ; then
    # Tentative conversion, not tested yet:
    rm logo.dxf >& /dev/null
    magick logo.svg logo.dxf
elif [ $NHAS_INKSCAPE == 0 && $NHAS_PSTOEDIT == 0 ] ; then
    rm logo.dxf >& /dev/null
    inkscape logo.svg -E logo.eps
    pstoedit -dt -f "dxf:-polyaslines -mm" logo.eps logo.dxf
    rm logo.eps
fi



if [ $NHAS_MAGICK == 0 ] ; then
   LOGO_HEIGHT=$(magick identify -format "%h" logo.svg)
   LOGO_WIDTH=$(magick identify -format "%h" logo.svg)
   HAS_LOGO_SIZE=1
elif [ $NHAS_INKSCAPE == 0 ] ; then
   LOGO_WIDTH=$(echo "scale = 4; $(inkscape logo.svg -W 2>/dev/null) / 90.0 * 25.4" | bc)
   LOGO_HEIGHT=$(echo "scale = 4; $(inkscape logo.svg -H 2>/dev/null) / 90.0 * 25.4" | bc)
   HAS_LOGO_SIZE=1
else
   # Defaults
   LOGO_WIDTH=127
   LOGO_HEIGHT=127
fi

echo $LOGO_WIDTH x $LOGO_HEIGHT




# Call python wrapper - KiCAD's Python is just 'python'.
python GenFixture.py --render --board $BOARD --layer $LAYER --rev $REV --mat_th $MAT --pcb_th $PCB --out $OUTPUT --screw_len $SCREW_LEN --screw_d $SCREW_D --washer_th $WASHER_TH --nut_th $NUT_TH --nut_f2f $NUT_F2F --nut_c2c $NUT_C2C --border $BORDER
