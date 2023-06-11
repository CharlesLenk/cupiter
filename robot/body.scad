include <robot imports.scad>

//torso_2();
//torso_armor();
//torso_armor_blank();

hip_len = 11;
waist_len = socket_dist + ball_dist + 1;
torso_len = body_len - waist_len - hip_len;
shoulder_inner_width = shoulder_width - 2 * (ball_dist + socket_d/2);

torso_width_start = socket_d + 3;
torso_width_inc = 1.2;
torso_height_start = segment_height + 4;
torso_height_inc = 0.75;
waist_ball_overlap_adjust = 2.5;

//translate([30, 0]) body_exploded();
////
//body_assembled();
assembled();
//waist_armor();

module body_assembled(with_armor = true) {
	c1() torso();
	if(with_armor) c2() torso_armor_blank();
	translate([0, torso_len, 0]) {
		c1() waist();
		if(with_armor) c2() waist_armor_blank();
	}
	translate([0, torso_len + waist_len, 0]) {
		c1() hips();
		if(with_armor) c2() hips_armor_blank();
	}
}

module body_exploded() {
	torso();
	translate([0, 0, -10]) torso_armor();
	translate([0, 25]) {
		waist();
		translate([0, 0, -10]) waist_armor();
	}
	translate([0, 45]) {
		hips();
		translate([0, 0, -10]) hips_armor();
	}
}

module torso_armor_blank() {
	width = torso_width_start + 2 * torso_width_inc;
	height = torso_height_start + 2 * torso_height_inc;
	shoulder_segment_width = shoulder_width - 2 * ball_dist;

	shoulder_width_offset = ball_dist - segment_height/2;
	inner_segment_width = shoulder_segment_width - 2 * shoulder_width_offset;
	
	shoulder_pad_width = (inner_segment_width - socket_d)/2 + 0.75;
	shoulder_pad_height = 1.4;
	shoulder_pad_y_pos = shoulder_height - socket_d/2 - shoulder_pad_height + 0.25;
	
	translate([-shoulder_pad_width + inner_segment_width/2, 0]) {
		shoulder_pad();
	}
	translate([-inner_segment_width/2, 0]) {
		shoulder_pad();
	}

	module shoulder_pad() {
		hull() {
			translate([0, shoulder_pad_y_pos]) {
				translate([0, 0, -height/4]) {
					rounded_cube([shoulder_pad_width, 2 * segment_d + shoulder_pad_height, height/2], segment_d);
				}
				translate([0, shoulder_pad_height/2 - 0.05, -height/2]) {
					rounded_cube([shoulder_pad_width, 2 * segment_d + shoulder_pad_height, height], segment_d);
				}
			}
		}
	}
	
	armor_segment(torso_len, width);
	hull() {
		y = 12;
		translate([shoulder_width/2 - ball_dist - shoulder_width_offset, y/2 + shoulder_height - socket_d/2 - 0.5, 0]) {
			rotate(90) armor_segment(inner_segment_width, y);
		}
		lower_segment_offset = (inner_segment_width - width)/2;
		translate([0, 6 + shoulder_height - segment_d + lower_segment_offset]) {
			armor_segment(segment_d, width);
		}
	}
		
	module armor_segment(length, w) {
		translate([-w/2, 0, -height/2]) {
			rounded_cube([w, length, height], segment_d);
		}
	}
}

module waist_ball_cut() {
	offset_amt = segment_d + 0.5;
	outer_width = torso_width_start - offset_amt;
	outer_height = torso_height_start - offset_amt;
	inner_width = outer_width - 4;
	inner_height = outer_height - 2;

	d = 2;
	translate([0, ball_dist - waist_ball_overlap_adjust, 0]) {
		hull () {
			translate([-inner_width/2, 0, -inner_height/2]) {
				rounded_cube([inner_width, d, inner_height], d);
			}
			translate([-outer_width/2, -1, -outer_height/2]) {
				rounded_cube([outer_width, d, outer_height], d);
			}
		}
	}
}

module waist_armor_blank() {
	width = torso_width_start + torso_width_inc;
	height = torso_height_start + torso_height_inc;
	
	difference() {
		translate([-width/2, waist_ball_overlap_adjust, -height/2]) {
			rounded_cube([width, waist_len - waist_ball_overlap_adjust, height], segment_d);
		}
		waist_ball_cut();
	}
}

module hips_armor_blank() {
	waist_width = torso_width_start;
	waist_length = 6;
	
	length = 1.5 + segment_width/2 + hip_len;
	
	lower_width = hip_width - 2 * ball_dist - 0.5;
	mid_width = lower_width * 1.5;
	
	difference() {
		union () {
			translate([0, 0, -torso_height_start/2]) {
				translate([-waist_width/2, waist_ball_overlap_adjust]) {
					rounded_cube([waist_width, waist_length - waist_ball_overlap_adjust, torso_height_start], segment_d);
				}
			}
			translate([0, 0, -torso_height_start/2]) {
				hull() {
					translate ([-mid_width/2, waist_ball_overlap_adjust, 0]) {
						rounded_cube([mid_width, length - 4.5 - waist_ball_overlap_adjust, torso_height_start], segment_d);
					}
					translate ([-lower_width/2, waist_ball_overlap_adjust]) {
						rounded_cube([lower_width, length - waist_ball_overlap_adjust, torso_height_start], segment_d);
					}
				}
			}
		}
		translate([0, 0]) waist_ball_cut();
	}
}

module torso(is_cut = false) {
	z = is_cut ? segment_cut_height : segment_height;
	socket_width = is_cut ? socket_d + 0.1 : socket_d;
	segment_width = is_cut ? segment_cut_width : segment_width;
	torso_upper_socket_gap = -0.05;
	torso_lower_socket_gap = -0.15;
	
	shoulder_upper_snap_len = 3.8;
	shoulder_lower_snap_len = 4.6;
	waist_snap_len = 6;
	difference() {
		union() {
			rounded_socket_blank(is_cut, torso_len - socket_r);
			translate([0, torso_len]) rotate([0, 180, 180]) rounded_socket_blank(is_cut);
			translate([shoulder_inner_width/2, shoulder_height]) {
				rotate([0, 180, 90]) rounded_socket_blank(is_cut);
			}
			translate([-shoulder_inner_width/2, shoulder_height]) {
				rotate(-90) rounded_socket_blank(is_cut, shoulder_inner_width - socket_r);
			}
		}
		if (!is_cut) {
			place_ball_cuts() {
				socket_cut(ball_offset = torso_upper_socket_gap);
				rotate(90) socket_cut(ball_offset = torso_upper_socket_gap);
				rotate(-90) socket_cut(ball_offset = torso_upper_socket_gap);
				rotate(180) socket_cut(ball_offset = torso_lower_socket_gap);
			}
		}
		translate([socket_d/2 + 0.1, shoulder_height]) {
			rotate(-90) armor_snap_inner_double(shoulder_upper_snap_len, socket_d, snap_depth, !is_cut);
		}
		translate([-socket_d/2  - 0.1 - shoulder_upper_snap_len, shoulder_height]) {
			rotate(-90) armor_snap_inner_double(shoulder_upper_snap_len, socket_d, snap_depth, !is_cut);
		}
		translate([0, torso_len - socket_d/2 - 2]) {
			armor_snap_inner_double(waist_snap_len, socket_d, snap_depth, !is_cut);
		}
	}
	if (is_cut) {
		place_ball_cuts() {
			ball_for_armor_subtractions();
			ball_for_armor_subtractions();
			ball_for_armor_subtractions();
			ball_for_armor_subtractions();
		}
	}
	
	module place_ball_cuts() {
		children(0);
		translate([shoulder_inner_width/2, shoulder_height]) children(1);
		translate([-shoulder_inner_width/2, shoulder_height]) children(2);
		translate([0, torso_len]) children(3);
	}
}

module waist(is_cut = false) {
	segment(waist_len, BALL, WAIST_SOCKET, is_cut = is_cut);
}

module hips(is_cut = false) {
	w = is_cut ? segment_cut_width : segment_width;
	mid_len = hip_len - segment_width/2 - socket_d/2;
	
	segment(ball_dist + mid_len, BALL, 0, is_cut, mid_snap = true);
	translate([hip_width/2, hip_len]) {
		rotate(90) segment(hip_width, BALL, BALL, is_cut, mid_snap = true);
	}
	translate([0, hip_len - w/4]) {
		cube([hip_width - 2 * ball_dist, w/2, segment_height], center = true);
	}
}

module torso_armor() {
	apply_armor_cut() {
		torso_armor_blank();
		torso(true);
	}
}

module waist_armor() {
	apply_armor_cut() {
		waist_armor_blank();
		waist(true);
	}
}

module hips_armor() {
	apply_armor_cut() {
		hips_armor_blank();
		hips(true);
	}
}
