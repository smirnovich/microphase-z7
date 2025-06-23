# CREATING NON-PROJECT MODE TDC PROJECT DIRECT_F1
set TclPath [file dirname [file normalize [info script]]]
cd $TclPath
put $TclPath

set_part xc7z020clg400-2
set_property target_language VHDL [current_project]
set_property default_lib work [current_project]

source top_bd_zynq.tcl

generate_target all [get_files $TclPath/top_bd_gen/top_bd_zynq/top_bd_zynq.bd]
make_wrapper -files [get_files $TclPath/top_bd_gen/top_bd_zynq/top_bd_zynq.bd] -top
add_files -norecurse $TclPath/top_bd_gen/top_bd_zynq/hdl/top_bd_zynq_wrapper.vhd
set_property top top_bd_zynq_wrapper [current_fileset]
read_xdc $TclPath/../Z7_LITE.xdc
read_xdc $TclPath/../Z7_LITE_timings.xdc

#open_bd_design {D:/_prjcts/vdm_tdc/top_bd_gen/top_bd_zynq/top_bd_zynq.bd}
#write_bd_tcl -force D:/_prjcts/vdm_tdc/top_bd_zynq.tcl
#synth_design
#opt_design
#place_design
#route_design
#write_bitstream main_top.bit -force
#write_hw_platform -fixed -include_bit -force -file ./top_bd_zynq.xsa