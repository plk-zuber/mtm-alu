#######################################################################
# Command to start help:
# /cad/GENUS171/tools/bin/cdnshelp &
# NOTE: use "Genus Command Reference", not "Genus Command Reference for Legacy UI"
# NOTE: necessary modiffications are marked with "TODO" keyword
#######################################################################
set sdc_version 1.7
# synopsys unit definitions do not work correctly in Encounter
set_units -capacitance 1.0pF
set_units -time 1.0ns
set_time_unit -nanoseconds
set_load_unit -picofarads

#------------------------------------------------------------------------------
# PUT YOUR CONSTRAINTS BELOW

#------------------------------------------------------------------------------
# clock constraints
#------------------------------------------------------------------------------
# define the clock of a given frequency for port clk
# start with the frequency of 50 MHz

# TODO: create_clock 

# VIVADO create_clock -add -name clk_50MHz -period 20.00 [get_ports clk]

# what type is clk?

get_object_type clk
get_object_type sin
get_object_type sout

create_clock -add -name clk_50m -period 20.00 clk
get_object_type clk_50m

# Set clock uncertainty to 0.3 for setup analysis
#     and to 0.1 for hold analysis for the clock

# TODO: set_clock_uncertainty

set_clock_uncertainty -setup 0.3 clk_50m
set_clock_uncertainty -hold 0.1 clk_50m

#------------------------------------------------------------------------------
# input constratints
#------------------------------------------------------------------------------
# Set driving cell to UCL_INV for all inputs
# Set the input transision to 0.2 for all inputs

# TODO: set_driving_cell
# TODO: set_input_transition

set_driving_cell -lib_cell UCL_INV [all_inputs]
set_input_transition 0.2 [all_inputs]   


# Set the input delay to the HALF OF THE CLOCK PERIOD for all inputs, 
# (rememeber to specify the clock)

# TODO set_input_delay

# suspend

set_input_delay 10.0 -clock clk_50m [all_inputs]


# Limit number of loads for all inputs to one

# TODO: set_max_fanout

#suspend
set_max_fanout 1.0 [all_inputs]


#------------------------------------------------------------------------------
# set output delays and loads
#------------------------------------------------------------------------------
# Set the output delay to the HALF OF THE CLOCK PERIOD for all outputs, 
# (rememeber to specify the clock)
# Set the output load to 0.1 pF for all outputs

# TODO: set_output_delay 
# TODO: set_load 

set_output_delay 10.0 -clock clk_50m [all_outputs]
set_load -pin_load 100 [all_outputs]
# in FEMTO


# #######################################################################
# Do not modify the settings below.
# This buffers are to weak - cause problems on max cap and max tran,
# or after fixing the max cap we get setup violations
set_dont_use UCL_INV_LP true
set_dont_use UCL_INV_LP2 true
set_dont_use UCL_BUF16 true
set_dont_use UCL_BUF16B true
# limit the number of d-flops
set_dont_use UCL_DFF_LP true
set_dont_use UCL_DFF_LP2 true
set_dont_use UCL_DFF_LP4 true
# set_dont_use UCL_DFF_RES2 true
set_dont_use UCL_DFF_SCAN true
