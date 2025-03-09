include <openscad-utilities/common.scad>
include <globals.scad>
use <openscad-utilities/arrow.scad>
use <snaps.scad>

socket_opening_angle = 115;

module apply_socket_cut(ball_offset = 0, socket_angle = 0, cut_angle = socket_opening_angle, is_cut = false) {
    height = segment_height + (is_cut ? segment_cut_height_offset : 0);
    width = socket_d + (is_cut ? segment_cut_width_offset : 0);

    difference() {
        children();
        if (!is_cut) rotate(socket_angle) socket_cut(cut_angle, ball_offset);
    }
    if (is_cut) ball_for_armor_subtractions();
}

module socket_cut(cut_angle = socket_opening_angle, ball_offset) {
    translate([0, 0, -socket_d/2]) {
        rotate(180) wedge(cut_angle, socket_d/2, socket_d);
    }
    sphere(d = ball_d + ball_offset);
    hull () {
        cylinder(h = socket_d, d = 4, center = true);
        translate([0, -socket_d/2, 0]) {
            cylinder(h = socket_d, d = 4, center = true);
        }
    }
}

module rounded_socket_blank(is_cut = false, cylinder_length, has_cylinder = true) {
    height = is_cut ? segment_cut_height : segment_height;
    socket_width = is_cut ? socket_d + 0.25 : socket_d;
    cylinder_length = is_undef(cylinder_length) ? socket_width/2 : cylinder_length;
    round_from_edge = 2;
    d = 7;

    rotate_extrude() {
        intersection() {
            armor_2d(socket_width, height, round_from_edge, d);
            translate([0, -height/2]) square([socket_width/2, height]);
        }
    }
    if (has_cylinder) {
        rotate([270, 0, 0]) linear_extrude(cylinder_length) {
            armor_2d(socket_width, height, round_from_edge, d);
        }
    }
}

module ball_for_armor_subtractions() sphere(d = ball_d + 0.2);

module ball(is_cut = false, tab_extension = 0) {
    if (is_cut) {
        translate([-segment_cut_width/2, 0, -segment_cut_height/2]) {
            cube([segment_cut_width, ball_d/2 + ball_tab_len + tab_extension, segment_cut_height]);
        }
    } else {
        xy_cut(ball_cut_height, size = ball_d) {
            sphere(d = ball_d);
        }
        translate([-segment_width/2, 0]) {
            rotate([0, 90, 0]) {
                linear_extrude(segment_width){
                    polygon(
                        [
                            [segment_height/4, 0],
                            [segment_height/4, ball_d/2],
                            [segment_height/2, ball_d/2 + ball_tab_len],
                            if (tab_extension > 0) [segment_height/2, ball_d/2 + ball_tab_len + tab_extension],

                            if (tab_extension > 0) [-segment_height/2, ball_d/2 + ball_tab_len + tab_extension],
                            [-segment_height/2, ball_d/2 + ball_tab_len],
                            [-segment_height/4, ball_d/2],
                            [-segment_height/4, 0],
                        ]
                    );
                }
            }
        }
    }
}

module apply_armor_cut(is_top = false) {
    armor_tightness_adjust = 0.05;

    xy_cut(armor_tightness_adjust, from_top = true, size = 100) {
        rotate([0, is_top ? 180 : 0, 0]) {
            difference() {
                children(0);
                children(1);
            }
        }
    }
}

module socket_with_snaps(is_cut = false) {
    cut_adjust = is_cut ? 0.15 : 0;
    height = is_cut ? segment_cut_height : segment_height;

    tab_len = 3.5;
    tab_width = 4;

    apply_socket_cut(head_and_foot_tolerance, is_cut = is_cut) {
        rounded_socket_blank(is_cut);
    }

    translate([0, socket_d/2]) snaps_tabs(tab_width, tab_len, height, is_cut);
}

module cross_brace(depth, target_width, is_cut) {
    height = is_cut ? segment_cut_height : segment_height;
    cut_adjust = is_cut ? 0.1 : 0;

    translate([0, 0, -height/2]) {
        linear_extrude(height) {
            hull() {
                reflect([1, 0, 0]) {
                    translate([target_width/2, 0]) {
                        circle(d = depth + cut_adjust);
                    }
                }
            }
        }
    }
}

module shoulder_cut(x, pos_y, neg_y, pos_z, neg_z, ext, d) {
    rotate([0, 270, 0]) {
        translate([-neg_z, -pos_y, -x/2]) {
            linear_extrude(x) {
                hull() {
                    difference() {
                        square([pos_z + neg_z, pos_y + neg_y]);
                        square([d/2, d/2]);
                    }
                    translate([d/2, d/2 - ext]) circle(d = d);
                }
            }
        }
    }
}

module armor_section(x, y, z, left_d, right_d, center = false, round_len = 3) {
    translate([0, center ? -y/2 : 0]) {
        rotate([270, 0, 0]) {
            linear_extrude(y) {
                armor_2d(x, z, round_len, 8, left_d, right_d);
            }
        }
    }
}

module armor_2d(x, y, round_len = 3, d = 8, left_d, right_d) {
    mid = y - 2 * round_len;
    left_d = is_positive(left_d) ? left_d : d;
    right_d = is_positive(right_d) ? right_d : d;

    hull() {
        reflect([0, 1, 0]) {
            translate([0, mid/2]) circle_corner(x/2, round_len, left_d/2);
            mirror([1, 0, 0]) translate([0, mid/2]) circle_corner(x/2, round_len, right_d/2);
        }
    }
}

module circle_corner(x, y, r) {
    intersection() {
        translate([-r + x, r > y ? 0 : -r + y]) circle(r);
        square([x, y]);
    }
}

module square_with_chamfers(x, y, chamfer_x, chamfer_y) {
    polygon(
        [
            [x/2, y/2 - chamfer_y],
            [x/2 - chamfer_x, y/2],
            [-x/2 + chamfer_x, y/2],
            [-x/2, y/2 - chamfer_y],
            [-x/2, -y/2 + chamfer_y],
            [-x/2 + chamfer_x, -y/2],
            [x/2 - chamfer_x, -y/2],
            [x/2, -y/2 + chamfer_y],
        ]
    );
}

module assembly_arrow() {
    arrow(head_width = 4, length = 7, center = true);
}
