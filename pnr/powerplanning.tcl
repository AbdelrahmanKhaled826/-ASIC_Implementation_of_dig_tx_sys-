
open_lib $ARC_TOP
copy_block -from_block ${DESIGN_NAME}_2_floorplan_ends -to temp_floorplan_ends
open_block temp_floorplan_ends


################################################################################ remove all strategies
remove_pg_strategy_via_rules -all
remove_pg_strategies -all
remove_pg_regions -all
remove_pg_via_master_rules -all
remove_pg_patterns -all
remove_routes -net_types {power ground} -stripe -lib_cell_pin_connect -macro_pin_connect  -ring

report_pg_strategies > "../reports/powerplanning/strategies_before_pg.rpt"


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



################################################################################Power_Planing
create_net -power VDD
create_net -ground VSS

set_attribute -objects [get_nets VDD] -name net_type -value power
set_attribute -objects [get_nets VSS] -name net_type -value ground

connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

###############################################################################Create_STD_Cells_Rail
create_pg_std_cell_conn_pattern M1_rail -layers {M1} -rail_width {@wtop @wbottom} -parameters {wtop wbottom}

set_pg_strategy M1_rail_strategy_pwr -core -pattern {{name: M1_rail} {nets: VDD} {parameters: {0.094 0.094}}}
set_pg_strategy M1_rail_strategy_gnd -core -pattern {{name: M1_rail} {nets: VSS} {parameters: {0.094 0.094}}}



compile_pg -strategies M1_rail_strategy_pwr
compile_pg -strategies M1_rail_strategy_gnd

################################################################################Create_MOD_Vertical_Mesh
#create_pg_mesh_pattern MOD_MESH_VERTICAL \
#       -layers " \
#               { {vertical_layer: M5}   {width: 0.3} {spacing: interleaving} {pitch: 4} {offset: 0.5}  {trim : true} } \
#               "

#set_pg_strategy VDDVSS_MOD_MESH_VERTICAL \
#       -core \
#       -pattern   { {name: MOD_MESH_VERTICAL} {nets:{VSS VDD}} } \
#       -extension { {{stop:design_boundary_and_generate_pin}} }

#compile_pg -strategies {VDDVSS_MOD_MESH_VERTICAL} -ignore_drc



################################################################################Create_Top_horizontal_Mesh
create_pg_mesh_pattern TOP_MESH_HORIZONTAL \
        -layers " \
                { {horizontal_layer: M6}   {width: 0.3} {spacing: interleaving} {pitch: 3.6} {offset: 0.0}  {trim : true} } \
                "


set_pg_strategy VDDVSS_TOP_MESH_HORIZONTAL \
        -core \
        -pattern   { {name: TOP_MESH_HORIZONTAL} {nets:{VDD VSS}} } \
        -extension { {{stop:design_boundary_and_generate_pin}} }



compile_pg -strategies {VDDVSS_TOP_MESH_HORIZONTAL}

################################################################################Create_Top_vertical_Mesh
create_pg_mesh_pattern TOP_MESH_VERTICAL \
        -layers " \
                { {vertical_layer: M7}   {width: 0.3} {spacing: interleaving} {pitch: 4} {offset: 0.5}  {trim : true} } \
                "



set_pg_strategy VDDVSS_TOP_MESH_VERTICAL \
        -core \
        -pattern   { {name: TOP_MESH_VERTICAL} {nets:{VSS VDD}} } \
        -extension { {{stop:design_boundary_and_generate_pin}} }



compile_pg -strategies {VDDVSS_TOP_MESH_VERTICAL}


################################################################################Create_Rectangular_Rings
create_pg_ring_pattern \
                 ring_pattern \
                 -horizontal_layer M6  -vertical_layer M7 \
                 -horizontal_width 1 -vertical_width 1 \
                 -horizontal_spacing 3 -vertical_spacing 3


set_pg_strategy RING -core -pattern {{ name: ring_pattern} { nets: "VSS VDD" } {offset:{1 1}}}

compile_pg -strategies RING

check_pg_connectivity -nets "VDD VSS"




set_pg_via_master_rule PG_VIA_3x1 -cut_spacing 0.25 -via_array_dimension {3 1}
create_pg_vias -to_layers M7 -from_layers M1 -via_masters PG_VIA_3x1 -nets VDD
create_pg_vias -to_layers M7 -from_layers M1 -via_masters PG_VIA_3x1 -nets VSS



################################################################################# Reports
set_app_option -name time.snapshot_storage_location -value "./"
create_qor_snapshot -name power_qor_snp -significant_digits 4

report_qor_snapshot -name power_qor_snp > "../reports/powerplanning/power.qor_snapshot.rpt"


check_pg_drc > "../reports/powerplanning/check_pg_drc.rpt"
check_pg_missing_vias > "../reports/powerplanning/check_pg_missing_vias.rpt"
check_pg_connectivity > "../reports/powerplanning/check_pg_connectivity.rpt"
report_qor -summary > "../reports/powerplanning/qor.rpt"
check_pg_drc -check_metal_on_track true > "../reports/powerplanning/check_drc.rpt"
report_congestion > "../reports/powerplanning/congestion.rpt"
################################################################################Save_Block
save_block -as ${DESIGN_NAME}_3_powerplan_ends
save_lib
close_block
close_lib

