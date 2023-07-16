include <../common.scad>
include <globals.scad>
use <snaps.scad>

socket_opening_angle = 120;

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

module ball_for_armor_subtractions() sphere(d = ball_d + 0.2);

module rounded_socket_blank(is_cut = false, cylinder_length) {
	height = is_cut ? segment_cut_height : segment_height;
	socket_width = is_cut ? socket_d + 0.15 : socket_d;
	cylinder_length = is_undef(cylinder_length) ? socket_width/2 : cylinder_length;
	
	intersection() {
		hull() {
			sphere(d = socket_width);
			rotate([-90, 0, 0]) cylinder(d = socket_width + 0.4, h = cylinder_length);
		}
		translate([-socket_width/2, -socket_width/2, -height/2]) {
			cube([socket_width, socket_width/2 + cylinder_length, height]);
		}
	}
}

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
				
						if (tab_extension > 0)[-height/2, ball_d/2 + ball_tab_len + tab_extension],
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

module socket_with_snaps(is_cut = false) {
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

module c1(armature_color = "#464646") color(armature_color) children();
module c2(armor_color = "#DDDDDD") color(armor_color) children();
