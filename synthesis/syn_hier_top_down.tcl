
source /home/svgpasic25abkhaled/GP/synthesis/common_setup.tcl

########################### Define Top Module ############################

set DESIGN_NAME "dig_tx_system"

##################### Define Working Library Directory ######################
sh rm -rf work
sh rm -rf outputs
sh rm -rf reports
sh rm -rf ./reports/compile
sh rm -rf ./reports/compile_incr_high


define_design_lib work -path ./work
sh mkdir ./outputs
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

source /home/svgpasic25abkhaled/GP/synthesis/analyze_script.tcl
elaborate $DESIGN_NAME -lib work

###################### Defining toplevel ###################################

current_design $DESIGN_NAME

###################### fix multiple nets and buffer any constant net ###################################

set_fix_multiple_port_nets -all -buffer_constants

###################### checking design consistency ###################################

check_design > "./reports/check_design.rpt"



#################### Prevent tool from using SLVT cells initially#####################

set_dont_use [get_lib_cells saed14slvt_base_ff0p88v125c/*]
set_dont_use [get_lib_cells saed14slvt_base_ss0p72vm40c/*]
set_dont_use [get_lib_cells saed14slvt_base_tt0p8v25c/*]


#################### Liniking All The Design Parts #########################

link

uniquify

#######################################  Constraint ############################################
source "$CONSTRAIN_PATH/cons_v2.tcl"



group_path -name SYS_CLK -weight 40 -critical_range 0.4 -to sys_clock
group_path -name SYS_GATED_CLK -weight 30 -critical_range 0.3 -to sys_gated_clk
group_path -name SPI_GATED_CLK -weight 2 -critical_range 0.1 -to spi_gated_clk
group_path -name SPI_CLK -weight 1 -critical_range 0.0 -to spi_clock



#######################################  Compile  ############################################
#compile -map_effort high -gate_clock -area_effort medium -power_effort none

compile -exact_map -map_effort high  -area_effort medium -power_effort medium
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




######################### Let tool swap in LVT only if needed to meet timing##############

compile -exact_map -map_effort high -area_effort medium -power_effort none -incremental_mapping

compile -exact_map -map_effort high -area_effort medium -power_effort none -incremental_mapping

compile -exact_map -map_effort high -area_effort medium -power_effort none -incremental_mapping

compile -exact_map -map_effort high -area_effort medium -power_effort none -incremental_mapping

compile -exact_map -map_effort high -area_effort medium -power_effort none -incremental_mapping

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


##################### Close Formality Setup file ###########################

set_svf -off

remove_attribute [get_lib_cells saed14slvt_base_ff0p88v125c/*] dont_use
remove_attribute [get_lib_cells saed14slvt_base_ss0p72vm40c/*] dont_use
remove_attribute [get_lib_cells saed14slvt_base_tt0p8v25c/*] dont_use


#######################################  write Outputs  ############################################
write_sdc -nosplit "./outputs/${DESIGN_NAME}.sdc"
write_file -format ddc -hierarchy -output "./outputs/${DESIGN_NAME}.ddc"
write_sdf  "./outputs/${DESIGN_NAME}.sdf"
write_file  -format verilog -hierarchy -output "./outputs/${DESIGN_NAME}.v"
