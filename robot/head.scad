include <../OpenSCAD-Utilities/common.scad>
include <globals.scad>
use <robot common.scad>

lens_diameter = 12;
eye_socket_diameter = lens_diameter + 2;
head_cube_y_offset = 5;

wall_thickness = 1.2;
head_cube_x = eye_socket_diameter + 2 * wall_thickness + 1;
head_cube_y = eye_socket_diameter + 2 * wall_thickness + 1;
head_cube_z = 14;
neck_len = 7;

function head_height() = head_cube_y_offset + neck_len + head_cube_y/2;
function neck_len() = neck_len;

antenna_angle = 35;

//head();


//head_2();

//head_assembled();
// hull() {
// 	sphere(d = 10);
// 	translate([-0.5, 0])  {
// 		translate([4.5, 0, -4]) sphere(d = 2);
// 		translate([5, 0, -1]) sphere(d = 2);
// 		translate([2, 3.5, -2]) sphere(d = 2);
// 		translate([2, -3.5, -2]) sphere(d = 2);
// 	}
// 	//translate([1, 0, -2]) torus(d1 = 8, d2 = 1);
// }

module antenna_position() {
	reflect([1, 0, 0]) {
		translate([(eye_socket_diameter + 2 * wall_thickness + 1)/2 + 1.2, 6]) {
			rotate([-antenna_angle, 0, 0]) {
				rotate([0, 270, 0]) {
					children();
				}
			}
		}
	}
}

//super_shroud();

module super_shroud() {
	y_adjust = 1.5;
	difference() {
		minkowski() {
			translate([0, y_adjust/2, edge_d/2]) head_block(head_cube_x - edge_d, head_cube_y - edge_d - y_adjust, head_cube_z - edge_d);
			sphere(d = 1);
		}
		translate([0, -1.2 + y_adjust/2, 1.5]) head_block(head_cube_x - 2.4, head_cube_y - y_adjust, head_cube_z);
	}
	intersection() {
		translate([0, 0, edge_d/2]) head_block(head_cube_x - edge_d, head_cube_y - edge_d, head_cube_z);
		union() {
			translate([-head_cube_x/2, -head_cube_y/2 + 5, - 5]) cube([head_cube_x, head_cube_y, head_cube_z]);
			cylinder(d = eye_socket_diameter, h = head_cube_z);
		}
	}
}

module head_block(x, y, z) {
	head_corner_r = 4;
	translate([0, -head_corner_r + y/2]) 
	hull()
	reflect([1, 0, 0])
	union() {
		translate([x/2 - head_corner_r, 0]) rotate_extrude(angle = 90) head_part(head_corner_r, 40, z, 10);
		rotate([90, 0, 0]) 
		linear_extrude(y - head_corner_r) head_part(x/2, 40, z, 10);
	}
}

module head_part(width, d, height, height_2) {
	intersection() {
		union() {
			translate([-d/2 + width, height_2]) circle(d = d);
			translate([0, height_2]) square([width, height - height_2]);
		}
		square([width, height]);
	}
}

head_assembled();

//antenna();

module antenna(is_cut = false) {
	peg_xy = 2;
	cut_xy = peg_xy + 0.15;

	if (is_cut) {
		rotate(45 - antenna_angle) {
			translate([-cut_xy/2, -cut_xy/2, 1.2]) cube([cut_xy, cut_xy, 3.15]);
		}
		translate([0, 0, 1.2]) cylinder(d = 5.2, h = 1);
	} else {
		rotate(45 - antenna_angle) {
			translate([-peg_xy/2, -peg_xy/2, 1.2]) {
				cube([peg_xy, peg_xy, 3]);
			}
		}
		translate([0, 0, 1.2]) cylinder(d = 5, h = 1);
		x = 1.5;
		y1 = 6;
		y2 = y1 + 6;
		gap = 0.25;
		cylinder(d1 = 3.5, d2 = 5, h = 1.2);
		linear_extrude(1.2) { 
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

module head_2_assembled() {
	rotate([90, 0, 0]) { 
		c2() head_2();
		rotate([90, 0, 0]) c1() socket_with_snaps();
		c1() rotate([270, 0, 0]) neck();
	}
}

// module head_2() {
// 	x = 11;
// 	y = 3;

// 	chamfer_x = 2;
// 	chamfer_y = 3;

// 	difference() {
// 		translate([0, 5.5, -3]) 
// 		minkowski() {
// 			//difference() {
// 				rotate([-38, 0])
// 				xy_cut(0.5)
// 				rotate([38, 0]) 
// 				hull() {
// 					h1 = 9;
// 					translate([0, 0, edge_d/2]) linear_extrude(h1 - edge_d/2) face_2d(x, y, chamfer_x, chamfer_y);

// 					id1 = 6;
// 					translate([0, -id1, h1]) 
// 					rotate([0, 270, 0]) rotate_extrude(angle = 90) translate([id1, 0]) rotate(-90) face_2d(x, y, chamfer_x, chamfer_y);

// 					id2 = 3;
// 					translate([0, -id1, h1 - id2 + id1]) 
// 					rotate([0, 270, 180]) rotate_extrude(angle = 90) translate([id2, 0]) rotate(-90) face_2d(x, y, chamfer_x, chamfer_y);
// 				}
// 				// translate([-x/2, -15, 0]) {
// 				// 	cube([x, 10, 5]);
// 				//} 
// 			//}
// 			sphere(d = edge_d);
// 		}
// 		rotate([90, 0, 0]) socket_with_snaps(true);
// 	}
// }

module face_2d(x, y, chamfer_x, chamfer_y) {
	polygon(
		[
			[x/2, y - chamfer_y],
			[x/2 - chamfer_x, y],
			[-x/2 + chamfer_x, y],
			[-x/2, y - chamfer_y],
			[-x/2, 0],
			[x/2, 0],
		]
	);
}

module head_assembled(neck_angle = 0) {
	rotate(180) {
		translate([0, 0]) {
			rotate(neck_angle) {
				rotate_z_relative_to_point([0, neck_len], neck_angle) {
					translate([0, neck_len]) {
						c2() head_2();
						c1() socket_with_snaps();
						antenna_position() c1() antenna();
						translate([0, head_cube_y_offset, head_cube_z/2 - 0.5]) c1() lens();
					}
				}
				c1() neck();
			}
		}
	}
}

//translate([20, 0]) head();
//head_2();

module head_2() {
	head_cube_y = eye_socket_diameter + 2 * wall_thickness + 1;

	difference() {
		translate([0, head_cube_y_offset, -head_cube_z/2]) {
			head_common(lens_diameter);
		}
		translate([0, -10 + socket_d/2, 0]) {
			rotate([-90, 0, 0]) cylinder(d = socket_d, h = 10);
		}
		antenna_position() antenna(true);
		socket_with_snaps(true);
	}

	//shroud();

	//head_common(lens_diameter);
	
	module head_common(lens_diameter) {
		eye_socket_diameter = lens_diameter + 2;
		bottom_edge_d = 2.5;
		
		translate([0, 0]) super_shroud();
		translate([0, 0, 0]) eye_socket();
		
		module eye_socket() {
			extension_past_shroud = 1;
			height = head_cube_z - wall_thickness + extension_past_shroud;
			lens_depth = 1.5;
			translate([0, 0, head_cube_z]) {
				difference () {
					cylinder(d = eye_socket_diameter, h = lens_depth);
					translate([0, 0, 0]) {
						cylinder(d = lens_diameter, h = lens_depth + 0.01);
					}
				}
			}
		}
		
		module shroud() {

			y_adjust = 0.5;
			
			head_cube_y = eye_socket_diameter + wall_thickness + 0.5 + y_adjust;

			shroud_diameter = 7;
			chamfer = 3;

			translate([0, -y_adjust]) 
			difference() {
				minkowski() {
					hull() {
						translate([0, edge_d/2]) {
							translate([0, 0, 1/3 * head_cube_z + edge_d/2])  linear_extrude(2/3 * head_cube_z - edge_d) {
								face_2d(head_cube_x - edge_d, head_cube_y - edge_d, chamfer, chamfer);
							}
							translate([0, 0, edge_d/2]) linear_extrude(1/3 * head_cube_z) {
								face_2d(head_cube_x - edge_d - 3, head_cube_y - edge_d - 1.5, chamfer, chamfer);
							}
						}
					}
					sphere(d = edge_d);
				}
				translate([0, 0, head_cube_z - 5]) {
					linear_extrude(head_cube_z) {
						face_2d(head_cube_x - 2 * wall_thickness, head_cube_y - wall_thickness, chamfer - wall_thickness/4, chamfer - wall_thickness/4);
					}
				}
				translate([0, 0, wall_thickness]) {
					rotate([270, 0, 0]) 
					translate([0, -head_cube_z]) {
						linear_extrude(5) {
							face_2d(head_cube_x - 2 * wall_thickness, head_cube_z, 1.3, head_cube_z/3 - edge_d/2);
						}
					}
				}
			}
		}
	}
}

module head() {
	// difference() {
	// 	translate([0, head_cube_y_offset, -head_cube_z/2]) {
	// 		head_common(lens_diameter);
	// 	}
	// 	translate([0, -10 + socket_d/2, 0]) {
	// 		rotate([-90, 0, 0]) cylinder(d = socket_d, h = 10);
	// 	}
	// 	socket_with_snaps(true);
	// }

	head_common(lens_diameter);
	
	module head_common(lens_diameter) {
		wall_thickness = 1.5;
		eye_socket_diameter = lens_diameter + 2;
		bottom_edge_d = 2.5;
		
		shroud();
		translate([0, 0, wall_thickness]) eye_socket();
		
		module eye_socket() {
			extension_past_shroud = 1;
			height = head_cube_z - wall_thickness + extension_past_shroud;
			lens_depth = 1.5;
			difference () {
				cylinder(d = eye_socket_diameter, h = height);
				translate([0, 0, height - lens_depth]) {
					cylinder(d = lens_diameter, h = lens_depth + 0.01);
				}
			}
		}
		
		module shroud() {
			wall_thickness = 1.5;
			head_cube_x = eye_socket_diameter + 2 * wall_thickness + 1;
			head_cube_y = eye_socket_diameter + 2 * wall_thickness + 1;
			y_adjust = 1;
			shroud_diameter = 7;
			
			translate([-head_cube_x/2, -head_cube_y/2 - y_adjust, 0]) {
				difference() {
					rounded_cube(
						[
							head_cube_x, 
							head_cube_y + y_adjust, 
							head_cube_z
						], 
						d = segment_d,
						top_d = 0,
						front_d = shroud_diameter
					);
					translate([wall_thickness, wall_thickness, wall_thickness]) {
						 rounded_cube(
							[
								head_cube_x - 2 * wall_thickness, 
								head_cube_y - 2 * wall_thickness + y_adjust, 
								head_cube_z
							], 
							d = shroud_diameter - wall_thickness,
							top_d = 0,
							bottom_d = 0,
							back_d = 0
						);
					}
					translate([0 - 1, -0.01, -1]) {
						cube([
							head_cube_x + 2, 
							wall_thickness + bottom_edge_d/2, 
							head_cube_z + 2
						]);
					}
				}
			}
		}
	}
}

module lens() {
	radius = 10;
	tension_fit_adjust = 0.2;
    intersection() {
        cylinder(d = lens_diameter + tension_fit_adjust, h = radius);
        translate([0, 0, -7]) sphere(r = radius);
    }
}

module neck() {
	xy_cut(ball_cut_height, size = 2 * ball_d + neck_len) {
		sphere(d = ball_d);
		translate([0, neck_len, 0]) sphere(d = ball_d);
		rotate([-90, 0, 0]) cylinder(d = 3.5, h = neck_len);
	}
}
