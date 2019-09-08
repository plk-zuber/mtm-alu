#------------------------------------------------------------------------------
# (#03) CREATE FLOORPLAN
#------------------------------------------------------------------------------
source tcl/00_common_settings.tcl

# TODO Menu: Floorplan -> Specify Floorplan
# Aspect Ratio: 1.0
# Core Utilization: 0.7
# Core to IO Boundary from all the sides: 20 um

# create_floorplan


# TODO Menu: Power -> Power Planning -> Add Ring ...
#------------------------------------------------------------------------------
# Generate following rings:
# - vddd, 5 um width
# - gndd, 5 um width
# - vddb, 2 um width
# - gndb, 2 um width
# The layers should be ME3 for Top and Bottom and ME4 for Left and Right.
# The rings should be extended to top and bottom. See the included pictures
# and use the Advance tab.
#
# Note: if incorrect ring was created, use Undo (key: u) function
# or select the ring elements with the mouse and use Del key.
#
# Note: you will have to make vddd and gndd rings first, than
# vddb and gndb (set the correct value of the offset).

# add_rings


# TODO Menu: Power -> Power Planning -> Add Stripe ...
#------------------------------------------------------------------------------
# Generate 1 vertical ME5 and 1 horizontal ME4 stripe for vddd and gndd.
# Width: 5 um, located in the center of the square (use "Relative from core or
# selected area" setting to locate the stripe).

# add_stripes 


# TODO: Menu: Route -> Special route ...
#------------------------------------------------------------------------------
#	Basic TAB:
#       	Sroute: select "Follow pins" only
#		Net(s): vddd gndd
#		Allow jogging: off
#	Via generation TAB:
#		Make via connections to: Stripe

# set_db route_special_via_connect_to_shape stripe
# route_special


# suspend

# place pins
#------------------------------------------------------------------------------
# The input pins (clk, rst_n, sin) should be placed on the left of the block 
# the output (sout) on the right.
# All signal pins should be on the ME3 layer.
#
# TODO Menu: File -> Save -> I/O File, select "sequence". Copy the file
# to "$DESIGN.io" and modify it to get required locations and layers
    

# read_io_file


# suspend
