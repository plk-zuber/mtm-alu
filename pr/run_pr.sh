#!/bin/bash

#update nfs (if any)
ls -laR . >> /dev/null 

#------------------------------------------------------------------------------
# Set paths.
source ./env.sh


#------------------------------------------------------------------------------
# Batch run (use it to automatize the flow)
# innovus -stylus -abort_on_error -no_gui -files ./tcl/run_pr.tcl -log innovus_mtm -overwrite


#------------------------------------------------------------------------------
# Interactive run with automatic starting of the scripts.
# The script execution can be stopped with "suspend" command in the script, and
# resumed with "resume" command.
# The GUI is open with "gui_show", and closed with "gui_hide" commands.

innovus -stylus -abort_on_error -files ./tcl/run_pr.tcl -log innovus_mtm -overwrite


#------------------------------------------------------------------------------
# Just start innovus

# innovus -stylus -log innovus_mtm -overwrite
