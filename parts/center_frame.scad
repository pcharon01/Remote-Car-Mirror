/*
 * Copyright (c) 2026 Patrick Charon
 * Licensed under CERN-OHL-P <https://cern-ohl.web.cern.ch/>
*/

frame_length = 98;
frame_width = 80;
frame_thickness = 5;

border_width = 2.5;
border_height = 5;
total_height = frame_thickness + border_height;

mount_step_length = 26;
mount_hole_width = 10;

screw_hole_spacing = 10;
screw_hole_offset = 7;
screw_hole_diameter = 5;

beam_thickness = 4;

shaft_diameter = 5.5;

motor_bay_width = 24.5;
motor_bay_length = 54;
motor_bay_depth = 11.5;
motor_bay_bevel = 5;
motor_bay_bar_width = 4;
motor_bay_bar_thickness = 2;

board_rack_screw_spacing = 20;
board_rack_screw_x = 48;
board_rack_screw_y = 5;
board_rack_screw_diameter = 5;

motor_knob_spacing = 7.97;
motor_knob_height = 3;
motor_knob_diameter = 4;

underside_reinforcement_width = 5;
underside_reinforcement_height = 7.45;
underside_reinforcement_length = 45;
underside_reinforcement_bevel = 15;
underside_reinforcement_spacing = 55;

module quarter_frame(mount_step_depth=3) {
    mount_step_x = frame_length / 2 - mount_step_length;
    mount_step_y = frame_width / 2 - mount_step_depth;

    difference() {
        union() {
            cube([frame_length / 2, frame_width / 2, frame_thickness]);

            translate([
                mount_step_x - border_width,
                mount_step_y - border_width,
                0
            ]) {
                cube([
                    mount_step_length + border_width,
                    border_width + mount_step_depth,
                    total_height
                ]);
            }

            translate([0, frame_width / 2 - border_width, 0]) {
                cube([
                    frame_length / 2 - mount_step_length,
                    border_width,
                    total_height
                ]);
            }
        }

        mount_hole_y = mount_step_y - mount_hole_width - border_width;

        union() {
            translate([mount_step_x, mount_step_y, 0]) {
                cube([mount_step_length, mount_step_depth, total_height]);
            }

            translate([mount_step_x, mount_hole_y, 0]) {
                cube([
                    mount_step_length - border_width,
                    mount_hole_width,
                    total_height
                ]);
            }

            translate([
                mount_step_x + screw_hole_offset,
                mount_step_y,
                total_height / 2
            ]) rotate([90, 0, 0]) {
                cylinder(d=screw_hole_diameter, h=border_width);
            }

            translate([
                mount_step_x + screw_hole_spacing + screw_hole_offset,
                mount_step_y,
                total_height / 2
            ]) rotate([90, 0, 0]) {
                cylinder(d=screw_hole_diameter, h=border_width);
            }
        }
    }
}

module center_frame(mount_step_depth=3) {
    rear_hole_length = mount_step_length - beam_thickness;
    rear_hole_width = frame_width - 2 * (
        mount_step_depth + border_width + mount_hole_width + beam_thickness
    );

    rear_hole_x = (frame_length - rear_hole_length) / 2 - beam_thickness;

    motor_bay_x = frame_length / 2 - mount_step_length - beam_thickness;

    difference() {
        union() {
            quarter_frame(mount_step_depth);
            mirror([1, 0, 0]) {
                quarter_frame(mount_step_depth);
            }

            mirror([0, 1, 0]) {
                quarter_frame(mount_step_depth);
                mirror([1, 0, 0]) {
                    quarter_frame(mount_step_depth);
                }
            }

            translate([
                frame_length / 2 - beam_thickness,
                0,
                frame_thickness / 2
            ]) rotate([0, 90, 0]) {
                cylinder(
                    d = shaft_diameter + beam_thickness,
                    h = beam_thickness
                );
            }

            translate([motor_bay_x, 0, frame_thickness / 2])
            rotate([0, 90, 0]) {
                cylinder(
                    d = motor_bay_width,
                    h = beam_thickness
                );
            }

            translate([motor_bay_x, 0, 0]) rotate([0, 90, 0]) {
                linear_extrude(beam_thickness)
                    polygon([
                        [0, -motor_bay_width / 2],
                        [motor_bay_depth - motor_bay_bevel, -motor_bay_width / 2],
                        [motor_bay_depth, -motor_bay_width / 2 + motor_bay_bevel],
                        [motor_bay_depth, motor_bay_width / 2 - motor_bay_bevel],
                        [motor_bay_depth - motor_bay_bevel, motor_bay_width / 2],
                        [0, motor_bay_width / 2]
                    ]);
            }

            translate([motor_bay_x - motor_bay_length - beam_thickness, 0, 0])
            rotate([0, 90, 0]) {
                linear_extrude(beam_thickness)
                    polygon([
                        [0, -motor_bay_width / 2],
                        [motor_bay_depth - motor_bay_bevel, -motor_bay_width / 2],
                        [motor_bay_depth, -motor_bay_width / 2 + motor_bay_bevel],
                        [motor_bay_depth, motor_bay_width / 2 - motor_bay_bevel],
                        [motor_bay_depth - motor_bay_bevel, motor_bay_width / 2],
                        [0, motor_bay_width / 2]
                    ]);
            }

            translate([
                motor_bay_x - motor_bay_length / 2,
                0,
                -motor_bay_depth + motor_bay_bar_thickness / 2,
            ]) {
                cube([
                    motor_bay_length,
                    motor_bay_bar_width,
                    motor_bay_bar_thickness,
                ], center = true);
            }
        }

        union() {
            translate([rear_hole_x, 0, frame_thickness / 2]) {
                cube([
                    rear_hole_length,
                    rear_hole_width,
                    frame_thickness
                ], center = true);
            }

            translate([
                motor_bay_x - motor_bay_length / 2,
                0,
                frame_thickness / 2
            ]) {
                cube([
                    motor_bay_length,
                    motor_bay_width,
                    frame_thickness
                ], center = true);
            }

            translate([motor_bay_x, 0, frame_thickness / 2 ])
            rotate([0, 90, 0]) {
                cylinder(
                    d = shaft_diameter,
                    h = mount_step_length + beam_thickness
                );
            }

            for (a = [-1, 1]) {
                for (b = [-1, 1]) {
                    translate([
                        motor_bay_x - board_rack_screw_x + a * board_rack_screw_spacing / 2,
                        b * (motor_bay_width / 2 + board_rack_screw_y),
                        frame_thickness / 2
                    ]) rotate([0, 0, 0]) {
                        cylinder(
                            d = board_rack_screw_diameter,
                            h = frame_thickness,
                            center=true
                        );
                    }
                }
            }
        }
    }

    translate([
        motor_bay_x - motor_knob_height / 2,
        0,
        frame_thickness / 2
    ]) rotate([0, 90, 0]) {
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

    translate([0, underside_reinforcement_spacing / 2, 0]) rotate([-90, 0, 0]) {
        linear_extrude(underside_reinforcement_width)
            polygon([
                [-underside_reinforcement_length / 2, 0],
                [underside_reinforcement_length / 2, 0],
                [underside_reinforcement_length / 2 - underside_reinforcement_bevel, underside_reinforcement_height],
                [-underside_reinforcement_length / 2 + underside_reinforcement_bevel, underside_reinforcement_height]
            ]);
    }

    translate([
        0,
        -underside_reinforcement_spacing / 2 - underside_reinforcement_width,
        0
    ]) rotate([-90, 0, 0]) {
        linear_extrude(underside_reinforcement_width)
            polygon([
                [-underside_reinforcement_length / 2, 0],
                [underside_reinforcement_length / 2, 0],
                [underside_reinforcement_length / 2 - underside_reinforcement_bevel, underside_reinforcement_height],
                [-underside_reinforcement_length / 2 + underside_reinforcement_bevel, underside_reinforcement_height]
            ]);
    }
}

center_frame();
