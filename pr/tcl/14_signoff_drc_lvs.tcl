#-----------------------------------------------------------------------
# (#14) SIGNOFF DRC LVS
#-----------------------------------------------------------------------
# Do not mofify this file.
#-----------------------------------------------------------------------
source tcl/00_common_settings.tcl

# DRC
check_drc           -out_file $reportDir/14_check_drc.rpt

# LVS
check_connectivity  -out_file $reportDir/14_check_connectivity.rpt

# TODO: Check the DRC and LVS reports for errors
