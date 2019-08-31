#!/bin/bash
# PPCU_VLSI project
# This is a template script to run genus synthesis

# set paths
source env.sh

#update nfs (if any)
ls -laR . >> /dev/null

rm -f genus_mtm.log

# run synthesis in batch mode

genus -abort_on_error -no_gui -batch -files tcl/synth_mtmAlu.tcl -log genus_mtm -overwrite

# if you want to start interactive sesion use:

# genus 

