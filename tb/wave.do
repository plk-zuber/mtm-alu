onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -group Top -noupdate /mtm_Alu_test_top/clk
add wave -group Top -noupdate /mtm_Alu_test_top/rst_n
add wave -group Top -noupdate /mtm_Alu_test_top/sin
add wave -group Top -noupdate /mtm_Alu_test_top/sout

onerror {resume}

add wave -group DUT -noupdate /mtm_Alu_test_top/DUT/clk
add wave -group DUT -noupdate /mtm_Alu_test_top/DUT/rst_n
add wave -group DUT -noupdate /mtm_Alu_test_top/DUT/sin
add wave -group DUT -noupdate /mtm_Alu_test_top/DUT/sout

add wave -group TESTBENCH_TASK -noupdate /mtm_Alu_test_top/u_mtm_Alu_tb/clk
add wave -group TESTBENCH_TASK -noupdate /mtm_Alu_test_top/u_mtm_Alu_tb/send_byte/ctl
add wave -group TESTBENCH_TASK -noupdate /mtm_Alu_test_top/u_mtm_Alu_tb/send_byte/data
add wave -group TESTBENCH_TASK -noupdate /mtm_Alu_test_top/u_mtm_Alu_tb/send_byte/opmode
add wave -group TESTBENCH_TASK -noupdate /mtm_Alu_test_top/u_mtm_Alu_tb/send_byte/crc

add wave -group Deserializer -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/clk
add wave -group Deserializer -color {Light Blue} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/state
add wave -group Deserializer -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/byte_cnt
add wave -group Deserializer -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/latch_flag
add wave -group Deserializer -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/data_cnt
add wave -group Deserializer -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/latch_cmd
add wave -group Deserializer -color {Dark Orchid} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/B_3_pre
add wave -group Deserializer -color {Dark Orchid} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/B_2_pre
add wave -group Deserializer -color {Dark Orchid} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/B_1_pre
add wave -group Deserializer -color {Dark Orchid} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/B_0_pre
add wave -group Deserializer -color {DodgerBlue} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/A_3_pre
add wave -group Deserializer -color {DodgerBlue} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/A_2_pre
add wave -group Deserializer -color {DodgerBlue} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/A_1_pre
add wave -group Deserializer -color {DodgerBlue} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/A_0_pre
add wave -group Deserializer -color {Yellow} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/OPMODE_pre
add wave -group Deserializer -color {Yellow} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/CRC_pre
add wave -group Deserializer -color {Red} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/opmode
add wave -group Deserializer -color {Red} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/crc
add wave -group Deserializer -color {Red} -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/crc_calc
add wave -group Deserializer -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/err_flag_crc
add wave -group Deserializer -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/err_flag_op
add wave -group Deserializer -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/err_flag_data
add wave -group Deserializer -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/t_err
add wave -group Deserializer -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/t_frame_cnt
add wave -group Deserializer -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/transmit_state
add wave -group Deserializer -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/d

add wave -group Deserializer_Output -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/A_out
add wave -group Deserializer_Output -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/B_out
add wave -group Deserializer_Output -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/OP_out
add wave -group Deserializer_Output -noupdate /mtm_Alu_test_top/DUT/u_mtm_Alu_deserializer/t_valid

add wave -group ALU -noupdate /mtm_Alu_test_top/DUT/A
add wave -group ALU -noupdate /mtm_Alu_test_top/DUT/B
add wave -group ALU -noupdate /mtm_Alu_test_top/DUT/C
add wave -group ALU -noupdate /mtm_Alu_test_top/DUT/opmode

#  reg [7:0] data;
#  reg [2:0] state;
#  reg [3:0] crc;
#  reg [2:0] opmode;
#  reg [2:0] byte_cnt;
#  reg [2:0] data_cnt;
#  reg latch_flag;
#  reg latch_cmd;
#  reg new_data;
#  reg data_err;
#
#  reg [7:0] B_3_pre; 
#  reg [7:0] B_2_pre; 
#  reg [7:0] B_1_pre; 
#  reg [7:0] B_0_pre; 
#  reg [7:0] A_3_pre; 
#  reg [7:0] A_2_pre; 
#  reg [7:0] A_1_pre; 
#  reg [7:0] A_0_pre; 
#  reg [2:0] OPMODE_pre;
#  reg [3:0] CRC_pre;
#
#  reg  crc_correct;
#  wire data_correct;
#  wire opmode_correct;
#
#  reg err_flag_crc;
#  reg err_flag_data;
#  reg err_flag_op;
#
#  reg       t_err;
#  reg [1:0] t_frame_cnt;
#  reg [2:0] transmit_state;
#
#  wire       ctl_parity;
#  wire [7:0] ctl_frame;
#
#  reg  [3:0]  crc_calc;
#  wire [3:0]  c;
#  wire [35:0] d;

onerror {resume}

#add wave -group RESULTS -color {Misty Rose} -noupdate /top/ul_pm_inst/ulpm_peak_high
#add wave -group RESULTS -color {Misty Rose} -noupdate /top/ul_pm_inst/ulpm_peak_offset
