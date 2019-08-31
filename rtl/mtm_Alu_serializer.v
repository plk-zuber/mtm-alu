`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH MTM 
// Engineer: Michal Garbacz
// 
// Create Date: 08/24/2019 03:57:54 PM
// Design Name: ALU Serializer 
// Module Name: mtm_Alu_serializer
// Project Name: mtm_Alu
// Target Devices: Custom IC Layout using Cadence Innovus
// Tool Versions: 
// Description: Serializer module. Protocol implemented according to
// the description provided in mtm_Alu_test_top.v
// 
// Revision 0.01 - File Created
// Comments: 1st version using State Machine. Will revise
// after synthesis results.
//////////////////////////////////////////////////////////////////////////////////


module mtm_Alu_serializer(
  input wire        clk,
  input wire        rst,
  input wire        t_valid,
  input wire        carry,
  input wire        overflow,
  input wire        zero,
  input wire        negative,
  input wire [31:0] C
);
  

  localparam WAIT   = 3'b000;
  localparam START  = 3'b001;

  always @(posedge clk) begin
    t_valid_d[0] <= t_valid; // this should be assigned, no need for one CC delay.
  end

  reg [2:0]      state;
  reg [3:0][7:0] C_reg;

  // Assign to a reg vs. D flip-flop?
  // assign t_valid_d[0] = t_valid;

  genvar k;
  generate // valid signal delay line 
    for (k = 0; k < 4; k = k + 1) begin: delay_line
      always @(posedge clk) begin
        t_valid_d[k + 1] <= t_valid_d[k];
      end
    end
  endgenerate

  always @(posedge clk) begin
    case (t_valid_d)
      4'b0001: begin // not everything at once...
	C_reg[0] <= C[7:0];
	CTL_reg  <= {1'b0, carry, overflow, zero, negative};
      end
      4'b0010: begin
	C_reg[1] <= C[15:8];
      end
      4'b0100: begin
	C_reg[2] <= C[23:16];
      end
      4'b1000: begin
	C_reg[3] <= C[31:24];
      end
      default: begin
	C_reg <= 32'h0;
      end
    endcase
  end

  always @(posedge clk) begin
    if (state == IDLE) begin
      if (t_valid_d[0]) begin // only after new valid data arrives. Valid data cannot arrive until all frames has been sent. 
	state    <= START;    // the design won't let new data arrive in meantime. (NEED TO CHECK IN SIMULATION)
	byte_cnt <= 3'b000;
	//data_cnt <= 2'b00; // I think we don't need that. The counter will
	//roll to 4'b0000 by itself.
	sout     <= 1'b0; // transmit start bit
      end
      else if (data_cnt) begin // if data_cnt different than 4'b0000
	state <= START;
	sout  <= 1'b0; // transmit start bit
      end
      else
	state <= IDLE;
	sout  <= 1'b1;
      end
    end

    //////////////////////////////////////////////////////////////

    else if (state == START) begin
      if (data_cnt == 2'b11) begin // STATE LOGIC
	state <= SEND_CTL;
	sout  <= 1'b1;
      end
      else begin
	state <= SEND_DATA;
	sout  <= 1'b0;
      end
    end
    
    //////////////////////////////////////////////////////////////
    
    else if (state == STOP) begin // what about STATE DIAGRAMS ???
      sout     <= 1'b1;
      state    <= IDLE;
      data_cnt <= data_cnt + 1;
    end
    
    //////////////////////////////////////////////////////////////
    
    else if (state == SEND_DATA) begin
      byte_cnt <= byte_cnt + 1;
      case (data_cnt) 
	generate
	  for (k = 0; k < 4; k = k + 1) begin // exactly HOW (in which order) to generate this type of statement?
	    k: begin
	      case (byte_cnt)
		3'b000: sout <= C_reg[k][7]; // MSB first
		3'b001: sout <= C_reg[k][6];
		3'b010: sout <= C_reg[k][5];
		3'b011: sout <= C_reg[k][4];
		3'b100: sout <= C_reg[k][3];
		3'b101: sout <= C_reg[k][2];
		3'b110: sout <= C_reg[k][1];
		3'b111: sout <= C_reg[k][0];
		default: sout <= 1'b1;
	      endcase
	    end
	  end
	endgenerate
        default: sout <= 1'b0;
      endcase

      if (byte_cnt == 3'b111) begin // STATE LOGIC
	state <= STOP;
      end
      else begin
	state <= SEND_DATA;
      end
    end

    //////////////////////////////////////////////////////////////

    else if (state == SEND_CTL) begin // REMEMBER ABOUT STOP BITS AND HOLDING THE LINE IDLE 
    // need to add functioniality (state <= TRANSMIT_STOP) ?
      byte_cnt <= byte_cnt + 1;
      case (byte_cnt)
	3'b000: sout <= CTL_reg[7]; // MSB first
	3'b001: sout <= CTL_reg[6];
	3'b010: sout <= CTL_reg[5];
	3'b011: sout <= CTL_reg[4];
	3'b100: sout <= CTL_reg[3];
	3'b101: sout <= CTL_reg[2];
	3'b110: sout <= CTL_reg[1];
	3'b111: sout <= CTL_reg[0];
	default: sout <= 1'b1;
      endcase
      if (byte_cnt == 3'b111) begin // STATE LOGIC
	state <= STOP;
      end
      else begin
	state <= SEND_CTL;
      end
    end
   
    //////////////////////////////////////////////////////////////
    
    else begin // STATE MACHINE's 'else'
    end

  end // always @posedge 'end'

endmodule
