module quarter_chassis() {
    difference() {
        union() {
            cube([49, 40, 5]);

            translate([49 - 28.5, 40 - 5, 0]) {
                cube([28.5, 5, 10]);
            };

            translate([0, 40 - 2.5, 0]) {
                cube([49 - 28.5, 2.5, 10]);
            };
        }

        union() {
            translate([49 - 26, 40 - 2.5, 0]) {
                cube([26, 2.5, 10]);
            }

            translate([49 - 26, 40 - 15, 0]){
                cube([26 - 2.5, 10, 5]);
            }

            translate([26 + 4, 40 - 2.5, 5]) rotate([90, 90, 0]) {
                cylinder(r=2.5,h=2.5);
                translate([0, 10, 0]) cylinder(r=2.5, h=2.5);
            }
        }
    }
}

difference() {
    union() {
        quarter_chassis();
        mirror([1, 0, 0]) {
            quarter_chassis();
        }

        mirror([0, 1, 0]) {
            quarter_chassis();
            mirror([1, 0, 0]) {
                quarter_chassis();
            }
        }

        rotate([0, 90, 0]) translate([-2, 0, 19])
            cylinder(d=24.5,h=4);

        translate([19, 0, 0]) rotate([0, 90, 0]) linear_extrude(4)
            polygon([[0, 12.25], [6.5, 12.25], [11.5, 7.25], [11.5, -7.5], [6.5, -12.25], [0, -12.25]]);

        translate([-39, 0, 0]) rotate([0, 90, 0]) linear_extrude(4)
            polygon([[0, 12.25], [6.5, 12.25], [11.5, 7.25], [11.5, -7.5], [6.5, -12.25], [0, -12.25]]);

        translate([45, 0, 2.5]) rotate([0, 90, 0])
            cylinder(d=9.5, h=4);
    }

    translate([23, -21, 0])
        cube([22, 42, 5]);

    translate([-35, -24.5 / 2, 0])
        cube([54, 24.5, 5]);

    translate([19, 0, 2.5]) rotate([0, 90, 0])
        cylinder(d=5.5, h=30);

    translate([19 - 38, 17.25, 0])
        cylinder(d=5, h=5);

    translate([19 - 58, 17.25, 0])
        cylinder(d=5, h=5);

    translate([19 - 38, -17.25, 0])
        cylinder(d=5, h=5);

    translate([19 - 58, -17.25, 0])
        cylinder(d=5, h=5);
}

translate([-35, -2, -11.5])
    cube([54, 4, 2]);

translate([16, 0, 2.5]) rotate([0, 90, 0]) {
    union() {
        translate([7.97, 0, 0])
            cylinder(d=4, h=3);

        translate([-7.97, 0, 0])
            cylinder(d=4, h=3);

        translate([0, 7.97, 0])
            cylinder(d=4, h=3);

        translate([0, -7.97, 0])
            cylinder(d=4, h=3);
    }
}

translate([0, -32.5, 0]) rotate([-90, 0, 0]) linear_extrude(5)
    polygon([[-22.5, 0], [-7.5, 7.45], [7.5, 7.45], [22.5, 0]]);

translate([0, 27.5, 0]) rotate([-90, 0, 0]) linear_extrude(5)
    polygon([[-22.5, 0], [-7.5, 7.45], [7.5, 7.45], [22.5, 0]]);
