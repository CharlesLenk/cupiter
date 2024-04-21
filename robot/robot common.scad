include <../OpenSCAD-Utilities/common.scad>
include <globals.scad>
use <snaps.scad>

socket_opening_angle = 120;

module apply_socket_cut(ball_offset = 0, socket_angle = 0, cut_angle = socket_opening_angle, is_cut = false) {
	height = segment_height + (is_cut ? segment_cut_height_amt : 0);
	width = socket_d + (is_cut ? segment_cut_width_amt : 0);
	
	difference() {
		children();
		if (!is_cut) rotate(socket_angle) socket_cut(cut_angle, ball_offset);
	}
	if (is_cut) ball_for_armor_subtractions();
}

module socket_cut(cut_angle = socket_opening_angle, ball_offset) {
	translate([0, 0, -socket_d/2]) {
		rotate(180) wedge(cut_angle, socket_d/2, socket_d);
	}
	sphere(d = ball_d + ball_offset);
	hull () {
		cylinder(h = socket_d, d = 4, center = true);
		translate([0, -socket_d/2, 0]) {
			cylinder(h = socket_d, d = 4, center = true);
		}
	}
}

module rounded_socket_blank(is_cut = false, cylinder_length) {
	height = is_cut ? segment_cut_height : segment_height;
	socket_width = is_cut ? socket_d + 0.2 : socket_d;
	cylinder_length = is_undef(cylinder_length) ? socket_width/2 : cylinder_length;
	round_from_edge = 2;
	d = 7;

	rotate_extrude() {
		intersection() {
			armor_2d(socket_width, height, round_from_edge, d);
			translate([0, -height/2]) square([socket_width/2, height]);
		}
	}
	rotate([270, 0, 0]) linear_extrude(cylinder_length) {
		armor_2d(socket_width, height, round_from_edge, d);
	}
}

module ball_for_armor_subtractions() sphere(d = ball_d + 0.2);

module ball(is_cut = false, tab_extension = 0) {
	cut_amt = is_cut ? segment_cut_height_amt : 0;
	height = is_cut ? segment_cut_height : segment_height;
	tab_width = is_cut ? segment_cut_width : segment_width;
	
	xy_cut(ball_cut_height, size = ball_d) {
		sphere(d = ball_d);
	}
	
	translate([-tab_width/2, 0]) {
		rotate([0, 90, 0]) {
			linear_extrude(tab_width){
				polygon(
					[
						[height/4, 0],
						[height/4, ball_d/2],
						[height/2, ball_d/2 + ball_tab_len],
						if (tab_extension > 0) [height/2, ball_d/2 + ball_tab_len + tab_extension],
				
						if (tab_extension > 0) [-height/2, ball_d/2 + ball_tab_len + tab_extension],
						[-height/2, ball_d/2 + ball_tab_len],
						[-height/4, ball_d/2],
						[-height/4, 0],
					]
				);
			}
		}
	}
}

module apply_armor_cut(is_top = false) {
	armor_tightness_adjust = 0.1;
	
	xy_cut((is_top ? -1 : 1) * armor_tightness_adjust, from_top = true, size = 100) {
		rotate([0, is_top ? 180 : 0, 0]) {
			difference() {
				children(0);
				children(1);
			}
		}
	}
}

module snaps_tabs(x, y, z, is_cut = false) {
	cut_adjust = is_cut ? 0.15 : 0;
	
	snap_tab_width = 1;
	width = x;
		
	intersection() {
		translate([0, y - 1, -z/2]) {
			rotate([90, 0, 0]) {
				armor_snap_outer(
					length = z, 
					target_width = width - 2 * snap_tab_width,
					depth = 1.5,
					is_cut = is_cut
				);
			}
		}
		translate([0, y/2, 0]) {
			cube([20, y, z], center = true);
		}
	}
	
	if (is_cut) {
		translate([-width/2, 0, -z/2]) {
			cube([width, y + 1, z]);
		}
	} else {
		translate([0, 0.001, -z/2]) {
			translate([- width/2, 0, 0]) {
				cube([snap_tab_width, y - 0.75, z]);
			}
			translate([width/2 - snap_tab_width, 0, 0]) {
				cube([snap_tab_width, y - 0.75, z]);
			}
		}
	}
}

module socket_with_snaps(is_cut = false) {
	head_and_foot_socket_gap = -0.2;
	cut_adjust = is_cut ? 0.15 : 0;
	height = is_cut ? segment_cut_height : segment_height;
	
	tab_len = 3.5;
	tab_width = 4;
	
	apply_socket_cut(head_and_foot_socket_gap, is_cut = is_cut) {
		rounded_socket_blank(is_cut);
	}

	translate([0, socket_d/2]) snaps_tabs(tab_width, tab_len, height, is_cut);
}

module cross_brace(depth, target_width, is_cut) {
	height = is_cut ? segment_cut_height : segment_height;
	cut_adjust = is_cut ? 0.1 : 0;
	
	translate([0, 0, -height/2]) { 
		linear_extrude(height) {
			hull() {
				reflect([1, 0, 0]) {
					translate([target_width/2, 0]) {
						circle(d = depth + cut_adjust);
					}
				}
			}
		}
	}
}

module armor_section(x, y, z, left_d = 0, right_d = 0) {
	rotate([270, 0, 0]) {
		linear_extrude(y) {
			armor_2d(x, z, 3, 8, left_d, right_d);
		}
	}
}

module armor_2d(x, y, round_len = 3, d = 8, left_d = 0, right_d = 0) {
	mid = y - 2 * round_len;
	left_d = left_d == 0 ? d : left_d;
	right_d = right_d == 0 ? d : right_d;

	hull() {
		reflect([0, 1, 0]) {
			translate([0, mid/2]) circle_fragment(x, y, left_d, round_len);
			mirror([1, 0, 0]) translate([0, mid/2]) circle_fragment(x, y, right_d, round_len);
		}
	}
}

module circle_fragment(x, y, d, round_len) {
	intersection() {	
		translate([-d/2 + x/2, 0]) {
			circle(d = d);
		}
		translate([0, 0]) {
			square([x/2, round_len]);
		} 
	}
}

module square_with_chamfers(x, y, chamfer_x, chamfer_y) {
	polygon(
		[
			[x/2, y/2 - chamfer_y],
			[x/2 - chamfer_x, y/2],
			[-x/2 + chamfer_x, y/2],
			[-x/2, y/2 - chamfer_y],
			[-x/2, -y/2 + chamfer_y],
			[-x/2 + chamfer_x, -y/2],
			[x/2 - chamfer_x, -y/2],
			[x/2, -y/2 + chamfer_y],
		]
	);
}

module c1(armature_color = "#464646") color(armature_color) children();
module c2(armor_color = "#DDDDDD") color(armor_color) children();
