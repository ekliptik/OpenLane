# Copyright 2020-2022 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
source $::env(SCRIPTS_DIR)/openroad/common/io.tcl
read

set_propagated_clock [all_clocks]

if { ($::env(DIODE_INSERTION_STRATEGY) == 3) || ($::env(DIODE_INSERTION_STRATEGY) == 6) } {
    set_placement_padding -masters $::env(DIODE_CELL) -left $::env(DIODE_PADDING)
}

source $::env(SCRIPTS_DIR)/openroad/common/set_routing_layers.tcl

set_macro_extension $::env(GRT_MACRO_EXTENSION)

source $::env(SCRIPTS_DIR)/openroad/common/set_layer_adjustments.tcl

set arg_list [list]
lappend arg_list -congestion_iterations $::env(GRT_OVERFLOW_ITERS)
lappend arg_list -verbose
if { $::env(GRT_ALLOW_CONGESTION) == 1 } {
    lappend arg_list -allow_congestion
}
puts $arg_list
set visnet clknet_5_27_0_clk_sys
# global_route_debug -st -net "$visnet"
# global_route_debug -rst -net "$visnet"
# global_route_debug -tree2D -net "$visnet"
# global_route_debug -tree3D -net "$visnet"
global_route {*}$arg_list
# save_image "watsteiner" -resolution 0.1 -display_option {Layers/met1 false} -display_option {Layers/via false} -display_option {Layers/met2 false} -display_option {Layers/via2 false} -display_option {Layers/met3 false}  -display_option {Layers/via3 false}  -display_option {Layers/met4 false} -display_option {Layers/via4 false} -display_option {Layers/met5 false} -display_option {Rows false}
# gui::pause
if { ($::env(DIODE_INSERTION_STRATEGY) == 3) || ($::env(DIODE_INSERTION_STRATEGY) == 6) } {
    repair_antennas "$::env(DIODE_CELL)" -iterations $::env(GRT_ANT_ITERS)
    check_placement
}

write

if {[info exists ::env(CLOCK_PORT)]} {
    if { $::env(GRT_ESTIMATE_PARASITICS) == 1 } {
        # set rc values
        source $::env(SCRIPTS_DIR)/openroad/common/set_rc.tcl
        # estimate wire rc parasitics
        estimate_parasitics -global_routing

        set ::env(RUN_STANDALONE) 0
        source $::env(SCRIPTS_DIR)/openroad/sta.tcl
    }
} else {
    puts "\[WARN\]: No CLOCK_PORT found. Skipping STA..."
}
