include <../OpenSCAD-Utilities/common.scad>
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

module foob(x, z, cylinder_length, chamfer_x = 1, chamfer_y = 1) {
	cylinder_length = is_undef(cylinder_length) ? socket_width/2 : cylinder_length;

	rotate(180) 
	rotate_extrude(angle = 180) {
		intersection() {
			square_with_chamfers(x, z, chamfer_x, chamfer_y);
			translate([0, -z/2]) square([x/2, z]);
		}
	}
	rotate([270, 0, 0]) linear_extrude(cylinder_length) square_with_chamfers(x, z, chamfer_x, chamfer_y);
}

module rounded_socket_blank(is_cut = false, cylinder_length, chamfer_y = 1) {
	height = is_cut ? segment_cut_height : segment_height;
	socket_width = is_cut ? socket_d + 0.2 : socket_d;
	cylinder_length = is_undef(cylinder_length) ? socket_width/2 : cylinder_length;
	chamfer_x = 1;

	rotate_extrude() {
		intersection() {
			square_with_chamfers(socket_width, height, chamfer_x, chamfer_y);
			translate([0, -height/2]) square([socket_width/2, height]);
		}
	}
	rotate([270, 0, 0]) linear_extrude(cylinder_length) square_with_chamfers(socket_width, height, chamfer_x, chamfer_y);
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

module armor_section(x, y, z, chamfer_x = 1.5, chamfer_y = 2.5) {
	rotate([270, 0, 0]) {
		linear_extrude(y) {
			square_with_chamfers(x, z, chamfer_x, chamfer_y);
			//armor_2d_round_2(x, z, 0, 0, 10);
		}
	}
}

armor_2d_round_2(10, 10, 0, 0, 10);

// translate([15, 0]) armor_2d_round(10, 10);
// armor_2d_round_2(10, 10, d = 10);


//circle_fragment_2(10, 5);

module armor_2d_round(x, y, chamfer_x, chamfer_y, d = 20) {
	rotate(90) hull() {
		translate([0, x/2]) circle_fragment(y, d);
		translate([0, -x/2]) rotate(180) circle_fragment(y, d);
	}
}

module armor_2d_round_2(x, y, chamfer_x, chamfer_y, d = 20) {
	rotate(90) hull() {
		translate([0, x/2]) circle_fragment_2(y, d);
		translate([0, -x/2]) rotate(180) circle_fragment_2(y, d);
	}
}

module circle_fragment_2(x, d, mid = 2) {
	y_adjust = 0;//isosceles_triangle_height(d/2, x - mid/2);
	reflect([1, 0, 0]) 
	translate([0, -(d/2 - y_adjust)]) { 
		intersection() {	
			translate([mid, -y_adjust]) {
				circle(d = d);
			}
			translate([-x/2, 0]) {
				square([x, d/2 - y_adjust]);
			} 
		}
	}
}

module circle_fragment(x, d) {
	y_adjust = isosceles_triangle_height(d/2, x);
	translate([0, -(d/2 - y_adjust)]) { 
		intersection() {	
			translate([0, -y_adjust]) {
				circle(d = d);
			}
			translate([-x/2, 0]) {
				square([x, d/2 - y_adjust]);
			} 
		}
	}
}

function isosceles_triangle_height(a, b) = sqrt(a^2 - b^2/4);

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
