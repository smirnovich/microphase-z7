module data_gen_core(

        input  logic clk,
        input  logic rst_n,
        input  logic startstop,
        input  logic control_mode,
        input logic [7:0] increment_value,
        input logic [15:0] burstlength_value,
        input logic [15:0] burstpause_value,
        // MAXIS
        output logic [31:0] axis_tdata,
        output logic axis_tlast,
        output logic axis_tvalid,
        input  logic axis_tready
    );
    typedef enum {
                ST_SETTINGS,
                ST_STREAM,
                ST_PAUSE
            } t_fsm_st;
    t_fsm_st fsm_ctrl;
    integer incr_counter=0;
    integer stream_counter=0;
    integer pause_counter=0;
    integer burst_length;
    logic stream_done_flag=0;

    assign burst_length = burstlength_value > 2 ? burstlength_value : 2;
    assign axis_tdata = incr_counter;
    always@(posedge clk)
    begin
        if(rst_n == 0)
        begin
            stream_done_flag <= 0;
            incr_counter <= 0;
            axis_tvalid <= 0;
            axis_tlast  <= 0;
            pause_counter <= 0;
            fsm_ctrl <= ST_SETTINGS;
        end
        else
        begin

            case (fsm_ctrl)
                ST_SETTINGS:
                begin
                    if (startstop == 1'b1)
                        fsm_ctrl <= ST_STREAM;
                    else
                        incr_counter <= 0;
                end
                ST_STREAM:
                begin
                    if (startstop == 1'b1) begin
                            if (stream_counter > burst_length-1)
                            begin
                                stream_counter <= 0;
                               // incr_counter <= 0;
                                axis_tvalid <= 0;
                                axis_tlast  <= 1'b0;
                                fsm_ctrl <= ST_PAUSE;
                            end
                        else
                            begin
                                incr_counter <= incr_counter + increment_value;
                                axis_tvalid <= 1;
                                if (axis_tready == 1'b1) begin 
                                    stream_counter <= stream_counter + 1;
                                    
                                end
                            end
                        if (stream_counter == burst_length-1)
                            axis_tlast  <= 1'b1;
                        else
                            axis_tlast  <= 1'b0;
                    end else begin 
                        axis_tvalid <= 0;
                        fsm_ctrl <= ST_SETTINGS;
                    end
                end
                ST_PAUSE:
                begin
                    if (startstop == 1'b1) begin 
                       if (pause_counter > 1000000) begin 
                        fsm_ctrl <= ST_STREAM;
                        pause_counter <= 0;
                       end 
                        else pause_counter <= pause_counter + 1;
                    end
                    else 
                        fsm_ctrl <= ST_SETTINGS;
                end
                default:
                    fsm_ctrl <= ST_SETTINGS;
            endcase
        end
    end
endmodule
