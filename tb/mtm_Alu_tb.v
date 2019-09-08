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


`define RESPONSE_DELAY 300

module mtm_Alu_tb (
  output reg clk,
  output reg rst_n,
  output reg sin,
  input wire sout
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

  //The TB must include:
  //- task send_byte to send a CMD or CTL command to the ALU

  ///////////// START OF TASK DEFINITION /////////////

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
            $display ("Transmitting START bit @%t", $time);
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
      $display ("Leaving task send_byte @%t", $time);
    end // task end
  endtask

  ///////////// END OF send_byte TASK DEFINITION /////////////

  //The TB must include:
  //- task send_calculation_data that will send 9 bytes to the ALU for given
  //  operands and operation

  ///////////// START OF TASK DEFINITION /////////////

  task send_calculation_data; // According to the protocol described in mtm_Alu_test_top.v
  // this task calls the above send_byte tasks

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////
  ////  USAGE: 
  ////  send_byte(A, B, opmode);
  ////  A, B   - two 32-bit operands
  ////  opmode - type of operation to be done
  ////
  ////////////////////////////////////////////////////////////////////////////////////////////////////

    input [31:0] A;
    input [31:0] B;
    input [2:0] opmode;

    begin

      cnt = 4'b0000;

      $display ("Sending calculation data.");
      $display ("A = %b", A);
      $display ("B = %b", B);

      case (opmode)
        3'b000: $display("The requested operation is: AND");
        3'b001: $display("The requested operation is: OR");
        3'b100: $display("The requested operation is: ADD");
        3'b101: $display("The requested operation is: SUB");
        default: $display("Wrong opmode");
      endcase

      send_byte(DATA, B[31:24], 3'b000, 4'h0); // start with B[31:24]
      send_byte(DATA, B[23:16], 3'b000, 4'h0);
      send_byte(DATA, B[15:8],  3'b000, 4'h0);
      send_byte(DATA, B[7:0],   3'b000, 4'h0);

      send_byte(DATA, A[31:24], 3'b000, 4'h0); // start with A[31:24]
      send_byte(DATA, A[23:16], 3'b000, 4'h0);
      send_byte(DATA, A[15:8],  3'b000, 4'h0);
      send_byte(DATA, A[7:0],   3'b000, 4'h0);

      send_byte(CTL , 8'h00, opmode, 4'h2);

      $display ("Leaving task send_calculation_data @%t", $time);
    end // task end
  endtask

  ///////////// END OF send_calculation_data TASK DEFINITION /////////////

  //The TB must include:
  //- procedural block for capturing the input data from the ALU


  reg [31:0] C_rx;
  reg [7:0]  CTL_rx;

  reg [1:0] frame;

  reg [2:0] i;

  reg [4:0] bit_nr;

  reg [15:0] result_cnt;

  initial begin
    frame      = 2'b11;
    result_cnt = 16'h0000;
    i          = 3'b000;
  end

  always begin // PROCEDURAL BLOCK TO READ DATA
    @(negedge clk) begin // negedge -> this is how it works in Verilog. Posedge wouldn't get the updated data.
      if (!sout) begin // START BIT
        $display("START bit received @ %t", $time);
        @(negedge clk) begin
          if (!sout) begin // DATA FRAME
            $display("DATA frame received @ %t", $time);
            //@(negedge clk);
            frame = frame + 1;
            //for (i = 0; i < 8; i = i + 1) begin 
            repeat(8) begin
              bit_nr = frame * 8 + i;
              @(negedge clk) C_rx[31 - bit_nr] = sout;
              $display("Bit nr. %d value is %b, @ time %t", bit_nr, sout, $time);
              i = i + 1;
            end
            @(negedge clk) $display("STOP BIT"); // STOP BIT
          end
          else begin // Line high -> CTL FRAME
            $display ("Receiving CTL FRAME");
            repeat(8) begin
              @(negedge clk) CTL_rx[7 - i] = sout;
              $display("CTL Bit nr. %d value is %b, @ time %t", i, sout, $time);
              i = i + 1;
            end
            @(negedge clk) $display("STOP BIT"); // STOP BIT
            $display("Received result nr %d : %b", result_cnt, C_rx);
            $display("Received CTL: %b", CTL_rx);
            result_cnt = result_cnt + 1;
          end
        end
      end
    end
  end
            
  reg [2:0] OPMODE_in;
  reg [31:0] A_in;
  reg [31:0] B_in;

  reg [15:0] k;

  initial begin
    k = 0; // start from zero
    repeat(250) begin

      if (!(k % 4)) begin
        A_in      = $random;
        B_in      = $random;
      end

      case (k % 4)
        0: OPMODE_in = OPMODE_ADD;
        1: OPMODE_in = OPMODE_SUB;
        2: OPMODE_in = OPMODE_AND;
        3: OPMODE_in = OPMODE_OR;
        default: OPMODE_in = OPMODE_ADD;
      endcase

      send_calculation_data(A_in, B_in, OPMODE_in);

      #`RESPONSE_DELAY
      $display("Checking result...@ %t", $time);

      case (OPMODE_in)
        OPMODE_AND: begin 
          if (C_rx == (A_in & B_in)) begin
            $display("Test nr. %d PASSED", k);
          end 
          else begin
            $display("Test FAILED");
            $finish;
          end
        end
        OPMODE_OR: begin 
          if (C_rx == (A_in | B_in)) begin
            $display("Test nr. %d PASSED", k);
          end 
          else begin
            $display("Test FAILED");
            $finish;
          end
        end
        OPMODE_ADD: begin 
          if (C_rx == A_in + B_in) begin
            $display("Test nr. %d PASSED", k);
          end 
          else begin
            $display("Test FAILED");
            $finish;
          end
        end
        OPMODE_SUB: begin 
          if (C_rx == A_in - B_in) begin
            $display("Test nr. %d PASSED", k);
          end 
          else begin
            $display("Test FAILED");
            $finish;
          end
        end
        default: $display("Wrong opmode");
      endcase

      k = k + 1;

    end // end repeat

  end
  

endmodule
