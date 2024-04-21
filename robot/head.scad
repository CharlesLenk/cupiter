include <../OpenSCAD-Utilities/common.scad>
include <globals.scad>
use <robot common.scad>

lens_diameter = 12;
eye_socket_diameter = lens_diameter + 2;
head_cube_y_offset = 4.5;

head_cube_x = eye_socket_diameter + 2 * min_wall_width + 1;
head_cube_y = eye_socket_diameter + 2 * min_wall_width + 1;
head_cube_z = 14;
neck_len = 7.5;
antenna_angle = 35;

head_assembled();

function neck_len() = neck_len;

module antenna_position() {
	reflect([1, 0, 0]) {
		translate([(eye_socket_diameter + 2 * min_wall_width + 1)/2 + 1.2, 6]) {
			rotate([-antenna_angle, 0, 0]) {
				rotate([0, 270, 0]) {
					children();
				}
			}
		}
	}
}

module antenna_left(is_cut = false) {
	peg_xy = 2;
	cut_xy = peg_xy + 0.15;

	if (is_cut) {
		rotate(45 - antenna_angle) {
			translate([-cut_xy/2, -cut_xy/2, min_wall_width]) cube([cut_xy, cut_xy, 3.15]);
		}
		translate([0, 0, min_wall_width]) cylinder(d = 5.2, h = 1);
	} else {
		rotate(45 - antenna_angle) {
			translate([-peg_xy/2, -peg_xy/2, min_wall_width]) {
				cube([peg_xy, peg_xy, 3]);
			}
		}
		translate([0, 0, min_wall_width]) cylinder(d = 5, h = 1);
		x = 1.5;
		y1 = 5;
		y2 = y1 + 6;
		gap = 0.25;
		cylinder(d1 = 3.5, d2 = 5, h = min_wall_width);
		linear_extrude(min_wall_width) { 
			polygon(
				[
					[x/2, 0],
					[x/2, y1],
					[x + gap, y1 + x/2],
					[x + gap, y2],
					[gap, y2],
					[gap, y1 + 1.5],
					[-gap, y1 + 1.5],
					[-gap, y2],
					[-x - gap, y2],
					[-x - gap, y1 + x/2],
					[-x/2, y1],
					[-x/2, 0],
				]
			);
		}
	}
}

module shroud() {
	y_adjust = 1.5;
	difference() {
		minkowski() {
			translate([0, y_adjust/2, edge_d/2]) {
				head_block(head_cube_x - edge_d, head_cube_y - edge_d - y_adjust, head_cube_z - edge_d);
			}
			sphere(d = 1);
		}
		translate([0, -min_wall_width + y_adjust/2, 1.5]) {
			head_block(head_cube_x - 2 * min_wall_width, head_cube_y - y_adjust, head_cube_z);
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

	module head_block(x, y, z) {
		head_corner_r = 4;
		translate([0, -head_corner_r + y/2]) {
			hull() {
				reflect([1, 0, 0]) {
					translate([x/2 - head_corner_r, 0]) {
						rotate_extrude(angle = 90) {
							head_part_2d(head_corner_r, 40, z, 10);
						}
					}
					rotate([90, 0, 0]) {
						linear_extrude(y - head_corner_r) {
							head_part_2d(x/2, 40, z, 10);
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
		extension_past_shroud = 1;
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
    intersection() {
        cylinder(d = lens_diameter, h = radius);
        translate([0, 0, -7]) sphere(r = radius);
    }
}

module neck() {
	xy_cut(ball_cut_height, size = 2 * ball_d + neck_len) {
		sphere(d = ball_d);
		translate([0, neck_len]) sphere(d = ball_d);
		rotate([-90, 0, 0]) cylinder(d = 3.5, h = neck_len);
	}
}

module head_assembled(neck_angle = 0) {
	rotate(180) {
		rotate(neck_angle) {
			rotate_z_relative_to_point([0, neck_len], neck_angle) {
				translate([0, neck_len]) {
					c2() head();
					c1() socket_with_snaps();
					antenna_position() c1() antenna_left();
					translate([0, head_cube_y_offset, head_cube_z/2 - 0.5]) c1() lens();
				}
			}
			c1() neck();
		}
	}
}
