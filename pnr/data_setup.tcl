
################################################################################Create_library
sh rm -fr $ARC_TOP
create_lib $ARC_TOP \
                -technology $Tech_file  \
                -ref_libs $REFERENCE_LIB

################################################################################Set_Tluplus_Files
read_parasitic_tech -tlup "$Tlup_max_file $Tlup_min_file" \
                    -layermap $Map_file

################################################################################Import_Design
read_verilog "$Core_compile"
current_design ${DESIGN_NAME}
source $Constraints_file


################################################################################Checking

report_ports -drive > "../reports/floorplanning/driving_cells.rpt"

################################################################################Save_Block
save_block -as ${DESIGN_NAME}_1_data_setup
save_lib

close_block
close_lib
