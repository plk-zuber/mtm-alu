#------------------------------------------------------------------------------
# (#00) COMMON SETTINGS
#------------------------------------------------------------------------------
# Do not modify this file
#------------------------------------------------------------------------------

# top cell name
set DESIGN mtmAlu_MG

set_db design_process_node 180
set_db init_design_uniquify {1}
set_db route_design_top_routing_layer 3

set reportDir ./timingReports
set resultDir ./RESULTS_PR

# Create output dirs
foreach {dir} [list $resultDir $reportDir ] {
  if {[expr ! [file exists $dir]]} { file mkdir $dir }
}

