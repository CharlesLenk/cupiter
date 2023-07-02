include <robot imports.scad>

hip_width = 6 + 2 * ball_dist;
shoulder_width = 33;
shoulder_height = 4;
torso_len = 36 + shoulder_height;
hip_len = 12;
waist_len = socket_dist + ball_dist + 1;
chest_len = torso_len - waist_len - hip_len;
shoulder_inner_width = shoulder_width - 2 * (ball_dist + socket_d/2);

torso_width_start = socket_d + 3;
torso_width_inc = 1.2;
torso_height_start = segment_height + 4;
torso_height_inc = 0.75;
waist_ball_overlap_adjust = 2.5;

body_assembled(with_armor = false);
//body_exploded();

function torso_len() = torso_len;
function hip_width() = hip_width;
function shoulder_width() = shoulder_width;
function shoulder_height() = shoulder_height;

module body_assembled(with_armor = true) {
	c1() chest();
	if(with_armor) c2() chest_armor_blank();
	translate([0, chest_len, 0]) {
		c1() waist();
		if(with_armor) c2() waist_armor_blank();
	}
	translate([0, chest_len + waist_len, 0]) {
		c1() pelvis();
		if(with_armor) c2() pelvis_armor_blank();
	}
}

module body_exploded() {
	chest();
	translate([0, 0, -10]) chest_armor();
	translate([0, 25]) {
		waist();
		translate([0, 0, -10]) waist_armor();
	}
	translate([0, 45]) {
		pelvis();
		translate([0, 0, -10]) pelvis_armor();
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

module chest(is_cut = false) {
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
			rounded_socket_blank(is_cut, chest_len - socket_r);
			translate([0, chest_len]) rotate([0, 180, 180]) rounded_socket_blank(is_cut);
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
		translate([0, chest_len - socket_d/2 - 2]) {
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
		translate([0, chest_len]) children(3);
	}
}

module chest_armor_blank() {
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
	
	armor_segment(chest_len, width);
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

module waist(is_cut = false) {
	segment(waist_len, BALL, WAIST_SOCKET, is_cut = is_cut);
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

module pelvis(is_cut = false) {
	w = is_cut ? segment_cut_width : segment_width;
	h = is_cut ? segment_cut_height : segment_height;
	
	hip_ball_angle = 15;
	
	opposite = (ball_dist + segment_width/2) * sin(hip_ball_angle);
	mid_len = hip_len - segment_width/2 - socket_d/2 - opposite;
	
	difference() {
		segment(ball_dist + mid_len, BALL, 0, is_cut);
		translate([0, ball_dist, 0]) {
			armor_snap_inner_double(mid_len - 0.2, segment_width, snap_depth, !is_cut);
		}
	}
	translate([hip_width/2, hip_len]) {
		rotate(90 + hip_ball_angle) {
			segment(ball_dist + segment_width/2, BALL, 0, is_cut);
		}
	}
	translate([-hip_width/2, hip_len]) {
		rotate( -90 - hip_ball_angle) {
			segment(ball_dist + segment_width/2, BALL, 0, is_cut);
		}
	}
	
	translate([0, mid_len + ball_dist + segment_width/2]) {
		difference() {
			adjacent = (ball_dist + segment_width/2) * cos(hip_ball_angle);
			rounded_cube(
				[hip_width + segment_width - 2 * adjacent, w, h], 
				d = w, top_d = 0, bottom_d = 0, center = true
			);
			rotate(90) {
				snap_width = hip_width - 2 * ball_dist - segment_width - 0.5;
				translate([0, -snap_width/2]) {
					one_side_double_snap(snap_width, segment_width, snap_depth, !is_cut);
				}
			}
		}
	}
}

module pelvis_armor_blank() {
	waist_width = torso_width_start;
	waist_length = 6.5;
	
	length = 0.5 + segment_width/2 + hip_len;
	
	lower_width = hip_width - 2 * ball_dist - 0.25;
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

module chest_armor() {
	apply_armor_cut() {
		chest_armor_blank();
		chest(true);
	}
}

module waist_armor() {
	apply_armor_cut() {
		waist_armor_blank();
		waist(true);
	}
}

module pelvis_armor() {
	apply_armor_cut() {
		pelvis_armor_blank();
		pelvis(true);
	}
}
