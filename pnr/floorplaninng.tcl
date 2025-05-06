
#################################################################################
open_lib $ARC_TOP

copy_block -from_block ${DESIGN_NAME}_1_data_setup -to temp_data_setup
open_block temp_data_setup

################################################################################Checking
report_lib $ARC_TOP > "../reports/floorplanning/report_lib.rpt"

################################################################################Reports
#report clock name and period and waveform (all attrebuits of clock)
report_clocks -skew -attributes > "../reports/floorplanning/clock_attributes.rpt"
#writes a report showing information  about  timing  exceptions && identify  the  reasons  an exception  is  ignored
report_exceptions > "../reports/floorplanning/exceptions.rpt"
report_disable_timing > "../reports/floorplanning/disable_timing.rpt"

#########################################################################overwrite constrains

remove_clock_uncertainty -setup [all_clocks]
remove_clock_uncertainty -hold [all_clocks]
remove_clock_transition [all_clocks]
remove_input_delay [all_inputs]
remove_output_delay [all_outputs]





set_input_delay  -clock [get_clocks spi_gated_clk] 0.42  [remove_from_collection [all_inputs] [get_ports "i_dig_tx_system_clk32  i_dig_tx_system_clk26"]]

set_output_delay -clock [get_clocks sys_gated_clk] 0.42 [get_ports o_dig_tx_system_data_out]
set_output_delay -clock [get_clocks sys_gated_clk] 0.42 [get_ports o_dig_tx_system_crc_valid]
set_output_delay -clock [get_clocks sys_clock]     0.42 [get_ports o_dig_tx_system_regfile_valid]
set_output_delay -clock [get_clocks sys_clock]     0.42 [get_ports o_dig_tx_system_output_valid]
set_output_delay -clock [get_clocks spi_gated_clk] 0.42 [get_ports o_dig_tx_system_data_slave_out]
set_output_delay -clock [get_clocks sys_clock]     0.42 [get_ports o_dig_tx_system_done]
set_output_delay -clock [get_clocks spi_gated_clk] 0.42 [get_ports o_dig_tx_system_miso_ena]
set_output_delay -clock [get_clocks spi_gated_clk] 0.42 [get_ports o_dig_tx_system_miso]

set_clock_uncertainty -setup 0.350  [all_clocks]
set_clock_uncertainty -hold  0.160  [all_clocks]

set_clock_transition 0.0 [get_clocks sys_clock]

set_min_capacitance 0  [get_lib_pins]







################################################################################Set_Power/Ground_Nets_And_Pins
set power                           "VDD"
set ground                          "VSS"
set powerPort                       "VDD"
set groundPort                      "VSS"
set ndm_logic0_net                  "VSS"
set ndm_logic1_net                  "VDD"
################################################################################Set_Options
#to control the recovery and removely time checks to make it enable or disable
#this for make STA take recovery and removal time in calculation

set_app_option -name time.disable_recovery_removal_checks -value false
set_app_option -name time.disable_case_analysis -value false



group_path -name INPUT -weight 20 -critical_range 0.2 -from [all_inputs] -to [all_registers]
group_path -name OUTPUT -weight 10 -critical_range 0.2 -from [all_registers] -to [all_outputs]
group_path -name REG -weight 50 -critical_range 0.4 -from [all_registers] -to [all_registers]
group_path -name SYS_CLK -weight 40 -critical_range 0.2 -to sys_clock
group_path -name SYS_GATED_CLK -weight 30 -critical_range 0.2 -to sys_gated_clk
group_path -name SPI_GATED_CLK -weight 20 -critical_range 0.1 -to spi_gated_clk
group_path -name COMBO -weight 1 -critical_range 0.0 -from [all_inputs] -to [all_outputs]


################################################################################Save_Block
save_block -as temp_floorplan_init


################################################################################Defining_Prefered_Routing_Directions
set_ignored_layers -min_routing_layer ${route_min_layer} -max_routing_layer ${pns_vlayer}
set_attribute [get_layers M1] routing_direction vertical
set_attribute [get_layers M2] routing_direction horizontal
set_attribute [get_layers M3] routing_direction vertical
set_attribute [get_layers M4] routing_direction horizontal
set_attribute [get_layers M5] routing_direction vertical
set_attribute [get_layers M6] routing_direction horizontal
set_attribute [get_layers M7] routing_direction vertical
set_attribute [get_layers M8] routing_direction horizontal
set_attribute [get_layers M9] routing_direction vertical



################################################################################Create_Floorplan
#define a track pattarn on metal1

set_wire_track_pattern -site_def unit -layer M1 -mode uniform -mask_constraint {mask_two mask_one} \
-coord 0.037 -space 0.074 -direction vertical

initialize_floorplan -core_utilization 0.35 -flip_first_row true \
                        -core_offset {10 10 10 10}

#initialize_floorplan -core_utilization 0.25 -flip_first_row true -row_core_ratio 0.6 -core_offset {10 10 10 10}


################################################################################Ports_Placement
place_pins -ports [get_ports *]



################################################################################Defining_Power/Ground_Nets_And_Pins
create_net -power VDD
create_net -ground VSS
set_attribute -objects [get_nets VDD] -name net_type -value power
set_attribute -objects [get_nets VSS] -name net_type -value ground
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]
check_mv_design > "../reports/floorplanning/mv_check.rpt"


################################################################################Save_Block
save_block -as temp_floorplane

################################################################################ Boundary cells insertion
set_boundary_cell_rules -prefix boundary -insert_into_blocks -at_va_boundary -left_boundary_cell */SAEDLVT14_CAPB2 -right_boundary_cell */SAEDLVT14_CAPB2
compile_boundary_cells
#compile_targeted_boundary_cells -all_targets


check_boundary_cells > "../reports/floorplanning/boundry_cell_check.rpt"

create_tap_cells -lib_cell [get_lib_cells saed14rvt_base_ff0p88v125c/SAEDRVT14_TAPDS] -distance 25 -pattern stagger



################################################################################Create_Floorplane_Placement


#size_cell U336 SAEDLVT14_BUF_1

create_placement -floorplan -timing_driven -effort high

create_placement -floorplan -timing_driven -effort high -incremental
create_placement -floorplan -timing_driven -effort high -incremental
legalize_placement

route_global -floorplan true -congestion_map_only true -effort_level high

report_placement > "../reports/floorplanning/floorplacement.rpt"
report_utilization > "../reports/floorplanning/utilization.rpt"
report_qor -summary > "../reports/floorplanning/qor.rpt"
report_timing -delay_type max -max_paths 5 > "../reports/floorplanning/setup_delay.rpt"
report_global_timing > "../reports/floorplanning/global_timing.rpt"

set_app_option -name time.snapshot_storage_location -value "./"
create_qor_snapshot -name floor_qor_snp -significant_digits 4

report_qor_snapshot -name floor_qor_snp > "../reports/floorplanning/floor.qor_snapshot.rpt"


save_block -as ${DESIGN_NAME}_2_floorplan_ends
save_lib
################################################################################
close_block
close_lib



