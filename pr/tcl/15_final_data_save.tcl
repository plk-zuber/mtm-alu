#-----------------------------------------------------------------------
# (#15) FINAL DATA SAVE
#-----------------------------------------------------------------------
# Do not modify this file.
#-----------------------------------------------------------------------
source tcl/00_common_settings.tcl

# Report quality of results
report_qor -format html -file $reportDir/15_qor.html

# Report area
report_area -out_file $reportDir/15_area.rpt

# Generate RC spefs for WC_rc & BC_rc corners
# write_parasitics -rc_corner WC_rc -spef_file $resultDir/${DESIGN}_WC_rc.spef.gz
# write_parasitics -rc_corner BC_rc -spef_file $resultDir/${DESIGN}_BC_rc.spef.gz

#-----------------------------------------------------------------------
# save innovus database
write_db $resultDir/${DESIGN}_innovus

# save standard delay format (SDF) file
write_sdf \
    -edges noedge \
    -max_view WC_av \
    -min_view BC_av \
    $resultDir/${DESIGN}.sdf.gz

#save flattened netlist
#write_netlist -flat \
#    -include_pg_ports \
#    -include_phys_insts \
#    -omit_floating_ports \
#    -exclude_leaf_cells \
#    $resultDir/${DESIGN}_flat.v.gz

#save hierarchical netlist with power/ground ports (for external LVS)
# write_netlist \
#     -include_pg_ports \
#     -include_phys_insts \
#     -omit_floating_ports \
#     -exclude_leaf_cells \
#     $resultDir/${DESIGN}_nonFlat.v.gz

#save non-flatted netlist without power ports for simulation
write_netlist $resultDir/${DESIGN}.noPower.v.gz

#save flatted netlist without power ports for simulation
#write_netlist  -flat  $resultDir/${DESIGN}.noPower.flat.v.gz


# write pin labels into file (for external LVS)
# create_pin_text \
#     -cells "$DESIGN" \
#     $resultDir/${DESIGN}_pins.txt

# Write the GDS2 file (layout)
set_db write_stream_label_all_pin_shape true
set_db write_stream_check_map_file true
write_stream $resultDir/${DESIGN}.gds.gz -map_file /cad/dk/umc180/SUS/UMC_18_CMOS.layermap

# save floorplan do desing exchange format (DEF) file
# write_def -floorplan $resultDir/${DESIGN}_floorplan.def.gz

# suspend
