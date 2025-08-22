// Created with Corsair v1.0.4

module regs #(
    parameter ADDR_W = 16,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    // System
    input clk,
    input rst,
    // Control.StartStop
    output  csr_control_startstop_out,
    // Control.Mode
    input csr_control_mode_en,
    input  csr_control_mode_in,
    output  csr_control_mode_out,
    // Control.IgnoreReady
    output  csr_control_ignoreready_out,

    // Increment.Value
    output [7:0] csr_increment_value_out,

    // BurstLength.Value
    output [15:0] csr_burstlength_value_out,

    // BurstPause.Value
    output [15:0] csr_burstpause_value_out,

    // AXI
    input  [ADDR_W-1:0] axil_awaddr,
    input  [2:0]        axil_awprot,
    input               axil_awvalid,
    output              axil_awready,
    input  [DATA_W-1:0] axil_wdata,
    input  [STRB_W-1:0] axil_wstrb,
    input               axil_wvalid,
    output              axil_wready,
    output [1:0]        axil_bresp,
    output              axil_bvalid,
    input               axil_bready,

    input  [ADDR_W-1:0] axil_araddr,
    input  [2:0]        axil_arprot,
    input               axil_arvalid,
    output              axil_arready,
    output [DATA_W-1:0] axil_rdata,
    output [1:0]        axil_rresp,
    output              axil_rvalid,
    input               axil_rready
);
wire              wready;
wire [ADDR_W-1:0] waddr;
wire [DATA_W-1:0] wdata;
wire              wen;
wire [STRB_W-1:0] wstrb;
wire [DATA_W-1:0] rdata;
wire              rvalid;
wire [ADDR_W-1:0] raddr;
wire              ren;
    reg [ADDR_W-1:0] waddr_int;
    reg [ADDR_W-1:0] raddr_int;
    reg [DATA_W-1:0] wdata_int;
    reg [STRB_W-1:0] strb_int;
    reg              awflag;
    reg              wflag;
    reg              arflag;
    reg              rflag;

    reg              axil_bvalid_int;
    reg [DATA_W-1:0] axil_rdata_int;
    reg              axil_rvalid_int;

    assign axil_awready = ~awflag;
    assign axil_wready  = ~wflag;
    assign axil_bvalid  = axil_bvalid_int;
    assign waddr        = waddr_int;
    assign wdata        = wdata_int;
    assign wstrb        = strb_int;
    assign wen          = awflag && wflag;
    assign axil_bresp   = 'd0; // always okay

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            waddr_int       <= 'd0;
            wdata_int       <= 'd0;
            strb_int        <= 'd0;
            awflag          <= 1'b0;
            wflag           <= 1'b0;
            axil_bvalid_int <= 1'b0;
        end else begin
            if (axil_awvalid == 1'b1 && awflag == 1'b0) begin
                awflag    <= 1'b1;
                waddr_int <= axil_awaddr;
            end else if (wen == 1'b1 && wready == 1'b1) begin
                awflag    <= 1'b0;
            end

            if (axil_wvalid == 1'b1 && wflag == 1'b0) begin
                wflag     <= 1'b1;
                wdata_int <= axil_wdata;
                strb_int  <= axil_wstrb;
            end else if (wen == 1'b1 && wready == 1'b1) begin
                wflag     <= 1'b0;
            end

            if (axil_bvalid_int == 1'b1 && axil_bready == 1'b1) begin
                axil_bvalid_int <= 1'b0;
            end else if ((axil_wvalid == 1'b1 && awflag == 1'b1) || (axil_awvalid == 1'b1 && wflag == 1'b1) || (wflag == 1'b1 && awflag == 1'b1)) begin
                axil_bvalid_int <= wready;
            end
        end
    end

    assign axil_arready = ~arflag;
    assign axil_rdata   = axil_rdata_int;
    assign axil_rvalid  = axil_rvalid_int;
    assign raddr        = raddr_int;
    assign ren          = arflag && ~rflag;
    assign axil_rresp   = 'd0; // always okay

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            raddr_int       <= 'd0;
            arflag          <= 1'b0;
            rflag           <= 1'b0;
            axil_rdata_int  <= 'd0;
            axil_rvalid_int <= 1'b0;
        end else begin
            if (axil_arvalid == 1'b1 && arflag == 1'b0) begin
                arflag    <= 1'b1;
                raddr_int <= axil_araddr;
            end else if (axil_rvalid_int == 1'b1 && axil_rready == 1'b1) begin
                arflag    <= 1'b0;
            end

            if (rvalid == 1'b1 && ren == 1'b1 && rflag == 1'b0) begin
                rflag <= 1'b1;
            end else if (axil_rvalid_int == 1'b1 && axil_rready == 1'b1) begin
                rflag <= 1'b0;
            end

            if (rvalid == 1'b1 && axil_rvalid_int == 1'b0) begin
                axil_rdata_int  <= rdata;
                axil_rvalid_int <= 1'b1;
            end else if (axil_rvalid_int == 1'b1 && axil_rready == 1'b1) begin
                axil_rvalid_int <= 1'b0;
            end
        end
    end

//------------------------------------------------------------------------------
// CSR:
// [0x0] - Control - Control register
//------------------------------------------------------------------------------
wire [31:0] csr_control_rdata;
assign csr_control_rdata[31:3] = 29'h0;

wire csr_control_wen;
assign csr_control_wen = wen && (waddr == 16'h0);

wire csr_control_ren;
assign csr_control_ren = ren && (raddr == 16'h0);
reg csr_control_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_control_ren_ff <= 1'b0;
    end else begin
        csr_control_ren_ff <= csr_control_ren;
    end
end
//---------------------
// Bit field:
// Control[0] - StartStop - Run the generator
// access: rw, hardware: o
//---------------------
reg  csr_control_startstop_ff;

assign csr_control_rdata[0] = csr_control_startstop_ff;

assign csr_control_startstop_out = csr_control_startstop_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_control_startstop_ff <= 1'b0;
    end else  begin
     if (csr_control_wen) begin
            if (wstrb[0]) begin
                csr_control_startstop_ff <= wdata[0];
            end
        end else begin
            csr_control_startstop_ff <= csr_control_startstop_ff;
        end
    end
end


//---------------------
// Bit field:
// Control[1] - Mode - Mode (0 - one burst, 1 - bursting until stop)
// access: rw, hardware: oie
//---------------------
reg  csr_control_mode_ff;

assign csr_control_rdata[1] = csr_control_mode_ff;

assign csr_control_mode_out = csr_control_mode_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_control_mode_ff <= 1'b0;
    end else  begin
     if (csr_control_wen) begin
            if (wstrb[0]) begin
                csr_control_mode_ff <= wdata[1];
            end
        end else if (csr_control_mode_en) begin
            csr_control_mode_ff <= csr_control_mode_in;
        end
    end
end


//---------------------
// Bit field:
// Control[2] - IgnoreReady - Ignore tready (0 - do not ignore (stream only when tready 1), 1 - ignore tready)
// access: rw, hardware: o
//---------------------
reg  csr_control_ignoreready_ff;

assign csr_control_rdata[2] = csr_control_ignoreready_ff;

assign csr_control_ignoreready_out = csr_control_ignoreready_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_control_ignoreready_ff <= 1'b0;
    end else  begin
     if (csr_control_wen) begin
            if (wstrb[0]) begin
                csr_control_ignoreready_ff <= wdata[2];
            end
        end else begin
            csr_control_ignoreready_ff <= csr_control_ignoreready_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x4] - Increment - Increment value for counter data
//------------------------------------------------------------------------------
wire [31:0] csr_increment_rdata;
assign csr_increment_rdata[31:8] = 24'h0;

wire csr_increment_wen;
assign csr_increment_wen = wen && (waddr == 16'h4);

wire csr_increment_ren;
assign csr_increment_ren = ren && (raddr == 16'h4);
reg csr_increment_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_increment_ren_ff <= 1'b0;
    end else begin
        csr_increment_ren_ff <= csr_increment_ren;
    end
end
//---------------------
// Bit field:
// Increment[7:0] - Value - Increment value for counter data
// access: rw, hardware: o
//---------------------
reg [7:0] csr_increment_value_ff;

assign csr_increment_rdata[7:0] = csr_increment_value_ff;

assign csr_increment_value_out = csr_increment_value_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_increment_value_ff <= 8'h1;
    end else  begin
     if (csr_increment_wen) begin
            if (wstrb[0]) begin
                csr_increment_value_ff[7:0] <= wdata[7:0];
            end
        end else begin
            csr_increment_value_ff <= csr_increment_value_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x8] - BurstLength - Length of one burst
//------------------------------------------------------------------------------
wire [31:0] csr_burstlength_rdata;
assign csr_burstlength_rdata[31:16] = 16'h0;

wire csr_burstlength_wen;
assign csr_burstlength_wen = wen && (waddr == 16'h8);

wire csr_burstlength_ren;
assign csr_burstlength_ren = ren && (raddr == 16'h8);
reg csr_burstlength_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_burstlength_ren_ff <= 1'b0;
    end else begin
        csr_burstlength_ren_ff <= csr_burstlength_ren;
    end
end
//---------------------
// Bit field:
// BurstLength[15:0] - Value - Increment value for counter data
// access: rw, hardware: o
//---------------------
reg [15:0] csr_burstlength_value_ff;

assign csr_burstlength_rdata[15:0] = csr_burstlength_value_ff;

assign csr_burstlength_value_out = csr_burstlength_value_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_burstlength_value_ff <= 16'h1;
    end else  begin
     if (csr_burstlength_wen) begin
            if (wstrb[0]) begin
                csr_burstlength_value_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_burstlength_value_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_burstlength_value_ff <= csr_burstlength_value_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xc] - BurstPause - Length of one burst
//------------------------------------------------------------------------------
wire [31:0] csr_burstpause_rdata;
assign csr_burstpause_rdata[31:16] = 16'h0;

wire csr_burstpause_wen;
assign csr_burstpause_wen = wen && (waddr == 16'hc);

wire csr_burstpause_ren;
assign csr_burstpause_ren = ren && (raddr == 16'hc);
reg csr_burstpause_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_burstpause_ren_ff <= 1'b0;
    end else begin
        csr_burstpause_ren_ff <= csr_burstpause_ren;
    end
end
//---------------------
// Bit field:
// BurstPause[15:0] - Value - Increment value for counter data
// access: rw, hardware: o
//---------------------
reg [15:0] csr_burstpause_value_ff;

assign csr_burstpause_rdata[15:0] = csr_burstpause_value_ff;

assign csr_burstpause_value_out = csr_burstpause_value_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_burstpause_value_ff <= 16'h1;
    end else  begin
     if (csr_burstpause_wen) begin
            if (wstrb[0]) begin
                csr_burstpause_value_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_burstpause_value_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_burstpause_value_ff <= csr_burstpause_value_ff;
        end
    end
end


//------------------------------------------------------------------------------
// Write ready
//------------------------------------------------------------------------------
assign wready = 1'b1;

//------------------------------------------------------------------------------
// Read address decoder
//------------------------------------------------------------------------------
reg [31:0] rdata_ff;
always @(posedge clk) begin
    if (rst) begin
        rdata_ff <= 32'h0;
    end else if (ren) begin
        case (raddr)
            16'h0: rdata_ff <= csr_control_rdata;
            16'h4: rdata_ff <= csr_increment_rdata;
            16'h8: rdata_ff <= csr_burstlength_rdata;
            16'hc: rdata_ff <= csr_burstpause_rdata;
            default: rdata_ff <= 32'h0;
        endcase
    end else begin
        rdata_ff <= 32'h0;
    end
end
assign rdata = rdata_ff;

//------------------------------------------------------------------------------
// Read data valid
//------------------------------------------------------------------------------
reg rvalid_ff;
always @(posedge clk) begin
    if (rst) begin
        rvalid_ff <= 1'b0;
    end else if (ren && rvalid) begin
        rvalid_ff <= 1'b0;
    end else if (ren) begin
        rvalid_ff <= 1'b1;
    end
end

assign rvalid = rvalid_ff;

endmodule