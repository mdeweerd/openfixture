#!/bin/sh

SOCK=""
SOCK="${SOCK} 1W"
SOCK="${SOCK} 2W"
SOCK="${SOCK} 4W"
SOCK="${SOCK} 5W"
SOCK="${SOCK} 2S"
SOCK="${SOCK} 4S"
SOCK="${SOCK} 3T"
SOCK="${SOCK} 4VW"

PINS="E2 E3 A2 A3 G1 G2"

for s in $SOCK ; do
  for p in $PINS ; do 
    cat pogopins.scad > tmp.scad
    cat >> tmp.scad <<EOF
socket_type="$s";
pin_type="$p";
EOF
    SYMBOL=R100-$s-P100-$p
    OUTFILE=R100-$s-P100-$p.step
    echo ../convert_shape.py tmp.scad $OUTFILE
    ../convert_shape.py tmp.scad $OUTFILE
    # Set correct names in generated files
    perl -i -p -e "s/Open CASCADE[^']*/${SYMBOL}/g;" $OUTFILE
  done
done
