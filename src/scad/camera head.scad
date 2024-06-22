include <openscad-utilities/common.scad>
include <globals.scad>
use <robot common.scad>
use <antenna.scad>

lens_diameter = 12;
eye_socket_diameter = lens_diameter + 2;
head_cube_y_offset = 4.5;

head_cube_x = eye_socket_diameter + 2 * min_wall_width + 1;
head_cube_y = eye_socket_diameter + 2 * min_wall_width + 1;
head_cube_z = 14;
antenna_angle = 45;

function neck_max_angle() = 18;

//head_assembly();
//socket_with_snaps();

module head_assembly(
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
    color(armor_color) camera_head();
    antenna_position(antenna_explode_x) {
        color(frame_color) camera_head_antenna_left();
    }
    translate([0, head_cube_y_offset, head_cube_z/2 - 0.5 + lens_explode_z]) color(frame_color) lens();
}

module camera_head_antenna_left(is_cut = false) {
    antenna_left(is_cut = is_cut, antenna_angle = antenna_angle);
}

module antenna_position(x_offset = 0) {
    reflect([1, 0, 0]) {
        translate([(eye_socket_diameter + 2 * antenna_depth() + 1)/2 + 1.2 + x_offset, 6]) {
            rotate([-antenna_angle, 0, 0]) {
                rotate([0, 270, 0]) {
                    children();
                }
            }
        }
    }
}

shroud();

module shroud() {
    y_adjust = 1.5;
    head_corner_r = 4;

    difference() {
        minkowski() {
            translate([0, y_adjust/2, edge_d/2]) {
                head_block(head_cube_x - edge_d, head_cube_y - edge_d - y_adjust, head_cube_z - edge_d);
            }
            sphere(d = 1);
        }
        translate([0, -min_wall_width + y_adjust/2, 1.5]) {
            head_block(head_cube_x - 2 * min_wall_width, head_cube_y - y_adjust, head_cube_z, head_corner_r - min_wall_width/2);
        }
    }
    intersection() {
        translate([0, 0, edge_d/2]) {
            head_block(head_cube_x - edge_d, head_cube_y - edge_d, head_cube_z);
        }
        union() {
            inner_block_dist_from_edge = 3;
            translate([0, y_adjust + inner_block_dist_from_edge, head_cube_z/2 - inner_block_dist_from_edge]) {
                rotate([0, 90, 0]) {
                    rounded_cube(
                        [head_cube_z, head_cube_y, head_cube_x],
                        d = 5, top_d = 0, bottom_d = 0, center = true
                    );
                }
            }
            cylinder(d = eye_socket_diameter, h = head_cube_z);
        }
    }

    module head_block(x, y, z, head_corner_r = head_corner_r) {
        slope_d = 45;
        translate([0, -head_corner_r + y/2]) {
            intersection() {
                hull() {
                    reflect([1, 0, 0]) {
                        translate([x/2 - head_corner_r, 0]) {
                            rotate_extrude(angle = 90) {
                                head_part_2d(head_corner_r, slope_d, z, 10);
                            }
                        }
                        rotate([90, 0, 0]) {
                            linear_extrude(y - head_corner_r) {
                                head_part_2d(x/2, slope_d, z, 10);
                            }
                        }
                    }
                }
                translate([x/2, head_corner_r]) {
                    rotate([90, 0, 270]) cube_one_round_corner([y, z, x], 1.5);
                }
            }
        }
    }

    module head_part_2d(width, d, height, height_2) {
        intersection() {
            union() {
                translate([-d/2 + width, height_2]) circle(d = d);
                translate([0, height_2]) square([width, height - height_2]);
            }
            square([width, height]);
        }
    }
}

module camera_head() {
    difference() {
        translate([0, head_cube_y_offset, -head_cube_z/2]) {
            head_base(lens_diameter);
        }
        antenna_position() camera_head_antenna_left(true);
        translate([0, -10 + socket_d/2, 0]) {
            rotate([-90, 0, 0]) cylinder(d = socket_d, h = 10);
        }
        socket_with_snaps(true);
    }

    module head_base(lens_diameter) {
        eye_socket_diameter = lens_diameter + 2;
        extension_past_shroud = 0.8;
        lens_depth = 1.5;
        tension_fit_adjust = 0.2;

        difference() {
            union() {
                shroud();
                translate([0, 0, head_cube_z]) {
                    cylinder(d = eye_socket_diameter, h = extension_past_shroud);
                }
            }
            translate([0, 0, head_cube_z + extension_past_shroud - lens_depth]) {
                cylinder(d = lens_diameter - tension_fit_adjust, h = lens_depth + 0.1);
            }
        }
    }
}

module lens() {
    radius = 10;
    distance_from_center = sqrt(radius ^ 2 - (lens_diameter ^ 2) / 4);
    base_z = 0.5;

    intersection() {
        cylinder(d = lens_diameter, h = radius);
        translate([0, 0, -distance_from_center + base_z]) sphere(r = radius);
    }
}
