include <openscad-utilities/common.scad>
include <globals.scad>
use <robot common.scad>
use <snaps.scad>

//socket_with_snaps();

//rounded_socket_blank();

wing_assembly();

// base();
// translate([10, 0]) socket_with_snaps();
// translate([25, 0]) feather(15);

feather_count = 5;
feather_width = 6;
feather_depth = 2.5;
feather_angle = 20;
feather_pos = [0, 15, 5];

fangle2 = 20;

module place_feathers(count, angle, h, i = 0) {
    //rotate([-angle, 0, 0])
    if (i < count) {
        rotate([i > 0 ? angle : 0, 0, 0]) {
            translate([0, 0, i > 0 ? h : 0]) {
                rotate([angle, 0, 0]) {
                    children();
                }
                place_feathers(count, angle, h, i + 1) {
                    children();
                }
            }
        }
    }
}

// place_feather_at_index(feather_angle, feather_width, 0, 3) {
//     translate([0, 0, feather_width/2]) rotate([90, 0, 90]) feather(40);
// }

module place_feather_at_index(angle, h, placement_index, i = 0) {
    if (i <= placement_index) {
        rotate([i > 0 ? angle : 0, 0, 0]) {
            translate([0, 0, i > 0 ? h : 0]) {
                if (i == placement_index) {
                    rotate([angle, 0, 0]) {
                        children();
                    }
                }
                place_feather_at_index(angle, h, placement_index, i + 1) {
                    children();
                }
            }
        }
    }
}

module wing_base() {
    difference() {
        translate([0, 0, 0]) {
            minkowski() {
                hull() {
                    derpth = feather_depth + 0.5;
                    translate([-derpth/2, 0, 0] + feather_pos) {
                        rotate([fangle2, 0, 0])
                        place_feathers(feather_count, feather_angle, feather_width) {
                            cube([derpth, 0.001, feather_width]);
                            cube([derpth, 0.001, feather_width]);
                            cube([derpth, 0.001, feather_width]);
                            cube([derpth, 0.001, feather_width]);
                            cube([derpth, 0.001, feather_width]);
                        }
                    }
                    x = segment_height + 2.4 - edge_d;
                    y = socket_d + 2.4 - edge_d;
                    linear_extrude(socket_d/2) rounded_square_2([x, y], 2, 2, 2, 2, center = true);
                    linear_extrude(socket_d/2 + 4) rounded_square_2([x, y/2], 2, 2, 2, 2, center = true);
                    translate([0, 9]) cylinder(h = 0.001, d = 0.001);
                }
                sphere(d = edge_d);
            }
        }
        rotate([90, 0, 90]) socket_with_snaps(is_cut = true);
        rotate([0, 90, 0]) cylinder(d = 4.5, h = 20, center = true);
        translate(feather_pos) {
            rotate([fangle2, 0, 0]) {
                for (i = [0 : feather_count - 1]) {
                    place_feather_at_index(feather_angle, feather_width, i) {
                        feather(15 + 4 * i, is_cut = true);
                    }
                }
            }
        }
    }
}

module wing_assembly() {
    wing_base();
    translate(feather_pos) {
        rotate([fangle2, 0, 0]) {
            for (i = [0 : feather_count - 1]) {
                place_feather_at_index(feather_angle, feather_width, i) {
                    feather(15 + 4 * i);
                }
            }
        }
    }
    rotate([90, 0, 90]) socket_with_snaps();
}

module feather(length, is_cut = false) {
    width = is_cut ? feather_width + 0.1 : feather_width;
    height = is_cut ? feather_depth + 0.1 : feather_depth;

    translate([0, 0, feather_width/2]) {
        rotate([90, 0, 90]) {
            hull() {
                linear_extrude(0.001) {
                    feather_polygon(width, length);
                }
                translate([0, 0, -height/2]) {
                    linear_extrude(height) {
                        feather_polygon(width - height, length - height/2);
                    }
                }
            }
            translate([0.01, 0]) {
                rotate(90) snaps_tabs(width - height, 3, feather_depth, is_cut = is_cut);
            }
        }
    }

    module feather_polygon(width, length) {
        polygon(
            [
                [0, width/2],
                [length - width/2, width/2],
                [length, 0],
                [length - width/2, -width/2],
                [0, -width/2],
            ]
        );
    }
}
