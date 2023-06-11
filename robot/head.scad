include <robot imports.scad>

lens_diameter = 12;
head_cube_y_offset = 5.5;
head_cube_z = 16;
neck_len = 8.5;

head_assembled();

module head_assembled(neck_angle = 0) {
	rotate(neck_angle) {
		rotate_z_relative_to_point([0, neck_len], neck_angle) {
			translate([0, neck_len]) {
				c2() head();
				c1() head_and_foot_socket();
				translate([0, head_cube_y_offset, head_cube_z/2 - 0.5]) c1() lens();
			}
		}
		c1() neck();
	}
}
//
//module head_assembled(neck_angle = 0) {
//	rotate_z_relative_to_point([0, -neck_len], neck_angle) {
//		rotate(neck_angle) {
//			c2() head();
//			c1() head_and_foot_socket();
//			translate([0, head_cube_y_offset, head_cube_z/2 - 0.5]) c1() lens();
//		}
//		rotate(180) c1() neck();
//	}
//}

module head() {
	difference() {
		translate([0, head_cube_y_offset, -head_cube_z/2]) {
			head_common(lens_diameter);
		}
		translate([0, -10 + socket_d/2, 0]) {
			rotate([-90, 0, 0]) cylinder(d = socket_d, h = 10);
		}
		head_and_foot_socket(true);
	}
	
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
