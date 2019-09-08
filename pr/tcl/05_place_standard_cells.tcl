#------------------------------------------------------------------------------
# (#05) PLACE STANDARD CELLS
#------------------------------------------------------------------------------
# Do not modify this file
#------------------------------------------------------------------------------
source tcl/00_common_settings.tcl

place_opt_design -report_prefix 05_place_opt -report_dir $reportDir
# TODO: look at the 05_place_opt.summary.gz file (use zcat command), check
# if there are any violating paths. Small violations (a few ps) are not critical here.

# Add tie cells (replacing logic 0 and 1)
#------------------------------------------------------------------------------
set_db add_tieoffs_cells { UCL_TIEHI UCL_TIELO }
add_tieoffs

