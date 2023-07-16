include <../common.scad>
include <globals.scad>
include <limbs.scad>

arm_len = 22;
arm_lower_len = 0.9 * arm_len;

elbow_joint_offset = -2;
elbow_max_angle = 160;
arm_armor_height = segment_height + 2.5;

arm_assembled();

module shoulder_socket(is_cut = false) {
	height = segment_height + (is_cut ? segment_cut_height_amt : 0);
	width = socket_d + (is_cut ? segment_cut_width_amt : 0);
	cut_d = is_cut ? 0.2 : 0;
	
	d = socket_d + 0.5 + cut_d;
	difference() {
		make_socket(shoulder_socket_gap, is_cut = is_cut) {
			hull() {
				rounded_socket_blank(is_cut);
				xy_cut(size = 2 * socket_d) {
					rotate([-90, 0, 0]) cylinder(d = socket_d + 1, h = socket_d/2);
				}
			}
		}
		if (!is_cut) {
			hull() {
				cylinder(d = 4, h = 10); 
				rotate([-25, 0, 0]) cylinder(d = 4, h = 10); 
			}
		}
		armor_snap_inner(
			length = 4, 
			target_width = socket_d,
			depth = 0.5,
			is_cut = !is_cut,
			width_cut_adjust = 0.2
		);
	}
}

module shoulder(is_cut = false) {
	shoulder_socket(is_cut);
	translate([0, socket_r + ball_dist]) {
		rotate(180) ball(is_cut);
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

module arm_upper(is_cut = false) {
	limb_segment(
		length = arm_len, 
		end1_len = ball_dist, 
		end2_len = hinge_socket_d/2, 
		is_cut = is_cut, 
		snaps = true, 
		cross_brace = true
	) {
		ball(is_cut);
		hinge_socket(elbow_joint_offset, is_cut);
	};
}

module arm_upper_armor_blank() {	
	max_length = arm_len - ball_dist - hinge_armor_y_offset - 0.1;
	
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

module arm_upper_armor(is_top = false) {
	apply_armor_cut(is_top) {
		arm_upper_armor_blank();
		arm_upper(true);
	}
}

module arm_lower(is_cut = false) {
	limb_segment(
		length = arm_lower_len, 
		end1_len = ball_dist, 
		end2_len = hinge_peg_size/2, 
		is_cut = is_cut, 
		snaps = true, 
		cross_brace = true
	) {
		ball(is_cut);
		hinge_peg_holder(elbow_joint_offset, is_cut);
	};
}

module arm_lower_armor_blank() {	
	translate([0, ball_dist]) {
		limb_lower_armor_blank(
			arm_armor_height,
			arm_lower_len - ball_dist + hinge_armor_y_offset,
			arm_armor_height - 1.4,
			cylinder_pos = [-elbow_joint_offset, arm_lower_len - ball_dist]
		);
	}
}

module arm_lower_armor(is_top = false) {
	apply_armor_cut(is_top) {
		arm_lower_armor_blank();
		arm_lower(true);
	}
}

module arm_assembled(
	with_armor = true, 
	elbow_angle = 0, 
	shrug_angle = 0, 
	arm_extension_angle = 0,
	simple_hands = false
) {
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
						if (simple_hands) {
							hand_simple_assembled(with_armor);
						} else {
							hand_assembled(with_armor);
						}
					}
				}		
			}					
		}
	}
}
