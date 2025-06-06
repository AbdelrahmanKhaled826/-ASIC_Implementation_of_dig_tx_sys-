
source /home/svgpasic25abkhaled/GP/synthesis/common_setup.tcl

########################### Define Top Module ############################

set DESIGN_NAME "dig_tx_system"

##################### Define Working Library Directory ######################
sh rm -rf work
sh rm -rf outputs
sh rm -rf outputs/compile
sh rm -rf reports
sh rm -rf ./reports/compile
sh rm -rf ./reports/compile_incr_high


define_design_lib work -path ./work
sh mkdir ./outputs
sh mkdir ./outputs/compile
sh mkdir ./reports
sh mkdir ./reports/compile
sh mkdir ./reports/compile_incr_high


############################# Formality Setup File ##########################

set_svf "./outputs/$DESIGN_NAME.svf"

#######################################  option   ###########################################################
set verilogout_no_tri    true
set verilogout_equation  false
set compile_automatic_clock_phase_inference none


#######################################  Reading Libraries ############################################



set target_library "$std_cell_lib"
set link_library "* $std_cell_lib"




##############  Reading files ############################################
lappend search_path "/home/svgpasic25abkhaled/GP/RTL"


set my_blocks { "dig_tx_clock_gating" "dig_tx_reg_file" "dig_tx_serializer" "dig_tx_rst_sync" "dig_tx_pulse_delayed" "dig_tx_pow_man_unit"  "dig_tx_crc" "dig_tx_fifo_synchronizer" "dig_tx_fifo_wr_ptr_handler" "dig_tx_fifo_re_ptr_handler" "dig_tx_fifo_mem" "dig_tx_asyn_fifo"  "dig_tx_control_unit" "spi_slave" }



foreach block $my_blocks {

analyze -library WORK -format sverilog "$block.sv"
elaborate "$block" -lib work
current_design $block
link
uniquify
compile -exact_map  -map_effort high -area_effort medium -power_effort medium

}


analyze -library WORK -format sverilog "dig_tx_system.sv"

elaborate $DESIGN_NAME -lib work



###################### Defining toplevel ###################################

current_design $DESIGN_NAME

###################### fix multiple nets and buffer any constant net ###################################

set_fix_multiple_port_nets -all -buffer_constants

###################### checking design consistency ###################################

check_design > "./reports/check_design.rpt"


#################### Liniking All The Design Parts #########################

link

uniquify

check_design > "./reports/check_design_after_link.rpt"

#######################################  Constraint ############################################
source "$CONSTRAIN_PATH/cons_v2.tcl"




group_path -name SYS_CLK -weight 40 -critical_range 3.0 -to sys_clock
group_path -name SYS_GATED_CLK -weight 30 -critical_range 2.0 -to sys_gated_clk
group_path -name SPI_GATED_CLK -weight 5 -critical_range 0.5 -to spi_gated_clk
group_path -name SPI_CLK -weight 1 -critical_range 0.0 -to spi_clock
group_path -name ALL_VIOS -weight 1 -critical_range 0.0 -to [all_outputs]



#######################################  Compile  ############################################

compile -exact_map -ungroup_all -map_effort high -area_effort medium -power_effort medium -boundary_optimization

#######################################  Reports_compile  ############################################
report_timing -max_paths 10 -delay_type max  > "./reports/compile/syn_setup.rpt"
report_timing -max_paths 10 -delay_type min  > "./reports/compile/syn_hold.rpt"
report_area > "./reports/compile/syn_area.rpt"
report_qor > "./reports/compile/syn_qor.rpt"
report_power > "./reports/compile/syn_power.rpt"
report_constraint -all_violators > "./reports/compile/syn_violators.rpt"
report_power -hierarchy > "./reports/compile/power_reports.rpt"
report_cell > "./reports/compile/cells_reports.rpt"
report_resources > "./reports/compile/resources.rpt"
report_clock_gating > "./reports/compile/clock_gating_reports.rpt"
report_compile_options > "./reports/compile/compile_options.rpt"



#######################################  write Outputs  ############################################
write_sdc -nosplit "./outputs/${DESIGN_NAME}_1.sdc"
write_file -format ddc -hierarchy -output "./outputs/${DESIGN_NAME}_1.ddc"
write_sdf  "./outputs/${DESIGN_NAME}_1.sdf"
write_file  -format verilog -hierarchy -output "./outputs/${DESIGN_NAME}_1.v"




#######################################
ungroup -all -flatten

compile -exact_map -map_effort high -ungroup_all -area_effort medium -power_effort medium -boundary_optimization -auto_ungroup delay -incremental_mapping

compile -exact_map -map_effort high -ungroup_all -area_effort medium -power_effort medium -boundary_optimization -auto_ungroup delay -incremental_mapping

compile -exact_map -map_effort high -ungroup_all -area_effort medium -power_effort medium -boundary_optimization -auto_ungroup delay -incremental_mapping

#######################################  Reports_compile_incr  ############################################
report_timing -max_paths 10 -delay_type max  > "./reports/compile_incr_high/syn_setup.rpt"
report_timing -max_paths 10 -delay_type min  > "./reports/compile_incr_high/syn_hold.rpt"
report_area > "./reports/compile_incr_high/syn_area.rpt"
report_qor > "./reports/compile_incr_high/syn_qor.rpt"
report_power > "./reports/compile_incr_high/syn_power.rpt"
report_constraint -all_violators > "./reports/compile_incr_high/syn_violators.rpt"
report_power -hierarchy > "./reports/compile_incr_high/power_reports.rpt"
report_cell > "./reports/compile_incr_high/cells_reports.rpt"
report_resources > "./reports/compile_incr_high/resources.rpt"
report_clock_gating > "./reports/compile_incr_high/clock_gating_reports.rpt"
report_compile_options > "./reports/compile_incr_high/compile_options.rpt"
report_auto_ungroup > "./reports/compile_incr_high/outo_ungroup.rpt"



##################### Close Formality Setup file ###########################

set_svf -off




#######################################  write Outputs  ############################################
write_sdc -nosplit "./outputs/${DESIGN_NAME}.sdc"
write_file -format ddc -hierarchy -output "./outputs/${DESIGN_NAME}.ddc"
write_sdf  "./outputs/${DESIGN_NAME}.sdf"
write_file  -format verilog -hierarchy -output "./outputs/${DESIGN_NAME}.v"
