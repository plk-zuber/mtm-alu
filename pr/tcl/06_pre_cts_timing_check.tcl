#------------------------------------------------------------------------------
# (#06) PRE-CTS TIMING CHECK
#------------------------------------------------------------------------------
# Do not modify this file.
#------------------------------------------------------------------------------
source tcl/00_common_settings.tcl


time_design -pre_cts -report_prefix 06_prects -report_dir $reportDir
# TODO: check 06_prects.summary.gz file for Violating Paths

