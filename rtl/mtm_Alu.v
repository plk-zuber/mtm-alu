/******************************************************************************
 * (C) Copyright 2019 AGH UST All Rights Reserved
 *
 * MODULE:    mtm_Alu
 * PROJECT:   PPCU_VLSI
 * AUTHORS:   Michal Garbacz
 * DATE:
 * ------------------------------------------------------------------------------
 * The ALU should operate as described in the mtmAlu_test_top module.
 * It should consist of three modules connected together:
 *   mtm_Alu_deserializer
 *   mtm_Alu_core
 *   mtm_Alu_serializer
 * The ALU should use posedge active clock and synchronous reset active LOW.
 *
 *******************************************************************************/

module mtm_Alu (
    input  wire clk,   // posedge active clock
    input  wire rst_n, // synchronous reset active low
    input  wire sin,   // serial data input
    output wire sout   // serial data output
);
  wire [31:0] A;
  wire [31:0] B;
  wire [31:0] C;
  wire [2:0]  opmode;
  wire        carry_out;
  wire        t_valid;

  mtm_Alu_deserializer u_mtm_Alu_deserializer(
    .clk(clk),
    .rst(rst_n),
    .din(sin),
    .A_out(A),
    .B_out(B),
    .OP_out(opmode),
    .t_valid(t_valid)
  );

  mtm_Alu_core u_mtm_Alu_core(
   .A(A),
   .B(B),
   .C(C),
   .opmode(opmode),
   .carry_out()
  );

//mtm_Alu_serializer u_mtm_Alu_serializer(
//);


endmodule
