############################################################
#################       Parameters      ####################
############################################################
set SYS_CLK_PERIOD 1.00
set SPI_CLK_PERIOD 1.00


set SYS_UNCERTAINTY_SETUP  0.300
set SPI_UNCERTAINTY_SETUP  0.300

set SYS_UNCERTAINTY_HOLD  0.150
set SPI_UNCERTAINTY_HOLD  0.150

set CLOCK_TRANSITION 0.03

set INPUT_DELAY  [expr 0.4*$SPI_CLK_PERIOD]
set OUTPUT_DELAY [expr 0.4*$SYS_CLK_PERIOD]

############################################################
#################   Clock Constraints   ####################
############################################################

create_clock -name sys_clock -period $SYS_CLK_PERIOD [get_ports i_dig_tx_system_clk32]
create_clock -name spi_clock -period $SPI_CLK_PERIOD [get_ports i_dig_tx_system_clk26]

## clock transition
#set_clock_transition $CLOCK_TRANSITION [get_clocks sys_clock]
#set_clock_transition $CLOCK_TRANSITION [get_clocks spi_clock]

## Generated Clocks
create_generated_clock -name sys_gated_clk -source [get_ports i_dig_tx_system_clk32] -master_clock sys_clock -divide_by 1 [get_ports u_dig_tx_sys_clock_gating/o_dig_tx_clock_gating_gated_clock]

create_generated_clock -name spi_gated_clk -source [get_ports i_dig_tx_system_clk26] -master_clock spi_clock -divide_by 1 [get_ports u_dig_tx_spi_clock_gating/o_dig_tx_clock_gating_gated_clock]

## clock groups
set_clock_groups -asynchronous -group {sys_clock sys_gated_clk}  -group {spi_clock spi_gated_clk}

set_clock_uncertainty -setup $SPI_UNCERTAINTY_SETUP  [all_clocks]
set_clock_uncertainty -hold $SPI_UNCERTAINTY_HOLD [all_clocks]

##################################################################
#################   environment constraints   ####################
##################################################################
## input & output delays
set_input_delay  -clock [get_clocks spi_gated_clk] $INPUT_DELAY  [remove_from_collection [all_inputs] [get_ports "i_dig_tx_system_clk32  i_dig_tx_system_clk26"]]

set_output_delay -clock [get_clocks sys_gated_clk] $OUTPUT_DELAY [get_ports o_dig_tx_system_data_out]
set_output_delay -clock [get_clocks sys_gated_clk] $OUTPUT_DELAY [get_ports o_dig_tx_system_crc_valid]
set_output_delay -clock [get_clocks sys_clock]     $OUTPUT_DELAY [get_ports o_dig_tx_system_regfile_valid]
set_output_delay -clock [get_clocks sys_clock]     $OUTPUT_DELAY [get_ports o_dig_tx_system_output_valid]
set_output_delay -clock [get_clocks spi_gated_clk] $OUTPUT_DELAY [get_ports o_dig_tx_system_data_slave_out]
set_output_delay -clock [get_clocks sys_clock]     $OUTPUT_DELAY [get_ports o_dig_tx_system_done]
set_output_delay -clock [get_clocks spi_gated_clk] $OUTPUT_DELAY [get_ports o_dig_tx_system_miso_ena]
set_output_delay -clock [get_clocks spi_gated_clk] $OUTPUT_DELAY [get_ports o_dig_tx_system_miso]

## outside environment
#set_driving_cell -library saed32hvt_ss0p7vn40c -lib_cell NBUFFX2_HVT -pin Y [all_inputs]
#set_load 50 [all_outputs]


set_driving_cell -library saed14hvt_base_ss0p72vm40c -lib_cell SAEDHVT14_BUF_1 -pin X [all_inputs]
set_load 0.05 [all_outputs]

###########################Operating Condition ##############################


set_operating_conditions -min_library "saed14slvt_base_ff0p88v125c" -min "ff0p88v125c" -max_library "saed14hvt_base_ss0p72vm40c" -max "ss0p72vm40c"

###########################wireload Model ##################################################

set_wire_load_model  -name 16000 -library saed14hvt_base_ss0p72vm40c

###########################area ##################################################

set_max_area 0

