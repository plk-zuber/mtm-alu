# PPCU_VLSI 2019 student project.
# This is the main script for genus synthesis.
# Command to start help:
# /cad/GENUS171/tools/bin/cdnshelp &
# NOTE: use "Genus Command Reference", not "Genus Command Reference for Legacy UI"
# NOTE: All the necessary modifications are marked with TODO: keyword

# Verbosity level 0-min, 11-max
set_db information_level 7 

# read the configuration for the flow 
source tcl/flow_config.tcl

# Read the multi-mode multi-corner configuration file.
# This defines timing libraties, operating conditions, and RC extraction corners
# for different operating modes of the DUT (we have 1 operating mode here)
read_mmmc "constraints/mmode.tcl"

# List of global Power nets
set_db init_power_nets  {vddd vddb}
set_db init_ground_nets {gndd gndb}

# Add layout information for the standard cell library
read_physical -lef "/cad/dk/umc180/SUS/SUSLIB_UCL_tech.lef /cad/dk/umc180/SUS/SUSLIB_UCL.lef"


puts "--------------------------------------------------------------------------------"
puts "-- HDL READ --------------------------------------------------------------------"
puts "--------------------------------------------------------------------------------"
# TODO: read design files
# read_hdl 

# suspend


#------------------------------------------------------------------------------
# merge and analyse the input files
puts "--------------------------------------------------------------------------------"
puts "-- ELABORATION -----------------------------------------------------------------"
puts "--------------------------------------------------------------------------------"
elaborate
# TODO: check if there are any errors or warnings during elaboration. There should be 
# no errors, warnings can be accepted only if they are well understood and justified.

# suspend

# Load the timing configuration
puts "--------------------------------------------------------------------------------"
puts "-- INIT DESIGN -----------------------------------------------------------------"
puts "--------------------------------------------------------------------------------"
init_design
# TODO: check if there are any errors/warnings
#
# The correct lines in the log should show no errors, e.g.:
#
# Statistics for commands executed by read_sdc:
#  "all_inputs"               - successful      4 , failed      0 (runtime  0.00)
#  "all_outputs"              - successful      2 , failed      0 (runtime  0.00)
#  "create_clock"             - successful      1 , failed      0 (runtime  0.00)
#  "get_ports"                - successful      1 , failed      0 (runtime  0.00)
#  "set_clock_uncertainty"    - successful      2 , failed      0 (runtime  0.00)
#  "set_dont_use"             - successful      8 , failed      0 (runtime  0.00)
#  "set_driving_cell"         - successful      1 , failed      0 (runtime  0.00)
#  "set_input_delay"          - successful      1 , failed      0 (runtime  0.00)
#  "set_input_transition"     - successful      1 , failed      0 (runtime  0.00)
#  "set_load"                 - successful      1 , failed      0 (runtime  0.00)
#  "set_load_unit"            - successful      1 , failed      0 (runtime  0.00)
#  "set_max_fanout"           - successful      1 , failed      0 (runtime  0.00)
#  "set_output_delay"         - successful      1 , failed      0 (runtime  0.00)
#  "set_time_unit"            - successful      1 , failed      0 (runtime  0.00)
#  "set_units"                - successful      2 , failed      0 (runtime  0.00)
# Total runtime 0

# suspend

puts "--------------------------------------------------------------------------------"
puts "-- CHECK TIMING CONSTRATINTS ---------------------------------------------------"
puts "--------------------------------------------------------------------------------"
check_timing_intent
# check_timing_intent -verbose > YOUR_REPORT_FILE
#
# TODO: the report should show no errors and no warnings
# 
# The correct report is similiar to:
#
# Lint summary
#  Unconnected/logic driven clocks                                  0
#  Sequential data pins driven by a clock signal                    0
#  Sequential clock pins without clock waveform                     0
#  Sequential clock pins with multiple clock waveforms              0
#  Generated clocks without clock waveform                          0
#  Generated clocks with incompatible options                       0
#  Generated clocks with multi-master clock                         0
#  Paths constrained with different clocks                          0
#  Loop-breaking cells for combinational feedback                   0
#  Nets with multiple drivers                                       0
#  Timing exceptions with no effect                                 0
#  Suspicious multi_cycle exceptions                                0
#  Pins/ports with conflicting case constants                       0
#  Inputs without clocked external delays                           0
#  Outputs without clocked external delays                          0
#  Inputs without external driver/transition                        0
#  Outputs without external load                                    0
#  Exceptions with invalid timing start-/endpoints                  0
# 
#                                                   Total:          0

# suspend

# check for undefined modules
check_design -unresolved
# TODO: check if the report contains the following info:
#
# No unresolved references in design 'mtm_Alu'
# o empty modules in design 'mtm_Alu'

# suspend

#------------------------------------------------------------------------------
# TODO: put your synthesis commands below.


#------------------------------------------------------------------------------
# TODO: put your report commands below.
# Report:
# - quality of results (QOR);
# - worst timing paths (to check, if the timing was met)
# Store reports in files


#------------------------------------------------------------------------------
# TODO: save the desing for the innovus P&R into a result directory
#  write_design -innovus -basename $resultDir/mtmAlu_

