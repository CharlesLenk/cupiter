include <robot imports.scad>

arm_armor_y_offset = 1;
leg_armor_y_offset = 1;

arm_armor_height = armor_height - 0.5;
limb_upper_armor_width = segment_height + 3;

arm_len = 22;
arm_lower_len = 0.9 * arm_len; 
leg_len = 1.5 * arm_len;
shoulder_len = socket_d/2;
leg_upper_len = leg_len - shoulder_len - hip_armor_tab_width;

module arm_exploded() {
	rotate([0, 270, 0]) arm_upper();
	translate([10, 0]) rotate([0, 270, 0]) arm_upper_armor();
	translate([-10, 0]) rotate([0, 90, 0]) arm_upper_armor(true);
	
	translate([0, -45]) {
		rotate([90, 90, 0]) {
			shoulder();
			translate([0, 0, 10]) shoulder_armor();
		}
	}

	translate([0, -10]) {
		rotate(180) {
			rotate([0, 270, 0]) arm_lower();
			translate([10, 0]) rotate([0, 270, 0]) arm_lower_armor();
			translate([-10, 0]) rotate([0, 90, 0]) arm_lower_armor(true);
		}
	}
}

module cross_section(elbow_test_angle = 160) {
	rotate_z_relative_to_point([elbow_joint_offset, 0], elbow_test_angle) {
		rotate([180, 0, 0]) {
			mirror([0, 0, 1]) arm_upper_armor();
			arm_upper();
		}
	}
	translate([0, 0, 0]) {
		arm_lower_armor();
		arm_lower(true);
	}
}

module shoulder_armor() {
	x = socket_d + 2.6;
	y = segment_height + (armor_height - segment_height)/2;
	z = 0.75 * armor_height;
	
	x2 = x - 3;
	z2 = socket_d/2 + armor_height/2;
	
	x3 = x2 - 3;
	
	armor_d = 7;
	
	module armor_blank() {
		intersection() {
			difference() {
				hull() {
					rounded_cube([x, y, z], 1, armor_d, 1);
					translate([x/2 - x2/2, 0]) rounded_cube([x2, y, z2], 1, 6, 1);
				}
				fix_preview() translate([x/2 - x3/2, 0]) {
					rounded_cube([x3, y - 1.5, z2], 1, 6 - 3, 0, 0, 0);
				}
			}
			translate([0, y]) {
				rotate([0, 270, 180]) cube_one_round_corner([z2, y, x], 2);
			}
		}
	}
	
	difference() {
		translate([-x/2, socket_d/2, -segment_height/2]) {
			rotate([90, 0, 0]) {
				armor_blank();
			}
		}
		rotate([0, 180, 0]) shoulder(true);
	}
}

module leg_exploded() {
	rotate([0, 90, 0]) {
		translate([0, 45]) {
			rotate(180) { 
				hip();
				translate([0, 0, 15]) hip_armor();
			}
		}
	}
	
	rotate([0, 90, 0]) leg_upper();
	translate([-10, 0]) rotate([0, 90, 0]) leg_upper_armor();
	translate([10, 0]) rotate([0, 270, 0]) leg_upper_armor(true);

	translate([0, -10]) {
		rotate(180) {
			rotate([0, 90, 0]) leg_lower();
			translate([-10, 0]) rotate([0, 90, 0]) leg_lower_armor();
			translate([10, 0]) rotate([0, 270, 0]) leg_lower_armor(true);
		}
	}
}

module hip_armor() {
	x = socket_d + 2.5;
	z =  0.75 * socket_d + hip_armor_tab_width - 0.15;
	y = armor_height - 1.5;
	
	x2 = x - 1;
	z2 = socket_d/2 + hip_armor_tab_width;
		
	module armor_blank() {
		intersection() {
			cut_d = 1.5;
			difference() {
				hull() {
					rounded_cube([x, y, z2], 1, 7, 5, 1, 1);
					translate([-x2/2 + x/2, 0]) {
						rounded_cube([x2, y, z], 1, 7, 5, 1, 1);
					}
				}
				translate([-0.001, -10 + 1.5, 2 * hip_armor_tab_width + z]) {
					rotate([0, 90, 0]) {
						rounded_cube([10, 10, x + 0.002], cut_d, cut_d, cut_d, 0, 0);
					}
				}
				translate([x/2, y/4, z/2]) {
					cube([rotator_peg_d - 1.5, y/2, z], center = true);
				}
			}
			union() {
				corner_d = 3;
				cube([x, y, z - corner_d/2]);
				translate([x, y - 6.1]) {
					rotate([0, -90, 0]) rounded_cube([z, 10, x], 0, corner_d, corner_d, 0, 0);
				}
			}
		}
	}
	
	difference() {
		translate([-x/2, socket_d/2 + hip_armor_tab_width - 0.15, -armor_height/2 + 1.5]) {
			rotate([90, 0, 0]) armor_blank();
		}
		translate([0, socket_d/2]) {
			rotate([-90, 0, 0]) cylinder(d = rotator_peg_d + 0.1, h = 2);
		}
		hip(true);
	}
}

module arm_upper_armor_blank() {	
	max_length = arm_len - ball_dist - arm_armor_y_offset - 0.1;
	
	translate([0, ball_dist]) {
		limb_upper_armor_blank(
			max_width = arm_armor_height, 
			max_length = max_length,
			min_width = arm_armor_height/2 + 0.9,
			min_length = max_length - 9.3,
			cylinder_pos = [-elbow_joint_offset, arm_len - ball_dist]
		);
	}
}

module leg_upper_armor_blank() {
	max_length = leg_upper_len - leg_armor_y_offset - 0.1;
	
	difference() {
		limb_upper_armor_blank(
			max_width = rotator_socket_d, 
			max_length = max_length,
			min_width = rotator_socket_d/2 + 1.1,
			min_length = max_length - 14.3,
			cylinder_pos = [-knee_joint_offset, leg_upper_len]
		);
		fix_preview() {
			translate([-rotator_socket_d/2, 0, 0]) {
				rotate([0, 90, 0]) {
					linear_extrude(rotator_socket_d) {
						projection(cut = true) {
							translate([0, 0, -rotator_socket_d/2 + 0.75]) {
								rotate([270, 0, 0]) {
									capped_cylinder(rotator_socket_d, rotator_socket_l);
								}
							}
						}
					}
				}			
			}
		}
	}
}

module limb_upper_armor_blank(max_width, max_length, min_width, min_length, cylinder_pos) {
	difference() {
		translate([-max_width/2, 0, -armor_height/2]) {
			hull() {
				rounded_cube([min_width, max_length, armor_height], segment_d);
				rounded_cube([max_width, min_length, armor_height], segment_d);
			}
		}
		translate(cylinder_pos) {
			cylinder(d = elbow_socket_size() + 0.2, h = armor_height, center = true);
		}
	}
}

module arm_lower_armor_blank() {	
	translate([0, ball_dist]) {
		limb_lower_armor_blank(
			arm_armor_height,
			arm_lower_len - ball_dist + arm_armor_y_offset,
			arm_armor_height - 1.4,
			cylinder_pos = [-elbow_joint_offset, arm_lower_len - ball_dist]
		);
	}
}

module leg_lower_armor_blank() {	
	translate([0, ball_dist]) {
		limb_lower_armor_blank(
			rotator_socket_d,
			leg_len - ball_dist + leg_armor_y_offset,
			rotator_socket_d - 2,
			cylinder_pos = [-knee_joint_offset, leg_len - ball_dist]
		);
	}
}

module limb_lower_armor_blank(max_width, max_length, min_width, cylinder_pos) {
	chamfer_depth = max_width/2 - min_width/2;
	hull() {
		translate([-max_width/2, chamfer_depth, -armor_height/2]) {
			rounded_cube([max_width/2 + min_width/2, max_length - chamfer_depth, armor_height], segment_d);
		}
		translate([-max_width/2 + chamfer_depth, 0, -armor_height/2]) {
			rounded_cube([max_width/2 + min_width/2 - chamfer_depth, max_length, armor_height], segment_d);
		}
	}
	translate(cylinder_pos) {
		rounded_cylinder(
			d = elbow_socket_size(), 
			h = armor_height, 
			top_d = segment_d,  
			bottom_d = segment_d, 
			center = true
		);
	}
}

module shoulder(is_cut = false) {
	segment(0, SHOULDER_SOCKET, BALL, is_cut);
}

module arm_upper(is_cut = false) {
	segment(arm_len, BALL, ELBOW_SOCKET, is_cut, 
		end1_snap = true, end2_snap = true, cross_brace = true);
}

module arm_lower(is_cut = false) {
	segment(arm_lower_len, BALL, ELBOW_PEG, is_cut, 
		end1_snap = true, end2_snap = true, cross_brace = true);
}

module arm_upper_armor(is_top = false) {
	apply_armor_cut(is_top) {
		arm_upper_armor_blank();
		arm_upper(true);
	}
}

module arm_lower_armor(is_top = false) {
	apply_armor_cut(is_top) {
		arm_lower_armor_blank();
		arm_lower(true);
	}
}

module hip(is_cut = false) segment(0, HIP_SOCKET, ROTATOR_PEG, is_cut);

module leg_upper(is_cut = false) {
	segment(leg_upper_len, ROTATOR_SOCKET, KNEE_SOCKET,
		is_cut, end1_snap = true, end2_snap = true, cross_brace = true);
}

module leg_lower(is_cut = false) {
	segment(leg_len, BALL, KNEE_PEG, is_cut, 
		end1_snap = true, end2_snap = true, cross_brace = true);
}

module leg_upper_armor(is_top = false) {
	apply_armor_cut(is_top) {
		leg_upper_armor_blank();
		leg_upper(true);
	}
}

module leg_lower_armor(is_top = false) {
	apply_armor_cut(is_top) {
		leg_lower_armor_blank();
		leg_lower(true);
	}
}

module arm_assembled(with_armor = true, elbow_angle = 0, shrug_angle = 0, arm_extension_angle = 0) {
	rotate(shrug_angle) { 
		rotate([0, 90, 270]) {
			rotate([0, 180, 0]) c1() shoulder();
			if(with_armor) c2() shoulder_armor();
		}
		rotate(arm_extension_angle) {
			rotate([0, 270, 0]) {
				c1() arm_upper();
				if(with_armor) c2() arm_upper_armor_blank();
			}	
			translate([0, arm_len, 0]) {
				rotate_with_offset_origin([0, 0, -elbow_joint_offset], [-elbow_angle, 0, 0]) {
					translate([0, arm_lower_len, 0]) {
						rotate([0, 270, 180]) {
							c1() arm_lower();
							if(with_armor) c2() arm_lower_armor_blank();
						}
					}
					translate([0, arm_lower_len]) {
						hand_assembled(with_armor);
					}
				}		
			}					
		}
	}
}

module leg_assembled(with_armor = true, leg_angle = 0) {
	hip_offset = socket_d/2 + hip_armor_tab_width;
	
	rotate([0, -90, 0]) {
		c1() hip();
		if(with_armor) c2() hip_armor();
	}
	translate([0, hip_offset, 0]) {
		rotate([0, 90, 0]) {
			c1() leg_upper();
			if(with_armor) c2() leg_upper_armor_blank();
		}
	}
	translate([0, leg_len]) {
		rotate_with_offset_origin([0, 0, knee_joint_offset], [leg_angle, 0, 0]) {
			translate([0, leg_upper_len + hip_offset, 0]) {
				rotate([0, 90, 180]) {
					c1() leg_lower();
					if(with_armor) c2() leg_lower_armor_blank();
				}
			}
			translate([0, leg_len]) foot_assembled();
		}
	}
}
