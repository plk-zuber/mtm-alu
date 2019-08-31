`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH MTM 
// Engineer: Michal Garbacz
// 
// Create Date: 08/24/2019 03:58:14 PM
// Design Name: 
// Module Name: mtm_Alu_deserializer
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

// STATE CODES - Gray

`undef  USE_TRANSMITTER
`define WIDE

module mtm_Alu_deserializer(
  input wire       clk,
  input wire       rst,
  input wire       din,
`ifdef WIDE
  output reg [31:0] A_out,
  output reg [31:0] B_out,
`else
  output reg [7:0]  A_out,
  output reg [7:0]  B_out,
`endif
  output reg [2:0]  OP_out, 
  output reg        t_valid
);
  localparam IDLE     = 3'b000;
  localparam START    = 3'b001;
  localparam DATA     = 3'b011;
  localparam CMD      = 3'b010;
  localparam CMD_READ = 3'b110;
  localparam ERR      = 3'b111;
  localparam STOP     = 3'b101;
  //localparam          = 3'b100;

  localparam T_START      = 3'b000;
  localparam T_WAIT       = 3'b001;
  localparam T_CHECK_ERR  = 3'b011;
  localparam T_SEND_ERR   = 3'b010;
  //localparam CMD_READ     = 3'b110;
  //localparam ERR          = 3'b111;
  //localparam STOP         = 3'b101;
  localparam T_END        = 3'b100;

  reg [7:0] data;
  reg [2:0] state;
  reg [3:0] crc;
  reg [2:0] opmode;
  reg [2:0] byte_cnt;
  reg [2:0] data_cnt;
  reg latch_flag;
  reg latch_cmd;
  reg new_data;
  reg data_err;

  reg [7:0] B_3_pre; 
  reg [7:0] B_2_pre; 
  reg [7:0] B_1_pre; 
  reg [7:0] B_0_pre; 
  reg [7:0] A_3_pre; 
  reg [7:0] A_2_pre; 
  reg [7:0] A_1_pre; 
  reg [7:0] A_0_pre; 
  reg [2:0] OPMODE_pre;
  reg [3:0] CRC_pre;

  reg  crc_correct;
  wire data_correct;
  wire opmode_correct;

  reg err_flag_crc;
  reg err_flag_data;
  reg err_flag_op;

  reg       t_err;
  reg [1:0] t_frame_cnt;
  reg [2:0] transmit_state;

  wire       ctl_parity;
  wire [7:0] ctl_frame;

  reg  [3:0]  crc_calc = 4'h2; // simulation only
  wire [3:0]  c;
  wire [35:0] d;


  always @(posedge clk) begin
    if (!rst) begin
      state    <= IDLE;
      data_err  <= 1'b0;
      data     <= 8'b0;
      byte_cnt <= 3'b0;
      data_cnt <= 3'b0;
      new_data <= 1'b0;
      crc_calc <= 4'b0010;
      OP_out   <= 3'b000;
    end
    else begin

      if (state == IDLE) begin
        //data_err   <= 1'b0; // do NOT clear right after IDLE state. Clear only after ERR flag is sent.

        if (t_err) begin
          data_err <= 1'b0; // now safely clear the err flag
        end

        latch_flag <= 1'b0;
        if (din)
          state <= IDLE;
        else
          state <= START;
      end

      else if (state == START) begin
        if (din)
          state    <= CMD;
        else begin
          state    <= DATA;
          new_data <= 1'b1;
          byte_cnt <= 1'b0;
          if (new_data)
            data_cnt <= data_cnt + 1;
          else
            data_cnt <= 3'b0;
        end
      end

      else if (state == DATA) begin
        case (byte_cnt)
          3'b000: data[7] <= din; // MSB first
          3'b001: data[6] <= din;
          3'b010: data[5] <= din;
          3'b011: data[4] <= din;
          3'b100: data[3] <= din;
          3'b101: data[2] <= din;
          3'b110: data[1] <= din;
          3'b111: data[0] <= din;
          default: data <= 7'b0; 
        endcase
        byte_cnt <= byte_cnt + 1;
        if (byte_cnt == 3'b111)
          state <= STOP;
        else
          state <= DATA;
      end
     
      else if (state == CMD) begin
        if (data_cnt == 3'b111) begin
          if (!din) begin
            state    <= CMD_READ;
            byte_cnt <= 3'b001; // start from 1 instead of 0, because 7 bits only.
          end
          else
            data_err <= 1'b1; // wrong CTL frame format - needs to start with 0
        end
        else 
          data_err <= 1'b1; // received CTL frame but not enough DATA frames 
      end

      else if (state == CMD_READ) begin
        case (byte_cnt)
          3'b001: opmode[2] <= din;
          3'b010: opmode[1] <= din;
          3'b011: opmode[0] <= din;
          3'b100: crc[3]    <= din;
          3'b101: crc[2]    <= din;
          3'b110: crc[1]    <= din;
          3'b111: crc[0]    <= din;
          default: data <= 7'b0; 
        endcase
        byte_cnt <= byte_cnt + 1;
        if (byte_cnt == 3'b111) begin
          state <= STOP;
          latch_cmd <= 1'b1;
        end
        else begin
          state <= CMD_READ;
          latch_cmd <= 1'b0;
        end
      end

      else if (state == STOP) begin
        if (din) begin // high state ends the frame, latch the received byte
          latch_cmd <= 1'b0;
          latch_flag <= 1'b1;
          state      <= IDLE;
        end
        else begin 
          latch_flag <= 1'b0;
          data_err   <= 1'b1;
        end
      end

      //else if (state == ERR) begin
      //  data_err <= 1'b1;
      //  state    <= IDLE;
      //end
      else 
        state <= IDLE;

    end // else end

  end // always @ end

  assign data_correct = ~data_err;

  /*always @* begin // asynchronous opmode error detection
    if (OPMODE_pre != 3'b000 || OPMODE_pre != 3'b001 || OPMODE_pre != 3'b100 || OPMODE_pre != 3'b101)
      opmode_correct = 0;
    else
      opmode_correct = 1;
   end*/
  
  assign opmode_correct = (OPMODE_pre == 3'b000 || OPMODE_pre == 3'b001 || OPMODE_pre == 3'b100 || OPMODE_pre == 3'b101);

  always @(posedge clk) begin
    if (latch_flag) begin // latch every byte  
      case (data_cnt)
        3'b000: B_3_pre <= data; 
        3'b001: B_2_pre <= data; 
        3'b010: B_1_pre <= data; 
        3'b011: B_0_pre <= data; 
        3'b100: A_3_pre <= data; 
        3'b101: A_2_pre <= data; 
        3'b110: A_1_pre <= data; 
        3'b111: A_0_pre <= data; 
      endcase
    end

    if (latch_cmd) begin
      // CRC and opmode Check here 
      OPMODE_pre <= opmode;
      CRC_pre    <= crc;
    end

  end

  /*always @(posedge clk) begin
    if (latch_cmd && !(latch_cmd_d1)) begin // rising edge of latch_cmd
      if (crc_correct && opmode_correct && data_correct) begin
        // start transmitting data
        start_transmit <= 1'b1;
      end
      else begin // transmit error flag
        if (!crc_correct)
          err_flag_crc  <= ERR_CRC;
        else if (!opmode_correct)
          err_flag_op   <= ERR_OP;
        else if (!data_correct)
          err_flag_data <= ERR_DATA;
        else begin
          err_flag_crc  <= 1'b0; // number of ones in {1'b1, ERR_FLAGS, PARIT} should be even
          err_flag_op   <= 1'b0; // number of ones in {1'b1, ERR_FLAGS, PARIT} should be even
          err_flag_data <= 1'b0; // number of ones in {1'b1, ERR_FLAGS, PARIT} should be even
        end
      end
    end
    else if (stop_transmit) begin
       start_transmit <= 1'b0;
    end
  end*/
    
 // TRANSMIT DATA OUT STATE MACHINE
 // WARNING : The code below splits 32 bit outputs into four clock cycles.
 // This was thought to be necessary for the ALU to work. However it seems that 32-bit output works fine.
`ifdef USE_TRANSMITTER 
  always @(posedge clk) begin
    if (transmit_state == T_WAIT) begin
      if (latch_cmd)
        transmit_state <= T_CHECK_ERR;
      else 
        transmit_state <= T_WAIT;
    end

    else if (transmit_state == T_CHECK_ERR) begin
      if (crc_correct && opmode_correct && data_correct) begin
        // start transmitting data
        transmit_state <= T_START;
        t_frame_cnt    <= 3'b0;
      end
      else begin // transmit error flag
        transmit_state <= T_SEND_ERR; 
        if (!crc_correct)
          err_flag_crc  <= 1'b1;
        else
          err_flag_crc  <= 1'b0;

        if (!opmode_correct)
          err_flag_op   <= 1'b1;
        else
          err_flag_op   <= 1'b0;

        if (!data_correct)
          err_flag_data <= 1'b1;
        else
          err_flag_data <= 1'b0;
      end
    end
    
    else if (transmit_state == T_START) begin
      t_valid     <= 1'b1;
      t_err       <= 1'b0;
      t_frame_cnt <= t_frame_cnt + 1;

      if(t_frame_cnt == 3'b011)
        transmit_state <= T_END;

      case (t_frame_cnt)
        3'b000: begin 
          OP_out <= OPMODE_pre; 
          A_out  <= A_0_pre;  
          B_out  <= B_0_pre; 
        end
        3'b001: begin 
          A_out  <= A_1_pre;  
          B_out  <= B_1_pre; 
        end
        3'b010: begin 
          A_out  <= A_2_pre;  
          B_out  <= B_2_pre; 
        end
        3'b011: begin 
          A_out  <= A_3_pre;  
          B_out  <= B_3_pre; 
        end
        default: begin
          A_out  <= 8'b0;
          B_out  <= 8'b0;
          OP_out <= 3'b0;
        end
      endcase
    end 

    else if (transmit_state == T_END) begin
      t_valid <= 1'b0;
      state   <= T_WAIT;
    end

    else if (transmit_state == T_SEND_ERR) begin
      t_err <= 1'b1;
      A_out <= ctl_frame; // use A output for ctl frame... (resources)

      if (t_err)
        state <= T_WAIT;
    end

    else begin
      transmit_state <= T_WAIT;
    end

  end
     
`else 
  always @(posedge clk) begin
    if (transmit_state == T_WAIT) begin
      if (latch_cmd)
        transmit_state <= T_CHECK_ERR;
      else 
        transmit_state <= T_WAIT;
    end

    else if (transmit_state == T_CHECK_ERR) begin
      if (crc_correct && opmode_correct && data_correct) begin
        // start transmitting data
        transmit_state <= T_START;
        t_frame_cnt    <= 3'b0;
      end
      else begin // transmit error flag
        transmit_state <= T_SEND_ERR; 
        if (!crc_correct)
          err_flag_crc  <= 1'b1;
        else
          err_flag_crc  <= 1'b0;

        if (!opmode_correct)
          err_flag_op   <= 1'b1;
        else
          err_flag_op   <= 1'b0;

        if (!data_correct)
          err_flag_data <= 1'b1;
        else
          err_flag_data <= 1'b0;
      end
    end
    
    else if (transmit_state == T_START) begin
      t_valid     <= 1'b1;
      t_err       <= 1'b0;

      OP_out <= OPMODE_pre; 
      A_out  <= {A_3_pre, A_2_pre, A_1_pre, A_0_pre};
      B_out  <= {B_3_pre, B_2_pre, B_1_pre, B_0_pre};

      if(t_valid)
        transmit_state <= T_END;
    end 

    else if (transmit_state == T_END) begin
      t_valid <= 1'b0;
      state   <= T_WAIT;
    end

    else if (transmit_state == T_SEND_ERR) begin
      t_err <= 1'b1;
      A_out <= ctl_frame; // use A output for ctl frame... (resources, no need for another output)

      if (t_err)
        state <= T_WAIT;
    end

    else begin
      transmit_state <= T_WAIT;
    end

  end
`endif

    assign ctl_parity = ^ctl_frame;
    //assign ctl_frame  = {err_flag_crc, err_flag_op, err_flag_data, ctl_parity};
    assign ctl_frame[7]   = 1'b1;
    assign ctl_frame[6:5] = {2{err_flag_crc}};
    assign ctl_frame[4:3] = {2{err_flag_op}};
    assign ctl_frame[2:1] = {2{err_flag_data}};
    assign ctl_frame[0]   = ctl_parity;

    assign d[35:20] = {B_0_pre, B_1_pre};
    assign d[19:4]  = {A_0_pre, A_1_pre};
    assign d[3:0]   = OPMODE_pre;

    assign c = crc_calc;

    // Chosen CRC polynomial : x4 + x + 1. Hamming Distance = 3
    // XOR Expression generated using python script

    always @* begin
      /*if (rst) begin
        crc_calc[0] = d[34]^d[33]^d[30]^d[26]^d[25]^d[24]^d[23]^d[21]^d[19]^d[18]^d[15]^d[11]^d[10]^d[9]^d[8]^d[6]^d[4]^d[3]^d[0]^c[1]^c[2];
        crc_calc[1] = d[35]^d[33]^d[31]^d[30]^d[27]^d[23]^d[22]^d[21]^d[20]^d[18]^d[16]^d[15]^d[12]^d[8]^d[7]^d[6]^d[5]^d[3]^d[1]^d[0]^c[1]^c[3];
        crc_calc[2] = d[34]^d[32]^d[31]^d[28]^d[24]^d[23]^d[22]^d[21]^d[19]^d[17]^d[16]^d[13]^d[9]^d[8]^d[7]^d[6]^d[4]^d[2]^d[1]^c[0]^c[2];
        crc_calc[3] = d[35]^d[33]^d[32]^d[29]^d[25]^d[24]^d[23]^d[22]^d[20]^d[18]^d[17]^d[14]^d[10]^d[9]^d[8]^d[7]^d[5]^d[3]^d[2]^c[0]^c[1]^c[3];
      end
      else crc_calc = 4'b0;*/
      crc_correct = (CRC_pre == crc_calc);
    end


endmodule
