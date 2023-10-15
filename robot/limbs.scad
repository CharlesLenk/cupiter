include <../common.scad>
include <globals.scad>
use <robot common.scad>
use <hands.scad>
use <feet.scad>
use <snaps.scad>

hinge_armor_y_offset = 1;
shoulder_socket_gap = -0.15;

armor_height = segment_height + 3;
limb_upper_armor_width = segment_height + 3;

rotator_peg_l = 8;
rotator_peg_d = 0.95 * ball_d;
rotator_socket_l = rotator_peg_l + socket_shell_width;
rotator_socket_d = rotator_peg_d + 2 * socket_shell_width;

hinge_peg_armor_peg_d = 2.75;
hinge_peg_armor_peg_h = 1.5;
elbow_wall_width = 1.5;
hinge_peg_d = 4.5;
hinge_peg_h = segment_height - elbow_wall_width;
hinge_socket_d = hinge_peg_d + 3;
hinge_peg_size = hinge_socket_d + 2.7;

module limb_upper_armor_blank(max_width, max_length, min_width, min_length, cylinder_pos) {
	difference() {
		translate([-max_width/2, 0, -armor_height/2]) {
			hull() {
				rounded_cube([min_width, max_length, armor_height], segment_d);
				rounded_cube([max_width, min_length, armor_height], segment_d);
			}
		}
		translate(cylinder_pos) {
			cylinder(d = hinge_socket_d + 0.2, h = armor_height, center = true);
		}
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
			d = hinge_socket_d, 
			h = armor_height, 
			top_d = segment_d,  
			bottom_d = segment_d, 
			center = true
		);
	}
}

module rotator_peg(peg_len, peg_ext_past_socket = 0, is_cut = false) {
	cut_adjust = is_cut ? 0.2 : 0;
	cylinder_l = peg_len + peg_ext_past_socket;
	
	if (is_cut) {
		rotate([90, 0, 0]) peg();
	} else {
		xy_cut(ball_cut_height, size = 2 * cylinder_l) {
			rotate([90, 0, 0]) peg();
		}
	}

	module peg() {
		translate([0, 0, -peg_ext_past_socket]) {
			difference() {
				capped_cylinder(rotator_peg_d + cut_adjust, cylinder_l + cut_adjust/2);
				snap_d2 = 2.5;
				translate([0, 0, snap_d2/2 + peg_ext_past_socket + 1]) {
					torus(rotator_peg_d - 1.25, snap_d2);
				}
			}
		}
	}
}

module rotator_socket(peg_len, is_cut = false) {
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
			fix_preview() {
				rotate(180) rotator_peg(peg_len, is_cut = true);
				translate([0, 0, -height/2]) {
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
			capped_cylinder(d = rotator_peg_d + 0.2, h = peg_len + 0.1);
		}
	}
}

module hinge_peg(is_cut = false) {
	hinge_socket_gap = -0.1;
	hinge_peg_cap_d = hinge_peg_d + 1.25;
	cut_offset = is_cut ? hinge_socket_gap : 0;
	cap_h = (hinge_peg_cap_d - hinge_peg_d)/2;

	difference() {
		union() {
			cylinder(d = hinge_peg_d + cut_offset, h = hinge_peg_h);
			translate([0, 0, hinge_peg_h - cap_h]) {
				cylinder(d1 = hinge_peg_d + cut_offset, d2 = hinge_peg_cap_d + cut_offset, h = cap_h);
			}
			cylinder(d2 = hinge_peg_d + cut_offset, d1 = hinge_peg_cap_d + cut_offset, h = cap_h);
		}
		if (!is_cut) {
			translate([0, 0, hinge_peg_h - hinge_peg_armor_peg_h]) {
				fix_preview() cylinder(d = hinge_peg_armor_peg_d, h = hinge_peg_armor_peg_h);
			}
		}
	}
}

module hinge_peg_holder(joint_offset = 0, is_cut = false) {
	if (is_cut) {
		translate([joint_offset, 0, -segment_cut_height/2]) {
			elbow_cube(true);
		}
	} else {
		translate([joint_offset, 0, -segment_height/2]) {
			cylinder(d = hinge_socket_d, h = elbow_wall_width);
			translate([0, 0, elbow_wall_width]) hinge_peg();
			difference() {
				elbow_cube();
				translate([0, 0, elbow_wall_width]) {
					cylinder(d = hinge_socket_d + 0.6, h = segment_height);
				}
			}
		}
	}
	
	module elbow_cube(is_cut = false) {
		corner_d = 3;	
		x_add = 1.4;
		y_add = 1;
		base_xy = hinge_peg_size/2;
		cube_x = base_xy + x_add;
		cube_y = base_xy + y_add;
		z = is_cut ? segment_cut_height : segment_height;
		
		difference() {
			union() {
				translate([-x_add, -y_add]) cube_one_round_corner([cube_x, cube_y, z], corner_d/2);
				if (is_cut) {
					cylinder(d = hinge_socket_d + 0.1, h = z);
				}
			}
			if (is_cut) {
				translate([0, 0, z - hinge_peg_armor_peg_h]) {
					cylinder(d = hinge_peg_armor_peg_d - 0.2, h = hinge_peg_armor_peg_h + 0.01);
				}
			}
		}
	}
}

module hinge_socket(joint_offset = 0, is_cut = false) {
	socket_opening_angle = 100;
	if (is_cut) {
		translate([joint_offset, 0]) {
			cylinder(d = hinge_socket_d + 0.1, h = segment_cut_height, center = true);
		}
		cube([segment_cut_width, hinge_socket_d + 0.1, segment_cut_height], center = true);
	} else {
		translate([0, 0, -segment_height/2]) {
			difference() {
				union () {
					translate([joint_offset, 0]) {
						cylinder(d = hinge_socket_d, h = segment_height - elbow_wall_width);
					}
					translate([-segment_width/2, 0]) {
						cube([segment_width, hinge_socket_d/2, segment_height]);
					}
				}
				translate([joint_offset, 0]) {
					fix_preview() hinge_peg(true);
				}
				fix_preview() {
					translate([joint_offset, 0]) {
						rotate(140) wedge(socket_opening_angle, segment_height, segment_height);
						translate([0, 0, segment_height - elbow_wall_width]) {
							fix_preview() cylinder(d = hinge_socket_d + 0.1, h = elbow_wall_width + 0.1);
						}
					}
				}
			}
		}
	}
}

module limb_segment(
	length, 
	end1_len = 0, 
	end2_len = 0, 
	is_cut = false, 
	snaps = false,
	cross_brace = false,
	snap_offset = 0
) {
    segment_mid_y = length - end1_len - end2_len;
	height = is_cut ? segment_cut_height : segment_height;
	width = is_cut ? segment_cut_width : segment_width;
    
	//snap_len = 3.5;
	snap_len = segment_mid_y - 3;
	snap_edge_dist = 0.5;
	end2_y = segment_mid_y > 0 ? length : end1_len + end2_len;
	
	// End one
	children(0);
	translate([0, end2_y, 0]) {
		// End two
		rotate(180) children(1);
	}
	
	mid_width = 1;
	mid_mid_y = segment_mid_y - 2.5;
	
	if (segment_mid_y > 0) {
		translate([0, segment_mid_y/2 + end1_len, 0]) {
								if (cross_brace) {
						cross_brace(1, segment_width, is_cut);
					}
			difference() {
				union() {
					mid_lenasdf = mid_mid_y + (is_cut ? 0.1 : 0);
					cube([width, segment_mid_y + (is_cut ? 0.1 : 0), height], center = true);
					
//					hull() {
//						cube([width, segment_mid_y + 0.002, height], center = true);
//					
//						
//
//						translate([-width/2 - mid_width/2, -mid_lenasdf/2, -height/4]) {
//							cube([width, mid_lenasdf, height/2]);
//						}
//					}
//					hull() {
//						translate([-width/2, -segment_mid_y/2, -height/2]) {
//							cube([width, segment_mid_y - snap_offset, height]);
//						}
//						translate([-width/2 + mid_width/2, -mid_lenasdf/2, -height/4]) {
//							cube([width, mid_lenasdf - snap_offset, height/2]);
//						}
//					}

				}
				if (snaps) {
//					translate([0, -(mid_mid_y - 1)/2, 0]) {
//						one_side_double_snap(
//							length = mid_mid_y - 1 - snap_offset, 
//							target_width = segment_width + mid_width,
//							is_cut = !is_cut
//						);
//						mirror([1, 0, 0]) one_side_double_snap(
//							length = mid_mid_y - 1, 
//							target_width = segment_width + mid_width,
//							is_cut = !is_cut
//						);
//					}
					translate([0, -segment_mid_y/2 + snap_edge_dist, 0]) {
						armor_snap_inner_double(
							length = snap_len, 
							target_width = segment_width,
							is_cut = !is_cut
						);
					}
					translate([0, segment_mid_y/2 - snap_edge_dist - snap_len]) {
						armor_snap_inner_double(
							length = snap_len, 
							target_width = segment_width,
							is_cut = !is_cut
						);
					}
				}
			}
		}  
	}
}
