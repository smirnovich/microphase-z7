`timescale 1 ps / 1 ps

module top
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    ETH_MDIO_mdc,
    ETH_MDIO_mdio_io,
    ETH_nRST,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
  //  GMII_ETH_col,
  //  GMII_ETH_crs,
    ETH_RXCK,
    ETH_RXDV,
 //   GMII_ETH_rx_er,
    ETH_RXD,
    ETH_TXCK,
    ETH_TXCTL,
  //  GMII_ETH_tx_er,
    ETH_TXD,
    PL_LED1
    );
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  output ETH_MDIO_mdc;
  inout ETH_MDIO_mdio_io;
  output ETH_nRST;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
//  input GMII_ETH_col;
//  input GMII_ETH_crs;
  input ETH_RXCK;
  input ETH_RXDV;
//  input GMII_ETH_rx_er;
  input [3:0]ETH_RXD;
  input ETH_TXCK;
  output [0:0]ETH_TXCTL;
//  output [0:0]GMII_ETH_tx_er;
  output [7:0]ETH_TXD;
  output PL_LED1;
  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire ETH_MDIO_mdc;
  wire ETH_MDIO_mdio_i;
  wire ETH_MDIO_mdio_io;
  wire ETH_MDIO_mdio_o;
  wire ETH_MDIO_mdio_t;
  wire ETH_nRST;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
//  wire GMII_ETH_col;
//  wire GMII_ETH_crs;
  wire ETH_RXCK;
  wire ETH_RXDV;
//  wire GMII_ETH_rx_er;
  wire [3:0]ETH_RXD;
  wire ETH_TXCK;
  wire [0:0]ETH_TXCTL;
//  wire [0:0]GMII_ETH_tx_er;
  wire [3:0]ETH_TXD;
  wire PL_LED1;
  IOBUF ETH_MDIO_mdio_iobuf
       (.I(ETH_MDIO_mdio_o),
        .IO(ETH_MDIO_mdio_io),
        .O(ETH_MDIO_mdio_i),
        .T(ETH_MDIO_mdio_t));
  top_bd_zynq top_bd_zynq_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .ETH_MDIO_mdc(ETH_MDIO_mdc),
        .ETH_MDIO_mdio_i(ETH_MDIO_mdio_i),
        .ETH_MDIO_mdio_o(ETH_MDIO_mdio_o),
        .ETH_MDIO_mdio_t(ETH_MDIO_mdio_t),
        .ETH_nRST(ETH_nRST),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
    //    .GMII_ETH_col(GMII_ETH_col),
    //    .GMII_ETH_crs(GMII_ETH_crs),
        .GMII_ETH_rx_clk(ETH_RXCK),
        .GMII_ETH_rx_dv(ETH_RXDV),
    //    .GMII_ETH_rx_er(GMII_ETH_rx_er),
        .GMII_ETH_rxd(ETH_RXD),
        .GMII_ETH_tx_clk(ETH_TXCK),
        .GMII_ETH_tx_en(ETH_TXCTL),
    //    .GMII_ETH_tx_er(GMII_ETH_tx_er),
        .GMII_ETH_txd(ETH_TXD),
        .PL_LED1(PL_LED1));
endmodule
