#------------------------------------------------------------------------------
# DESIGN FLOW PARAMETERS
# Do not modify this file

set_db design_process_node 180
# Note: LEC script generation does not when efforts are set to express
set_db syn_generic_effort express
set_db syn_map_effort express
set_db syn_opt_effort express

set_db remove_assigns true
set_db optimize_merge_flops false 

set_db max_cpus_per_server 1 ; # limiting to 8 CPU
#used to mimic a non-cadence environment
set_db enable_domain_name_check 0

# Chipware priority -> rtl compiler replaces some verilog modules (e.g. CW_8b10b_dec.v)
set_db hdl_use_cw_first false 
set_db wlec_set_cdn_synth_root true

# used to override pin properties from LEF
set_db use_power_ground_pin_from_lef true

set_db hdl_track_filename_row_col                 true   ;#used for cross probing and datapath report. May be memory consuming
set_db verification_directory_naming_style        "./LEC"

# set_db lp_insert_clock_gating                     true   ;#enables clock gating insertion during synthesis

