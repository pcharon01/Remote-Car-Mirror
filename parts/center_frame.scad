/*
 * Copyright (c) 2026 Patrick Charon
 * Licensed under CERN-OHL-P <https://cern-ohl.web.cern.ch/>
*/

$fn = 32;

frame_length = 98;
frame_width = 80;
frame_thickness = 5;

beam_width = 4;

border_width = 2.5;
border_height = 5;

mount_step_length = 26;
mount_step_depth = 3;

lateral_hole_width = 10;
motor_bay_width = 24.5;
motor_bay_length = 54;
motor_bay_depth = 11.5;
motor_bay_bevel = 5;
motor_bay_bar_width = 4;
motor_bay_bar_thickness = 2;

mount_screw_offset = 7;
mount_screw_spacing = 10;
mount_screw_diameter = 5;

board_rack_screw_diameter = 5;
board_rack_screw_x = 48;
board_rack_screw_y = 5;
board_rack_screw_spacing = 20;

shaft_diameter = 5.5;

motor_knob_diameter = 4;
motor_knob_height = 3;
motor_knob_spacing = 7.97;

underside_reinforcement_width = 5;
underside_reinforcement_length  = 45;
underside_reinforcement_height = 7.45;
underside_reinforcement_spacing = 55;
underside_reinforcement_bevel = 15;

module _frame_base() {
    cube([frame_length, frame_width, frame_thickness], center = true);

    for (y = [-1, 1]) {
        translate([0, y * (frame_width - border_width) / 2, border_height]) {
            cube([frame_length - 2 * mount_step_length, border_width, border_height], center = true);
        }

        for (x = [-1, 1]) {
            translate([x * (frame_length - mount_step_length - border_width) / 2,
                       y * (frame_width - border_width - mount_step_depth) / 2,
                       border_height]
            ) {
                cube([mount_step_length + border_width,
                      border_width + mount_step_depth,
                      border_height],
                      center = true);
            }
        }
    }
}

module _mounting_steps() {
    for (y = [-1, 1]) {
        for (x = [-1, 1]) {
            translate([x * (frame_length - mount_step_length) / 2,
                       y * (frame_width - mount_step_depth) / 2,
                       border_height / 2]
            ) {
                cube([mount_step_length, mount_step_depth, frame_thickness + border_height],
                     center = true);
            }
        }
    }
}

module _mechanics_attachments() {
    translate([(frame_length - beam_width) / 2 - mount_step_length, 0, 0]) {
        rotate([0, 90, 0]) {
            cylinder(d = motor_bay_width, h = beam_width, center = true);
        }
    }

    translate([(frame_length - beam_width) / 2, 0, 0]) {
        rotate([0, 90, 0]) {
            cylinder(d = shaft_diameter + beam_width, h = beam_width, center = true);
        }
    }

    for (dx = [0, -motor_bay_length - beam_width]) {
        translate([(frame_length - beam_width) / 2 - mount_step_length + dx,
                   0,
                   -frame_thickness / 2]
        ) {
            rotate([0, 90, 0]) {
                linear_extrude(beam_width, center = true) {
                    polygon([
                        [0, -motor_bay_width / 2],
                        [motor_bay_depth - motor_bay_bevel, -motor_bay_width / 2],
                        [motor_bay_depth, -motor_bay_width / 2 + motor_bay_bevel],
                        [motor_bay_depth, motor_bay_width / 2 - motor_bay_bevel],
                        [motor_bay_depth - motor_bay_bevel, motor_bay_width / 2],
                        [0, motor_bay_width / 2]
                    ]);
                }
            }
        }
    }

    translate([(frame_length - motor_bay_length) / 2 - mount_step_length - beam_width,
               0,
               -motor_bay_depth - (frame_thickness - motor_bay_bar_thickness) / 2]) {
        cube([motor_bay_length, motor_bay_bar_width, motor_bay_bar_thickness], center = true);
    }
}

module _frame_holes() {
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * (frame_length - mount_step_length - border_width) / 2,
                       y * ((frame_width - lateral_hole_width) / 2 - mount_step_depth - border_width),
                       0]
            ) {
                cube([mount_step_length - border_width, lateral_hole_width, frame_thickness],
                     center = true);
            }
        }
    }

    translate([(frame_length - mount_step_length - beam_width) / 2, 0, 0]) {
        cube([mount_step_length - beam_width,
             frame_width - 2 * (mount_step_depth + border_width + beam_width + lateral_hole_width),
             frame_thickness],
             center = true);
    }

    translate([(frame_length - motor_bay_length) / 2 - mount_step_length - beam_width, 0, 0]) {
        cube([motor_bay_length, motor_bay_width, frame_thickness], center = true);
    }
}

module _screw_holes() {
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            for (dx = [0, mount_screw_spacing]) {
                translate([x * (frame_length / 2 - mount_step_length + mount_screw_offset + dx),
                           y * ((frame_width - border_width) / 2 - mount_step_depth),
                           (frame_thickness + border_height - mount_screw_diameter) / 2]
                ) {
                    rotate([90, 0, 0]) {
                        cylinder(d = mount_screw_diameter, h = border_width, center = true);
                    }
                }
            }
        }
    }

    for (y = [-1, 1]) {
        for (dx = [-board_rack_screw_spacing / 2, board_rack_screw_spacing / 2]) {
            translate([frame_length / 2 - mount_step_length - beam_width - board_rack_screw_x + dx,
                       y * (motor_bay_width / 2 + board_rack_screw_y),
                       0]
            ) {
                rotate([0, 0, 0]) {
                    cylinder(d = board_rack_screw_diameter, h = frame_thickness, center = true);
                }
            }
        }
    }
}

module _shaft_hole() {
    translate([(frame_length - mount_step_length - beam_width) / 2, 0, 0]) {
        rotate([0, 90, 0]) {
            cylinder(d = shaft_diameter, h = mount_step_length + beam_width, center = true);
        }
    }
}

module _motor_knobs() {
    translate([(frame_length - beam_width) / 2 - mount_step_length - motor_knob_height, 0, 0]) {
        rotate([0, 90, 0]) {
            for (a = [-1, 1]) {
                for (b = [-1, 1]) {
                    translate([a * motor_knob_spacing, 0, 0])
                        cylinder(
                            d = motor_knob_diameter,
                            h = motor_knob_height,
                            center = true
                        );

                    translate([0, a * motor_knob_spacing, 0])
                        cylinder(
                            d = motor_knob_diameter,
                            h = motor_knob_height,
                            center = true
                        );
                }
            }
        }
    }
}

module _underside_reinforcement() {
    difference() {
        for (y = [-1, 1]) {
            translate([0,
                      y * (underside_reinforcement_spacing + underside_reinforcement_width) / 2,
                      - (frame_thickness + underside_reinforcement_height) / 2]
            ) {
                cube([underside_reinforcement_length,
                    underside_reinforcement_width,
                    underside_reinforcement_height],
                    center = true);
            }
        }

        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                translate([x * (underside_reinforcement_length / 2 - underside_reinforcement_bevel),
                          y * (underside_reinforcement_spacing + underside_reinforcement_width) / 2,
                          - (frame_thickness) / 2]
                ) {
                    rotate([-90, 0, 90 - 90 * x]) {
                        linear_extrude(underside_reinforcement_width, center = true)
                            polygon([
                                [underside_reinforcement_bevel, 0],
                                [underside_reinforcement_bevel, underside_reinforcement_height],
                                [0, underside_reinforcement_height]
                            ]);
                    }
                }
            }
        }
    }
}

module center_frame() {
    difference() {
        union() {
            _frame_base();
            _mechanics_attachments();
        }

        _mounting_steps();
        _frame_holes();
        _screw_holes();
        _shaft_hole();
    }

    _motor_knobs();
    _underside_reinforcement();
}

center_frame();
