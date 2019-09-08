#-----------------------------------------------------------------------
# (#11) SIGNOFF EXTRACTION
#-----------------------------------------------------------------------
# Do not modify this file.
#-----------------------------------------------------------------------
source tcl/00_common_settings.tcl

# Select QRC extraction to be in signoff mode
set_db extract_rc_engine post_route
set_db extract_rc_effort_level signoff
set_db extract_rc_coupled true
set_db extract_rc_lef_tech_file_map /cad/dk/umc180/SUS/lefdef.layermap

# if $startWithOAlib {
#   set_db extract_rc_use_qrc_oa_interface true
# }

extract_rc

