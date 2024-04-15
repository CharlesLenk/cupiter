include <../OpenSCAD-Utilities/common.scad>
include <limb constants.scad>


hinge_peg_armor_peg_d = 2.75;
hinge_peg_armor_peg_h = 1.5;
elbow_wall_width = 1.5;
hinge_peg_h = segment_height - elbow_wall_width;

upper_thigh_width = socket_d + 2.5; //rotator_socket_d + 2;
upper_thigh_length_front = 1;//4;
thigh_length = leg_upper_len;
lower_thigh_width_front = 4;

upper_thigh_length_back = 6.5;
lower_thight_width_back = 1.2;

pivot_test = false;
pivot_d = 4;

leg_width = segment_height + 3;
leg_inner_width = 3;

leg_lower_len = leg_len - ball_dist;
lower_leg_back_width = 3.7;
lower_leg_lower_width_front = 4;

chamfer_depth = 1.5;

edge_d = segment_d;

armor_z = segment_height + 3;

arm_height = 10;
arm_width = 10;

arm_upper_top_len = 4.5;
arm_lower_bot_width_front = 3.5;
arm_lower_bot_width_back = 3.4;

arm_upper_bot_width_back = 1.1;

arm_upper_bot_width_front = get_limb_width_at_y(
	start_width = arm_width/2, 
	end_width = arm_lower_bot_width_front, 
	length = arm_armor_upper_len + arm_armor_lower_len - arm_upper_top_len, 
	y = arm_armor_upper_len - arm_upper_top_len - hinge_armor_y_offset - 0.1
);
arm_lower_width_mid = get_limb_width_at_y(
	start_width = arm_width/2, 
	end_width = arm_lower_bot_width_front, 
	length = arm_armor_upper_len + arm_armor_lower_len - arm_upper_top_len, 
	y = arm_armor_upper_len - arm_upper_top_len - hinge_armor_y_offset
);
leg_upper_bot_width_front = get_limb_width_at_y(
	start_width = upper_thigh_width/2, 
	end_width = lower_leg_lower_width_front, 
	length = leg_upper_len + leg_lower_len - upper_thigh_length_front, 
	y = leg_upper_len - upper_thigh_length_front - hinge_armor_y_offset - 0.1
);
leg_lower_width_mid = get_limb_width_at_y(
	start_width = upper_thigh_width/2, 
	end_width = lower_leg_lower_width_front, 
	length = leg_upper_len + leg_lower_len - upper_thigh_length_front, 
	y = leg_upper_len - upper_thigh_length_front - hinge_armor_y_offset
);

module leg_upper_armor_blank() {
	upper_limb_armor_rounded(
		upper_thigh_width,
		upper_thigh_length_front,
		upper_thigh_length_back,
		leg_upper_bot_width_front,
		lower_thight_width_back,
		thigh_length,
		knee_joint_offset
	);
}

module leg_lower_armor_blank() {
	limb_lower_rounded(
		limb_length = leg_lower_len,
		width_front_top = leg_lower_width_mid,
		width_front_bot = lower_leg_lower_width_front,
		width_back = lower_leg_back_width,
		joint_offset = knee_joint_offset
	);
}

module arm_upper_armor_blank() {
	upper_limb_armor_rounded(
		arm_width,
		arm_upper_top_len,
		arm_upper_top_len,
		arm_upper_bot_width_front,
		arm_upper_bot_width_back,
		arm_armor_upper_len,
		elbow_joint_offset,
		segment_height + 2.7
	);
}

module arm_lower_armor_blank() {
	limb_lower_rounded(
		limb_length = arm_armor_lower_len,
		width_front_top = arm_lower_width_mid,
		width_front_bot = arm_lower_bot_width_front,
		width_back = arm_lower_bot_width_back,
		joint_offset = elbow_joint_offset,
		segment_height + 2.7
	);
}

leg_upper_armor_blank();
translate([0, leg_upper_len]) {
	leg_lower_armor_blank();
}

translate([-20, 0]) {
	arm_upper_armor_blank();
	translate([0, arm_armor_upper_len]) {		
		arm_lower_armor_blank();
	}
}

function drop_ratio() = (upper_thigh_width/2 - lower_leg_lower_width_front) / (thigh_length - upper_thigh_length_front + leg_lower_len);

function get_limb_width_at_y(
	start_width,
	end_width,
	length,
	y
) = start_width - ((start_width - end_width) / length) * y;

//for (i = [0 : 20]) {
//	x = get_limb_width_at_y(
//		10,
//		0,
//		40,
//		i * 2
//	);
//	translate([x, i * 2]) {
//		circle(r = 0.5);
//	}	
//}

module upper_limb_armor_rounded(
	top_width,
	top_width_ext_front,
	top_width_ext_back,
	bot_width_front,
	bot_width_back,
	length,
	joint_offset,
	armor_z = armor_z
) {
    d = edge_d;
    minkowski() {
        difference() {
            translate([0, d/2]) {
                upper_limb(
                    armor_z - d,
                    top_width - d,
                    top_width_ext_front - d/2,
                    top_width_ext_back - d/2,
                    length - d,
                    bot_width_front - d/2,
                    bot_width_back - d/2
                );
            }
            translate([joint_offset, length]) {
                cylinder(d = hinge_socket_d + d + 0.2, h = armor_z, center = true);
            }
        }
        sphere(d = d);
    }
}

module limb_lower_rounded(
	limb_length,
	width_front_top,
	width_front_bot,
	width_back,
	joint_offset,
	armor_z = armor_z
) {
    d = edge_d;
    minkowski() {
        union() {
            translate([0, d/2]) {
                lower_leg(
					limb_length - d,
					width_front_top - d/2,
					width_front_bot - d/2,
					width_back - d/2,
                    armor_z - d
                );
            }
            translate([joint_offset, 0]) {
                cylinder(d = hinge_socket_d - d, h = armor_z - d, center = true);
            }
        }
        sphere(d = d);
    }
}

module upper_limb(
    leg_width,
    upper_thigh_width,
    upper_thigh_length_front,
    upper_thigh_length_back,
    thigh_length,
    lower_thigh_width_front,
    lower_thight_width_back
) {
    hull() {
        extrude_center_z(leg_inner_width) {
            limb_upper_2d(
                upper_thigh_width,
                upper_thigh_length_front,
                upper_thigh_length_back,
                thigh_length,
                lower_thigh_width_front,
                lower_thight_width_back
            );
        }
        extrude_center_z(leg_width) {
            limb_upper_2d(
                upper_thigh_width - 2 * chamfer_depth,
                upper_thigh_length_front,
                upper_thigh_length_back,
                thigh_length,
                lower_thigh_width_front - chamfer_depth,
                lower_thight_width_back
            );
        }
    }
}

module extrude_center_z(length) {
    translate([0, 0, -length/2]) {
        linear_extrude(length) {
            children();
        }
    }
}

module limb_upper_2d(
    upper_thigh_width,
    upper_thigh_length_front,
    upper_thigh_length_back,
    thigh_length,
    lower_thigh_width_front,
    lower_thight_width_back
) {
    thigh_gap = 0.1;
    thigh_length = thigh_length - thigh_gap - hinge_armor_y_offset;
    difference() {
        polygon(
            [
                [upper_thigh_width/2, 0],
                [upper_thigh_width/2, upper_thigh_length_front],
                [lower_thigh_width_front, thigh_length],
                [-lower_thight_width_back, thigh_length],
                [-upper_thigh_width/2, upper_thigh_length_back],
                [-upper_thigh_width/2, 0],
            ]
        );
    }
}

module lower_leg(
	limb_length,
	width_front_top,
	width_front_bot,
	width_back,
	limb_height
) {
    hull() {
        extrude_center_z(leg_inner_width) {
            limb_lower_2d(
				limb_length,
				width_front_top,
				width_front_bot,
				width_back,
				width_back
            );
        }
        extrude_center_z(limb_height) {
            limb_lower_2d(
				limb_length,
				width_front_top - chamfer_depth,
				width_front_bot - chamfer_depth,
				width_back,
				width_back - 0.5
            );
        }
    }
}

module limb_lower_2d(
	limb_length,
	width_front_top,
	width_front_bot,
	width_back,
	width_back_2
) { 
	translate([0, -hinge_armor_y_offset]) {
		polygon(
			[
				[width_front_top, 0],
				[width_front_bot, limb_length + hinge_armor_y_offset],
				[-width_back_2, limb_length + hinge_armor_y_offset],
				[-width_back, 0],
			]
		);
	}
}
