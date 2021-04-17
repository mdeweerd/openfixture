#!/bin/sh

AUTHORS="Mario DE WEERD"
if [ 0 == 1 ] ; then
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
    echo ../convert_shape.py tmp.scad $OUTFILE
    ../convert_shape.py tmp.scad $OUTFILE
    DATE=$(TZ=UTC date +"%Y-%m-%dT%T")
    # Set correct names in generated files
    perl -i -p -0777 -e "s/Open CASCADE[^']*|FreeCAD Model/${SYMBOL}/g;" \
          -e "s/FILE_NAME[^;]*;/FILE_NAME('Pogopin $FAMILY-$s socket with $PFAMILY-$p pin.',
'$DATE',('$AUTHORS'),(''),(' '),'FreeCAD','CC-BY-CA');/g;" \
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
    echo ../convert_shape.py tmp.scad $OUTFILE
    ../convert_shape.py tmp.scad $OUTFILE
    DATE=$(TZ=UTC date +"%Y-%m-%dT%T")
    AUTHORS="Mario DE WEERD"
    # Set correct names in generated files
    perl -i -p -0777 -e "s/Open CASCADE[^']*|FreeCAD Model/${SYMBOL}/g;" \
          -e "s/FILE_NAME[^;]*;/FILE_NAME('Pogopin $FAMILY-$s socket with $PFAMILY-$p pin.',
'$DATE',('$AUTHORS'),(''),(' '),'FreeCAD','CC-BY-CA');/g;" \
         $OUTFILE
  done
done
