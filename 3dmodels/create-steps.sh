#!/bin/sh
#
# 3D Model STEP generation for POGO TEST PINS.
#
# Author: Mario DE WEERD - https://github.com/mdeweerd
#
# License: CC-BY-SA
#   See: by-sa-4.0.md or https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
#
# The 3D Models are a combination of the test pin socket
# and the test pin.
# SOCK contains the list of socket types
# PINS contains the list of pint types
# FAMILY is the name of the "family" of SOCKETs
# PFAMILY is the name of the "family" of PINs
#
# This script loops over the combinations
# and calls convert_shape.py, a gist by slazav on github .
# That in turn requires Freecad to generate the step
# file using the pogopin.scad "openscad" script that 
# is copied to a temporary file to include the specific
# parameters for the "openscad" script.
# "FreeCAD" does not seem to offer the possibility to pass
# "openscad" parameters ont he command line and does not
# seemm to support the "include" statement in "opsnscad"
# files.
#
# Openscad itself is not used because it generates 'stl' files
# that KiCAD can't use.  
#
# This script also modifies properties of the generated STEP files 
# such as Descriptions, authors and a reference to a license.
#
# Originaly this is run under cygwin on Windows, which explains
# references to windows paths in some scripts.
#
# The `if [ 1 == 1 ]` and/or `if [ 0 == 1 ]` tests below
# are there to quicly disable portions of this script during
# development.
#

AUTHORS="Mario DE WEERD"
PERL=${PERL:=perl}
CONVERT_SHAPE=${CONVERT_SHAPE:=../convert_shape.py}
if [ 1 == 1 ] ; then
SOCK=""
SOCK="${SOCK} 1W"
SOCK="${SOCK} 2W"
SOCK="${SOCK} 4W"
SOCK="${SOCK} 5W"
SOCK="${SOCK} 2S"
SOCK="${SOCK} 4S"
SOCK="${SOCK} 3T"
SOCK="${SOCK} 4VW"

PINS="E2 E3 A2 A3 G1 G2 B1"
PINS="B1"
FAMILY="R100"
PFAMILY="P100"
for s in $SOCK ; do
  for p in $PINS ; do 
    cat pogopins.scad > tmp.scad
    cat >> tmp.scad <<EOF
family="$FAMILY";
socket_type="$s";
pin_type="$p";
EOF
    SYMBOL=$FAMILY-$s-$PFAMILY-$p
    OUTFILE=$FAMILY-$s-$PFAMILY-$p.step
    echo ${CONVERT_SHAPE} tmp.scad $OUTFILE
    ${CONVERT_SHAPE} tmp.scad $OUTFILE
    DATE=$(TZ=UTC date +"%Y-%m-%dT%T")
    # Set correct names in generated files
    ${PERL} -i -p -0777 -e "s/Open CASCADE[^']*|FreeCAD Model/${SYMBOL}/g;" \
          -e "s/FILE_NAME[^;]*;/FILE_NAME('Pogopin $FAMILY-$s socket with $PFAMILY-$p pin.',
'$DATE',('$AUTHORS'),(''),(' '),'FreeCAD','CC-BY-SA');/g;" \
         $OUTFILE
  done
done
fi


# 
# R50
#

SOCK=""
SOCK="${SOCK} 1W7"
#SOCK="${SOCK} 1W9"
SOCK="${SOCK} 2W7"
#SOCK="${SOCK} 2W9"
#SOCK="${SOCK} 1C"
#SOCK="${SOCK} 2C"
#SOCK="${SOCK} 3C"
SOCK="${SOCK} 1S"
SOCK="${SOCK} 2S"
SOCK="${SOCK} 3S"

PINS="E2 E3 A2 A3 G1 G2 B1"
FAMILY="R50"
PFAMILY="P50"
for s in $SOCK ; do
  for p in $PINS ; do 
    cat pogopins.scad > tmp.scad
    cat >> tmp.scad <<EOF
family="$FAMILY";
socket_type="$s";
pin_type="$p";
EOF
    SYMBOL=$FAMILY-$s-$PFAMILY-$p
    OUTFILE=$FAMILY-$s-$PFAMILY-$p.step
    echo ${CONVERT_SHAPE} tmp.scad $OUTFILE
    ${CONVERT_SHAPE} tmp.scad $OUTFILE
    DATE=$(TZ=UTC date +"%Y-%m-%dT%T")
    AUTHORS="Mario DE WEERD"
    # Set correct names in generated files
    ${PERL} -i -p -0777 -e "s/Open CASCADE[^']*|FreeCAD Model/${SYMBOL}/g;" \
          -e "s/FILE_NAME[^;]*;/FILE_NAME('Pogopin $FAMILY-$s socket with $PFAMILY-$p pin.',
'$DATE',('$AUTHORS'),(''),(' '),'FreeCAD','CC-BY-SA');/g;" \
         $OUTFILE
  done
done
