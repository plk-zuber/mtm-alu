# library sets for different process corners
create_library_set -name WC_libs -timing [ list /cad/dk/umc180/SUS/SUSLIB_UCL_ss.lib ]
create_library_set -name BC_libs -timing [ list /cad/dk/umc180/SUS/SUSLIB_UCL_ff.lib ]

# operating conditions for different process corners
create_opcond -name op_cond_slow -process 1 -voltage 1.7 -temperature 80
create_opcond -name op_cond_fast -process 1 -voltage 1.9 -temperature 0

# rc extraction corners
create_rc_corner -name WC_rc -temperature 80 -qrc_tech /cad/dk/umc180oa/Rulefiles/QRC/G-DF-MIXED_MODE_RFCMOS18-1.8V_3.3V-1P6M-MMC/qrcTechFile
create_rc_corner -name BC_rc -temperature 0  -qrc_tech /cad/dk/umc180oa/Rulefiles/QRC/G-DF-MIXED_MODE_RFCMOS18-1.8V_3.3V-1P6M-MMC/qrcTechFile

#------------------------------------------------------------------------------
# timing condition = merge library sets with operating conditions
create_timing_condition -name WC_tc -opcond op_cond_slow -library_sets WC_libs
create_timing_condition -name BC_tc -opcond op_cond_fast -library_sets BC_libs

# delay corner = add rc extraction data to timing condition
# This is a full configuration of lib + opcond + rc, used for delay calculation
create_delay_corner -name WC_dc -timing_condition WC_tc -rc_corner WC_rc
create_delay_corner -name BC_dc -timing_condition BC_tc -rc_corner BC_rc

#------------------------------------------------------------------------------
# constraint mode = set of constraints for given DUT operation mode (e.g. func / test)
create_constraint_mode -name standard_cm -sdc_files [ list ./constraints/mtmAlu.sdc ]

# analysis view = sdc + DUT operation mode + delay corner
create_analysis_view -name WC_av -delay_corner WC_dc -constraint_mode standard_cm
create_analysis_view -name BC_av -delay_corner BC_dc -constraint_mode standard_cm

# configuration for set and hold check
set_analysis_view -setup [ list WC_av ] -hold [ list BC_av ]
