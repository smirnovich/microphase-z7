platform create -name {platform_dma} -hw {../fpga/top_bd_zynq.xsa} -proc {ps7_cortexa9_0} -os {standalone} -out .
bsp setlib -name lwip213 -ver 1.0
bsp write
bsp reload
bsp regenerate
setws .
platform read ./platform_dma/platform.spr
app create -name app_dma -template "Empty Application(C)"