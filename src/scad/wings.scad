include <openscad-utilities/common.scad>
include <globals.scad>
use <robot common.scad>
use <snaps.scad>

feather_count = 5;
feather_width = 4;
feather_socket_width = feather_width + 2;
feather_depth = 2.5;
feather_angle = 20;
feather_pos = [0, 17, 3];
feather_z_offset = socket_d/2 + 8;

wing_assembly();

//blade_antenna(30);

module blade_antenna(l, is_cut = false, holes = 0) {
    w = 8;
    base_wa = feather_width;
    bot_notcha = 2;
    edge_margin = 0;
    top_w = 1.5;

    translate([0, 0, 0])
    rotate([0, 270, 0])
    union() {
        if (!is_cut) {
            translate([0, -base_wa/2, -feather_depth/2 + edge_d/2]) {
                difference() {
                    minkowski() {
                        linear_extrude(feather_depth - edge_d) {
                            offset(delta = -edge_d/2) {
                                antenna_2d(l, base_wa, bot_notcha, top_w, holes);
                            }
                        }
                        sphere(d = 1);
                    }
                    translate([-base_wa, 0, -base_wa/2]) {
                        cube([base_wa, base_wa, 2 * base_wa]);
                    }
                }
            }
        }
        translate([-0.5, 0]) {
            union() {
                translate([0, -base_wa/2, -feather_depth/2]) {
                    cube([0.5, base_wa, feather_depth]);
                }
                rotate(90) snaps_tabs(base_wa, 3, feather_depth, is_cut = is_cut, snap_tab_width = 1.2);
            }
        }
    }
}

module antenna_2d(l, base_w, bot_notch, top_w, holes = 0) {
    hole_dist = 4;
    translate([-base_w, 0]) {
        square([base_w, base_w]);
    }
    difference() {
        hull() {
            translate([top_w, -top_w]) {
                square([l - 2 * top_w, top_w]);
            }
            square([l, base_w]);
            translate([2.5 * bot_notch, base_w]) {
                square([l - 2.5 * bot_notch, bot_notch]);
            }
        }
        for (i = [0 : holes]) {
            translate([i * hole_dist + 4, (base_w + bot_notch + top_w)/2 - top_w]) {
                circle(d = 2);
            }
        }
        r = 2 *  (base_w + bot_notch)/2;
        translate([r + holes * hole_dist + 8 - 2, base_w + bot_notch + 2.5]) {
            hull() {
                circle(r = r);
                translate([l, 0]) {
                    circle(r = r);
                }
            }
        }
    }
}

module wing_base() {
    difference() {
        minkowski() {
            hull() {
                feather_socket_depth = feather_depth + 0.5;
                translate([0, 0, feather_z_offset]) {
                    for (i = [-1 : feather_count - 2]) {
                        place_at_index(feather_angle, feather_socket_width, i) {
                            linear_extrude(0.001) {
                                r = feather_socket_depth/2;
                                rounded_square_2([feather_socket_depth, feather_socket_width], r, r, r, r, center = true);
                            }
                        }
                    }
                }
                x = segment_height + 2.4 - edge_d;
                y = socket_d + 2.4 - edge_d;
                linear_extrude(socket_d/2) rounded_square_2([x, y], 2, 2, 2, 2, center = true);
                translate([0, 0, socket_d/2]) rotate([0, 90, 0]) cylinder(h = x, d = socket_d/2, center = true);
                translate([0, 13]) cylinder(h = 0.001, d = 2);
            }
            sphere(d = edge_d);
        }
        rotate([90, 0, 90]) socket_with_snaps(is_cut = true);
        rotate([0, 90, 0]) cylinder(d = 4.5, h = 20, center = true);
        place_feathers(true);
        translate([0, -25]) cube([50, 50, 50]);
    }
}

module wing_assembly() {
    color(armor_color) wing_base();
    color(frame_color) place_feathers();
    rotate([90, 0, 90]) {
        color(frame_color) socket_with_snaps();
    }
}

module place_feathers(is_cut = false) {
    translate([0, 0, feather_z_offset]) {
        for (i = [-1 : feather_count - 2]) {
            feather_len = 20 + 4 * (feather_count - i - 2);
            place_at_index(feather_angle, feather_socket_width, i) {
                translate([0, 0, edge_d/2]) {
                    blade_antenna(feather_len, holes = feather_count - i - 2, is_cut = is_cut);
                }
            }
        }
    }
}

module place_at_index(angle, part_len, placement_index, i = 0) {
    increment = placement_index/abs(placement_index);
    if (i == placement_index) {
        children();
    } else {
        translate([0, increment * part_len/2]) {
            rotate([increment * -angle, 0, 0]) {
                translate([0, increment * part_len/2]) {
                    place_at_index(angle, part_len, placement_index, i + increment) {
                        children();
                    }
                }
            }
        }
    }
}
