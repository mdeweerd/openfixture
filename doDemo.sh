#!/bin/bash
PRJ_DIR="yardstick_demo"
if [ ! -r ${PRJ_DIR}/yardstickone.kicad_pcb ] ; then
  mkdir "${PRJ_DIR}" >& /dev/null
  ( cd "${PRJ_DIR}" ; wget 'https://raw.githubusercontent.com/greatscottgadgets/yardstick/master/yardstickone/yardstickone.kicad_pcb' )
fi

cat > ${PRJ_DIR}/fixture.conf <<'EOF'
PINS="J1-1,J1-2,J1-3,J1-4,P1-1,P1-2,P1-3,P1-4,P1-5,P1-6,P1-7,P1-8,P1-9,P1-10,P1-11,P1-12,P1-13,P1-14"
#EXCLUDE_SIZE_REFS=QR1,QR2,Q3,BRD1
REV="DEMO"
#PCB_H=50
EOF

./genfixture.sh "${PRJ_DIR}/yardstickone.kicad_pcb"
