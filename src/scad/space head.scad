include <openscad-utilities/common.scad>
include <globals.scad>
use <robot common.scad>
use <antenna.scad>
use <snaps.scad>

head_width = 13;
head_front_r = 4;
head_flat_width = max(0, head_width - 2 * head_front_r);

head_depth = 15;
head_depth_adjusted = head_depth - edge_d;
head_x_dist = 3;
head_height = 19;
head_cut_angle = 40;
chin_r = 21;

head_antenna_angle = -45;
visor_depth = -0.2;
head_socket_pos = [0, 0.3, -4];

space_head_assembly();

module space_head_assembly(
    frame_color = frame_color,
    armor_color = armor_color,
    explode = false
) {
    lens_explode_z = explode ? 15 : 0;
    antenna_explode_x = explode ? 20 : 0;

    if (explode) {
        reflect([1, 0, 0]) {
            translate([antenna_explode_x/1.2, 0, 6]) {
                rotate(270) assembly_arrow();
            }
        }
    }
    if (explode) {
        translate([0, head_socket_pos[1] + 10, 6]) {
            rotate([0, 0, 0]) assembly_arrow();
        }
    }
    color(armor_color) space_head();
    translate(head_socket_pos) {
        antenna_position(antenna_explode_x) {
            color(frame_color) space_head_antenna_left();
        }
        translate([0, visor_depth + lens_explode_z, 0]) color(frame_color) visor();
    }
}

module visor() {
    difference() {
        intersection() {
            space_head_without_visor();
            visor_cut();
        }
        visor_pegs(true);
    }
}

module visor_cut(is_cut) {
    cut_depth = segment_cut_height/2 + 2 + visor_depth;
    d = is_cut ? 3.1 : 3;
    hull() {
        reflect([1, 0, 0]) {
            translate([0.5, cut_depth, 4]) rotate([-90, 0, 0]) cylinder(d = d, h = head_depth/2 - cut_depth + 1);
            translate([4, cut_depth, 12.5]) rotate([-90, 0, 0]) cylinder(d = d, h = head_depth/2 - cut_depth + 1);
        }
    }
}

module visor_pegs(is_cut = false) {
    cut_adjust = is_cut ? 0.15 : 0;
    translate([0, segment_cut_height/2 + 2 + visor_depth, 0]) {
        translate([0, 0, 8.5]) rotate([270, 0, 0]) rounded_cylinder(1.7 + cut_adjust, 3 + cut_adjust, 1, 0);
    }
}

module space_head_for_print() {
    rotate([head_cut_angle, 0, 180]) space_head();
}

module space_head() {
    difference() {
        translate(head_socket_pos) space_head_with_accessory_sockets();
        socket_cut();
    }

    module socket_cut() {
        rotate([45 - head_cut_angle, 0, 0]) {
            rotate([90, 0, 0]) socket_with_snaps(true);
            translate([-head_width/2, -head_depth + segment_cut_height/2, 1.5]) {
                rotate([0, 90, 0]) {
                    rounded_cube([head_height/2, head_depth, head_width], d = 3, top_d = 0, bottom_d = 0);
                }
            }
            translate([0, segment_cut_height/2, 0]) rotate(45) cube([1, 1, socket_d], center = true);
        }
    }
}

module space_head_with_accessory_sockets() {
    difference() {
        space_head_without_visor();
        antenna_position() space_head_antenna_left(true);
        visor_cut(true);
    }
    visor_pegs();
}

module space_head_without_visor() {
    head_width_adjusted = head_width - edge_d;
    head_height = head_height - edge_d;
    head_mid_h = 0;

    head_form_rounded();

    module head_form_rounded() {
        translate([0, 0, edge_d/2]) {
            minkowski() {
                rotate(90) head_form_with_back_cut();
                sphere(d = edge_d);
            }
        }
    }

    module head_form_with_back_cut() {
        cut_offset = head_depth_adjusted/2 - head_x_dist + 1;

        difference() {
            head_form();
            translate([cut_offset, 0, 0]) {
                rotate([0, head_cut_angle, 0]) {
                    translate([-head_height, -head_width/2, -head_depth]) {
                        cube([head_height, head_width, head_depth]);
                    }
                }
            }
        }
    }

    module head_form() {
        hull() {
            translate([0, 0, -head_depth_adjusted/2 + head_height]) {
                rotate([90, 0, 0]) {
                    rotate_extrude() {
                        translate([-head_x_dist + head_depth_adjusted/2, 0]) {
                            hull() {
                                reflect([0, 1, 0]) {
                                    translate([0, head_flat_width/2]) {
                                        circle_corner(head_x_dist, head_width_adjusted/2 - head_flat_width/2, head_front_r);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            reflect([0, 1, 0]) {
                chin_len = head_height - head_depth_adjusted/2 - head_mid_h;
                translate([-head_x_dist + head_depth_adjusted/2, 0, chin_len]) {
                    rotate([0, 270, 0]) {
                        intersection() {
                            translate([-chin_len, 0, -head_x_dist]) {
                                cube([chin_len, head_depth_adjusted/2, head_x_dist]);
                            }
                            translate([0, -chin_r + head_front_r + head_flat_width/2]) {
                                rotate_extrude()
                                translate([chin_r - head_front_r, 0])
                                rotate(270)
                                circle_corner(head_x_dist, head_width_adjusted/2 - head_flat_width/2, head_front_r);
                            }
                        }
                    }
                }
           }
       }
    }
}

module space_head_antenna_left(is_cut = false) {
    antenna_left(is_cut = is_cut, antenna_angle = 0);
}

module antenna_position(x_offset = 0) {
    reflect([1, 0, 0]) {
        translate([head_width/2 + x_offset, 0, head_height - head_depth/2]) {
            rotate([head_antenna_angle + 180, 0, 0]) {
                rotate([0, 270, 0]) {
                    children();
                }
            }
        }
    }
}
