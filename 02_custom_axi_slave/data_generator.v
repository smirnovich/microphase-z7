`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 23.01.2025 20:47:41
// Design Name:
// Module Name: data_generator
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


module data_generator
  #(
     CLK_FREQ = 100000,
     BRAM_DEPTH = 16384
   )
   (
     input wire clk,
     input wire rst_n,

     input wire [1:0] en,
     input wire [31:0] incr,
     output wire [31:0] addr_bram,
     output wire [31:0] data2bram,
     output reg memen,
     output reg [3:0] web
   );

  localparam COUNTER_LIMIT = 520;
  localparam INCREMENT = 4;
  integer divider_counter;
  reg [31:0] data2write;
  reg addr2write;

  assign data2bram = data2write;
  assign addr_bram = addr2write;
  always@(posedge clk)
  begin
    if (rst_n)
    begin
      addr2write <= 'b0;
      divider_counter <= 'b0;
      data2write <= 'b0;
      web <= 'b0;
    end
    else
    begin
      memen <= en[1];
      if (en[0] == 1'b1)
      begin
        web <= 'b1;
        if (divider_counter == COUNTER_LIMIT)
        begin
          divider_counter <= 0;
          if (addr2write == BRAM_DEPTH/INCREMENT - 1)
            addr2write <= 'b0;
          else
            addr2write <= addr2write + incr;
          data2write <= data2write + 1;
        end
        else
        begin
          divider_counter <= divider_counter + 1;
        end
      end
      else
      begin
        addr2write <= 'b0;
        divider_counter <= 'b0;
        data2write <= 'b0;
        web <= 'b0;
      end
    end
  end
endmodule
