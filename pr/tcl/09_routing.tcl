#------------------------------------------------------------------------------
# (#09) ROUTING
#------------------------------------------------------------------------------
# Do not modify this file
#------------------------------------------------------------------------------
source tcl/00_common_settings.tcl

# Add filler cells
#------------------------------------------------------------------------------
set_db add_fillers_cells { UCL_CAP9 UCL_CAP8 UCL_CAP7 UCL_CAP6 UCL_CAP5 UCL_FILL }
set_db add_fillers_prefix FILLER
add_fillers

# Route the design
#------------------------------------------------------------------------------
# Metal1 must enclose pins; specific for SUS library
set_db route_design_with_via_in_pin 1:1

# No planar access to pins on Metal 1; specific for SUS library
set_db route_design_with_via_only_for_lib_cell_pin 1:1

set_db route_design_with_timing_driven 1
set_db route_design_with_si_driven 0
set_db route_design_detail_post_route_swap_via multiCut

# routing command
route_design -global_detail -via_opt -wire_opt

