include <robot imports.scad>

elbow_peg_armor_peg_d = 2.75;
elbow_peg_armor_peg_h = 1.5;
shoulder_socket_gap = -0.15;
elbow_wall_width = 1.5;
elbow_peg_d = 4.5;
elbow_peg_h = segment_height - elbow_wall_width;
elbow_socket_d = elbow_peg_d + 3;
elbow_peg_size = elbow_socket_d + 2.7;
elbow_peg_len = elbow_peg_size/2;

assembled(with_armor = false);

function elbow_peg_size() = elbow_peg_size;
function elbow_socket_size() = elbow_socket_d;

module head_and_foot_socket(is_cut = false) {
	head_and_foot_socket_gap = -0.2;
	cut_adjust = is_cut ? 0.15 : 0;
	tab_len = 3.5;
	height = is_cut ? segment_cut_height : segment_height;
	
	base_width = 4;
	snap_tab_width = 1;
	snap_tab_gap = base_width - 2 * snap_tab_width;
	
	make_socket(head_and_foot_socket_gap, is_cut = is_cut) {
		rounded_socket_blank(is_cut);
	}
		
	difference() {
		translate([0, socket_d/2 + tab_len - 1, -height/2]) {
			rotate([90, 0, 0]) {
				armor_snap_outer(
					length = height, 
					target_width = snap_tab_gap,
					depth = 1.5,
					is_cut = is_cut
				);
			}
		}
		translate([-5, socket_d/2 + tab_len, -5]) {
			cube([10, 10, 10]);
		}
	}
	
	if (is_cut) {
		width = base_width + cut_adjust;
		translate([-width/2, socket_d/2, -height/2]) {
			cube([width, tab_len + 1, height]);
		}
	} else {
		translate([0, socket_d/2 - 0.001, -height/2]) {
			translate([-snap_tab_width - snap_tab_gap/2, 0, 0]) {
				cube([snap_tab_width, tab_len - 0.75, height]);
			}
			translate([snap_tab_gap/2, 0, 0]) {
				cube([snap_tab_width, tab_len - 0.75, height]);
			}
		}
	}
}

module rounded_socket_blank(is_cut = false, cylinder_length) {
	height = is_cut ? segment_cut_height : segment_height;
	socket_width = is_cut ? socket_d + 0.15 : socket_d;
	cylinder_length = is_undef(cylinder_length) ? socket_width/2 : cylinder_length;
	
	intersection() {
		hull() {
			sphere(d = socket_width);
			rotate([-90, 0, 0]) cylinder(d = socket_width + 0.3, h = cylinder_length);
		}
		translate([-socket_width/2, -socket_width/2, -height/2]) {
			cube([socket_width, socket_width/2 + cylinder_length, height]);
		}
	}
}

module elbow_socket(joint_offset, is_cut = false) {
	socket_opening_angle = 100;
	if (is_cut) {
		translate([0, 0, -segment_cut_height/2]) {
			union() {
				translate([joint_offset, 0, 0]) {
					cylinder(d = elbow_socket_d + 0.1, h = segment_cut_height);
					
				}
				translate([-segment_cut_width/2, -(elbow_socket_d + 2.5)/2, 0]) {
					cube([segment_cut_width, (elbow_socket_d + 2.5)/2 + elbow_socket_d/2, segment_cut_height]);
				}
			}
		}
	} else {
		translate([0, 0, -segment_height/2]) {
			difference() {
				union () {
					translate([joint_offset, 0, 0]) {
						cylinder(d = elbow_socket_d, h = segment_height - elbow_wall_width);
					}
					translate([-segment_width/2, 0, 0]) {
						cube([segment_width, elbow_socket_d/2, segment_height]);
					}
				}
				translate([joint_offset, 0, -elbow_wall_width]) {
					elbow_peg_peg(true);
				}
				translate([joint_offset, 0, -0.001]) {
					rotate(140) wedge(socket_opening_angle, segment_height, segment_height);
					translate([0, 0, segment_height - elbow_wall_width]) {
						cylinder(d = elbow_socket_d + 0.1, h = elbow_wall_width + 0.1);
					}
				}
			}
		}
	}
}

module elbow_cube(is_cut = false) {
	corner_d = 3;	
	x_add = 1.55;
	y_add = 1;
	base_xy = elbow_peg_size/2;
	cube_x = base_xy + x_add;
	cube_y = base_xy + y_add;
	z = is_cut ? segment_cut_height : segment_height;
	
	difference() {
		union() {
			translate([-x_add, -y_add]) cube_one_round_corner([cube_x, cube_y, z], corner_d/2);
			if (is_cut) {
				fix_preview() {
					difference() {
						cylinder(d = elbow_socket_d + 0.1, h = z);
					}
				}
			}
		}
		if (is_cut) {
			translate([0, 0, z - elbow_peg_armor_peg_h]) {
				cylinder(d = elbow_peg_armor_peg_d - 0.2, h = elbow_peg_armor_peg_h + 0.001);
			}
		}
	}
}

module elbow_peg(joint_offset, is_cut = false) {
	if (is_cut) {
		translate([joint_offset, 0, -segment_cut_height/2]) {
			elbow_cube(true);
		}
	} else {
		translate([joint_offset, 0, -segment_height/2]) {
			elbow_peg_peg();
			difference() {
				elbow_cube();
				translate([0, 0, elbow_wall_width]) {
					cylinder(d = elbow_socket_d + 0.6, h = segment_height);
				}
			}
			cylinder(d = elbow_socket_d, h = elbow_wall_width);
		}
	}
}

module elbow_peg_peg(is_cut = false) {
	elbow_socket_gap = -0.15;
	elbow_peg_cap_d = elbow_peg_d + 1.25;
	cut_offset = is_cut ? elbow_socket_gap : 0;
	cap_h = (elbow_peg_cap_d - elbow_peg_d)/2;

	difference() {
		translate([0, 0, elbow_wall_width]) {
			cylinder(d = elbow_peg_d + cut_offset, h = elbow_peg_h);
			translate([0, 0, elbow_peg_h - cap_h]) {
				cylinder(d1 = elbow_peg_d + cut_offset, d2 = elbow_peg_cap_d + cut_offset, h = cap_h);
			}
			cylinder(d2 = elbow_peg_d + cut_offset, d1 = elbow_peg_cap_d + cut_offset, h = cap_h);
		}
		if (!is_cut) {
			translate([0, 0, elbow_wall_width + elbow_peg_h - elbow_peg_armor_peg_h]) {
				cylinder(d = elbow_peg_armor_peg_d, h = elbow_peg_armor_peg_h);
			}
		}
	}
}

module waist_socket(is_cut = false) {
	height = segment_height + (is_cut ? segment_cut_height_amt : 0);
	width = socket_d + (is_cut ? segment_cut_width_amt : 0);
	
	translate([0, -0.5 + socket_d/2]) {
		cross_brace(1, socket_d, is_cut);
	}
	difference() {
		make_socket(waist_socket_gap, is_cut = is_cut) {
			rounded_socket_blank(is_cut);
		}
		translate([0, 0.25]) {
			armor_snap_inner_double(
				length = 3.5, 
				target_width = socket_d,
				depth = snap_depth,
				is_cut = !is_cut
			);
		}
	}	
}

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
			depth = 0.5,
			is_cut = !is_cut,
			width_cut_adjust = 0.2
		);
	}	
}

module ball(is_cut = false) {
	cut_amt = is_cut ? segment_cut_height_amt : 0;
	height = is_cut ? segment_cut_height : segment_height;
	tab_width = is_cut ? segment_cut_width : segment_width;
	
	xy_cut(ball_cut_height, size = ball_d) {
		sphere(d = ball_d);
	}
	hull () {
		translate([
			0, ball_d/2 + ball_tab_len, 
			segment_height/2 + ball_cut_height
		]) {
			cube([tab_width, 0.01, height], center = true);
		}
		translate([0, ball_d/2, 0]) {
			cube([tab_width, 0.01, segment_height/2 + cut_amt], center = true);
		}
	}
	translate([0, ball_d/4, 0]) {
		cube([tab_width, ball_d/2, segment_height/2 + cut_amt], center = true);
	}
}

module rotator_peg(is_cut = false) {
	cut_adjust = is_cut ? 0.2 : 0;
	cylinder_l = rotator_peg_l - rotator_peg_d/2;
	
	if (is_cut) {
		rotate([90, 0, 0]) peg();
	} else {
		translate([0, 0, 0]) {
			xy_cut(ball_cut_height, size = 2 * cylinder_l + 1) {
				rotate([90, 0, 0]) peg();
			}
		}
	}

	module peg() {
		difference() {
			capped_cylinder(rotator_peg_d + cut_adjust, rotator_peg_l + cut_adjust/2);
			snap_d2 = 2.5;
			translate([0, 0, snap_d2/2 + hip_armor_tab_width + 1]) {
				torus(rotator_peg_d - 1.25, snap_d2);
			}
		}
	}
}

module rotator_socket(is_cut = false) {
	cut_adjust = is_cut ? 0.1 : 0;
	height = is_cut ? segment_cut_height : segment_height;
	diameter = rotator_socket_d + cut_adjust;
	length = rotator_socket_l + cut_adjust;
	width = is_cut ? segment_cut_width : segment_width;
	
	difference() {
		union() {
			intersection() {
				rotate([-90, 0, 0]) {
					capped_cylinder(diameter + cut_adjust, rotator_socket_l + cut_adjust/2 - 1, width);
				}
				cube([diameter, 2 * length, height], center = true);
			}
			translate([-width/2, 0, -height/2]) {
				cube([width, rotator_socket_l - 1, height]);
			}
		}
		if (!is_cut) {
			translate([0, -hip_armor_tab_width - 0.001, 0]) {
				rotate(180) rotator_peg(is_cut = true);
			}
			fix_preview() {
				translate([0, -hip_armor_tab_width, -height/2]) {
					linear_extrude(height) {
						projection(cut = true) {
							translate([0, 0, -segment_height/2 + 0.3]) {
								rotate([90, 0, 180]) capped_cylinder(rotator_peg_d, rotator_peg_l);
							}
						}
					}				
				}
			}
		}
	}
	if (is_cut) {
		rotate([-90, 0, 0]) {
			cylinder(d = rotator_peg_d + 0.2, h = rotator_peg_l - rotator_peg_d/2 - hip_armor_tab_width + 0.1);
		}
	}
}
