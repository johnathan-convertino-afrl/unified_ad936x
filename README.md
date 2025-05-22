# Unified AD936X FPGA Project
### Contains core files and scripts to generate a AD936X platform using fusesoc.

![image](docs/manual/img/AFRL.png)

---

   author: Jay Convertino

   date: 2025.05.23

   details: Generate AD936X FPGA image for various unified targets. These are systems with a AD936x built onto a board with the FPGA.

   license: MIT

---

### Version
#### Current
  - none

#### Previous
  - none

### DOCUMENTATION
  !!!INCOMPLETE AND DOES NOT EXIST!!!

  - [unified_ad936x.pdf](docs/manual/unified_ad936x.pdf)
  - [github page](https://johnathan-convertino-afrl.github.io/unified_ad936x)

### PARAMETERS
##### ad9361_pl_wrapper.v
  * FPGA_TECHNOLOGY : See ad_hdl_fusesoc readme.md for details
  * FPGA_FAMILY : See ad_hdl_fusesoc readme.md for details
  * SPEED_GRADE : See ad_hdl_fusesoc readme.md for details
  * DEV_PACKAGE : See ad_hdl_fusesoc readme.md for details
  * ADC_INIT_DELAY : Tune IDELAY macros
  * DAC_INIT_DELAY : Tune IDELAY macros
  * DELAY_REFCLK_FREQUENCY : Reference clock in MHz for delay input
  * DMA_AXI_PROTOCOL_TO_PS : Set DMA protocol, 1 = AXI3, 0 = AXI4
  * AXI_DMAC_ADC_ADDR : Set address of ADC DMA, default: 32'h7C400000
  * AXI_DMAC_DAC_ADDR : Set address of DAC DMA, default: 32'h7C420000
  * AXI_AD9361_ADDR : Set address of AD9361, default: 32'h79020000

### FUSESOC

* fusesoc_info.core created.
* Simulation not available

#### Targets

* RUN WITH: (fusesoc run --target=X VENDER:CORE:NAME:VERSION)
* --target can be one of the below.
  - adrv9361-z7035_fmc         : adrv9361-z7035_fmc target.
  - adrv9361-z7035_fmc_bootgen : adrv9361-z7035_fmc build with boot.bin output in BOOTFS folder.


