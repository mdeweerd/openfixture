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

PIN="E2"

for s in $SOCK ; do
  for p in $PIN ; do 
    cat pogopins.scad > tmp.scad
    cat >> tmp.scad <<EOF
socket_type="$s";
pin_type="$p";
EOF
    SYMBOL=R100-$s-P100-$p
    OUTFILE=R100-$s-P100-$p.step
    echo ../convert_shape.py tmp.scad $OUTFILE
    ../convert_shape.py tmp.scad $OUTFILE
#    perl -i -p -e "s/Open CASCADE[^']*/${SYMBOL}/g;" $OUTFILE
  done
done
