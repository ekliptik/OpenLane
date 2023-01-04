source /home/emil/pulls/OpenLane/designs/ctu_can_fd/runs/RUN_2022.11.29_00.15.36/config.tcl
# source /home/emil/pulls/tt02-verilog-demo/runs/wokwi/config.tcl
source /home/emil/pulls/OpenLane/pdks/sky130B/libs.tech/openlane/config.tcl
# source /home/emil/pulls/OpenLane/placement-view-prep.tcl

# source /home/emil/pulls/OpenLane/scripts/tcl_commands/placement.tcl
# set ::env(SCRIPTS_DIR) "$::env(OPENLANE_ROOT)/scripts"
set ::env(CURRENT_DEF) $::env(PLACEMENT_CURRENT_DEF)
set ::env(CURRENT_ODB) "$::env(floorplan_results)/$::env(DESIGN_NAME).odb"
# set ::env(CURRENT_ODB) "/home/emil/pulls/chase-the-beat/runs/wokwi/results/floorplan/chase_the_beat.odb"
source /home/emil/pulls/OpenLane/scripts/openroad/gpl.tcl
