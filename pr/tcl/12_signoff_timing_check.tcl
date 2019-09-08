#-----------------------------------------------------------------------
# (#12) SIGNOFF TIMING CHECK
#-----------------------------------------------------------------------
# Do not modify this file.
#-----------------------------------------------------------------------
source tcl/00_common_settings.tcl

#-----------------------------------------------------------------------
# forcing all clocks to be propagated
#-----------------------------------------------------------------------
set_interactive_constraint_modes [all_constraint_modes -active]
set_propagated_clock [all_clocks]

set_db timing_analysis_async_checks async
#-----------------------------------------------------------------------
# Signoff timing analysis
set_distributed_hosts -local
# NOTE: tempus 17.1 fails when -remote_host is set to 0!!! ?????
# set_multi_cpu_usage -local_cpu 8 -remote_host 8 -cpu_per_remote_host 1
set_multi_cpu_usage -local_cpu 1 -remote_host 1 -cpu_per_remote_host 1

# Runs signoff timing analysis using extraction (QRC) and Tempus in batch mode
time_design_signoff \
    -report_dir $reportDir \
    -report_prefix 12_signoff_time \
    -report_only

# TODO: check the timing report for violations
