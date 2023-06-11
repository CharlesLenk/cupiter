include <robot imports.scad>

hand_x = 10;
hand_y = 9;
hand_z = 6;

finger_width = 2.5;
palm_z = 8;
wrist_len = 2.5;
wrist_socket_gap = -0.15;

joint_angles = [45, 45, 45];

relaxed = [
	[45, 45, 45],
	[30, 30, 30],
	[25, 25, 25],
	[20, 20, 20],
	[45, 45]
];

fist = [
	[90, 90, 90],
	[90, 90, 90],
	[90, 90, 90],
	[90, 90, 90],
	[0, 90]
];

flat_hand = [
	[0, 0, 0],
	[0, 0, 0],
	[0, 0, 0],
	[0, 0, 0],
	[0, 0]
];

module hand_assembled(with_armor = true) {
	rotate([180, 90, 0]) {
		c1() hand_left();
		if(with_armor) c2() hand_armor();
	}
}

hand_test();

module hand_test() {
	$fs = 0.4;
	translate([-15, 0, 0]) {
		rotate([90, 0, 0]) hand_left();
	}	
	hand(flat_hand);
	translate([15, 0]) hand(fist);
	translate([30, 0]) hand(relaxed);
}

finger_heights = [0, 0.5, 0.75, 0.5, -4];
finger_segment_heights = [2.4, 3.15, 3.5, 3.15, 4];

module hand(gesture) {
	translate([-2 * finger_width, -finger_width/2, ball_d/2 + 1.25]) {
		translate([finger_width/2, finger_width/2, palm_z]) {
			for (finger = [0 : 3]) {
				translate([finger * finger_width, 0, finger_heights[finger]]) {
					finger(gesture[finger], finger_segment_heights[finger]);
				}
			}
		}
		thumb_angle = 15;
		
		
		translate([finger_width/2 + 4 * finger_width, finger_width/2, 4]) {
			finger(gesture[4], finger_segment_heights[4]);
		}
		hull() {
			translate([4 * finger_width, 0, 3]) {
				//rotate([0, 30, 0]) {
					translate([0, 0]) {
						rounded_cube([finger_width, finger_width, 1], 1, top_d = 0);
					}
				//}
			}
			translate([3 * finger_width, 0, 0]) {
				//rotate([0, 30, 0]) {
					translate([0, 0]) {
						rounded_cube([finger_width, finger_width, palm_z/2], 1, top_d = 0);
					}
				//}
			}
		}
		
		
		
		rounded_cube([4 * finger_width, finger_width, palm_z], 1, top_d = 0);
		translate([finger_width, 0, palm_z]) {
			rounded_cube([3 * finger_width, finger_width, 0.5], 1, top_d = 0, bottom_d = 0);
		}
		translate([2 * finger_width, 0, palm_z]) {
			rounded_cube([finger_width, finger_width, finger_heights[2]], 1, top_d = 0, bottom_d = 0);
		}
	}
	sphere(d = ball_d);
}

module thumb(angle1, angle2) {
	rotate(-angle1) {
		translate([-2 * finger_width, -finger_width/2, ball_d/2 + 1.25]) {
			translate([finger_width/2, finger_width/2, palm_z]) {
				translate([4 * finger_width, 0, finger_heights[4]]) {
					rotate(-angle2) finger(gesture[4], finger_segment_heights[4]);
				}
			}
		}
	}
}

module finger(joint_angles, segment_height, index = 0) {	
	if (index < len(joint_angles)) {
		finger_segment(segment_height, joint_angles[index], index) {
			finger(joint_angles, segment_height, index + 1);
		}
	}
	
	module finger_segment(height, angle, index) {
		translate([0, 0, index > 0 ? height : 0]) {
//			rotate([0, 90, 0]) {
//				rounded_cylinder(
//					d = finger_width, h = finger_width, 
//					top_d = 1, bottom_d = 1, center = true
//				);
//			}
			hull() {
				translate([-finger_width/2, -finger_width/2]) {
					rounded_cube([finger_width, finger_width, 0.001], 
					1, top_d = 0, bottom_d = 0);
				}
				rotate([angle, 0, 0]) {
					translate([-finger_width/2, -finger_width/2]) {
						rounded_cube([finger_width, finger_width, 0.001], 
						1, top_d = 0, bottom_d = 0);
					}
				}
			}
			rotate([angle, 0, 0]) {
				translate([-finger_width/2, -finger_width/2]) {
					rounded_cube([finger_width, finger_width, segment_height], 
					1, top_d = (index == len(joint_angles) - 1) ? 1 : 0, bottom_d = 0);
				}
				children();
			}
		}
	}
}

module hand_left() {	
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

	hand_hole_size = 4;
	hand_hole_dist_from_edge = finger_z/2;
	hand_hole_angle = 10;

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
			translate([0, 0, 0]) {
		
				
				rotate([-90, 0, 0]) cylinder(d = 3.5, h = ball_d/2 + wrist_len);
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
					cylinder(d = hand_hole_size, h = hand_x + 2);
				}
			}
		}
	}
}

module hand_armor() {
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
	w = 5;
	
	x_reflect(w) {
		hull() {
			y_reflect(l - d) {
				rounded_cylinder(d = d, h = h, top_d = is_cut ? 0 : 0.75);
			}
		}
	}
}
