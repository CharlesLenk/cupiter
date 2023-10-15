include <../OpenSCAD-Utilities/common.scad>
include <globals.scad>
include <limbs.scad>

hip_armor_tab_width = 1.3;
leg_len = 33;
leg_upper_len = leg_len - socket_d/2 - hip_armor_tab_width;

knee_joint_offset = -2.3;
knee_max_angle = 165;

leg_assembled();

module hip_socket(is_cut = false) {
	height = segment_height + (is_cut ? segment_cut_height_amt : 0);
	width = socket_d + (is_cut ? segment_cut_width_amt : 0);
	cut_d = is_cut ? 0.2 : 0;
	
	d = socket_d + 0.5 + cut_d;
	difference() {
		make_socket(shoulder_socket_gap, is_cut = is_cut) {
			rounded_socket_blank(is_cut);
		}
		armor_snap_inner(
			length = 4, 
			target_width = socket_d,
			depth = 0.4,
			is_cut = !is_cut,
			width_cut_adjust = 0.2
		);
	}	
}

module hip(is_cut = false) {
	hip_socket(is_cut);
	translate([0, hip_armor_tab_width + socket_d/2]) {
		rotate(180) rotator_peg(rotator_peg_l, hip_armor_tab_width, is_cut);
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

module leg_upper_armor_blank() {
	max_length = leg_upper_len - hinge_armor_y_offset - 0.1;
	
	difference() {
		limb_upper_armor_blank(
			max_width = rotator_socket_d, 
			max_length = max_length,
			min_width = rotator_socket_d/2 + 1.2,
			min_length = max_length - 13.4,
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

module leg_upper(is_cut = false) {
	limb_segment(
		length = leg_upper_len, 
		end1_len = rotator_socket_l - 1, 
		end2_len = hinge_socket_d/2, 
		is_cut = is_cut, 
		snaps = true, 
		cross_brace = true,
		snap_offset = 1.5
	) {
		rotator_socket(rotator_peg_l, is_cut);
		hinge_socket(knee_joint_offset, is_cut);
	};
}

module leg_upper_armor(is_top = false) {
	apply_armor_cut(is_top) {
		leg_upper_armor_blank();
		leg_upper(true);
	}
}

module leg_lower(is_cut = false) {
	limb_segment(
		length = leg_len, 
		end1_len = ball_dist, 
		end2_len = hinge_peg_size/2, 
		is_cut = is_cut, 
		snaps = true, 
		cross_brace = true
	) {
		ball(is_cut);
		hinge_peg_holder(knee_joint_offset, is_cut);
	};
}

module leg_lower_armor_blank() {	
	translate([0, ball_dist]) {
		limb_lower_armor_blank(
			rotator_socket_d,
			leg_len - ball_dist + hinge_armor_y_offset,
			rotator_socket_d - 2.3,
			cylinder_pos = [-knee_joint_offset, leg_len - ball_dist]
		);
	}
}

module leg_lower_armor(is_top = false) {
	apply_armor_cut(is_top) {
		leg_lower_armor_blank();
		leg_lower(true);
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
