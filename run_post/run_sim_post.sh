#!/bin/bash
# to start simvision add "-gui" option at the command line


source /cad/env/cadence_path.XCELIUM1809

# using "source" command is necessary, as the script sets the 
# enviroment variables (XRUN_NETLIST_ARGS)
source ./prepare_post_data.sh

if [[ "$?" != "0" ]] ; then
  echo "prepare_post_data.sh failed."
  exit -1
fi

# create results directory if does not exits
if [[ ! -e RESULTS ]] ; then
  mkdir RESULTS
fi

# run simulation
#   xrun replaces irun
#   XRUN_NETLIST_ARGS is defined in prepare_post_data.sh script
#   tcl file contatins the simulator commands (dump net activity data,
#       run the simulation)
#   TODO: check if the -F file correctly points to you testbench
xrun \
  -F mtm_Alu_post.f \
  +access+r \
  $XRUN_NETLIST_ARGS \
  -tcl -input tcl/dumptcf.tcl \
  "$@"

# TODO: after simulation check the xrun.log if the SDF annotation was correct.
# The log should include the lines:
# 
# Annotation completed successfully...
#    SDF statistics: No. of Pathdelays = * Annotated = 100.00% -- No. of Tchecks = * Annotated = 100.00% 
# 
# TODO: check if the simulation results are the same as for the RTL simulation.
