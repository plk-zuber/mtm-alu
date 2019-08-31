`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH MTM 
// Engineer: Michal Garbacz
// 
// Create Date: 08/24/2019 03:54:50 PM
// Design Name: 
// Module Name: mtm_Alu_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define WIDE // ALU is asynchronous so first attempt is to process all 32 bits in one cc
// if timing is closed for 50 MHz, it stays that way.
// will check again after place & route

module mtm_Alu_core(
`ifdef WIDE
  input wire   [31:0] A,
  input wire   [31:0] B,
  output reg   [31:0] C,
`else
  input wire   [7:0] A,
  input wire   [7:0] B,
  output reg   [7:0] C,
`endif
  input wire   [2:0] opmode,
  output wire        carry,
  output wire        overflow,
  output wire        zero,
  output wire        negative
);
  localparam OPMODE_AND  = 3'b000;
  localparam OPMODE_OR   = 3'b001;
  localparam OPMODE_ADD  = 3'b100;
  localparam OPMODE_SUB  = 3'b101;

`ifdef WIDE
  `define carry_bit 32
  wire [32:0] sum_wide;
`else
  `define carry_bit 8
  wire [8:0] sum_wide;
`endif

  // Flags according to ARM architecture: C, Z, N, V

  assign sum_wide  = {1'b0, A} + {1'b0, B};
  assign carry     = sum_wide[`carry_bit]; // C flag (CARRY or UNSIGNED OVERFLOW)
  assign zero      = (C == 0); // Z flag (ZERO)
  assign negative  = C[31]; // N flag (NEGATIVE)
  assign overflow  = (~(A[31] | B[31]) & C[31]) | (A[31] & B[31] & (~(C[31]))); // V flag (SIGNED OVERFLOW)

  always @* begin
    case (opmode)
      OPMODE_AND: begin
        C = A & B;
      end
      OPMODE_OR: begin
        C = A | B;
      end
      OPMODE_ADD: begin
        C = A + B;
      end
      OPMODE_SUB: begin
        C = A - B;
      end
      default: begin // add by default
        C = A + B;
      end
    endcase
  end

endmodule
