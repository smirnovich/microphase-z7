# MicroPhase z7-Lite

This repository is devoted to simple examples for MicroPhase Z7 Lite board, [AliExpress-avaliable](https://aliexpress.ru/item/1005002542001122.html?spm=a2g2w.orderdetail.0.0.45344aa6H0Hokr&sku_id=12000021066812071). Examples are prepared with Vivado 2023.1 on Windows 10.


Basic examples are also available directly from [MicroPhase](https://fpga-docs.microphase.cn/en/latest/DEV_BOARD/Z7-LITE/Z7-Lite_Reference_Manual.html), taking into account that the examples are for Vivado 2018.3.

![MicroPhaseZ7](photos/photo_izo.jpg)
<img src="photos/photo_top.jpg"  width=50%> <img src="photos/photo_bottom.jpg"  width=49%>

## Board features

- Zynq 7010/20 (xc7z010-1clg400c/xc7z020-1clg400c)
- microSD card slot (PS)
- 4Gbit DDR3 MT41J256M16 RE-125 (PS)
- USB Host 3320C-EZK(PS)
- Winbond 16MB QSPI Flash W25Q128JVSIQ (PS)
- HDMI Output (PL)
- Ethernet RTL8201F (PL)
- Leds and Buttons (PS/PL)
- USB type-C UART to ZYNQ
- USB type-C JTAG
- two GPIO 2x20
- full of examples from AliExpress-seller (Vivado 2018.3, need to be requested)

## About projects
All projects created in non-project mode with Vivado 2023.1.
- To build FPGA project run `<proj_name>/fpga/main.tcl` script in Vivado tcl-console;
- To build Vitis bare-metal environment run `<proj_name>/arm/arm_build.tcl` in Software Command Line Tool.
- Each project has its own README with additional info

### Projects list (continues to be expanded and updated):
- [x] [`01_pure_eth`](/01_pure_eth/) - connecting RTL8201 to PS-Ethernet controller through EMIO (bare-metal)
- [x] [`02_custom_axi_slave`](/02_custom_axi_slave/) - Adding custom low-speed AXI peripheral for data gathering and streaming via Ethernet (bare-metal)
  -[x] bare-metal example
  -[ ] Linux example (Buildroot)
    - [ ] using UIO
    - [ ] (*may be will be cancelled*) with custom driver
- [ ] [`03_dma`](/03_dma/) - Launching simple DMA example (bare-metal)
- [ ] [`04_sgdma`](/04_sgdma/) - Expanding `03` project to Scatter-Gather DMA mode  
  - [ ] bare-metal example
  - [ ] Linux example (Buildroot)
- [ ] [`05_vdma`](/05_vdma/) - Implementing examples for onboard HDMI and frame-buffer interaction  
  - [ ] bare-metal example
  - [ ] Linux example (Buildroot)


