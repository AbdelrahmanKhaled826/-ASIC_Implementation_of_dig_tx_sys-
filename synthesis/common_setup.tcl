
#####################################################################################Main_PATH
set ROOT_DIR            "/home/svgpasic25abkhaled/GP"
set VERILOG_PATH        "${ROOT_DIR}/RTL"
set CONSTRAIN_PATH     "${ROOT_DIR}/cons"

## Point to the new 14nm SAED libs

set DESIGN_REF_PATH               "/home/tools/PDK/SAED14_EDK"

##############################################################


# Library Setup Variables


set std_cell_lib    "${DESIGN_REF_PATH}/SAED14nm_EDK_STD_LVT/liberty/nldm/base/saed14lvt_base_ff0p88v125c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_LVT/liberty/nldm/base/saed14lvt_base_ss0p72vm40c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_LVT/liberty/nldm/base/saed14lvt_base_tt0p8v25c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_SLVT/liberty/nldm/base/saed14slvt_base_ff0p88v125c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_SLVT/liberty/nldm/base/saed14slvt_base_ss0p72vm40c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_SLVT/liberty/nldm/base/saed14slvt_base_tt0p8v25c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_RVT/liberty/nldm/base/saed14rvt_base_ff0p88v125c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_RVT/liberty/nldm/base/saed14rvt_base_ss0p72vm40c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_RVT/liberty/nldm/base/saed14rvt_base_tt0p8v25c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_HVT/liberty/nldm/base/saed14hvt_base_ff0p88v125c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_HVT/liberty/nldm/base/saed14hvt_base_ss0p72vm40c.db \
${DESIGN_REF_PATH}/SAED14nm_EDK_STD_HVT/liberty/nldm/base/saed14hvt_base_tt0p8v25c.db \
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
