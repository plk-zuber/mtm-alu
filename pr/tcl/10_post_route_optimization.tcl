#-----------------------------------------------------------------------
# (#10) POST-ROUTE OPTIMIZATION
#-----------------------------------------------------------------------
# Do not modify this file
#-----------------------------------------------------------------------
source tcl/00_common_settings.tcl

set_db extract_rc_engine post_route
set_db extract_rc_effort_level medium

#enable Signal Integrity analysis
set_db delaycal_enable_si true
set_db opt_post_route_drv_recovery true
set_db opt_effort high

# optimize
opt_design -post_route -drv -report_prefix 10a_opt_post_route_drv -report_dir $reportDir
opt_design -post_route -setup -hold -report_prefix 10b_opt_post_route_setup_hold -report_dir $reportDir

# TODO: check the report summaries for violations
