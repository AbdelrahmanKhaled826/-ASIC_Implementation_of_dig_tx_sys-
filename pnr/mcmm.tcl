
########################################################################
########################   Corners & Modes    ##########################
########################################################################

### remove any saved scenarios
remove_corners -all
remove_modes -all
remove_scenarios -all


###creat new corner

create_corner slow
create_corner fast

### read parasitic

read_parasitic_tech \
        -tlup $Tlup_max_file \
        -layermap $Map_file \
        -name tlup_max

read_parasitic_tech \
        -tlup $Tlup_min_file \
        -layermap $Map_file \
        -name tlup_min

set_parasitics_parameters \
        -early_spec tlup_min \
        -late_spec tlup_min \
        -corners {fast}

set_parasitics_parameters \
        -early_spec tlup_max \
        -late_spec tlup_max \
        -corners {slow}

create_mode func

######################### FUNC MODE #############################

current_mode func

create_scenario -mode func -corner fast -name func_fast
create_scenario -mode func -corner slow -name func_slow


current_scenario func_fast
read_sdc $Constraints_file


current_scenario func_slow
read_sdc $Constraints_file
