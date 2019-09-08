#------------------------------------------------------------------------------
# (#02) CONNECT POWER TO GATES
#------------------------------------------------------------------------------
# Do not modify this file
#------------------------------------------------------------------------------
source tcl/00_common_settings.tcl

# Connecting power lines to the gates.
# The netlist from the synthesis does not include power connection to the
# gates. We specify which power nets should be connected to given cell pins.
connect_global_net vddd -type pg_pin -pin_base_name vddd -verbose
connect_global_net gndd -type pg_pin -pin_base_name gndd -verbose
connect_global_net vddb -type pg_pin -pin_base_name vddb -verbose
connect_global_net gndb -type pg_pin -pin_base_name gndb -verbose

