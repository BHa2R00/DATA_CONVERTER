#!/bin/bash
rm -v ./*.{lxt,vcd}
iverilog -o out1 ./DATA_CONVERT.v ./READ.v ./OUT.v ./CTRL.v ./tb.v
vvp -n out1 -lxt2
cp out1.vcd out1.lxt
gtkwave out1.lxt
