`timescale 1ns/1ps
/******************************************************************************
 * (C) Copyright 2019 AGH UST All Rights Reserved
 *
 * MODULE:    mtm_Alu tb
 * PROJECT:   PPCU_VLSI
 * AUTHORS:   Michal Garbacz
 * DATE:
 * ------------------------------------------------------------------------------
 * This module (TB) provides test patterns for the ALU, reads data from the ALU and 
 * verifies if the operation result is correct.
 * 
 * The TB must include:
 * - task send_byte to send a CMD or CTL command to the ALU
 * - task send_calculation_data that will send 9 bytes to the ALU for given
 *   operands and operation
 * - procedural block for capturing the input data from the ALU
 * - task compare to compare the result from the ALU and the expected data.
 * 
 * The test vectors must provide at least:
 * - sending max (0xFFFF) and min (0) data with all the ALU operations (AND OR, ADD,SUB)
 * - sending 1000 random valid data
 * - sending invalid data (wrong number of DATA packets before CTL packet)
 * - sending data with CRC error
 * 
 * The testbench should print final PASS/FAIL text information.
 */

module mtm_Alu_tb (
  output reg clk,
  output reg rst_n,
  output reg sin,
  output reg sout
);

  localparam CTL   = 1'b1;
  localparam DATA  = 1'b0;

  localparam OPMODE_AND  = 3'b000;
  localparam OPMODE_OR   = 3'b001;
  localparam OPMODE_ADD  = 3'b100; 
  localparam OPMODE_SUB  = 3'b101;

  initial begin
    $timeformat(-9, 1, " ns", 0);
    clk      = 0;
    sin      = 1; // IDLE line state
    rst_n    = 0;
    #5 rst_n = 1; // deassert
  end

  always #2 clk = ~clk;

  reg empty = 1'b0;
  reg [3:0] cnt;
  reg [7:0] ctl_data;

  ///////////// TASK DEFINITION /////////////

  task send_byte; // According to the protocol described in mtm_Alu_test_top.v

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////
  ////  USAGE: 
  ////  send_byte(ctl, data, opmode, crc);
  ////  ctl    - frame type (1 - CTL, 0 - DATA)
  ////  data   - data value to be send in DATA frame. Irrelevant for CTL frame
  ////  opmode - opmode to be sent in CTL frame. Irrelevant for DATA frame
  ////  crc    - crc to be sent in CTL frame. Irrelevant for DATA frame.
  ////
  ////////////////////////////////////////////////////////////////////////////////////////////////////

    input ctl;
    input [7:0] data;
    input [2:0] opmode;
    input [3:0] crc;

    begin

      cnt = 4'b0000;

      if (ctl) begin
        $display ("Sending CTL frame. CRC = %b. OPMODE = %b.", crc, opmode);
      end
      else begin 
        $display ("Sending DATA frame. DATA = %b.", data);
      end

      ctl_data = {empty, opmode, crc};

      while (cnt != 4'b1011) begin
        @(negedge clk) begin //latch values before posedge

          if (cnt == 4'b1011) begin
            cnt <= 4'b0000;
          end
          else begin
            cnt <= cnt + 1;
          end

          if (!cnt) begin
            sin <= 1'b0; // START bit
            $display ("Start bit @%t", $time);
          end
          else if (cnt == 4'b1011) begin
            sin <= 1'b1;
            $display ("Finished transmitting. Going IDLE @%t", $time);
          end
          else if (cnt == 4'b1010) begin
            sin <= 1'b1;
            $display ("Transmitting STOP bit @%t", $time);
          end
          else if (!ctl) begin 
            case (cnt)
              4'b0001: sin <= 1'b0; // leading 0 indicates DATA frame         
              4'b0010: sin <= data[7]; // MSB first
              4'b0011: sin <= data[6];         
              4'b0100: sin <= data[5];         
              4'b0101: sin <= data[4];         
              4'b0110: sin <= data[3];         
              4'b0111: sin <= data[2];         
              4'b1000: sin <= data[1];         
              4'b1001: sin <= data[0];         
              default: sin <= 1'bx; 
            endcase 
          end
          else begin // CTL frame
            case (cnt)
              4'b0001: sin <= 1'b1; // leading 1 indicates CTL frame         
              4'b0010: sin <= ctl_data[7]; // MSB first
              4'b0011: sin <= ctl_data[6];         
              4'b0100: sin <= ctl_data[5];         
              4'b0101: sin <= ctl_data[4];         
              4'b0110: sin <= ctl_data[3];         
              4'b0111: sin <= ctl_data[2];         
              4'b1000: sin <= ctl_data[1];         
              4'b1001: sin <= ctl_data[0];         
              default: sin <= 1'bx; 
            endcase 
          end
        end // @ negedge end
      end // while end
      $display ("Leaving task @%t", $time);
    end // task end
  endtask

  ///////////// END OF TASK DEFINITION /////////////

  initial begin
    #10 send_byte(DATA, 8'h0F, 3'b000, 4'h0); // start with B[31:24]
    send_byte(DATA, 8'hFF, 3'b000, 4'h0);
    send_byte(DATA, 8'hFF, 3'b000, 4'h0);
    send_byte(DATA, 8'hFF, 3'b000, 4'h0);

    send_byte(DATA, 8'h00, 3'b000, 4'h0); // A[31:24]
    send_byte(DATA, 8'h00, 3'b000, 4'h0);
    send_byte(DATA, 8'h55, 3'b000, 4'h0);
    send_byte(DATA, 8'h77, 3'b000, 4'h0);

    send_byte(CTL , 8'h77, OPMODE_OR, 4'h2);
  end
  

endmodule
