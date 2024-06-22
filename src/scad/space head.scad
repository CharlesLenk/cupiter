include <openscad-utilities/common.scad>
include <globals.scad>
use <robot common.scad>
use <antenna.scad>

head_alt_width = 13;
head_alt_front_r = 4;

head_alt_flat_with = max(0, head_alt_width - 2 * head_alt_front_r);

head_alt_depth = 15;
head_alt_depth_adjusted = head_alt_depth - edge_d;
head_alt_x_dist = 3;
head_alt_height = 19;
head_alt_cut_angle = 40;

chin_r = 20;

space_head();

head_alt_antenna_angle = 90;

eye_r = 1.5;

// translate([0, 5.96, 3])


// difference() {

// translate([0, 6, 3])
// rotate([-90, 0, 0])
// rotate(90)

//     thing(eye_r, 4);

// }

// difference() {
//     space_head();
//     test(true);
// }

// translate([0, -0.01])
// color("GREY")
// intersection() {
//     space_head();
//     test();
// }

// lens();
// lens_cut();
//space_head_assembly();

module space_head_assembly(
    frame_color = frame_color,
    armor_color = armor_color,
    explode = false
) {
    lens_explode_z = explode ? 15 : 0;
    antenna_explode_x = explode ? 25 : 0;

    if (explode) {
        reflect([1, 0, 0]) {
            translate([antenna_explode_x, 6, 0]) {
                rotate(270) assembly_arrow();
            }
        }
    }
    if (explode) {
        translate([0, head_cube_y_offset, head_cube_z/2 + lens_explode_z/2]) {
            rotate([90, 0, 0]) assembly_arrow();
        }
    }
    color(armor_color) space_head();
    antenna_position(antenna_explode_x) {
        color(frame_color) space_head_antenna_left();
    }
    translate([0, 4, 0]) color(frame_color) visor();
}

module space_head_antenna_left(is_cut = false) {
    antenna_left(is_cut = is_cut, antenna_angle = 0);
}

module visor() {
    intersection() {
        space_head();
        lens_cut();
    }
}

head_alt_socket_pos = [0, 0.5, -4];

module visor_cut(is_cut) {
    cut_depth = segment_cut_height/2 + 2;
    d = is_cut ? 3.1 : 3;
    hull() {
        reflect([1, 0, 0]) {
            translate([0.5, cut_depth, 0]) rotate([-90, 0, 0]) cylinder(d = d, h = 10);
            translate([3.5, cut_depth, 9]) rotate([-90, 0, 0]) cylinder(d = d, h = 10);
        }
    }
}

// translate([0, segment_cut_height/2 + 2, 6])
// snaps_tabs(4, 2, 2, false, snap_depth = 1.2);

module antenna_position(x_offset = 0) {
    reflect([1, 0, 0]) {
        translate(
            [
                head_alt_width/2,
                head_alt_socket_pos[1],
                head_alt_height - head_alt_depth/2 + head_alt_socket_pos[2]
            ]
        ) {
            rotate([45 - head_alt_antenna_angle + 180, 0, 0]) {
                rotate([0, 270, 0]) {
                    children();
                }
            }
        }
    }
}

module space_head() {
    head_alt_width_adjusted = head_alt_width - edge_d;
    head_alt_height = head_alt_height - edge_d;
    head_alt_mid_h = 1;

    module head_form() {
        hull() {
            translate([0, 0, -head_alt_depth_adjusted/2 + head_alt_height]) {
                rotate([90, 0, 0]) {
                    rotate_extrude() {
                        translate([-head_alt_x_dist + head_alt_depth_adjusted/2, 0]) {
                            hull() {
                                reflect([0, 1, 0]) {
                                    translate([0, head_alt_flat_with/2]) {
                                        circle_corner(head_alt_x_dist, head_alt_width_adjusted/2 - head_alt_flat_with/2, head_alt_front_r);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            translate([-head_alt_x_dist + head_alt_depth_adjusted/2, 0, head_alt_height - head_alt_depth_adjusted/2 - head_alt_mid_h]) {
                linear_extrude(head_alt_mid_h) {
                    hull() {
                        reflect([0, 1, 0]) {
                            translate([0, head_alt_flat_with/2]) {
                                circle_corner(head_alt_x_dist, head_alt_width_adjusted/2 - head_alt_flat_with/2, head_alt_front_r);
                            }
                        }
                    }
                }
            }
            reflect([0, 1, 0]) {
                chin_len = head_alt_height - head_alt_depth_adjusted/2 - head_alt_mid_h;
                translate([-head_alt_x_dist + head_alt_depth_adjusted/2, 0, chin_len]) {
                    rotate([0, 270, 0]) {
                        intersection() {
                            translate([-chin_len, 0, -head_alt_x_dist]) {
                                cube([chin_len, head_alt_depth_adjusted/2, head_alt_x_dist]);
                            }
                            translate([0, -chin_r + head_alt_front_r + head_alt_flat_with/2]) {
                                rotate_extrude()
                                translate([chin_r - head_alt_front_r, 0])
                                rotate(270)
                                circle_corner(head_alt_x_dist, head_alt_width_adjusted/2 - head_alt_flat_with/2, head_alt_front_r);
                            }
                        }
                    }
                }
           }
       }
    }

    module head_form_with_back_cut() {
        cut_offset = head_alt_depth_adjusted/2 - head_alt_x_dist + 1;
        translate([cut_offset, 0]) {
            rotate([0, head_alt_cut_angle, 0]) {
                xy_cut(size = 40) {
                    rotate([0, -head_alt_cut_angle, 0]) {
                        translate([-cut_offset, 0]) {
                            head_form();
                        }
                    }
                }
            }
        }
    }

    module with_jaw_cut() {
        difference() {
            translate(head_alt_socket_pos) {
                rotate(90) head_form_with_back_cut();
            }
            translate([-head_alt_width/2, -segment_cut_height/2 - head_alt_depth + edge_d/2, 2]) {
                rotate([0, 90, 0]) {
                    rounded_cube([8, segment_cut_height + head_alt_depth, head_alt_width], d = 4, top_d = 0, bottom_d = 0);
                }
            }
        }
    }

    module head_form_rounded() {
        minkowski() {
            with_jaw_cut();
            sphere(d = edge_d);
        }
    }

    difference() {
        head_form_rounded();
        antenna_position() {
            space_head_antenna_left(true);
        }
        rotate([90, 0, 0]) socket_with_snaps(true);
        lens_cut(true);
    }
}
