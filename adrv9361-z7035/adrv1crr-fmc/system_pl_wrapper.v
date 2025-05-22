//******************************************************************************
//  file:     system_pl_wrapper.v
//
//  author:   JAY CONVERTINO
//
//  date:     2023/11/02
//
//  about:    Brief
//  System wrapper for pl only for adrv9361-z7035_fmc board.
//
//  license: License MIT
//  Copyright 2023 Jay Convertino
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
 * Module: system_pl_wrapper
 *
 * System wrapper for pl only for adrv9361-z7035_fmc board.
 *
 * Parameters:
 *
 * FPGA_TECHNOLOGY        - Type of FPGA, such as Ultrascale, Arria 10. 1 is for 7 series.
 * FPGA_FAMILY            - Sub type of fpga, such as GX, SX, etc. 4 is for zynq.
 * SPEED_GRADE            - Number that corresponds to the ships recommeneded speed. 10 is for -1.
 * DEV_PACKAGE            - Specify a number that is equal to the manufactures package. 14 is for cl.
 * DELAY_REFCLK_FREQUENCY - Reference clock frequency used for ad_data_in instances
 * ADC_INIT_DELAY         - Initial Delay for the ADC
 * DAC_INIT_DELAY         - Initial Delay for the DAC
 *
 * Ports:
 *
 *  axi_aclk                      - AXI Lite control bus
 *  axi_aresetn                   - AXI Lite control bus
 *  s_axi_awvalid                 - AXI Lite control bus
 *  s_axi_awaddr                  - AXI Lite control bus
 *  s_axi_awready                 - AXI Lite control bus
 *  s_axi_awprot                  - AXI Lite control bus
 *  s_axi_wvalid                  - AXI Lite control bus
 *  s_axi_wdata                   - AXI Lite control bus
 *  s_axi_wstrb                   - AXI Lite control bus
 *  s_axi_wready                  - AXI Lite control bus
 *  s_axi_bvalid                  - AXI Lite control bus
 *  s_axi_bresp                   - AXI Lite control bus
 *  s_axi_bready                  - AXI Lite control bus
 *  s_axi_arvalid                 - AXI Lite control bus
 *  s_axi_araddr                  - AXI Lite control bus
 *  s_axi_arready                 - AXI Lite control bus
 *  s_axi_arprot                  - AXI Lite control bus
 *  s_axi_rvalid                  - AXI Lite control bus
 *  s_axi_rready                  - AXI Lite control bus
 *  s_axi_rresp                   - AXI Lite control bus
 *  s_axi_rdata                   - AXI Lite control bus
 *  adc_dma_irq                   - fmcomms2-3 ADC irq
 *  dac_dma_irq                   - fmcomms2-3 DAC irq
 *  delay_clk                     - fmcomms2-3 delay clock
 *  rx_clk_in_p                   - fmcomms2-3 receive clock in
 *  rx_clk_in_n                   - fmcomms2-3 receive clock in
 *  rx_frame_in_p                 - fmcomms2-3 receive frame
 *  rx_frame_in_n                 - fmcomms2-3 receive frame
 *  rx_data_in_p                  - fmcomms2-3 receive lvds data
 *  rx_data_in_n                  - fmcomms2-3 receive lvds data
 *  tx_clk_out_p                  - fmcomms2-3 transmit clock
 *  tx_clk_out_n                  - fmcomms2-3 transmit clock
 *  tx_frame_out_p                - fmcomms2-3 transmit frame
 *  tx_frame_out_n                - fmcomms2-3 transmit frame
 *  tx_data_out_p                 - fmcomms2-3 transmit lvds data
 *  tx_data_out_n                 - fmcomms2-3 transmit lvds data
 *  enable                        - fmcomms2-3 enable
 *  txnrx                         - fmcomms2-3 txnrx select
 *  up_enable                     - fmcomms2-3 enable input
 *  up_txnrx                      - fmcomms2-3 txnrx select input
 *  tdd_sync_t                    - fmcomms2-3 TDD sync i/o
 *  tdd_sync_i                    - fmcomms2-3 TDD sync i/o
 *  tdd_sync_o                    - fmcomms2-3 TDD sync i/o
 *  adc_m_dest_axi_awaddr         - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_awlen          - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_awsize         - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_awburst        - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_awprot         - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_awcache        - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_awvalid        - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_awready        - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_wdata          - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_wstrb          - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_wready         - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_wvalid         - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_wlast          - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_bvalid         - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_bresp          - fmcomms2-3 ADC DMA
 *  adc_m_dest_axi_bready         - fmcomms2-3 ADC DMA
 *  dac_m_src_axi_arready         - fmcomms2-3 DAC DMA
 *  dac_m_src_axi_arvalid         - fmcomms2-3 DAC DMA
 *  dac_m_src_axi_araddr          - fmcomms2-3 DAC DMA
 *  dac_m_src_axi_arlen           - fmcomms2-3 DAC DMA
 *  dac_m_src_axi_arsize          - fmcomms2-3 DAC DMA
 *  dac_m_src_axi_arburst         - fmcomms2-3 DAC DMA
 *  dac_m_src_axi_arprot          - fmcomms2-3 DAC DMA
 *  dac_m_src_axi_arcache         - fmcomms2-3 DAC DMA
 *  dac_m_src_axi_rdata           - fmcomms2-3 DAC DMA
 *  dac_m_src_axi_rready          - fmcomms2-3 DAC DMA
 *  dac_m_src_axi_rvalid          - fmcomms2-3 DAC DMA
 *  dac_m_src_axi_rresp           - fmcomms2-3 DAC DMA
 *  dac_m_src_axi_rlast           - fmcomms2-3 DAC DMA
 *  iic_sda_fmc                   - i2c for fmc
 *  iic_scl_fmc                   - i2c for fmc
 *  iic2intc_irpt                 - i2c for fmc
 */
module system_pl_wrapper #(
    parameter FPGA_TECHNOLOGY = 0,
    parameter FPGA_FAMILY = 0,
    parameter SPEED_GRADE = 0,
    parameter DEV_PACKAGE = 0,
    parameter ADC_INIT_DELAY = 23,
    parameter DAC_INIT_DELAY = 0,
    parameter DELAY_REFCLK_FREQUENCY = 200
  ) (
    input           axi_aclk,
    input           axi_aresetn,
    input           s_axi_awvalid,
    input  [31:0]   s_axi_awaddr,
    output          s_axi_awready,
    input   [2:0]   s_axi_awprot,
    input           s_axi_wvalid,
    input  [31:0]   s_axi_wdata,
    input  [ 3:0]   s_axi_wstrb,
    output          s_axi_wready,
    output          s_axi_bvalid,
    output [ 1:0]   s_axi_bresp,
    input           s_axi_bready,
    input           s_axi_arvalid,
    input  [31:0]   s_axi_araddr,
    output          s_axi_arready,
    input   [2:0]   s_axi_arprot,
    output          s_axi_rvalid,
    input           s_axi_rready,
    output [ 1:0]   s_axi_rresp,
    output [31:0]   s_axi_rdata,
    output          adc_dma_irq,
    output          dac_dma_irq,
    input           delay_clk,
    input           rx_clk_in_p,
    input           rx_clk_in_n,
    input           rx_frame_in_p,
    input           rx_frame_in_n,
    input   [5:0]   rx_data_in_p,
    input   [5:0]   rx_data_in_n,
    output          tx_clk_out_p,
    output          tx_clk_out_n,
    output          tx_frame_out_p,
    output          tx_frame_out_n,
    output  [5:0]   tx_data_out_p,
    output  [5:0]   tx_data_out_n,
    output          enable,
    output          txnrx,
    input           up_enable,
    input           up_txnrx,
    output          tdd_sync_t,
    input           tdd_sync_i,
    output          tdd_sync_o,
    output [31:0]   adc_m_dest_axi_awaddr,
    output [ 3:0]   adc_m_dest_axi_awlen,
    output [ 2:0]   adc_m_dest_axi_awsize,
    output [ 1:0]   adc_m_dest_axi_awburst,
    output [ 2:0]   adc_m_dest_axi_awprot,
    output [ 3:0]   adc_m_dest_axi_awcache,
    output          adc_m_dest_axi_awvalid,
    input           adc_m_dest_axi_awready,
    output [63:0]   adc_m_dest_axi_wdata,
    output [ 7:0]   adc_m_dest_axi_wstrb,
    input           adc_m_dest_axi_wready,
    output          adc_m_dest_axi_wvalid,
    output          adc_m_dest_axi_wlast,
    input           adc_m_dest_axi_bvalid,
    input  [ 1:0]   adc_m_dest_axi_bresp,
    output          adc_m_dest_axi_bready,
    input           dac_m_src_axi_arready,
    output          dac_m_src_axi_arvalid,
    output [31:0]   dac_m_src_axi_araddr,
    output [ 3:0]   dac_m_src_axi_arlen,
    output [ 2:0]   dac_m_src_axi_arsize,
    output [ 1:0]   dac_m_src_axi_arburst,
    output [ 2:0]   dac_m_src_axi_arprot,
    output [ 3:0]   dac_m_src_axi_arcache,
    input  [63:0]   dac_m_src_axi_rdata,
    output          dac_m_src_axi_rready,
    input           dac_m_src_axi_rvalid,
    input  [ 1:0]   dac_m_src_axi_rresp,
    input           dac_m_src_axi_rlast,
    inout           iic_sda_fmc,
    inout           iic_scl_fmc,
    output          iic2intc_irpt
  );

  //iic fmc
  wire  [31:0]  iic_fmc_axi_awaddr;
  wire  [ 2:0]  iic_fmc_axi_awprot;
  wire          iic_fmc_axi_awvalid;
  wire          iic_fmc_axi_awready;
  wire  [31:0]  iic_fmc_axi_wdata;
  wire  [ 3:0]  iic_fmc_axi_wstrb;
  wire          iic_fmc_axi_wvalid;
  wire          iic_fmc_axi_wready;
  wire  [ 1:0]  iic_fmc_axi_bresp;
  wire          iic_fmc_axi_bvalid;
  wire          iic_fmc_axi_bready;
  wire  [31:0]  iic_fmc_axi_araddr;
  wire  [ 2:0]  iic_fmc_axi_arprot;
  wire          iic_fmc_axi_arvalid;
  wire          iic_fmc_axi_arready;
  wire  [31:0]  iic_fmc_axi_rdata;
  wire  [ 1:0]  iic_fmc_axi_rresp;
  wire          iic_fmc_axi_rvalid;
  wire          iic_fmc_axi_rready;

   //ADC DMA AXI4LITE bus signals
  wire           connect_axi_awvalid;
  wire   [31:0]  connect_axi_awaddr;
  wire   [ 2:0]  connect_axi_awprot;
  wire           connect_axi_awready;
  wire           connect_axi_wvalid;
  wire   [31:0]  connect_axi_wdata;
  wire   [ 3:0]  connect_axi_wstrb;
  wire           connect_axi_wready;
  wire           connect_axi_bvalid;
  wire   [ 1:0]  connect_axi_bresp;
  wire           connect_axi_bready;
  wire           connect_axi_arvalid;
  wire   [31:0]  connect_axi_araddr;
  wire   [ 2:0]  connect_axi_arprot;
  wire           connect_axi_arready;
  wire           connect_axi_rvalid;
  wire   [31:0]  connect_axi_rdata;
  wire   [ 1:0]  connect_axi_rresp;
  wire           connect_axi_rready;

  //iic wires
  wire sda_i;
  wire sda_o;
  wire sda_t;
  wire scl_i;
  wire scl_o;
  wire scl_t;

  // Group: Instantianted Modules

  // Module: iic_sda_iobuf
  //
  // Tristate i2c sda
  ad_iobuf #(
    .DATA_WIDTH(1)
  ) iic_sda_iobuf (
    .dio_t (sda_t),
    .dio_i (sda_o),
    .dio_o (sda_i),
    .dio_p (iic_sda_fmc)
  );

  // Module: iic_scl_iobuf
  //
  // Tristate i2c scl
  ad_iobuf #(
    .DATA_WIDTH(1)
  ) iic_scl_iobuf (
    .dio_t (scl_t),
    .dio_i (scl_o),
    .dio_o (scl_i),
    .dio_p (iic_scl_fmc)
  );

  // Module: inst_ad9361_pl_wrapper
  //
  // Module instance of ad9361_pl_wrapper for the fmcomms2-3 device.
  ad9361_pl_wrapper #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .FPGA_FAMILY(FPGA_FAMILY),
    .SPEED_GRADE(SPEED_GRADE),
    .DEV_PACKAGE(DEV_PACKAGE),
    .ADC_INIT_DELAY(ADC_INIT_DELAY),
    .DAC_INIT_DELAY(DAC_INIT_DELAY),
    .DELAY_REFCLK_FREQUENCY(DELAY_REFCLK_FREQUENCY)
  ) inst_ad9361_pl_wrapper (
    .axi_aclk(axi_aclk),
    .axi_aresetn(axi_aresetn),
    .s_axi_awvalid(connect_axi_awvalid),
    .s_axi_awaddr(connect_axi_awaddr),
    .s_axi_awready(connect_axi_awready),
    .s_axi_awprot(connect_axi_awprot),
    .s_axi_wvalid(connect_axi_wvalid),
    .s_axi_wdata(connect_axi_wdata),
    .s_axi_wstrb(connect_axi_wstrb),
    .s_axi_wready(connect_axi_wready),
    .s_axi_bvalid(connect_axi_bvalid),
    .s_axi_bresp(connect_axi_bresp),
    .s_axi_bready(connect_axi_bready),
    .s_axi_arvalid(connect_axi_arvalid),
    .s_axi_araddr(connect_axi_araddr),
    .s_axi_arready(connect_axi_arready),
    .s_axi_arprot(connect_axi_arprot),
    .s_axi_rvalid(connect_axi_rvalid),
    .s_axi_rready(connect_axi_rready),
    .s_axi_rresp(connect_axi_rresp),
    .s_axi_rdata(connect_axi_rdata),
    .adc_dma_irq(adc_dma_irq),
    .dac_dma_irq(dac_dma_irq),
    .delay_clk(delay_clk),
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
    .up_enable(up_enable),
    .up_txnrx(up_txnrx),
    .tdd_sync_t(tdd_sync_t),
    .tdd_sync_i(tdd_sync_i),
    .tdd_sync_o(tdd_sync_o),
    .adc_m_dest_axi_awaddr(adc_m_dest_axi_awaddr),
    .adc_m_dest_axi_awlen(adc_m_dest_axi_awlen),
    .adc_m_dest_axi_awsize(adc_m_dest_axi_awsize),
    .adc_m_dest_axi_awburst(adc_m_dest_axi_awburst),
    .adc_m_dest_axi_awprot(adc_m_dest_axi_awprot),
    .adc_m_dest_axi_awcache(adc_m_dest_axi_awcache),
    .adc_m_dest_axi_awvalid(adc_m_dest_axi_awvalid),
    .adc_m_dest_axi_awready(adc_m_dest_axi_awready),
    .adc_m_dest_axi_wdata(adc_m_dest_axi_wdata),
    .adc_m_dest_axi_wstrb(adc_m_dest_axi_wstrb),
    .adc_m_dest_axi_wready(adc_m_dest_axi_wready),
    .adc_m_dest_axi_wvalid(adc_m_dest_axi_wvalid),
    .adc_m_dest_axi_wlast(adc_m_dest_axi_wlast),
    .adc_m_dest_axi_bvalid(adc_m_dest_axi_bvalid),
    .adc_m_dest_axi_bresp(adc_m_dest_axi_bresp),
    .adc_m_dest_axi_bready(adc_m_dest_axi_bready),
    .dac_m_src_axi_arready(dac_m_src_axi_arready),
    .dac_m_src_axi_arvalid(dac_m_src_axi_arvalid),
    .dac_m_src_axi_araddr(dac_m_src_axi_araddr),
    .dac_m_src_axi_arlen(dac_m_src_axi_arlen),
    .dac_m_src_axi_arsize(dac_m_src_axi_arsize),
    .dac_m_src_axi_arburst(dac_m_src_axi_arburst),
    .dac_m_src_axi_arprot(dac_m_src_axi_arprot),
    .dac_m_src_axi_arcache(dac_m_src_axi_arcache),
    .dac_m_src_axi_rdata(dac_m_src_axi_rdata),
    .dac_m_src_axi_rready(dac_m_src_axi_rready),
    .dac_m_src_axi_rvalid(dac_m_src_axi_rvalid),
    .dac_m_src_axi_rresp(dac_m_src_axi_rresp),
    .dac_m_src_axi_rlast(dac_m_src_axi_rlast)
  );

  // Module: inst_axi_crossbar_pl
  //
  // Module instance of axi_crossbar_pl for the fmcomms2-3 device.
  axi_crossbar_pl inst_axi_crossbar_pl (
    .aclk(axi_aclk),
    .aresetn(axi_aresetn),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .m_axi_awaddr({iic_fmc_axi_awaddr, connect_axi_awaddr}),
    .m_axi_awprot({iic_fmc_axi_awprot, connect_axi_awprot}),
    .m_axi_awvalid({iic_fmc_axi_awvalid, connect_axi_awvalid}),
    .m_axi_awready({iic_fmc_axi_awready, connect_axi_awready}),
    .m_axi_wdata({iic_fmc_axi_wdata, connect_axi_wdata}),
    .m_axi_wstrb({iic_fmc_axi_wstrb, connect_axi_wstrb}),
    .m_axi_wvalid({iic_fmc_axi_wvalid, connect_axi_wvalid}),
    .m_axi_wready({iic_fmc_axi_wready, connect_axi_wready}),
    .m_axi_bresp({iic_fmc_axi_bresp, connect_axi_bresp}),
    .m_axi_bvalid({iic_fmc_axi_bvalid, connect_axi_bvalid}),
    .m_axi_bready({iic_fmc_axi_bready, connect_axi_bready}),
    .m_axi_araddr({iic_fmc_axi_araddr, connect_axi_araddr}),
    .m_axi_arprot({iic_fmc_axi_arprot, connect_axi_arprot}),
    .m_axi_arvalid({iic_fmc_axi_arvalid, connect_axi_arvalid}),
    .m_axi_arready({iic_fmc_axi_arready, connect_axi_arready}),
    .m_axi_rdata({iic_fmc_axi_rdata, connect_axi_rdata}),
    .m_axi_rresp({iic_fmc_axi_rresp, connect_axi_rresp}),
    .m_axi_rvalid({iic_fmc_axi_rvalid, connect_axi_rvalid}),
    .m_axi_rready({iic_fmc_axi_rready, connect_axi_rready})
  );

  // Module: inst_axi_iic_fmc
  //
  // Module instance of axi_iic_fmc for the fmcomms2-3 device.
  axi_iic_fmc inst_axi_iic_fmc (
    .s_axi_aclk(axi_aclk),
    .s_axi_aresetn(axi_aresetn),
    .iic2intc_irpt(iic2intc_irpt),
    .s_axi_awaddr(iic_fmc_axi_awaddr[8:0]),
    .s_axi_awvalid(iic_fmc_axi_awvalid),
    .s_axi_awready(iic_fmc_axi_awready),
    .s_axi_wdata(iic_fmc_axi_wdata),
    .s_axi_wstrb(iic_fmc_axi_wstrb),
    .s_axi_wvalid(iic_fmc_axi_wvalid),
    .s_axi_wready(iic_fmc_axi_wready),
    .s_axi_bresp(iic_fmc_axi_bresp),
    .s_axi_bvalid(iic_fmc_axi_bvalid),
    .s_axi_bready(iic_fmc_axi_bready),
    .s_axi_araddr(iic_fmc_axi_araddr[8:0]),
    .s_axi_arvalid(iic_fmc_axi_arvalid),
    .s_axi_arready(iic_fmc_axi_arready),
    .s_axi_rdata(iic_fmc_axi_rdata),
    .s_axi_rresp(iic_fmc_axi_rresp),
    .s_axi_rvalid(iic_fmc_axi_rvalid),
    .s_axi_rready(iic_fmc_axi_rready),
    .sda_i(sda_i),
    .sda_o(sda_o),
    .sda_t(sda_t),
    .scl_i(scl_i),
    .scl_o(scl_o),
    .scl_t(scl_t),
    .gpo()
  );

endmodule
