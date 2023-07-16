include <../common.scad>
include <globals.scad>
use <robot common.scad>

hand_x = 10;
hand_y = 9;
hand_z = 6;

finger_width = 2.3;
palm_z = 7;
palm_chamfer = 1;
wrist_len = 2.5;
wrist_socket_gap = -0.10;
hand_z_from_socket = socket_d/2 - 2.5;
hand_armor_height = 1.3;

hand_hole_size = 4;
hand_hole_angle = 10;

index_finger_length = 7;
digit_len_ratios = [0.83, 1, 1.13, 1, 0.77];
digit_lens = [
	digit_len_ratios[0] * index_finger_length, 
	digit_len_ratios[1] * index_finger_length, 
	digit_len_ratios[2] * index_finger_length, 
	digit_len_ratios[3] * index_finger_length, 
	digit_len_ratios[4] * index_finger_length
];
digit_start_heights = [0, 0.9, 1.2, 0.9, -4];

translate([0, -20]) {
	hand_assembled();
	translate([15, 0]) hand_simple_assembled();
}

posed_hands(reflect = true);

module modify_hand_for_print() {
	xy_cut(height = -2.75, size = socket_d) {
		rotate([-30, 0, 0]) children();
	}
}

module posed_hands(reflect = false) {
	count_per_row = 4;
	x_dist = 15;
	y_dist = 20;
	
	reflect([reflect ? 1 : 0, 0, 0]) {
		translate([reflect ? x_dist/2 : 0, 0]) { 
			position_hands() {
				grip();
				flat();
				relaxed();
				fist();
				love();
				prosper();
				peace();
				five();
				open_grip();
			}
		}
	}
	
	module position_hands() {
		for (j = [0 : $children/count_per_row]) {
			row_start_index = j * count_per_row;
			row_end_index = min(row_start_index + count_per_row - 1, $children - 1);
			
			if(row_start_index <= row_end_index) {
				for(i = [row_start_index : row_end_index]) {
					translate([i % count_per_row * x_dist, j * y_dist]) {
						modify_hand_for_print() children(i);
					}
				}
			}
		}
	}
}

module grip() {
	gesture = [
		[55, 30, 35],
		[60, 40, 30],
		[65, 40, 40],
		[45, 40, 50],
		[10, -50]
	];
	difference() {
		hand(
			gesture,
			thumb_angle = 20,
			thumb_palm_extension_angle = 30,
			thumb_palm_angle = 90,
			thumb_z_boost = 3
		);
		translate([0, -2.5, hand_z_from_socket + palm_z - 0.5]) {
			rotate([0, 90 - hand_hole_angle, 0]) {
				cylinder(d = hand_hole_size + 0.1, h = 20, center = true);
			}
		}
	}
}

module open_grip() {
	gesture = [
		[80, 20, 30],
		[80, 35, 35],
		[80, 40, 45],
		[65, 40, 45],
		[0, -10]
	];
	difference() {
		hand(
			gesture,
			thumb_angle = 10,
			thumb_palm_angle = 10,
			thumb_z_boost = 1
		);
		translate([0, -2.5, hand_z_from_socket + palm_z - 1.5]) {
			rotate([0, 90 - hand_hole_angle, 0]) {
				cylinder(d = hand_hole_size, h = 20, center = true);
			}
		}
	}
}

module flat() {
	gesture = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0],
		[0, 0]
	];
	hand(gesture);
}

module relaxed() {
	gesture = [
		[30, 30, 30],
		[30, 30, 30],
		[25, 25, 25],
		[25, 20, 25],
		[10, -20]
	];
	hand(
		gesture,
		finger_splay_angles = [-6, -2, 2, 6],
		thumb_angle = 60,
		thumb_palm_extension_angle = 10,
		thumb_palm_angle = 60
	);
}

module love() {
	gesture = [
		[0, 0, 0],
		[90, 90, 45],
		[90, 90, 45],
		[0, 0, 0],
		[45, 0]
	];
	hand(gesture);
}


module fist() {
	gesture = [
		[90, 90, 90],
		[90, 90, 90],
		[90, 90, 90],
		[90, 90, 90],
		[10, -90]
	];
	hand(
		gesture,
		thumb_angle = 75,
		thumb_palm_extension_angle = 20,
		thumb_palm_angle = 90,
		thumb_z_boost = 2
	);
}

module prosper() {
	gesture = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0],
		[45, 0]
	];
	hand(
		gesture,
		finger_splay_angles = [-18, -20, 18, 18]
	);
}

module peace() {
	gesture = [
		[90, 90, 90],
		[90, 90, 90],
		[0, 0, 0],
		[0, 0, 0],
		[30, -45]
	];
	hand(
		gesture,
		finger_splay_angles = [0, 0, -15, 18],
		thumb_angle = 50,
		thumb_palm_extension_angle = 20,
		thumb_palm_angle = 130,
		thumb_z_boost = 3
	);
}

module five() {
	gesture = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0],
		[45, 0]
	];
	hand(
		gesture,
		finger_splay_angles = [-30, -15, 0, 22]
	);
}

module hand(
	gesture,
	finger_splay_angles = [0, 0, 0, 0],
	thumb_angle = 0,
	thumb_tilt_angle = 0,
	thumb_palm_extension_angle = 0,
	thumb_palm_angle = 0,
	thumb_z_boost = 0
) {
	difference() {
		union () {
			translate([-2 * finger_width, -finger_width + segment_height/2 - hand_armor_height, hand_z_from_socket]) {
				translate([finger_width/2, finger_width/2, palm_z]) {
					for (finger = [0 : 3]) {
						finger_lens = let(finger_len = digit_lens[finger]) [0.4 * finger_len, 0.3 * finger_len, 0.3 * finger_len];
						
						translate([finger * finger_width, 0, digit_start_heights[finger]]) {
							finger(gesture[finger], finger_lens, index = 0, splay_angle = finger_splay_angles[finger]);
						}
					}
				}

				translate([4 * finger_width, 0, palm_z + digit_start_heights[4] + thumb_z_boost]) {
					thumb(
						gesture[4],
						thumb_angle = thumb_angle,
						thumb_palm_extension_angle = thumb_palm_extension_angle,
						thumb_palm_angle = thumb_palm_angle,
						palm_extension_below_thumb = palm_z + digit_start_heights[4] - palm_chamfer + thumb_z_boost
					);
				}
				
				bottom_cube_width = 4 * finger_width - 2 * palm_chamfer;
				// palm
				hull() {
					translate([0, 0, palm_chamfer]) {
						rounded_cube([4 * finger_width, finger_width, palm_z - palm_chamfer], 1, top_d = 0);
					}
					translate([2 * finger_width - bottom_cube_width/2, 0]) {
						rounded_cube([bottom_cube_width, finger_width, 2], 1, top_d = 0);
					}
				}
				hull() {
					translate([finger_width, 0, palm_z]) {
						rounded_cube([3 * finger_width, finger_width, digit_start_heights[1]], 1, top_d = 0, bottom_d = 0);
					}
					translate([2 * finger_width, 0, palm_z]) {
						rounded_cube([finger_width, finger_width, digit_start_heights[2]], 1, top_d = 0, bottom_d = 0);
					}
				}
			}
			intersection() {
				difference() {
					sphere(d = socket_d);
					
					hull() {
						intersection() {
							rotate([90, 0, 0]) cylinder(d = 4.5, h = socket_d, center = true);
							cube([20, 20, 4], center = true); 
						}
						translate([0, 0, -2.75]) {
							rotate([90, 0, 0]) cylinder(d = 3, h = socket_d, center = true);
						}
					}
				}
				cube([socket_d, segment_height, socket_d], center = true); 
			}
		}
		sphere(d = ball_d - 0.2);
		translate([0, 0, -socket_d + 2.75]) {
			cube([socket_d, socket_d, socket_d], center = true); 
		}
		translate([0, 0, -socket_d/2]) {
			cylinder(d = 6, h = 3.5); 
		}
		translate([0, segment_height/2]) {
			rotate([90, 0, 0]) {
				translate([0, hand_z_from_socket + palm_z * 0.65, hand_armor_height]) fix_preview() hand_armor_tabs(true);
			}
		}
	}
}

module thumb(
	joint_angles = [0, 0],
	thumb_angle = 0,
	thumb_palm_extension_angle = 0,
	thumb_palm_angle = 0,
	palm_extension_below_thumb = 0,
	thumb_z_boost = 0
) {
	palm_chamfer = 1;
	thumb_bump_height = 1.2;
	thumb_tilt_angle = joint_angles[0];
	
	position_thumb_base() {
		translate([finger_width/2, finger_width/2, 0]) {
			finger_lens = let(finger_len = digit_lens[4]) [0.5 * finger_len, 0.5 * finger_len];
			rotate(90 + thumb_angle) finger([0, joint_angles[1]], finger_lens);
		}
	}
	hull() {
		position_thumb_base() {
			translate([0, 0, -thumb_bump_height]) {
				rotate_relative_to_point([finger_width/2, finger_width/2, 0], [0, 0, thumb_angle]) {
					rounded_cube([finger_width, finger_width, thumb_bump_height], 1, top_d = 0);
				}
			}
		}
		translate([-finger_width, 0, -palm_extension_below_thumb]) {
			rounded_cube([finger_width, finger_width, palm_extension_below_thumb + 1], 1, top_d = 1);
		}
		translate([-palm_chamfer - finger_width, 0, -palm_extension_below_thumb -palm_chamfer]) {
			rounded_cube([finger_width, finger_width, 2], 1, top_d = 1);
		}
	}
	
	module position_thumb_base() {
		rotate_relative_to_point([-finger_width/2, finger_width/2, 0], [0, 0, -thumb_palm_angle]) {
			rotate_relative_to_point([0, 0, -palm_extension_below_thumb], [0, thumb_palm_extension_angle, 0]) {
				rotate([0, thumb_tilt_angle, 0]) {
					children();
				}
			}
		}
	}
}

module finger(joint_angles, segment_heights, index = 0, splay_angle = 0) {	
	if (index < len(joint_angles)) {
		finger_segment(segment_heights, joint_angles[index], index, splay_angle) {
			finger(joint_angles, segment_heights, index + 1, splay_angle);
		}
	}
	
	module finger_segment(segment_heights, angle, index, splay_angle = 0) {
		translate([0, 0, index > 0 ? segment_heights[index - 1] : 0]) {
			if (index == 0) rotate(90) joint(splay_angle);
			joint(angle);
			rotate([angle, index > 0 ? 0 : splay_angle, 0]) {
				translate([-finger_width/2, -finger_width/2]) {
					rounded_cube(
						[finger_width, finger_width, segment_heights[index]], 
						1, top_d = (index == len(joint_angles) - 1) ? 1 : 0, bottom_d = 0
					);
				}
				children();
			}
		}
	}
	
	module joint(angle) {
		if (angle != 0) {
			rotate([90, 0, angle/abs(angle) * 90]) {
				translate([0, 0, -finger_width/2]) {
					rotate_extrude(angle = abs(angle)) {
						rounded_square_2([finger_width/2, finger_width], c1 = 0, c2 = 0.5, c3 = 0.5, c4 = 0);
					}
				}
			}
		}
	}
}

module hand_armor() {
	hand_edge_margin = 0.5;
	width = 4 * finger_width - 2 * hand_edge_margin;
	c2_width = 4 * finger_width - 2 * palm_chamfer;
	
	difference() {
		hull() {
			translate([0, hand_z_from_socket, 0]) {
				translate([-width/2, palm_chamfer]) rounded_cube([
					width, 
					palm_z - palm_chamfer, 
					hand_armor_height
				], d = 1, top_d = 0.5, bottom_d = 0.5);
				
				translate([finger_width, palm_chamfer]) { 
					rounded_cube([
						finger_width - hand_edge_margin, 
						palm_z - palm_chamfer + digit_start_heights[1], 
						hand_armor_height
					], d = 1, top_d = 0.5, bottom_d = 0.5);
				}
				translate([0, palm_chamfer]) { 
					rounded_cube([
						finger_width, 
						palm_z - palm_chamfer + digit_start_heights[2], 
						hand_armor_height
					], d = 1, top_d = 0.5, bottom_d = 0.5);
				}
				translate([-finger_width, palm_chamfer]) { 
					rounded_cube([
						finger_width, 
						palm_z - palm_chamfer + digit_start_heights[1], 
						hand_armor_height
					], d = 1, top_d = 0.5, bottom_d = 0.5);
				}		
				translate([-c2_width/2, hand_edge_margin]) {
					rounded_cube([
						c2_width, 
						palm_z/2, 
						hand_armor_height
					], d = 1, top_d = 0.5, bottom_d = 0.5);
				}
			}
		}
		translate([0, 0, segment_height/2]) sphere(d = socket_d + 0.2);
	}
	translate([0, hand_z_from_socket + palm_z * 0.65, hand_armor_height]) hand_armor_tabs();
}

module hand_simple_left() {	
	hand_y_adjust = 2.5;
	finger_z_from_hand = 0.15 * hand_z;
	
	finger_x = hand_x/4;
	finger_y = 0.6 * hand_y;
	finger_z = hand_z + finger_z_from_hand;
	knuckle_z = 0.5 * hand_z;
	
	thumb_x = 0.65 * hand_x;
	thumb_y = 0.75 * hand_y;
	thumb_z = hand_z + 2 * finger_z_from_hand;
	
	edge_d = 2.5;

	hand_hole_dist_from_edge = finger_z/2;

    difference () {
		union() {
			translate([-hand_x/2, hand_y_adjust, -segment_height/2]) {
				difference() {
					hand_blank();
					translate([hand_x/2, hand_y/2, 0]) {
						hand_armor_tabs(true);
					}
				}
			}
			make_socket(ball_offset = wrist_socket_gap) {
				sphere(d = socket_d);
			}
		}
		sphere(d = ball_d + wrist_socket_gap);
		translate([-hand_x/2, hand_y_adjust, -segment_height/2]) {
			hand_hole();
		}
    }
	
	module hand_blank() {
		difference() {
			union () {
				rounded_cube([
					hand_x, 
					hand_y - finger_z_from_hand, 
					hand_z
				], edge_d);
				rounded_cube([hand_x, hand_y, knuckle_z], edge_d, bottom_d = segment_d);
				for(i = [0 : 3]) {
					translate([i * finger_x, hand_y - finger_y, 0]) {
						rounded_cube([finger_x, finger_y, finger_z], edge_d);
					}
				}
				rounded_cube([thumb_x, thumb_y - finger_x, thumb_z], edge_d);
				translate([0, thumb_y - finger_x, 0]) {
					rounded_cube([0.85 * thumb_x, finger_x, thumb_z], edge_d);
				}
				rounded_cube([finger_x, thumb_y, thumb_z], edge_d); 
			}
		}
	}
	
	module hand_hole() {		
		translate([
			0, 
			hand_y - hand_hole_dist_from_edge, 
			hand_hole_dist_from_edge
		]) {
			rotate([0, 90, -hand_hole_angle]) {
				translate([0, 0, -1]) {
					cylinder(d = hand_hole_size + 0.15, h = hand_x + 2);
				}
			}
		}
	}
}

module hand_simple_armor() {
	hand_y_adjust = 2.5;
	armor_height = 1.25;
	
	corner_d = 2.5 - 1;
	
	translate([0, hand_y_adjust + hand_y/2, -segment_height/2]) {
		translate([0, 0, -armor_height/2 + 0.05]) {
			rounded_cube([
				hand_x - 1, 
				hand_y - 1, 
				armor_height
			], d = corner_d, top_d = 0.5, bottom_d = 0.5, center = true);
		}
		hand_armor_tabs();
	}
}

module hand_armor_tabs(is_cut = false) {
	d = is_cut ? 1.65 : 1.5;
	h = is_cut ? 1.65 : 1.5;
	l = 3;
	w = 2.5;
	
	translate([-d/2 + w, -l/2]) {
		rounded_cube([d, l, h], d, top_d = is_cut ? 0 : 0.75, bottom_d = 0);
	}
	translate([-d/2 - w, -l/2]) {
		rounded_cube([d, l, h], d, top_d = is_cut ? 0 : 0.75, bottom_d = 0);
	}
}

module hand_assembled(with_armor = true) {
	rotate([0, 180, 0]) {
		mirror([1, 0, 0]) {
			rotate([0, 90, 90]) {
				c1() grip();
				if(with_armor) {
					translate([0, segment_height/2]) {
						rotate([90, 0, 0]) {
							c2() hand_armor();
						}
					}
				}
			}
		}
	}
}

module hand_simple_assembled(with_armor = true) {
	rotate([0, 90, 0]) {
		c1() hand_simple_left();
		if(with_armor) c2() hand_simple_armor();
	}
}
