# CREATING NON-PROJECT MODE TDC PROJECT DIRECT_F1
set TclPath [file dirname [file normalize [info script]]]
cd $TclPath
put $TclPath

source ./../common/setup.tcl
add_files -norecurse $TclPath/data_generator.v
set_property source_mgmt_mode All [current_project]
update_compile_order -fileset sources_1
source top_bd_zynq.tcl

generate_target all [get_files $TclPath/.srcs/sources_1/top_bd_gen/top_bd_zynq/top_bd_zynq.bd]
make_wrapper -files [get_files $TclPath/.srcs/sources_1/top_bd_gen/top_bd_zynq/top_bd_zynq.bd] -top
# add_files -norecurse $TclPath/top_bd_gen/top_bd_zynq/hdl/top_bd_zynq_wrapper.vhd
# set_property top top_bd_zynq_wrapper [current_fileset]

# open_bd_design {D:/_prjcts/vdm_tdc/top_bd_gen/top_bd_zynq/top_bd_zynq.bd}
# write_bd_tcl -force D:/_prjcts/vdm_tdc/top_bd_zynq.tcl
# synth_design
# opt_design
# place_design
# route_design
# write_bitstream main_top.bit -force
# write_hw_platform -fixed -include_bit -force -file ./top_bd_zynq.xsa