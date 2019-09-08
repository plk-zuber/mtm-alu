#!/bin/bash
# This script removes all the temporary data and results from Innovus

rm -rf mp_data*
rm -f xrun.history
rm -f qrc_*.log
rm -f host-monitor.log*
rm -rf ecoTimingDB
rm -rf timingReports
rm -rf RESULTS_PR
rm -f innovus_mtm.*
rm -f rc_model.bin
rm -f innovus.*
