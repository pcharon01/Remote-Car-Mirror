/*
 * Copyright (c) 2026 Patrick Charon
 * Licensed under CERN-OHL-P <https://cern-ohl.web.cern.ch/>
*/

frame_width = 80;
frame_thickness = 5;
border_height = 5;
border_width = 2.5;
border_thickness = frame_thickness + border_height;

arch_width = 60;
arch_length = 66;
arch_height = 20;

beam_width = 4;
arch_thickness = 5;

grid_offset = 10;

front_step_length = 30;

mount_bracket_length = 25;
mount_screw_spacing = 10;
mount_screw_offset = 2.5;
mount_screw_diameter = 5;

shaft_diameter = 5.5;

axle_screw_diameter = 4.5;

tail_length = 26;
rear_bumper_width = 75;

module rear_frame() {
    difference() {
        union() {
            translate([0, 0, arch_height / 2]) {
                cube([arch_length, arch_width, arch_height], center = true);
            }

            for (x = [beam_width * 3 / 2 + grid_offset, arch_length - beam_width * 3 / 2 - grid_offset]) {
                for (y = [-1, 1]) {
                    translate([
                        x - arch_length / 2,
                        y * (arch_width - beam_width) / 2,
                        arch_height + frame_thickness / 2
                    ]) {
                        cube([
                            beam_width,
                            beam_width,
                            frame_thickness
                        ], center = true);
                    }

                    translate([
                        0,
                        y * (arch_width / 2 - grid_offset - beam_width * 3 / 2),
                        arch_height + arch_thickness / 2 + frame_thickness
                    ]) {
                        cube([
                            arch_length,
                            beam_width,
                            arch_thickness
                        ], center = true);
                    }
                }
            }

            for (y = [beam_width * 3 / 2 + grid_offset, arch_width - beam_width * 3 / 2 - grid_offset]) {
                for (x = [-1, 1]) {
                    translate([
                        x * (arch_length - beam_width) / 2,
                        y - arch_width / 2,
                        arch_height + frame_thickness / 2
                    ]) {
                        cube([
                            beam_width,
                            beam_width,
                            frame_thickness
                        ], center = true);
                    }

                    translate([
                        x * (arch_length / 2 - grid_offset - beam_width * 3 / 2),
                        0,
                        arch_height + arch_thickness / 2 + frame_thickness
                    ]) {
                        cube([
                            beam_width,
                            arch_width,
                            arch_thickness
                        ], center = true);
                    }
                }
            }

            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([
                        x * (arch_length - beam_width) / 2,
                        y * (arch_width / 2 + (frame_width - arch_width) /4),
                        arch_height / 2
                    ]) {
                        cube([
                            beam_width,
                            (frame_width - arch_width) / 2,
                            arch_height
                        ], center = true);
                    }
                }
            }

            translate([
                -(arch_length + front_step_length) / 2,
                0,
                frame_thickness / 2
            ]) {
                cube([
                    front_step_length,
                    frame_width,
                    frame_thickness
                ], center = true);
            }

            for (y = [-1, 1]) {
                translate([
                    -(arch_length + front_step_length) / 2,
                    y * (frame_width - border_width) / 2,
                    border_height / 2 + frame_thickness
                ]) {
                    cube([
                        front_step_length,
                        border_width,
                        border_height
                    ], center = true);
                }

                translate([
                    -(arch_length / 2 + front_step_length / 2),
                    y * (arch_width - frame_thickness) / 2,
                    border_height / 2 + frame_thickness
                ]) {
                    cube([
                        front_step_length,
                        frame_thickness,
                        border_height
                    ], center = true);
                }

                translate([
                    -(arch_length / 2 + front_step_length + mount_bracket_length / 2),
                    y * (frame_width - border_width) / 2,
                    border_thickness / 2
                ]) {
                    cube([
                        mount_bracket_length,
                        border_width,
                        border_thickness
                    ], center = true);
                }
            }

            for (y = [-1, 1]) {
                translate([
                    -arch_length / 2,
                    y * (frame_width - border_width) / 2,
                    border_thickness
                ]) rotate([90, 0, 0]) {
                    triangle_side = arch_height - border_thickness;

                    linear_extrude(border_width, center=true)
                        polygon([
                            [-2 * triangle_side, 0],
                            [0, 0],
                            [0, triangle_side]
                        ]);
                }

                translate([
                    -arch_length / 2,
                    y * (arch_width - frame_thickness) / 2,
                    border_thickness
                ]) rotate([90, 0, 0]) {
                    triangle_side = arch_height - border_thickness;

                    linear_extrude(frame_thickness, center=true)
                        polygon([
                            [-2 * triangle_side, 0],
                            [0, 0],
                            [0, triangle_side]
                        ]);
                }

                for (x = [-(arch_length / 2 + front_step_length), -(arch_length / 2), arch_length / 2 - beam_width]) {
                    translate([
                        x,//-(arch_length / 2 + front_step_length),
                        0,
                        frame_thickness / 2
                    ]) rotate([0, 90, 0]) {
                        cylinder(d = shaft_diameter + beam_width, h = beam_width);
                    }
                }

            }

            for (y = [-1, 1]) {
                translate([
                    arch_length / 2,
                    y * (arch_width - frame_thickness) / 2,
                    0
                ]) rotate([90, 0, 0]) {
                    linear_extrude(frame_thickness, center = true) {
                        polygon([
                            [0, 0],
                            [tail_length, frame_thickness],
                            [tail_length, 2 * frame_thickness],
                            [tail_length - 2 * frame_thickness, 2 * frame_thickness],
                            [0, 4 * frame_thickness]
                        ]);
                    }

                    translate([
                        tail_length - frame_thickness / 2,
                        5/2 * frame_thickness,
                        0
                    ]) {
                        cube(frame_thickness, center = true);
                    }
                }
            }

            translate([
                arch_length / 2 + tail_length - frame_thickness / 2,
                0,
                7/2 * frame_thickness
            ]) {
                cube([
                    frame_thickness,
                    rear_bumper_width,
                    frame_thickness
                ], center = true);
            }
        }

        union() {
            translate([0, 0, (arch_height - arch_thickness) / 2]) {
                cube([
                    arch_length - 2 * beam_width,
                    arch_width,
                    arch_height - arch_thickness
                ], center = true);
            }

            translate([0, 0, arch_height - arch_thickness / 2]) {
                cube([
                    arch_length - 2 * beam_width,
                    arch_width - 2 * beam_width,
                    arch_thickness
                ], center = true);
            }

            for (x = [-1, 1]) {
                translate([
                    x * (arch_length / 2 - grid_offset - beam_width * 3 / 2),
                    arch_width / 2 - beam_width,
                    arch_height + arch_thickness + (arch_thickness - beam_width)
                ]) rotate([0, -90, 0]) {
                    linear_extrude(beam_width, center = true)
                        polygon([
                            [0, beam_width],
                            [beam_width, 0],
                            [beam_width, beam_width]
                        ]);
                }

                translate([
                    x * (arch_length / 2 - grid_offset - beam_width * 3 / 2),
                    -arch_width / 2 + beam_width,
                    arch_height + arch_thickness + (arch_thickness - beam_width)
                ]) rotate([180, -90, 0]) {
                    linear_extrude(beam_width, center = true)
                        polygon([
                            [0, beam_width],
                            [beam_width, 0],
                            [beam_width, beam_width]
                        ]);
                }
            }

            for (y = [-1, 1]) {
                translate([
                    arch_length / 2 - beam_width,
                    y * (arch_width / 2 - grid_offset - beam_width * 3 / 2),
                    arch_height + arch_thickness + (arch_thickness - beam_width)
                ]) rotate([0, -90, -90]) {
                    linear_extrude(beam_width, center = true)
                        polygon([
                            [0, beam_width],
                            [beam_width, 0],
                            [beam_width, beam_width]
                        ]);
                }

                translate([
                    -arch_length / 2 + beam_width,
                    y * (arch_width / 2 - grid_offset - beam_width * 3 / 2),
                    arch_height + arch_thickness + (arch_thickness - beam_width)
                ]) rotate([0, -90, 90]) {
                    linear_extrude(beam_width, center = true)
                        polygon([
                            [0, beam_width],
                            [beam_width, 0],
                            [beam_width, beam_width]
                        ]);
                }
            }

            translate([
                -(arch_length + front_step_length - beam_width) / 2,
                0,
                frame_thickness / 2
            ]) {
                cube([
                    front_step_length - beam_width,
                    arch_width - frame_thickness * 4,
                    frame_thickness
                ], center = true);
            }

            translate([
                -(arch_length / 2 - beam_width),
                0,
                frame_thickness / 2
            ]) rotate([0, -90, 0]) {
                cylinder(d = shaft_diameter, h = front_step_length + beam_width);
            }

            translate([
                arch_length / 2 - beam_width,
                0,
                frame_thickness / 2
            ]) rotate([0, 90, 0]) {
                cylinder(d = axle_screw_diameter, h = beam_width);
            }

            for (y = [-1, 1]) {
                for (x = [0, mount_screw_spacing]) {
                    translate([
                        -(arch_length / 2 + front_step_length + mount_bracket_length - mount_screw_offset - mount_screw_diameter / 2 - x),
                        y * (frame_width - border_width) / 2,
                        border_thickness / 2
                    ]) rotate([90, 0, 0]) {
                        cylinder(d = mount_screw_diameter, h = border_width, center = true);
                    }
                }
            }
        }
    }
}

rear_frame();
