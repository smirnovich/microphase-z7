module data_gen
    #(
        
    parameter ADDR_W = 16,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
    )
     (
         input clk,
         input rst_n,
         output start_stop,
         // AXI
         input  wire [ADDR_W-1:0] axil_awaddr,
         input  wire [2:0]        axil_awprot,
         input  wire              axil_awvalid,
         output wire              axil_awready,
         input  wire [DATA_W-1:0] axil_wdata,
         input  wire [STRB_W-1:0] axil_wstrb,
         input  wire              axil_wvalid,
         output wire              axil_wready,
         output wire [1:0]        axil_bresp,
         output wire              axil_bvalid,
         input  wire              axil_bready,

         input  wire [ADDR_W-1:0] axil_araddr,
         input  wire [2:0]        axil_arprot,
         input  wire              axil_arvalid,
         output wire              axil_arready,
         output wire [DATA_W-1:0] axil_rdata,
         output wire [1:0]        axil_rresp,
         output wire              axil_rvalid,
         input  wire              axil_rready,
         // MAXIS
         output wire     [31:0] axis_tdata,
         output wire            axis_tlast,
         output wire            axis_tvalid,
         input  wire            axis_tready
     );

  //reg clk;
  //reg rst;
  wire csr_control_startstop_out;
  wire csr_control_mode_en;
  wire csr_control_mode_in;
  wire csr_control_mode_out;
  wire csr_control_ignoreready_out;
  wire [7:0] csr_increment_value_out;
  wire [15:0] csr_burstlength_value_out;
  wire [15:0] csr_burstpause_value_out;
  //reg [ADDR_W-1:0] axil_awaddr;
  //reg [2:0] axil_awprot;
  //reg axil_awvalid;
  //reg axil_awready;
  //reg [DATA_W-1:0] axil_wdata;
  //reg [STRB_W-1:0] axil_wstrb;
  //reg axil_wvalid;
  //reg axil_wready;
  //reg [1:0] axil_bresp;
  //reg axil_bvalid;
  //reg axil_bready;
  //reg [ADDR_W-1:0] axil_araddr;
  //reg [2:0] axil_arprot;
  //reg axil_arvalid;
  //reg axil_arready;
  //reg [DATA_W-1:0] axil_rdata;
  //reg [1:0] axil_rresp;
  //reg axil_rvalid;
  //reg axil_rready;


    assign start_stop = csr_control_startstop_out;
    regs regs_inst (
             .clk(clk),
             .rst(~rst_n),
             .csr_control_startstop_out(csr_control_startstop_out),
             .csr_control_mode_en(csr_control_mode_en),
             .csr_control_mode_in(csr_control_mode_in),
             .csr_control_mode_out(csr_control_mode_out),
             .csr_control_ignoreready_out(csr_control_ignoreready_out),
             .csr_increment_value_out(csr_increment_value_out),
             .axil_awaddr(axil_awaddr),
             .axil_awprot(axil_awprot),
             .axil_awvalid(axil_awvalid),
             .axil_awready(axil_awready),
             .axil_wdata(axil_wdata),
             .axil_wstrb(axil_wstrb),
             .axil_wvalid(axil_wvalid),
             .axil_wready(axil_wready),
             .axil_bresp(axil_bresp),
             .axil_bvalid(axil_bvalid),
             .axil_bready(axil_bready),
             .axil_araddr(axil_araddr),
             .axil_arprot(axil_arprot),
             .axil_arvalid(axil_arvalid),
             .axil_arready(axil_arready),
             .axil_rdata(axil_rdata),
             .axil_rresp(axil_rresp),
             .axil_rvalid(axil_rvalid),
             .axil_rready(axil_rready)
         );

    data_gen_core data_gen_core_inst(
                      .clk(clk),
                      .rst_n(rst_n),
                      .startstop(csr_control_startstop_out),
                    //  .csr_control_mode_en(csr_control_mode_en),
                  //    .csr_control_mode_in(csr_control_mode_in),
                      .control_mode(csr_control_mode_out),
                      .increment_value(csr_increment_value_out),

                      .axis_tdata(axis_tdata),
                      .axis_tlast(axis_tlast),
                      .axis_tvalid(axis_tvalid),
                      .axis_tready(axis_tready)
                  );

endmodule
