include <../OpenSCAD-Utilities/common.scad>
include <limb constants.scad>
include <limbs.scad>
use <limb armor.scad>

elbow_max_angle = 158;
arm_armor_height = segment_height + 3;

function elbow_max_angle() = elbow_max_angle;

//arm_lower_armor();

//arm_assembled();

module shoulder_socket(is_cut = false) {
	height = segment_height + (is_cut ? segment_cut_height_amt : 0);
	width = socket_d + (is_cut ? segment_cut_width_amt : 0);
	cut_d = is_cut ? 0.2 : 0;
	
	d = socket_d + 0.5 + cut_d;
	difference() {
		make_socket(shoulder_socket_gap, is_cut = is_cut) {
			rounded_socket_blank(is_cut, chamfer_y = 1.7);
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
			depth = 0.6,
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

// rotate(-90) hinge_peg_holder();
// rotate([0, 180, 0]) hinge_socket();
// translate([0, 3, 0]) rotate([270, 0, 0]) cylinder(d = 5, h = 5);
arm_assembled();

// shoulder_armor();
// shoulder(false);

	// rotate([0, 180, 0]) shoulder(true);
	// translate([-10, -22, -10]) cube([20, 20, 20]);

//shoulder_armor();

shoulder_ball_d = 5;
shoulder_socket_d = shoulder_ball_d + 3;

// shoulder_socket_test();

// module shoulder_socket_test() {
// 	hull() {
// 		cylinder(h = shoulder_ball_d + 2.4, r = shoulder_socket_d/2, center = true);
// 		translate([4, 0]) cylinder(h = shoulder_ball_d + 2.4, r = shoulder_socket_d/2, center = true);
// 	}
// 	rotate([270, 0, 0]) cylinder(h = shoulder_ball_d/2 + 8, r = shoulder_ball_d/2 + 0.3);
// }

module shoulder_armor() {
	shell_width = 1.4;
	
	x = socket_d + 2 * shell_width;
	y = segment_height + shell_width;
	z = 0.75 * armor_height;
	
	x2 = x - 3;
	z2 = socket_d/2 + armor_height/2;
	
	x3 = x2 - 3;
	
	armor_d = 7;

	height = segment_height + 2.6;
	
	// module armor_blank() {
	// 	minkowski() {
	// 		translate([0, 0]) {
	// 			hull() {
	// 				aaa = 2;
	// 				xy_cut(edge_d/2 - segment_height/2, size = 15) {
	// 					translate([0, edge_d/2 - aaa]) armor_section(socket_d + 2.4 - edge_d, socket_d/2 - edge_d + aaa, height - edge_d);
	// 				}
	// 				translate([0, 0, -segment_height/2]) 
	// 				rotate([90, 0, 0]) translate([0, edge_d/2]) armor_section(socket_d + 2.4 - edge_d, 4.8 - edge_d, height - edge_d);

	// 				translate([0, -1.8]) 
	// 				xy_cut(segment_height/2 - 1, size = 15, from_top = true) {
	// 					// xy_cut(edge_d/2 - segment_height/2, size = 15) {
	// 					// 	armor_section(socket_d - 1.5, y - edge_d, height - edge_d);
	// 					// }
	// 				}
	// 				//translate([0, height/2 - 1.5, -2.5]) rotate([90, 0, 0]) armor_section(socket_d + 2.4 - edge_d, 0.01, height - edge_d);
	// 			}
	// 		}
	// 		sphere(d = 1);
	// 	}
	// }

	module armor_blank() {
		minkowski() {
			translate([0, 0]) {
				hull() {
					xy_cut(edge_d/2 - segment_height/2, size = 15) {
						difference() {
							foob(socket_d - edge_d + 2.4, segment_height - edge_d + 2.4, socket_d/2, 1.2, 1.9);
							translate([0, 10 + socket_d/2 - edge_d/2]) cube([20, 20, 20], center = true);
							translate([0, -9.8 - ball_d/2 + edge_d/2]) cube([20, 20, 20], center = true);
						}
					}

					// translate([0, -1.8]) 
					// xy_cut(segment_height/2 - 1, size = 15, from_top = true) {
					// 	// xy_cut(edge_d/2 - segment_height/2, size = 15) {
					// 	// 	armor_section(socket_d - 1.5, y - edge_d, height - edge_d);
					// 	// }
					// }
					//translate([0, height/2 - 1.5, -2.5]) rotate([90, 0, 0]) armor_section(socket_d + 2.4 - edge_d, 0.01, height - edge_d);
				}
			}
			sphere(d = 1);
		}
	}

	
	//armor_blank()
	
	difference() {
		translate([0, 0]) armor_blank();
		//translate([0, -4.5]) rounded_cube([6, 4, 20], center = true, top_d = 0, bottom_d = 0, d = 1);
		//translate([0, 0, -0.5]) rotate([90, 0, 0]) rounded_cube([6, 6, 20], center = true, top_d = 0, bottom_d = 0, d = 1);
		difference() {
			rotate([0, 180, 0]) shoulder(true);
			//translate([-10, -22, -10]) cube([20, 20, 20]);
		}
	}

	
}

// module shoulder_armor() {
// 	shell_width = 1.4;
	
// 	x = socket_d + 2 * shell_width;
// 	y = segment_height + shell_width;
// 	z = 0.75 * armor_height;
	
// 	x2 = x - 3;
// 	z2 = socket_d/2 + armor_height/2;
	
// 	x3 = x2 - 3;
	
// 	armor_d = 7;

// 	height = segment_height + 2.6;
	
// 	module armor_blank() {
// 		minkowski() {
// 			translate([0, edge_d/2]) {
// 				hull() {
// 					xy_cut(edge_d/2 - segment_height/2, size = 15) {
// 						armor_section(socket_d + 2.4 - edge_d, y - edge_d, height - edge_d);
// 					}
// 					translate([0, -1.8]) 
// 					xy_cut(segment_height/2 - 1, size = 15, from_top = true) {
// 						xy_cut(edge_d/2 - segment_height/2, size = 15) {
// 							armor_section(socket_d - 1.5, y - edge_d, height - edge_d);
// 						}
// 					}
// 					//translate([0, height/2 - 1.5, -2.5]) rotate([90, 0, 0]) armor_section(socket_d + 2.4 - edge_d, 0.01, height - edge_d);
// 				}
// 			}
// 			sphere(d = 1);
// 		}
// 	}

	
// 	//armor_blank()
	
// 	difference() {
// 		translate([0, -y + socket_d/2]) armor_blank();
// 		translate([0, -4.6]) rounded_cube([6.7, 4, 20], center = true, top_d = 0, bottom_d = 0, d = 1);
// 		rotate([0, 180, 0]) shoulder(true);
// 	}
// }

module arm_upper(is_cut = false) {
	limb_segment(
		length = arm_upper_len, 
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

// translate([15, 0]) arm_upper();
// translate([15, 22]) arm_upper_armor();
// arm_upper_alt();
// translate([0, 22]) arm_upper_armor_alt();

module arm_upper_alt(is_cut = false) {
	limb_segment(
		length = arm_upper_len - socket_d/2, 
		end1_len = rotator_socket_l - 1, 
		end2_len = hinge_socket_d/2, 
		is_cut = is_cut, 
		snaps = true, 
		cross_brace = false
	) {
		rotator_socket(rotator_peg_l, is_cut);
		hinge_socket(elbow_joint_offset, is_cut);
	};
}

module arm_upper_armor_alt(is_top = false) {
	apply_armor_cut(is_top) {
		mirror([1, 0, 0]) translate([0, 0]) arm_upper_armor_blank();
		arm_upper_alt(true);
	}
}

module arm_upper_armor(is_top = false) {
	apply_armor_cut(is_top) {
		mirror([1, 0, 0]) translate([0, ball_dist]) arm_upper_armor_blank();
		arm_upper(true);
	}
}

module arm_lower(is_cut = false) {
	limb_segment(
		length = arm_lower_len, 
		end1_len = hinge_peg_size/2, 
		end2_len = ball_dist, 
		is_cut = is_cut, 
		snaps = true, 
		cross_brace = true
	) {
		hinge_peg_holder(elbow_joint_offset, is_cut);
		ball(is_cut);
	};
}

module arm_lower_armor(is_top = false) {
	apply_armor_cut(is_top) {
		mirror([0, 0, 0]) arm_lower_armor_blank();
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
				
			}
			if(with_armor) {
				translate([0, ball_dist]) {
					rotate([0, 90, 0]) c2() arm_upper_armor_blank();	
				}
			}
			translate([0, arm_upper_len, 0]) {
				rotate_with_offset_origin([0, 0, -elbow_joint_offset], [elbow_angle, 0, 0]) {
					translate([0, 0, 0]) {
						rotate([0, 90, 0]) {
							c1() arm_lower();
						}
					}
					if(with_armor) rotate([0, 90, 0]) c2() arm_lower_armor_blank();
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
