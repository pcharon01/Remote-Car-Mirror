/*
 * Copyright (c) 2026 Patrick Charon
 * Licensed under CERN-OHL-P <https://cern-ohl.web.cern.ch/>
*/

use <parts/center_frame.scad>
use <parts/rear_frame.scad>

translate([0, 0, 2.5])
    center_frame();

translate([113, 0, 0])
    rear_frame();
