`timescale 1ns / 1ps

module data_generator
#(
    COUNTER_LIMIT = 520
)
(
        input wire clk,
        input wire rst_n,
        
        input wire [1:0] en,
        input wire [31:0] incr, 
        output reg led,
        output wire [31:0] axi_tdata,
        output wire axi_tlast,
        output wire axi_tvalid,
        input wire axi_tready
    );
    
    localparam INCREMENT = 4;
    integer divider_counter;
    integer microstream_counter;
    reg [31:0] data2write;
    reg [31:0] addr2write;
    reg tvalid;
    reg led_reg;
    reg axi_tlast_reg;
    assign axi_tdata = data2write;
    assign axi_tvalid = tvalid;
    assign axi_tlast = (led==1'b0) && (tvalid == 1'b1);//axi_tlast_reg;
    always@(posedge clk) begin
        if (!rst_n) 
        begin
            addr2write <= 'b0;
            divider_counter <= 'b0;
            microstream_counter <= 0;
            data2write <= 'b0;
            led <= 'b0;
        end
        else begin
            tvalid <= led;
        if (en[0] == 1'b1) begin
            if (divider_counter == COUNTER_LIMIT) begin
                led <= en[1];
                if (microstream_counter == 16) begin
                    microstream_counter <= 0;
                    divider_counter <= 0;
                end else begin
                    microstream_counter <= microstream_counter  + 1;
                end
                data2write <= data2write + incr;
            end
            else
                begin
                    led <= 1'b0;
                    divider_counter <= divider_counter + 1;
                end
            end
        else begin
            addr2write <= 'b0;
            divider_counter <= 'b0;
            data2write <= 'b0;
        end 
        end
    end
endmodule
