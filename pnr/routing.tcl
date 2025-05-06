
################################################################################Open_Lib
open_lib $ARC_TOP
copy_block -from_block  ${DESIGN_NAME}_5_clock_ends -to temp_clock_ends
open_block temp_clock_ends




set_app_options -name route.global.effort_level -value ultra
set_app_options -name route.global.timing_driven -value true
set_app_options -name route.global.timing_driven_effort_level -value high
#set_app_options -name route.global.crosstalk_driven -value true



################################################################################Checking

check_design -checks pre_route_stage > "../reports/routing/pre_routing.rpt"
check_routability -connect_standard_cells_within_pins true > "../reports/routing/pre_routing_check_route.rpt"


set_propagated_clock [get_clocks]



##################################################################overwrite constrains

remove_clock_uncertainty -setup [all_clocks]
remove_clock_uncertainty -hold [all_clocks]
remove_clock_transition [all_clocks]
remove_input_delay [all_inputs]
remove_output_delay [all_outputs]



set_input_delay  -clock [get_clocks spi_gated_clk] 0.30  [remove_from_collection [all_inputs] [get_ports "i_dig_tx_system_clk32  i_dig_tx_system_clk26"]]

set_output_delay -clock [get_clocks sys_gated_clk] 0.30 [get_ports o_dig_tx_system_data_out]
set_output_delay -clock [get_clocks sys_gated_clk] 0.30 [get_ports o_dig_tx_system_crc_valid]
set_output_delay -clock [get_clocks sys_clock]     0.30 [get_ports o_dig_tx_system_regfile_valid]
set_output_delay -clock [get_clocks sys_clock]     0.30 [get_ports o_dig_tx_system_output_valid]
set_output_delay -clock [get_clocks spi_gated_clk] 0.30 [get_ports o_dig_tx_system_data_slave_out]
set_output_delay -clock [get_clocks sys_clock]     0.30 [get_ports o_dig_tx_system_done]
set_output_delay -clock [get_clocks spi_gated_clk] 0.30 [get_ports o_dig_tx_system_miso_ena]
set_output_delay -clock [get_clocks spi_gated_clk] 0.30 [get_ports o_dig_tx_system_miso]

set_clock_uncertainty -setup 0.300  [all_clocks]
set_clock_uncertainty -hold  0.150  [all_clocks]




set_clock_transition 0.0 [get_clocks sys_clock]


set_min_capacitance 0  [get_lib_pins]




set_ignored_layers -min_routing_layer  ${route_min_layer} -max_routing_layer ${route_max_layer}
report_ignored_layers

################################################################################Route_Optimization
source ./../scripts/mcmm.tcl


route_opt
route_opt
route_opt
remove_ports VDD
remove_ports VSS

################################################################################Connecting_power/Ground_Nets_And_Pins
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

optimize_routes -max_detail_route_iterations 100



check_lvs -max_errors 10000 > "../reports/routing/check_lvs.rpt"

################################################################################# write parasitics
#write_parasitics -corner fast -format spef -output  "../reports/extraction/${DESIGN_NAME}_min.spef"
#write_parasitics -corner slow -format spef -output  "../reports/extraction/${DESIGN_NAME}_max.spef"



################################################################################Reports
set_app_option -name time.snapshot_storage_location -value "./"
create_qor_snapshot -name route -significant_digits 4
report_congestion
write_verilog -include {pg_netlist} "../outputs/${DESIGN_NAME}_pt.v"
write_sdc -output "../outputs/${DESIGN_NAME}_sdc.sdc"

check_routes > "../reports/routing/routes.rpt"
check_routability > "../reports/routing/routability.rpt"
report_congestion > "../reports/routing/congestion.rpt"
report_utilization > "../reports/routing/utilization.rpt"
report_qor_snapshot > "../reports/routing/route.qor_snapshot.rpt"
report_qor -summary > "../reports/routing/route.qor"
report_constraints -all_violators > "../reports/routing/route.con"
report_timing -capacitance -transition_time -input_pins -nets -delay_type max > "../reports/routing/route.max.tim"
report_timing -capacitance -transition_time -input_pins -nets -delay_type min > "../reports/routing/route.min.tim"
report_global_timing -sig 3 > "../reports/routing/route.global.tim.rpt"

################################################################################Save_Cell
save_block -as ${DESIGN_NAME}_6_complete
save_lib

close_block
close_lib

