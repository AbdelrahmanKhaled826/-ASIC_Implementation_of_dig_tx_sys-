
####################################################################################### Main_PATH
set ROOT_DIR        "/home/svgpasic25abkhaled/GP"
set DESIGN_REF_PATH "/home/tools/PDK/SAED14_EDK"
set VERILOG_DIR     "/home/svgpasic25abkhaled/GP/synthesis/syn_new_cons/syn_hier_top_down_2/outputs"


###########################################################inputs

set DESIGN_NAME     "dig_tx_system"

set Constraints_file      "${ROOT_DIR}/synthesis/syn_new_cons/syn_hier_top_down_2/outputs/${DESIGN_NAME}.sdc"
set Core_compile          "${ROOT_DIR}/synthesis/syn_new_cons/syn_hier_top_down_2/outputs/${DESIGN_NAME}.v"


########################################################## outputs

set Svf_file              "${ROOT_DIR}/pnr/hier_top_down2/results/${DESIGN_NAME}.svf"
set ARC_TOP               "${ROOT_DIR}/pnr/hier_top_down2/results/${DESIGN_NAME}.ndm"
set Top_design_pt         "${ROOT_DIR}/pnr/hier_top_down2/results/${DESIGN_NAME}_pt.v"

###########################################################Variables

set pns_vlayer M7
set pns_hlayer M6
set route_min_layer M2
set route_max_layer M7


#################################################################################REF_PATH

set DESIGN_REF_TECH_PATH "${DESIGN_REF_PATH}/SAED14nm_EDK_TECH_DATA"

#######################################################################################Liberty
set Std_cell_lib         "${DESIGN_REF_PATH}/SAED14nm_EDK_STD_LVT/liberty/nldm/base/saed14lvt_base_ff0p88v125c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_LVT/liberty/nldm/base/saed14lvt_base_ss0p72vm40c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_LVT/liberty/nldm/base/saed14lvt_base_tt0p8v25c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_RVT/liberty/nldm/base/saed14rvt_base_ff0p88v125c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_RVT/liberty/nldm/base/saed14rvt_base_ss0p72vm40c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_RVT/liberty/nldm/base/saed14rvt_base_tt0p8v25c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_HVT/liberty/nldm/base/saed14hvt_base_ff0p88v125c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_HVT/liberty/nldm/base/saed14hvt_base_ss0p72vm40c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_HVT/liberty/nldm/base/saed14hvt_base_tt0p8v25c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_SLVT/liberty/nldm/base/saed14slvt_base_ff0p88v125c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_SLVT/liberty/nldm/base/saed14slvt_base_ss0p72vm40c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_SLVT/liberty/nldm/base/saed14slvt_base_tt0p8v25c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_LVT/liberty/nldm/cg/saed14lvt_cg_ff0p88v125c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_LVT/liberty/nldm/cg/saed14lvt_cg_ss0p72vm40c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_LVT/liberty/nldm/cg/saed14lvt_cg_tt0p8v25c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_RVT/liberty/nldm/cg/saed14rvt_cg_ff0p88v125c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_RVT/liberty/nldm/cg/saed14rvt_cg_ss0p72vm40c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_RVT/liberty/nldm/cg/saed14rvt_cg_tt0p8v25c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_HVT/liberty/nldm/cg/saed14hvt_cg_ff0p88v125c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_HVT/liberty/nldm/cg/saed14hvt_cg_ss0p72vm40c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_HVT/liberty/nldm/cg/saed14hvt_cg_tt0p8v25c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_SLVT/liberty/nldm/cg/saed14slvt_cg_ff0p88v125c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_SLVT/liberty/nldm/cg/saed14slvt_cg_ss0p72vm40c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_SLVT/liberty/nldm/cg/saed14slvt_cg_tt0p8v25c.db "


#######################################################################################


set REFERENCE_LIB "/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_STD_LVT/ndm/saed14lvt_frame_only.ndm \
/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_STD_SLVT/ndm/saed14slvt_frame_only.ndm \
/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_STD_HVT/ndm/saed14hvt_frame_only.ndm \
/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_STD_RVT/ndm/saed14rvt_frame_only.ndm "

set Std_cell_gds        "/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_STD_RVT/gds/saed14rvt.gds \
/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_STD_SLVT/gds/saed14slvt.gds \
/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_STD_HVT/gds/saed14hvt.gds \
/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_STD_LVT/gds/saed14lvt.gds "


set Tech_file             "/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_TECH_DATA/tf/saed14nm_1p9m.tf"
set Map_file              "/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_TECH_DATA/map/saed14nm_tf_itf_tluplus.map"
#set Gds_map_file          "/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_TECH_DATA/map/saed14nm_1p9m_gdsout.map"
set Gds_map_file          "/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_TECH_DATA/map/saed14nm_1p9m_gdsin_gdsout.map"

set Tlup_max_file         "/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_TECH_DATA/tlup/saed14nm_1p9m_Cmax.tlup"
set Tlup_min_file         "/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_TECH_DATA/tlup/saed14nm_1p9m_Cmin.tlup"
set Nxtgrd_max_file       "/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_TECH_DATA/nxtgrd/saed14nm_1p9m_Cmax.nxtgrd"
set Nxtgrd_min_file      "/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_TECH_DATA/nxtgrd/saed14nm_1p9m_Cmin.nxtgrd"

set icv_drc_runset        "/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_TECH_DATA/icv_drc/saed14nm_1p9m_drc_rules.rs"
set icv_mfill_runset      "/home/tools/PDK/SAED14_EDK/SAED14nm_EDK_TECH_DATA/icv_drc/saed14nm_1p9m_mfill_rules.rs"
################################################
