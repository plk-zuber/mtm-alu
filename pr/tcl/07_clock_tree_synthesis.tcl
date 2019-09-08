#------------------------------------------------------------------------------
# (#07) CLOCK TREE SYNTHESIS (CTS)
#------------------------------------------------------------------------------
# Do not modify this file.
#------------------------------------------------------------------------------
source tcl/00_common_settings.tcl

# define buffers for clock tree
set_db cts_inverter_cells {UCL_INV4}
set_db cts_buffer_cells {UCL_BUF4 UCL_BUF8 UCL_BUF8_2}

set_db cts_target_max_transition_time 0.3
# set_db cts_target_skew 0.2

# generate clock tree
clock_design

# generate raports
report_clock_trees -summary -out_file $reportDir/07_clock_tree_summary.txt
report_clock_tree_structure -out_file $reportDir/07_clock_tree_structure.txt

# TODO: browse the reports. Check:
# - what is the requirement for the target leaf slew? was the target met?
# - what is the number leaf cells in the design (dflops in our case)
# - what is the number of buffers/inverters used? (should be below 10% of
#   leaf cells).

