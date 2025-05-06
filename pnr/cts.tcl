

################################################################################Open_Lib
open_lib $ARC_TOP
copy_block -from_block  ${DESIGN_NAME}_4_place_ends -to temp_place_ends
open_block temp_place_ends
################################################################################Checking

check_legality  -verbose >  "../reports/cts/place_legality.rpt"
check_design -checks pre_clock_tree_stage > "../reports/cts/pre_cts_check.rpt"





################################################################################Set_Clock_Tree_Options
#set_propagated_clock [all_clocks]
#set_max_transition 3   -clock_path [get_clocks]
#set_max_capacitance 3  -clock_path [get_clocks]

set_ignored_layers -min_routing_layer ${route_min_layer} -max_routing_layer ${route_max_layer}

set_app_options -name cts.compile.enable_cell_relocation -value all
set_app_options -name cts.compile.size_pre_existing_cell_to_cts_references -value true
set_app_options -name cts.compile.timing_driven_sink_transition -value true
set_app_options -name clock_opt.flow.enable_ccd -value true
set_app_options -name ccd.timing_effort -value high
set_app_options -name cts.compile.enable_local_skew -value true
set_app_options -name ccd.hold_control_effort -value ultra
set_app_options -name opt.common.hold_effort -value high
set_app_options -name cts.compile.enable_global_route -value true




##################################################################overwrite constrains

remove_clock_uncertainty -setup [all_clocks]
remove_clock_uncertainty -hold [all_clocks]
remove_clock_transition [all_clocks]
remove_input_delay [all_inputs]
remove_output_delay [all_outputs]



set_input_delay  -clock [get_clocks spi_gated_clk] 0.35  [remove_from_collection [all_inputs] [get_ports "i_dig_tx_system_clk32  i_dig_tx_system_clk26"]]

set_output_delay -clock [get_clocks sys_gated_clk] 0.35 [get_ports o_dig_tx_system_data_out]
set_output_delay -clock [get_clocks sys_gated_clk] 0.35 [get_ports o_dig_tx_system_crc_valid]
set_output_delay -clock [get_clocks sys_clock]     0.35 [get_ports o_dig_tx_system_regfile_valid]
set_output_delay -clock [get_clocks sys_clock]     0.35 [get_ports o_dig_tx_system_output_valid]
set_output_delay -clock [get_clocks spi_gated_clk] 0.35 [get_ports o_dig_tx_system_data_slave_out]
set_output_delay -clock [get_clocks sys_clock]     0.35 [get_ports o_dig_tx_system_done]
set_output_delay -clock [get_clocks spi_gated_clk] 0.35 [get_ports o_dig_tx_system_miso_ena]
set_output_delay -clock [get_clocks spi_gated_clk] 0.35 [get_ports o_dig_tx_system_miso]

set_clock_uncertainty -setup 0.302  [all_clocks]
set_clock_uncertainty -hold  0.151  [all_clocks]




set_clock_transition 0.0 [get_clocks sys_clock]


group_path -name INPUT -weight 10 -critical_range 0.1 -from [all_inputs] -to [all_registers]
group_path -name OUTPUT -weight 20 -critical_range 0.1 -from [all_registers] -to   [all_outputs]
group_path -name REG2REG  -weight 60  -critical_range 0.1  -from [all_registers] -to [all_registers]
group_path -name SYS_CLK -weight 40 -critical_range 0.2 -to sys_clock
group_path -name SYS_GATED_CLK -weight 30 -critical_range 0.2 -to sys_gated_clk
group_path -name SPI_GATED_CLK -weight 20 -critical_range 0.1 -to spi_gated_clk
group_path -name COMBO -weight 1 -critical_range 0.0 -from [all_inputs] -to [all_outputs]


set_clock_tree_options  -target_skew 0 -target_latency 0

#set_clock_tree_options -clocks sys_clock -target_skew 0.3 -target_latency 0.0

################################################################################Set_Clock_Tree_References


remove_attribute [get_lib_cells saed14slvt_base_ff0p88v125c/*] dont_use
remove_attribute [get_lib_cells saed14slvt_base_ss0p72vm40c/*] dont_use
remove_attribute [get_lib_cells saed14slvt_base_tt0p8v25c/*] dont_use


set_lib_cell_purpose -include cts {*/SAEDLVT14_INV_S_1 */SAEDLVT14_INV_S_2 */SAEDLVT14_INV_S_4 */SAEDLVT14_INV_S_8 */SAEDLVT14_INV_S_16 */SAEDLVT14_INV_S_20 \
*/SAEDLVT14_BUF_S_2 */SAEDLVT14_BUF_S_4 */SAEDLVT14_BUF_S_6 */SAEDLVT14_BUF_S_8 */SAEDLVT14_BUF_S_16 */SAEDLVT14_BUF_S_20 \
*/SAEDSLVT14_INV_S_1 */SAEDSLVT14_INV_S_2 */SAEDSLVT14_INV_S_4 */SAEDSLVT14_INV_S_8 */SAEDSLVT14_INV_S_16 */SAEDSLVT14_INV_S_20 \
*/SAEDSLVT14_BUF_S_2 */SAEDSLVT14_BUF_S_4 */SAEDSLVT14_BUF_S_6 */SAEDSLVT14_BUF_S_8 */SAEDSLVT14_BUF_S_16 */SAEDSLVT14_BUF_S_20  }





create_routing_rule CLK_SPACING -spacings {M2 0.3 M3 0.5 M4 0.7}
set_clock_routing_rules -rules CLK_SPACING -min_routing_layer M2 -max_routing_layer M5

report_clock_settings >  "../reports/cts/clk_setting.rpt"

set_app_options -name opt.common.user_instance_name_prefix -value clock



source ./../scripts/mcmm.tcl
#clock_opt -from build_clock -to build_clock

################################################################################Save_Cell
#set_app_option -name time.snapshot_storage_location -value "./"
#create_qor_snapshot -name clock_pre_route -significant_digits 4

################################################################################Reports

#report_qor_snapshot -name clock_pre_route >  "../reports/cts/clock_pre_route.qor_snapshot.rpt"
#report_qor > "../reports/cts/clock_pre_route_qor.rpt"
#report_constraints -all_violators > "../reports/cts/clock_pre_route_constarins"
#report_timing -capacitance -transition_time -input_pins -nets -delay_type max > "../reports/cts/clock_pre_route.max.tim.rpt"
#report_timing -capacitance -transition_time -input_pins -nets -delay_type min > "../reports/cts/clock_pre_route.min.tim.rpt"


################################################################################Clock_optimiaztion
set_app_options -name opt.common.user_instance_name_prefix -value clock
#clock_opt -from route_clock -to final_opto

clock_opt
set_min_capacitance 0.0  [get_lib_pins]
legalize_placement

################################################################################Connecting_power/Ground_Nets_And_Pins
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

remove_ports VDD
remove_ports VSS
################################################################################Reports
create_qor_snapshot -name clock -significant_digits 4
report_qor_snapshot -name clock > "../reports/cts/clock.qor_snapshot.rpt"

report_clock_qor > "../reports/cts/clock_tree_qor.rpt"
report_clock_timing -type skew > "../reports/cts/clock_timing.rpt"
report_qor -summary > "../reports/cts/clock.qor.rpt"
report_constraints -all_violators > "../reports/cts/clock_route.constrains.rpt"
report_timing -capacitance -transition_time -input_pins -nets -delay_type max > "../reports/cts/clock.max.tim.rpt"
report_timing -capacitance -transition_time -input_pins -nets -delay_type min > "../reports/cts/clock.min.tim.rpt"
report_global_timing -sig 3 > "../reports/cts/clock.global.tim.rpt"
check_clock_trees > "../reports/cts/cts_route_check.rpt"

################################################################################Save_Block

write_sdc -output "../outputs/${DESIGN_NAME}_cts_sdc.sdc"
save_block -as ${DESIGN_NAME}_5_clock_ends
save_lib

close_block
close_lib
