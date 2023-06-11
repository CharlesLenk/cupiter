include <robot imports.scad>

snap_angle = 100;
socket_opening_angle = 120;
armor_tightness_adjust = 0.1;

module segment(
	length, 
	end1 = 0, 
	end2 = 0, 
	is_cut = false, 
	end1_snap = false,
	mid_snap = false,
	end2_snap = false
) {
    segment_mid_y = get_segment_mid_y(length, end1, end2);
	height = is_cut ? segment_cut_height : segment_height;
	width = is_cut ? segment_cut_width : segment_width;
    
	snap_len = 4;
	snap_edge_dist = 0.5;
	end2_y = segment_mid_y > 0 ? length : get_end_y(end1) + get_end_y(end2);
	
	get_end(end1);
	translate([0, end2_y, 0]) {
		rotate(180) get_end(end2);
	}
	
	if (segment_mid_y > 0) {
		translate([0, segment_mid_y/2 + get_end_y(end1), 0]) {
			difference() {
				cube([width, segment_mid_y + 0.002, height], center = true);
				if (end1_snap) {
					translate([0, -segment_mid_y/2 + snap_edge_dist, 0]) {
						snaps();
					}
				}
				if (mid_snap) {
					translate([0, -snap_len/2, 0]) snaps();
				}
				if (end2_snap) {
					translate([
						0, 
						segment_mid_y/2 - snap_edge_dist - snap_len, 
						0
					]) {
						snaps();
					}
				}
			}
		}  
	}
	
	module snaps() {
		armor_snap_inner_double(
			length = snap_len, 
			target_width = segment_width,
			depth = snap_depth,
			is_cut = !is_cut
		);
	}
	
    module get_end(end) {
        if (end == SOCKET) {
			socket(is_cut);
        } else if (end == BALL) {
            ball(is_cut);
		} else if (end == ROTATOR_SOCKET) {
			rotator_socket(is_cut);
		} else if (end == ROTATOR_PEG) {
			rotator_peg();
		} else if (end == WAIST_SOCKET) {
			waist_socket(is_cut);
		} else if (end == ELBOW_PEG) {
			elbow_peg(elbow_joint_offset, is_cut);
		} else if (end == ELBOW_SOCKET) {
			elbow_socket(elbow_joint_offset, is_cut);
		} else if (end == KNEE_PEG) {
			elbow_peg(knee_joint_offset, is_cut);
		} else if (end == KNEE_SOCKET) {
			elbow_socket(knee_joint_offset, is_cut);
		} else if (end == SHOULDER_SOCKET) {
			shoulder_socket(is_cut);
		} else if (end == HIP_SOCKET) {
			hip_socket(is_cut);
		}
    }
}

function get_segment_mid_y(length, end1 = 0, end2 = 0) = 
	length - get_end_y(end1) - get_end_y(end2);

function get_end_y(end) = 
	(end == SOCKET || end == WAIST_SOCKET || end == SHOULDER_SOCKET || end == HIP_SOCKET)? socket_dist : 
	end == BALL ? ball_dist : 
	end == ROTATOR_SOCKET ? rotator_socket_l :
	end == ROTATOR_PEG ? 0 :
	(end == ELBOW_PEG || end == KNEE_PEG) ? elbow_peg_len :
	(end == ELBOW_SOCKET || end == KNEE_SOCKET) ? elbow_socket_len :
	0;

module make_socket(ball_offset = 0, socket_angle = 0, cut_angle = socket_opening_angle, is_cut = false) {
	height = segment_height + (is_cut ? segment_cut_height_amt : 0);
	width = socket_d + (is_cut ? segment_cut_width_amt : 0);
	
	difference() {
		intersection() {
			children();
			cube([width, socket_d, height], center = true);
		}
		if (!is_cut) rotate(socket_angle) socket_cut(cut_angle, ball_offset);
	}
	if (is_cut) ball_for_armor_subtractions();
}

module socket_cut(cut_angle = socket_opening_angle, ball_offset) {
	translate([0, 0, -socket_d/2]) {
		rotate(180) wedge(cut_angle, socket_d, socket_d);
	}
	sphere(d = ball_d + ball_offset);
	hull () {
		cylinder(h = socket_d, d = 4, center = true);
		translate([0, -socket_d/2, 0]) {
			cylinder(h = socket_d, d = 4, center = true);
		}
	}
}

module ball_for_armor_subtractions() {
	sphere(d = ball_d + 0.2);
}

module armor_snap_inner_double(
	length, 
	target_width,
	depth,
	is_cut = false
) {
	snap_triangle_height = (depth + segment_cut_width_amt/2);
	z_dist = snap_triangle_height / tan(90 - snap_angle/2) + 0.1;
	
	translate([0, 0, z_dist]) snaps();
	translate([0, 0, -z_dist]) snaps();
	
	module snaps() {
		armor_snap_inner(
			length = length, 
			target_width = target_width, 
			depth = depth,
			is_cut = is_cut
		);
	}
}

module armor_snap_outer(
	length, 
	target_width,
	depth,
	is_cut = false
) {
	cut_adjust = is_cut ? 0.1 : 0;
	
	snap_bump();
	translate([0, length]) rotate(180) snap_bump();
	
	module snap_bump() {
		translate([depth + target_width/2 + cut_adjust, 0]) {
			rotate([0, 90, 90]) {
				wedge(snap_angle, depth + cut_adjust, length);
			}
		}
	}
}

module one_side_double_snap(
	length, 
	target_width,
	depth,
	is_cut = false
) {
	snap_triangle_height = (depth + segment_cut_width_amt/2);
	z_dist = snap_triangle_height / tan(90 - snap_angle/2) + 0.1;
	
	translate([0, length]) {
		rotate(180) {
			translate([0, 0, z_dist]) snap_bump(length, target_width, depth, is_cut);
			translate([0, 0, -z_dist]) snap_bump(length, target_width, depth, is_cut);
		}
	}
}

module armor_snap_inner(
	length, 
	target_width,
	depth,
	is_cut = false
) {
	snap_bump(length, target_width, depth, is_cut);
	translate([0, length]) rotate(180) snap_bump(length, target_width, depth, is_cut);
}

module snap_bump(
	length, 
	target_width,
	depth,
	is_cut = false
) {
	depth_cut_adjust = is_cut ? 0.15 : 0;
	width_cut_adjust = is_cut ? 0.1 : 0;
	
	translate([-target_width/2 + depth_cut_adjust + depth, -width_cut_adjust/2]) {
		rotate([0, 90, 90]) {
			wedge(snap_angle, 2 * depth, length + width_cut_adjust);
		}
	}
}

module apply_armor_cut(is_top = false) {
	xy_cut((is_top ? -1 : 1 ) * armor_tightness_adjust, from_top = true, size = 100) {
		rotate([0, is_top ? 180 : 0, 0]) {
			difference() {
				children(0);
				children(1);
			}
		}
	}
}

module c1() color(armature_color) children();
module c2() color(armor_color) children();
