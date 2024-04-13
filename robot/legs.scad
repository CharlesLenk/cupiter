include <../OpenSCAD-Utilities/common.scad>
include <globals.scad>
include <limbs.scad>
use <limb armor.scad>

hip_armor_tab_width = 1.3;
leg_len = 33;
leg_upper_len = leg_len - socket_d/2 - hip_armor_tab_width;

knee_joint_offset = -2.3;
knee_max_angle = 165;

//leg_upper_armor();

//leg_assembled();

function knee_max_angle() = knee_max_angle;

module hip_socket(is_cut = false) {
	height = segment_height + (is_cut ? segment_cut_height_amt : 0);
	width = socket_d + (is_cut ? segment_cut_width_amt : 0);
	cut_d = is_cut ? 0.2 : 0;
	
	d = socket_d + 0.5 + cut_d;
	difference() {
		make_socket(shoulder_socket_gap, is_cut = is_cut) {
			rounded_socket_blank(is_cut, chamfer_y = 1.7);
		}
		armor_snap_inner(
			length = 4, 
			target_width = socket_d,
			depth = 0.4,
			is_cut = !is_cut,
			width_cut_adjust = 0.2
		);
	}	
}

module hip(is_cut = false) {
	//xy_cut(-segment_height/2 + 0.5, size = 30) {
		hip_socket(is_cut);
		translate([0, hip_armor_tab_width + socket_d/2]) {
			rotate(180) rotator_peg(rotator_peg_l, hip_armor_tab_width, is_cut);
		}
	//}
}

hip();

module hip_armor() {
	x = socket_d + 2.5;
	z =  0.75 * socket_d + hip_armor_tab_width - 0.15;
	
	x2 = x - 1;
	z2 = socket_d/2 + hip_armor_tab_width;

	height = segment_height + 3 - edge_d;

	y = 9;
	
	difference() {
		translate([0, -y + socket_d/2 + hip_armor_tab_width]) { 
			minkowski() {
				xy_cut(-(segment_height + 2)/2 + 1 + edge_d/2, size = 20) {
					hull() {
						translate([0, edge_d/2]) {
							armor_section(socket_d + 1, y - edge_d, height);
						}
						translate([0, edge_d/2 - 2.5 + y/2]) {
							armor_section(socket_d + 2, 5 - edge_d, height);
						}
					}
				}
				sphere(d = edge_d);
			}
		}
		translate([0, socket_d/2]) {
			rotate([-90, 0, 0]) cylinder(d = rotator_peg_d + 0.1, h = 10);
		}
		translate([0, 0, -5]) {
			cube([rotator_peg_d - 1.5, 20, 10], center = true);
		}
		hip(true);
	}
}

module leg_upper(is_cut = false) {
    limb_segment(
        length = leg_upper_len, 
        end1_len = rotator_socket_l - 1, 
        end2_len = hinge_socket_d/2, 
        is_cut = is_cut, 
        snaps = true, 
        cross_brace = true
    ) {
        rotator_socket(rotator_peg_l, is_cut);
        hinge_socket(knee_joint_offset, is_cut);
    };
}

module leg_upper_armor(is_top = false) {
	apply_armor_cut(is_top) {
		leg_upper_armor_blank();
		rotate([0, 180, 0]) leg_upper(true);
	}
}

module leg_lower(is_cut = false) {
	limb_segment(
		length = leg_len, 
		end1_len = ball_dist, 
		end2_len = hinge_peg_size/2, 
		is_cut = is_cut, 
		snaps = true, 
		cross_brace = true
	) {
		hinge_peg_holder(knee_joint_offset, is_cut);
        ball(is_cut);
	};
}

module leg_lower_armor(is_top = false) {
	apply_armor_cut(is_top) {
        leg_lower_armor_blank();
		leg_lower(true);
	}
}

module leg_assembled(with_armor = true, leg_angle = 0) {
	hip_offset = socket_d/2 + hip_armor_tab_width;
	
	rotate([0, -90, 0]) {
		c1() hip();
		if(with_armor) c2() hip_armor();
	}
	translate([0, hip_offset, 0]) {
        rotate([0, 90, 0]) c1() leg_upper();
        rotate([0, 270, 0]) if(with_armor) c2() leg_upper_armor_blank();
	}
	translate([0, leg_len]) {
		rotate_with_offset_origin([0, 0, knee_joint_offset], [-leg_angle, 0, 0]) {
			rotate([0, 270, 0]) c1() leg_lower();
			if(with_armor) rotate([0, 270, 0]) c2() leg_lower_armor_blank();
			translate([0, leg_len]) foot_assembled();
		}
	}
}
