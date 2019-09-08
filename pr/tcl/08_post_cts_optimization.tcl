#------------------------------------------------------------------------------
# (#08) POST-CTS OPTIMIZATION. Now hold time is already important.
#------------------------------------------------------------------------------
# Do not modify this file
#------------------------------------------------------------------------------
source tcl/00_common_settings.tcl

# optimize setup first
opt_design -post_cts -report_prefix 08a_postCts_setup -report_dir $reportDir
# optimize hold
opt_design -post_cts -hold -report_prefix 08b_postCts_hold -report_dir $reportDir
# optimiza max load, max fanout, etc.
opt_design -post_cts -drv -report_prefix 08c_postCts_drv -report_dir $reportDir

# write timing reports
time_design -post_cts -report_prefix 08d_time_postCts_setup -report_dir $reportDir
time_design -post_cts -hold -report_prefix 08e_time_postCts_hold -report_dir $reportDir

# TODO: check all the generated report summaries for violations
