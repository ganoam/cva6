#!/bin/bash

## set variables
export DESIGN="regfile-tb"
export VER=10.7e
export LIB=rtl
export LOG=${DESIGN}.log

if [ -e $LIB ]; then
  rm -rf $LIB
fi

vlib-$VER ${LIB}

echo -n "** Compilation using modelsim version: $VER of $DESIGN: " > $LOG

vlog-$VER +acc -O0 -work $LIB src/ariane_regfile_fpga.sv >> $LOG
vlog-$VER +acc -O0 -work $LIB src/ariane_regfile_ff.sv >> $LOG
vlog-$VER +acc -O0 -work $LIB tb/ariane_regfile_tb.sv >> $LOG

vsim-$VER rtl.ariane_regfile_tb -do "source scripts/waves.do; run -all;"



