
################################################################################ open library
open_lib $ARC_TOP
copy_block -from_block  ${DESIGN_NAME}_3_powerplan_ends -to temp_1_powerplan_ends
open_block  temp_1_powerplan_ends
################################################################################Checking
report_lib $ARC_TOP

###############################Pre place checks##########################
check_design -checks pre_placement_stage > "../reports/placement/pre_placement.rpt"

################################################################################General Optimization
set_app_options -name time.disable_recovery_removal_checks -value false
set_app_options -name time.disable_case_analysis -value false
set_app_options -name place.coarse.continue_on_missing_scandef -value true
#set_app_options -name place.coarse.congestion_analysis_effort -value high
set_app_options -name opt.common.hold_effort -value high

set_app_options -name opt.timing.effort -value high





################################################################################Place_Optimization
set_app_options -name opt.common.user_instance_name_prefix -value place

source ./../scripts/mcmm.tcl


##################################################################overwrite constrains

remove_clock_uncertainty -setup [all_clocks]
remove_clock_uncertainty -hold [all_clocks]
remove_clock_transition [all_clocks]
remove_input_delay [all_inputs]
remove_output_delay [all_outputs]



set_input_delay  -clock [get_clocks spi_gated_clk] 0.40  [remove_from_collection [all_inputs] [get_ports "i_dig_tx_system_clk32  i_dig_tx_system_clk26"]]

set_output_delay -clock [get_clocks sys_gated_clk] 0.40 [get_ports o_dig_tx_system_data_out]
set_output_delay -clock [get_clocks sys_gated_clk] 0.40 [get_ports o_dig_tx_system_crc_valid]
set_output_delay -clock [get_clocks sys_clock]     0.40 [get_ports o_dig_tx_system_regfile_valid]
set_output_delay -clock [get_clocks sys_clock]     0.40 [get_ports o_dig_tx_system_output_valid]
set_output_delay -clock [get_clocks spi_gated_clk] 0.40 [get_ports o_dig_tx_system_data_slave_out]
set_output_delay -clock [get_clocks sys_clock]     0.40 [get_ports o_dig_tx_system_done]
set_output_delay -clock [get_clocks spi_gated_clk] 0.40 [get_ports o_dig_tx_system_miso_ena]
set_output_delay -clock [get_clocks spi_gated_clk] 0.40 [get_ports o_dig_tx_system_miso]

set_clock_uncertainty -setup 0.310  [all_clocks]
set_clock_uncertainty -hold  0.155  [all_clocks]




set_clock_transition 0.0 [get_clocks sys_clock]

set_min_capacitance 0  [get_lib_pins]

#########################Placement Optimization ##########################
create_placement -effort high -timing_driven
create_placement -effort high -timing_driven -incremental
create_placement -effort high -timing_driven -incremental
create_placement -effort high -timing_driven -incremental

# create_placement_blockage -type soft -boundary { {46.75  43.055} {51.34 43.62}}

place_opt

place_opt

legalize_placement


################################################################################# insert tie cells
add_tie_cells

legalize_placement -incremental
legalize_placement -incremental

################################################################################ connect cells to pg
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

remove_ports VDD
remove_ports VSS


################################################################################Reports
set_app_option -name time.snapshot_storage_location -value "./"
create_qor_snapshot -name place_qor_snp -significant_digits 4

report_qor_snapshot -name place_qor_snp > "../reports/placement/place.qor_snapshot.rpt"
report_qor > "../reports/placement/place.qor.rpt"
report_constraints -all_violators > "../reports/placement/place.con.rpt"
report_timing -capacitance -transition_time -input_pins -nets -delay_type max > "../reports/placement/place.max.tim.rpt"
report_timing -capacitance -transition_time -input_pins -nets -delay_type min > "../reports/placement/place.min.tim.rpt"
report_global_timing -sig 3 > "../reports/placement/place.global.tim.rpt"
report_utilization >  "../reports/placement/utalization.rpt"
check_legality > "../reports/placement/legality.rpt"

################################################################################Save_Block
save_block -as ${DESIGN_NAME}_4_place_ends
save_lib
################################################################################

close_block
close_lib
