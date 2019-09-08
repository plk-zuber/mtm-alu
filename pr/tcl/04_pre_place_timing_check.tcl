#------------------------------------------------------------------------------
# (#04) PRE-PLACEMENT TIMING CHECK
#------------------------------------------------------------------------------
# Do not modify this file
#------------------------------------------------------------------------------
source tcl/00_common_settings.tcl

# Check timing before placement by ignoring net loads, write report
set_db timing_analysis_type ocv
set_db timing_analysis_cppr both
check_timing
time_design -pre_place -report_prefix 04_preplace -report_dir $reportDir

# TODO: look at the 04_preplace.summary.gz file (use zcat command), check
# if there are any violating paths. Small violations (a few ps) are not critical here.

