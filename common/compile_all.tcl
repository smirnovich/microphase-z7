synth_design
opt_design
place_design
route_design
write_bitstream  -force $TclPath/main_top.bit
write_hw_platform -fixed -include_bit -force -file $TclPath/top_bd_zynq.xsa