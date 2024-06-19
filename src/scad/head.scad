include <openscad-utilities/common.scad>
include <globals.scad>
use <robot common.scad>

lens_diameter = 12;
eye_socket_diameter = lens_diameter + 2;
head_cube_y_offset = 4.5;

head_cube_x = eye_socket_diameter + 2 * min_wall_width + 1;
head_cube_y = eye_socket_diameter + 2 * min_wall_width + 1;
head_cube_z = 14;
antenna_angle = 45;

antenna_depth = 1.35;


// linear_extrude(10)
// circle_fragment(head_cube_x/2, 0, 3, 4);

// linear_extrude(5) {
//     circle_fragment(head_cube_x, 0, head_cube_x/2, 4);
// }

// rotate_extrude(angle = 180) {
//     rotate(90) circle_fragment(head_cube_x, 0, head_cube_x/2, 4);
// }

//head_assembly();

head_alt_width = 13;
head_alt_front_r = 4;
min_flat_width = 5;

head_alt_flat_with = max(0, head_alt_width - 2 * head_alt_front_r);

head_alt_depth = 15;
head_alt_depth_adjusted = head_alt_depth - edge_d;
head_alt_x_dist = 3;
head_alt_height = 19;
head_alt_cut_angle = 40;

chin_r = 20;

//translate([0, 20, 0]) rotate(-90) head_alt();

head_alt_antenna_angle = 90;

// reflect([1, 0, 0])
// color("GREY")
// hull() {
// translate([0, 7.5, 9])
// sphere(d = 4);
// translate([0, 7.5, 3])
// sphere(d = 4);
// }

eye_r = 1.5;

// translate([0, 5.96, 3])
// rotate([-90, 0, 0])
// rotate(90)
// difference() {

//     hull() {
//         thing(eye_r + 2.5, 0.01);
//         thing(eye_r + 0.5, 2);
//     }
//     thing(eye_r, 4);
// }

// difference() {

// translate([0, 6, 3])
// rotate([-90, 0, 0])
// rotate(90)

//     thing(eye_r, 4);

// }

head_alt_2();

module thing(eye_r, h) {
    eye_len = 12;

    hull() {
        translate([2 - eye_len/2, 0]) cylinder(h = h, r = eye_r + 0.5);
        translate([-2 + eye_len/2, 0]) cylinder(h = h, r = eye_r - 0.5);
    }
}

antenna_position_2() {
    //antenna_left(antenna_angle = 0);
}

head_alt_socket_pos = [0, 0.5, -4.5];

module antenna_position_2(x_offset = 0) {
    reflect([1, 0, 0]) {
        translate(
            [
                head_alt_width/2 + antenna_depth + x_offset,
                head_alt_socket_pos[1],
                head_alt_height - head_alt_depth/2 + head_alt_socket_pos[2]
            ]
        ) {
            rotate([antenna_angle - head_alt_antenna_angle + 180, 0, 0]) {
                rotate([0, 270, 0]) {
                    children();
                }
            }
        }
    }
}

module head_alt_2() {

    head_alt_width = head_alt_width - edge_d;
    head_alt_height = head_alt_height - edge_d;
    head_alt_mid_h = 1;

    module head_form_with_back_cut() {
        aaa = head_alt_depth_adjusted/2 - head_alt_x_dist + 1;
        translate([aaa, 0]) {
            rotate([0, head_alt_cut_angle, 0]) {
                xy_cut(size = 40) {
                    rotate([0, -head_alt_cut_angle, 0]) {
                        translate([-aaa, 0]) {
                            head_form();
                        }
                    }
                }
            }
        }
    }

    module head_form() {
        hull() {
            translate([0, 0, -head_alt_depth_adjusted/2 + head_alt_height]) {
                rotate([90, 0, 0]) {
                    rotate_extrude() {
                        translate([-head_alt_x_dist + head_alt_depth_adjusted/2, 0]) {
                            hull() {
                                reflect([0, 1, 0]) {
                                    translate([0, head_alt_flat_with/2]) {
                                        circle_corner(head_alt_x_dist, head_alt_front_r, head_alt_front_r);
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
                                circle_corner(head_alt_x_dist, head_alt_front_r, head_alt_front_r);
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
                                circle_corner(head_alt_x_dist, head_alt_front_r, head_alt_front_r);
                            }
                        }
                    }
                }
           }
       }
    }

    module head_form_rounded() {
        minkowski() {
            translate([0, 0, edge_d/2]) {
                head_form_with_back_cut();
            }
            sphere(d = edge_d);
        }
    }

    difference() {
        translate(head_alt_socket_pos) rotate(90) head_form_rounded();
        //rotate([0, 90, 0]) cylinder(d = 6, h = head_alt_width + 2, center = true);
        translate([-10, -segment_cut_height/2 - 3, 2]) {
            rotate([0, 90, 0]) {
                rounded_cube([8, segment_cut_height + 3, 20], d = 4, top_d = 0, bottom_d = 0);
            }
        }
        antenna_position_2() {
            antenna_left(true, antenna_angle = 0, antenna_depth = 0);
        }
        rotate([90, 0, 0]) socket_with_snaps(true);
    }
    //rotate([90, 0, 0]) socket_with_snaps();
}

module circle_corner(x, y, r) {
    intersection() {
        translate([-r + x, 0]) circle(r);
        square([x, y]);
    }
}


// difference()  {
//     translate([0, 5, -1]) head_alt();
//     rotate([90, 0, 0]) socket_with_snaps(true);
// }
//rotate([90, 0, 0]) socket_with_snaps();


module head_alt() {
width = 12;
minkowski() {
difference() {
rotate([-45, 0, 0]) {
xy_cut(size = 50) {
    rotate([45, 0, 0])
    hull() {
        linear_extrude(0.01) circle(d = 7);
        translate([0, 0, 5])
        linear_extrude(6) {
            shape();
        }
        translate([0, -4, 11])
        rotate([90, 0, 90]) {
            rotate_extrude(angle = 270) {
                translate([4, 0, 0]) rotate(90) shape();
            }
        }
    }
}
}
reflect([1, 0, 0])
translate([-14.5, -10, 3.5])
hull() {
rotate([0, 270, 0])
rounded_cube([20, 20, 20], d = 9, top_d = 0, bottom_d = 0, center = true);
translate([-10, 0, 0])
rotate([0, 270, 0])
rounded_cube([30, 30, 30], d = 9, top_d = 0, bottom_d = 0, center = true);
}
}
sphere(d = 1);
}

antenna_position_2() {
    antenna_left();
}

module shape() {
    reflect([1, 0, 0]) {
        translate([-3.5 + width/2, 0, 0]) circle(d = 7);
    }
}
}






// module circle_fragment(x, y, d, round_len) {
//     intersection() {
//         translate([-d/2 + x/2, 0]) {
//             circle(d = d);
//         }
//         translate([0, 0]) {
//             square([x/2, round_len]);
//         }
//     }
// }

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
    color(armor_color) head();
    antenna_position(antenna_explode_x) color(frame_color) antenna_left();
    translate([0, head_cube_y_offset, head_cube_z/2 - 0.5 + lens_explode_z]) color(frame_color) lens();
}


function neck_len() = neck_len;
function neck_max_angle() = 18;

module antenna_position(x_offset = 0) {
    reflect([1, 0, 0]) {
        translate([(eye_socket_diameter + 2 * antenna_depth + 1)/2 + 1.2 + x_offset, 6]) {
            rotate([-antenna_angle, 0, 0]) {
                rotate([0, 270, 0]) {
                    children();
                }
            }
        }
    }
}

module antenna_left(is_cut = false, antenna_angle = antenna_angle, antenna_depth = antenna_depth) {
    base_d = 5;
    peg_h = 3;

    if (is_cut) {
        rotate(45 - antenna_angle) {
            translate([0, 0, antenna_depth]) {
                linear_extrude(peg_h + 0.15) {
                    offset(0.04) {
                        peg_polygon();
                    }
                }
            }
        }
        translate([0, 0, antenna_depth]) cylinder(d = base_d + 0.2, h = 1);
    } else {
        rotate(45 - antenna_angle) {
            translate([0, 0, antenna_depth]) {
                linear_extrude(peg_h) {
                    peg_polygon();
                }
            }
        }
        translate([0, 0, antenna_depth]) cylinder(d = 5, h = 1);
        x = 1.6;
        y1 = 5;
        y2 = y1 + 6;
        gap = 0.3;
        cylinder(d1 = base_d - 1.5, d2 = base_d, h = antenna_depth);
        linear_extrude(antenna_depth) {
            polygon(
                [
                    [x/2, 0],
                    [x/2, y1],
                    [x + gap, y1 + x/2],
                    [x + gap, y2],
                    [gap, y2],
                    [gap, y1 + x],
                    [-gap, y1 + x],
                    [-gap, y2],
                    [-x - gap, y2],
                    [-x - gap, y1 + x/2],
                    [-x/2, y1],
                    [-x/2, 0],
                ]
            );
        }
    }

    module peg_polygon() {
        peg_xy = 2.5;
        chamfer = 1;
        polygon(
            [
                [peg_xy/2, peg_xy/2],
                [peg_xy/2, -peg_xy/2],
                [-peg_xy/2 + chamfer, -peg_xy/2],
                [-peg_xy/2, -peg_xy/2 + chamfer],
                [-peg_xy/2, peg_xy/2]
            ]
        );
    }
}

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

module head() {
    difference() {
        translate([0, head_cube_y_offset, -head_cube_z/2]) {
            head_base(lens_diameter);
        }
        antenna_position() antenna_left(true);
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
