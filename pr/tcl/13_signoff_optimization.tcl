#-----------------------------------------------------------------------
# (#13) SIGNOFF OPTIMIZATION
#-----------------------------------------------------------------------
# This step is necesary only if the timing is not met at previous stage
#-----------------------------------------------------------------------
# source tcl/00_common_settings.tcl
#
# delete_filler
#-----------------------------------------------------------------------
# addtional delay margin for signoff analysis
# set_db opt_signoff_setup_target_slack 0.2

#opt_signoff -drv \
#    -no_eco_route \
#    -report_dir $reportDir \
#    -report_prefix 12a_signoff_opt_drv
#
#opt_signoff -hold \
#    -no_eco_route \
#    -report_dir $reportDir \
#    -report_prefix 12b_signoff_opt_hold
#
#opt_signoff -setup \
#    -no_eco_route \
#    -report_dir $reportDir \
#    -report_prefix 12c_signoff_opt_setup

#add_fillers
#route_eco
#extract_rc
#-----------------------------------------------------------------------
# Signoff timing analysis after optimization

#time_design_signoff \
#    -report_dir $reportDir \
#    -report_prefix 12d_signoff_time_opt \
#    -report_only
