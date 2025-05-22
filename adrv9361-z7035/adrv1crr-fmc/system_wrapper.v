//******************************************************************************
//  file:     system_wrapper.v
//
//  author:   JAY CONVERTINO
//
//  date:     2025/05/22
//
//  about:    Brief
//  System wrapper for pl and ps for adrv9361-z7035_fmc board.
//
//  license: License MIT
//  Copyright 2025 Jay Convertino
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//******************************************************************************

/*
 * Module: system_wrapper
 *
 * System wrapper for pl and ps for adrv9361-z7035_fmc board.
 *
 * Parameters:
 *
 * FPGA_TECHNOLOGY        - Type of FPGA, such as Ultrascale, Arria 10. 1 is for 7 series.
 * FPGA_FAMILY            - Sub type of fpga, such as GX, SX, etc. 4 is for zynq.
 * SPEED_GRADE            - Number that corresponds to the ships recommeneded speed. 21 is for -2L.
 * DEV_PACKAGE            - Specify a number that is equal to the manufactures package. 4 is for fb.
 * DELAY_REFCLK_FREQUENCY - Reference clock frequency used for ad_data_in instances
 * ADC_INIT_DELAY         - Initial Delay for the ADC
 * DAC_INIT_DELAY         - Initial Delay for the DAC
 *
 * Ports:
 *
 * ddr_addr               - DDR interface
 * ddr_ba                 - DDR interface
 * ddr_cas_n              - DDR interface
 * ddr_ck_n               - DDR interface
 * ddr_ck_p               - DDR interface
 * ddr_cke                - DDR interface
 * ddr_cs_n               - DDR interface
 * ddr_dm                 - DDR interface
 * ddr_dq                 - DDR interface
 * ddr_dqs_n              - DDR interface
 * ddr_dqs_p              - DDR interface
 * ddr_odt                - DDR interface
 * ddr_ras_n              - DDR interface
 * ddr_reset_n            - DDR interface
 * ddr_we_n               - DDR interface
 * fixed_io_ddr_vrn       - DDR interface
 * fixed_io_ddr_vrp       - DDR interface
 * fixed_io_mio           - ps mio
 * fixed_io_ps_clk        - ps clk
 * fixed_io_ps_porb       - ps por
 * fixed_io_ps_srstb      - ps rst
 * iic_scl_fmc            - fmcomms2-3 i2c
 * iic_sda_fmc            - fmcomms2-3 i2c
 * gpio_bd                - gpio
 * rx_clk_in_p            - fmcomms2-3 rx clk
 * rx_clk_in_n            - fmcomms2-3 rx clk
 * rx_frame_in_p          - fmcomms2-3 rx frame
 * rx_frame_in_n          - fmcomms2-3 rx frame
 * rx_data_in_p           - fmcomms2-3 rx data
 * rx_data_in_n           - fmcomms2-3 rx data
 * tx_clk_out_p           - fmcomms2-3 tx clk
 * tx_clk_out_n           - fmcomms2-3 tx clk
 * tx_frame_out_p         - fmcomms2-3 tx frame
 * tx_frame_out_n         - fmcomms2-3 tx frame
 * tx_data_out_p          - fmcomms2-3 tx data
 * tx_data_out_n          - fmcomms2-3 tx data
 * txnrx                  - fmcomms2-3 txnrx
 * enable                 - fmcomms2-3 enable
 * gpio_muxout_tx         - fmcomms2-3 gpio
 * gpio_muxout_rx         - fmcomms2-3 gpio
 * gpio_resetb            - fmcomms2-3 gpio
 * gpio_sync              - fmcomms2-3 gpio
 * gpio_en_agc            - fmcomms2-3 gpio
 * gpio_ctl               - fmcomms2-3 gpio
 * gpio_status            - fmcomms2-3 gpio
 * spi_csn                - spi chip select
 * spi_clk                - spi clk
 * spi_mosi               - spi master out
 * spi_miso               - spi master in
 * spi_udc_csn_tx         - spi udc chip select tx
 * spi_udc_csn_rx         - spi udc chip select rx
 * spi_udc_sclk           - spi udc clock
 * spi_udc_data           - spi udc data
 */
module system_wrapper #(
    parameter FPGA_TECHNOLOGY = 1,
    parameter FPGA_FAMILY = 4,
    parameter SPEED_GRADE = 21,
    parameter DEV_PACKAGE = 4,
    parameter DELAY_REFCLK_FREQUENCY = 200,
    parameter ADC_INIT_DELAY = 23,
    parameter DAC_INIT_DELAY = 0
  ) (
    inout       [14:0]      ddr_addr,
    inout       [ 2:0]      ddr_ba,
    inout                   ddr_cas_n,
    inout                   ddr_ck_n,
    inout                   ddr_ck_p,
    inout                   ddr_cke,
    inout                   ddr_cs_n,
    inout       [ 3:0]      ddr_dm,
    inout       [31:0]      ddr_dq,
    inout       [ 3:0]      ddr_dqs_n,
    inout       [ 3:0]      ddr_dqs_p,
    inout                   ddr_odt,
    inout                   ddr_ras_n,
    inout                   ddr_reset_n,
    inout                   ddr_we_n,
    inout                   fixed_io_ddr_vrn,
    inout                   fixed_io_ddr_vrp,
    inout       [53:0]      fixed_io_mio,
    inout                   fixed_io_ps_clk,
    inout                   fixed_io_ps_porb,
    inout                   fixed_io_ps_srstb,
    inout                   iic_scl,
    inout                   iic_sda,
    inout       [19:0]      gpio_bd,
    input                   rx_clk_in_p,
    input                   rx_clk_in_n,
    input                   rx_frame_in_p,
    input                   rx_frame_in_n,
    input       [ 5:0]      rx_data_in_p,
    input       [ 5:0]      rx_data_in_n,
    output                  tx_clk_out_p,
    output                  tx_clk_out_n,
    output                  tx_frame_out_p,
    output                  tx_frame_out_n,
    output      [ 5:0]      tx_data_out_p,
    output      [ 5:0]      tx_data_out_n,
    output                  txnrx,
    output                  enable,
    inout                   gpio_muxout_tx,
    inout                   gpio_muxout_rx,
    inout                   gpio_rf0,
    output                  gpio_rf1,
    output                  gpio_rf2,
    input                   gpio_rf3,
    input                   gpio_rf4,
    inout                   gpio_rf5,
    inout                   gpio_clksel,
    output                  ad9517_csn,
    output                  ad9517_clk,
    output                  ad9517_mosi,
    input                   ad9517_miso,
    inout                   ad9517_pdn,
    inout                   ad9517_ref_sel,
    inout                   ad9517_ld,
    inout                   ad9517_status,
    inout                   gpio_resetb,
    inout                   gpio_sync,
    inout                   gpio_en_agc,
    inout       [ 3:0]      gpio_ctl,
    inout       [ 7:0]      gpio_status,
    output                  spi_csn,
    output                  spi_clk,
    output                  spi_mosi,
    input                   spi_miso,
    output                  fan_pwm,
    input                   fan_tach,
    output                  spi_udc_csn_tx,
    output                  spi_udc_csn_rx,
    output                  spi_udc_sclk,
    output                  spi_udc_data
  );

  // internal signals

  wire    [ 1:0]  s_spi_csn;
  wire            s_spi_clk;
  wire            s_spi_mosi;
  wire            s_spi_miso;
  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  //PS TO PL / PL TO PS signals
  
  wire            s_delay_clk;
  wire            s_axi_clk;
  wire            s_axi_aresetn;
  wire            s_adc_dma_irq;
  wire            s_dac_dma_irq;
  wire            s_iic2intc_irpt;

  //axi gp0
  wire        w_axi_awvalid;
  wire [31:0] w_axi_awaddr;
  wire        w_axi_awready;
  wire [ 2:0] w_axi_awprot;
  wire        w_axi_wvalid;
  wire [31:0] w_axi_wdata;
  wire [ 3:0] w_axi_wstrb;
  wire        w_axi_wready;
  wire        w_axi_bvalid;
  wire [ 1:0] w_axi_bresp;
  wire        w_axi_bready;
  wire        w_axi_arvalid;
  wire [31:0] w_axi_araddr;
  wire        w_axi_arready;
  wire [ 2:0] w_axi_arprot;
  wire        w_axi_rvalid;
  wire        w_axi_rready;
  wire [ 1:0] w_axi_rresp;
  wire [31:0] w_axi_rdata;

  //axi interface for the adc to the hp0 interface
  wire [31:0]   adc_hp0_axi_awaddr;
  wire [ 3:0]   adc_hp0_axi_awlen;
  wire [ 2:0]   adc_hp0_axi_awsize;
  wire [ 1:0]   adc_hp0_axi_awburst;
  wire [ 2:0]   adc_hp0_axi_awprot;
  wire [ 3:0]   adc_hp0_axi_awcache;
  wire          adc_hp0_axi_awvalid;
  wire          adc_hp0_axi_awready;
  wire [63:0]   adc_hp0_axi_wdata;
  wire [ 7:0]   adc_hp0_axi_wstrb;
  wire          adc_hp0_axi_wready;
  wire          adc_hp0_axi_wvalid;
  wire          adc_hp0_axi_wlast;
  wire          adc_hp0_axi_bvalid;
  wire [ 1:0]   adc_hp0_axi_bresp;
  wire          adc_hp0_axi_bready;

  //axi interface for dac to the hp1 interface
  wire          dac_hp1_axi_arready;
  wire          dac_hp1_axi_arvalid;
  wire [31:0]   dac_hp1_axi_araddr;
  wire [ 3:0]   dac_hp1_axi_arlen;
  wire [ 2:0]   dac_hp1_axi_arsize;
  wire [ 1:0]   dac_hp1_axi_arburst;
  wire [ 2:0]   dac_hp1_axi_arprot;
  wire [ 3:0]   dac_hp1_axi_arcache;
  wire [63:0]   dac_hp1_axi_rdata;
  wire          dac_hp1_axi_rready;
  wire          dac_hp1_axi_rvalid;
  wire [ 1:0]   dac_hp1_axi_rresp;
  wire          dac_hp1_axi_rlast;

  assign spi_csn = s_spi_csn[0];
  assign spi_clk = s_spi_clk;
  assign spi_mosi = s_spi_mosi;
  assign ad9517_csn = s_spi_csn[1];
  assign ad9517_clk = s_spi_clk;
  assign ad9517_mosi = s_spi_mosi;
  assign spi_miso_s = (~s_spi_csn[0] & spi_miso) | (~s_spi_csn[1] & ad9517_miso);
  
  // instantiations... copy pasta
  
  // board gpio - 31-0

  assign gpio_i[31:20] = gpio_o[31:20];

  ad_iobuf #(
    .DATA_WIDTH(20)
  ) i_iobuf_bd (
    .dio_t (gpio_t[19:0]),
    .dio_i (gpio_o[19:0]),
    .dio_o (gpio_i[19:0]),
    .dio_p (gpio_bd));

  // unused gpio - 63-61

  assign gpio_i[63:61] = gpio_o[63:61];

  // rf & ad9517 gpio - 60:56

  ad_iobuf #(
    .DATA_WIDTH(5)
  ) i_iobuf (
    .dio_t (gpio_t[60:56]),
    .dio_i (gpio_o[60:56]),
    .dio_o (gpio_i[60:56]),
    .dio_p ({ ad9517_pdn,         // 60:60
              ad9517_ref_sel,     // 59:59
              ad9517_ld,          // 58:58
              ad9517_status,      // 57:57
              gpio_rf0}));        // 56:56

  // unused gpio - 55:53

  assign gpio_i[55:53] = gpio_o[55:53];

  // rf & clock-select gpio - 52:51

  ad_iobuf #(
    .DATA_WIDTH(2)
  ) i_iobuf_rf_1 (
    .dio_t (gpio_t[52:51]),
    .dio_i (gpio_o[52:51]),
    .dio_o (gpio_i[52:51]),
    .dio_p ({ gpio_rf5,           // 52:52
              gpio_clksel}));     // 51:51

  // unused gpio - 50:47

  assign gpio_i[50:47] = gpio_o[50:47];

  // ad9361 gpio - 46:32

  ad_iobuf #(
    .DATA_WIDTH(15)
  ) i_iobuf_ad9361 (
    .dio_t (gpio_t[46:32]),
    .dio_i (gpio_o[46:32]),
    .dio_o (gpio_i[46:32]),
    .dio_p ({ gpio_resetb,        // 46:46
              gpio_sync,          // 45:45
              gpio_en_agc,        // 44:44
              gpio_ctl,           // 43:40
              gpio_status}));     // 39:32

  // ad9361 input protection

  ad_adl5904_rst i_adl5904_rst_a (
    .sys_cpu_clk (s_axi_clk),
    .rf_peak_det_n (gpio_rf4),
    .rf_peak_rst (gpio_rf2));

  ad_adl5904_rst i_adl5904_rst_b (
    .sys_cpu_clk (s_axi_clk),
    .rf_peak_det_n (gpio_rf3),
    .rf_peak_rst (gpio_rf1));
  
  assign fan_pwm = 1'b1;

  // Group: Instantianted Modules

  // Module: inst_system_pl_wrapper
  //
  // Module instance of system_pl_wrapper for the fmcomms2-3 device.
  system_pl_wrapper #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .FPGA_FAMILY(FPGA_FAMILY),
    .SPEED_GRADE(SPEED_GRADE),
    .DEV_PACKAGE(DEV_PACKAGE),
    .ADC_INIT_DELAY(ADC_INIT_DELAY),
    .DAC_INIT_DELAY(DAC_INIT_DELAY),
    .DELAY_REFCLK_FREQUENCY(DELAY_REFCLK_FREQUENCY)
  ) inst_system_pl_wrapper (
    .axi_aclk(s_axi_clk),
    .axi_aresetn(s_axi_aresetn),
    .s_axi_awvalid(w_axi_awvalid),
    .s_axi_awaddr(w_axi_awaddr),
    .s_axi_awready(w_axi_awready),
    .s_axi_awprot(w_axi_awprot),
    .s_axi_wvalid(w_axi_wvalid),
    .s_axi_wdata(w_axi_wdata),
    .s_axi_wstrb(w_axi_wstrb),
    .s_axi_wready(w_axi_wready),
    .s_axi_bvalid(w_axi_bvalid),
    .s_axi_bresp(w_axi_bresp),
    .s_axi_bready(w_axi_bready),
    .s_axi_arvalid(w_axi_arvalid),
    .s_axi_araddr(w_axi_araddr),
    .s_axi_arready(w_axi_arready),
    .s_axi_arprot(w_axi_arprot),
    .s_axi_rvalid(w_axi_rvalid),
    .s_axi_rready(w_axi_rready),
    .s_axi_rresp(w_axi_rresp),
    .s_axi_rdata(w_axi_rdata),
    .adc_dma_irq(s_adc_dma_irq),
    .dac_dma_irq(s_dac_dma_irq),
    .delay_clk(s_delay_clk),
    .rx_clk_in_p(rx_clk_in_p),
    .rx_clk_in_n(rx_clk_in_n),
    .rx_frame_in_p(rx_frame_in_p),
    .rx_frame_in_n(rx_frame_in_n),
    .rx_data_in_p(rx_data_in_p),
    .rx_data_in_n(rx_data_in_n),
    .tx_clk_out_p(tx_clk_out_p),
    .tx_clk_out_n(tx_clk_out_n),
    .tx_frame_out_p(tx_frame_out_p),
    .tx_frame_out_n(tx_frame_out_n),
    .tx_data_out_p(tx_data_out_p),
    .tx_data_out_n(tx_data_out_n),
    .enable(enable),
    .txnrx(txnrx),
    .up_enable(gpio_o[47]),
    .up_txnrx(gpio_o[48]),
    .tdd_sync_t(),
    .tdd_sync_i(1'b0),
    .tdd_sync_o(),
    .adc_m_dest_axi_awaddr(adc_hp0_axi_awaddr),
    .adc_m_dest_axi_awlen(adc_hp0_axi_awlen),
    .adc_m_dest_axi_awsize(adc_hp0_axi_awsize),
    .adc_m_dest_axi_awburst(adc_hp0_axi_awburst),
    .adc_m_dest_axi_awprot(adc_hp0_axi_awprot),
    .adc_m_dest_axi_awcache(adc_hp0_axi_awcache),
    .adc_m_dest_axi_awvalid(adc_hp0_axi_awvalid),
    .adc_m_dest_axi_awready(adc_hp0_axi_awready),
    .adc_m_dest_axi_wdata(adc_hp0_axi_wdata),
    .adc_m_dest_axi_wstrb(adc_hp0_axi_wstrb),
    .adc_m_dest_axi_wready(adc_hp0_axi_wready),
    .adc_m_dest_axi_wvalid(adc_hp0_axi_wvalid),
    .adc_m_dest_axi_wlast(adc_hp0_axi_wlast),
    .adc_m_dest_axi_bvalid(adc_hp0_axi_bvalid),
    .adc_m_dest_axi_bresp(adc_hp0_axi_bresp),
    .adc_m_dest_axi_bready(adc_hp0_axi_bready),
    .dac_m_src_axi_arready(dac_hp1_axi_arready),
    .dac_m_src_axi_arvalid(dac_hp1_axi_arvalid),
    .dac_m_src_axi_araddr(dac_hp1_axi_araddr),
    .dac_m_src_axi_arlen(dac_hp1_axi_arlen),
    .dac_m_src_axi_arsize(dac_hp1_axi_arsize),
    .dac_m_src_axi_arburst(dac_hp1_axi_arburst),
    .dac_m_src_axi_arprot(dac_hp1_axi_arprot),
    .dac_m_src_axi_arcache(dac_hp1_axi_arcache),
    .dac_m_src_axi_rdata(dac_hp1_axi_rdata),
    .dac_m_src_axi_rready(dac_hp1_axi_rready),
    .dac_m_src_axi_rvalid(dac_hp1_axi_rvalid),
    .dac_m_src_axi_rresp(dac_hp1_axi_rresp),
    .dac_m_src_axi_rlast(dac_hp1_axi_rlast),
    .iic_scl_fmc(iic_scl),
    .iic_sda_fmc(iic_sda),
    .iic2intc_irpt(s_iic2intc_irpt)
  );

  // Module: inst_system_ps_wrapper
  //
  // Module instance of inst_system_ps_wrapper for the built in CPU.
  system_ps_wrapper inst_system_ps_wrapper
    (
      .GPIO_I(gpio_i),
      .GPIO_O(gpio_o),
      .GPIO_T(gpio_t),
      .SPI0_SCLK_I(1'b0),
      .SPI0_SCLK_O(s_spi_clk),
      .SPI0_MOSI_I(1'b0),
      .SPI0_MOSI_O(s_spi_mosi),
      .SPI0_MISO_I(s_spi_miso),
      .SPI0_SS_I(1'b1),
      .SPI0_SS_O(s_spi_csn[0]),
      .SPI0_SS1_O(s_spi_csn[1]),
      .SPI0_SS2_O(),
      .SPI1_SCLK_I(1'b0),
      .SPI1_SCLK_O(spi_udc_sclk),
      .SPI1_MOSI_I(spi_udc_data),
      .SPI1_MOSI_O(spi_udc_data),
      .SPI1_MISO_I(1'b0),
      .SPI1_SS_I(1'b1),
      .SPI1_SS_O(spi_udc_csn_tx),
      .SPI1_SS1_O(spi_udc_csn_rx),
      .SPI1_SS2_O(),
      .M_AXI_araddr(w_axi_araddr),
      .M_AXI_arprot(w_axi_arprot),
      .M_AXI_arready(w_axi_arready),
      .M_AXI_arvalid(w_axi_arvalid),
      .M_AXI_awaddr(w_axi_awaddr),
      .M_AXI_awprot(w_axi_awprot),
      .M_AXI_awready(w_axi_awready),
      .M_AXI_awvalid(w_axi_awvalid),
      .M_AXI_bready(w_axi_bready),
      .M_AXI_bresp(w_axi_bresp),
      .M_AXI_bvalid(w_axi_bvalid),
      .M_AXI_rdata(w_axi_rdata),
      .M_AXI_rready(w_axi_rready),
      .M_AXI_rresp(w_axi_rresp),
      .M_AXI_rvalid(w_axi_rvalid),
      .M_AXI_wdata(w_axi_wdata),
      .M_AXI_wready(w_axi_wready),
      .M_AXI_wstrb(w_axi_wstrb),
      .M_AXI_wvalid(w_axi_wvalid),
      .S_AXI_HP0_arready(),
      .S_AXI_HP0_awready(adc_hp0_axi_awready),
      .S_AXI_HP0_bvalid(adc_hp0_axi_bvalid),
      .S_AXI_HP0_rlast(),
      .S_AXI_HP0_rvalid(),
      .S_AXI_HP0_wready(adc_hp0_axi_wready),
      .S_AXI_HP0_bresp(adc_hp0_axi_bresp),
      .S_AXI_HP0_rresp(),
      .S_AXI_HP0_bid(),
      .S_AXI_HP0_rid(),
      .S_AXI_HP0_rdata(),
      .S_AXI_HP0_ACLK(s_axi_clk),
      .S_AXI_HP0_arvalid(1'b0),
      .S_AXI_HP0_awvalid(adc_hp0_axi_awvalid),
      .S_AXI_HP0_bready(adc_hp0_axi_bready),
      .S_AXI_HP0_rready(1'b0),
      .S_AXI_HP0_wlast(adc_hp0_axi_wlast),
      .S_AXI_HP0_wvalid(adc_hp0_axi_wvalid),
      .S_AXI_HP0_arburst(2'b01),
      .S_AXI_HP0_arlock(0),
      .S_AXI_HP0_arsize(3'b011),
      .S_AXI_HP0_awburst(adc_hp0_axi_awburst),
      .S_AXI_HP0_awlock(0),
      .S_AXI_HP0_awsize(adc_hp0_axi_awsize),
      .S_AXI_HP0_arprot(0),
      .S_AXI_HP0_awprot(adc_hp0_axi_awprot),
      .S_AXI_HP0_araddr(0),
      .S_AXI_HP0_awaddr(adc_hp0_axi_awaddr),
      .S_AXI_HP0_arcache(4'b0011),
      .S_AXI_HP0_arlen(0),
      .S_AXI_HP0_arqos(0),
      .S_AXI_HP0_awcache(adc_hp0_axi_awcache),
      .S_AXI_HP0_awlen(adc_hp0_axi_awlen),
      .S_AXI_HP0_awqos(0),
      .S_AXI_HP0_arid(0),
      .S_AXI_HP0_awid(0),
      .S_AXI_HP0_wid(0),
      .S_AXI_HP0_wdata(adc_hp0_axi_wdata),
      .S_AXI_HP0_wstrb(adc_hp0_axi_wstrb),
      .S_AXI_HP1_arready(dac_hp1_axi_arready),
      .S_AXI_HP1_awready(),
      .S_AXI_HP1_bvalid(),
      .S_AXI_HP1_rlast(dac_hp1_axi_rlast),
      .S_AXI_HP1_rvalid(dac_hp1_axi_rvalid),
      .S_AXI_HP1_wready(),
      .S_AXI_HP1_bresp(),
      .S_AXI_HP1_rresp(dac_hp1_axi_rresp),
      .S_AXI_HP1_bid(),
      .S_AXI_HP1_rid(),
      .S_AXI_HP1_rdata(dac_hp1_axi_rdata),
      .S_AXI_HP1_ACLK(s_axi_clk),
      .S_AXI_HP1_arvalid(dac_hp1_axi_arvalid),
      .S_AXI_HP1_awvalid(1'b0),
      .S_AXI_HP1_bready(1'b0),
      .S_AXI_HP1_rready(dac_hp1_axi_rready),
      .S_AXI_HP1_wlast(1'b0),
      .S_AXI_HP1_wvalid(1'b0),
      .S_AXI_HP1_arburst(dac_hp1_axi_arburst),
      .S_AXI_HP1_arlock(0),
      .S_AXI_HP1_arsize(dac_hp1_axi_arsize),
      .S_AXI_HP1_awburst(2'b01),
      .S_AXI_HP1_awlock(0),
      .S_AXI_HP1_awsize(3'b011),
      .S_AXI_HP1_arprot(dac_hp1_axi_arprot),
      .S_AXI_HP1_awprot(0),
      .S_AXI_HP1_araddr(dac_hp1_axi_araddr),
      .S_AXI_HP1_awaddr(0),
      .S_AXI_HP1_arcache(dac_hp1_axi_arcache),
      .S_AXI_HP1_arlen(dac_hp1_axi_arlen),
      .S_AXI_HP1_arqos(0),
      .S_AXI_HP1_awcache(4'b0011),
      .S_AXI_HP1_awlen(0),
      .S_AXI_HP1_awqos(0),
      .S_AXI_HP1_arid(0),
      .S_AXI_HP1_awid(0),
      .S_AXI_HP1_wid(0),
      .S_AXI_HP1_wdata(0),
      .S_AXI_HP1_wstrb(~0),
      .IRQ_F2P({{2{1'b0}}, s_adc_dma_irq, s_dac_dma_irq, s_iic2intc_irpt, {11{1'b0}}}),
      .FCLK_CLK0(s_axi_clk),
      .FCLK_CLK1(s_delay_clk),
      .FIXED_IO_mio(fixed_io_mio),
      .DDR_cas_n(ddr_cas_n),
      .DDR_cke(ddr_cke),
      .DDR_ck_n(ddr_ck_n),
      .DDR_ck_p(ddr_ck_p),
      .DDR_cs_n(ddr_cs_n),
      .DDR_reset_n(ddr_reset_n),
      .DDR_odt(ddr_odt),
      .DDR_ras_n(ddr_ras_n),
      .DDR_we_n(ddr_we_n),
      .DDR_ba(ddr_ba),
      .DDR_addr(ddr_addr),
      .FIXED_IO_ddr_vrn(fixed_io_ddr_vrn),
      .FIXED_IO_ddr_vrp(fixed_io_ddr_vrp),
      .DDR_dm(ddr_dm),
      .DDR_dq(ddr_dq),
      .DDR_dqs_n(ddr_dqs_n),
      .DDR_dqs_p(ddr_dqs_p),
      .FIXED_IO_ps_srstb(fixed_io_ps_srstb),
      .FIXED_IO_ps_clk(fixed_io_ps_clk),
      .FIXED_IO_ps_porb(fixed_io_ps_porb),
      .peripheral_aresetn(s_axi_aresetn)
    );

endmodule
