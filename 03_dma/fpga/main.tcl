# CREATING NON-PROJECT MODE TDC PROJECT DIRECT_F1
set TclPath [file dirname [file normalize [info script]]]
cd $TclPath
put $TclPath

source ./../../common/setup.tcl

source ./../../01_pure_eth/top_bd_zynq.tcl

generate_target all [get_files $TclPath/top_bd_gen/top_bd_zynq/top_bd_zynq.bd]
#make_wrapper -files [get_files $TclPath/top_bd_gen/top_bd_zynq/top_bd_zynq.bd] -top
#add_files -norecurse $TclPath/top_bd_gen/top_bd_zynq/hdl/top_bd_zynq_wrapper.vhd
# add_files -norecurse $TclPath/top.sv
# set_property top top [current_fileset]

source ./../../common/compile_all.tcl
