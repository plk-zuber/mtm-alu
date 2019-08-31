transcript file log.txt

setenv XILINX "/applics/xilinx/vivado/2018_3_1207_2324/Vivado/2018.3"

vlib work
vmap work work

vlog $env(XILINX)/data/verilog/src/glbl.v

vlog -work work ../rtl/mtm_Alu_core.v
vlog -work work ../rtl/mtm_Alu_deserializer.v
vlog -work work ../rtl/mtm_Alu_serializer.v

vlog -work work ../rtl/mtm_Alu.v

vlog -work work mtm_Alu_test_top.v
vlog -work work mtm_Alu_tb.v

vsim -novopt -fsmdebug \
     -L work -L unisims_ver -L unimacro_ver -L unifast_ver -L simprims_ver -L secureip -L unisim -L unimacro -L unifast   work.glbl -t ps mtm_Alu_test_top


do wave.do

run 1 us
