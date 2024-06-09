include <openscad-utilities/common.scad>
include <globals.scad>
include <limbs.scad>
use <feet.scad>

knee_joint_offset = -2.3;
knee_max_angle = 165;

leg_upper_top_width = socket_d + 2.4;
upper_thigh_length_back = 6.5;
lower_thight_width_back = 1.2;
leg_lower_armor_len = leg_lower_len - ball_dist;
lower_leg_back_width = 3.7;
lower_leg_lower_width_front = 4;
armor_z = segment_height + 3;

module leg_assembly(
    frame_color = frame_color,
    armor_color = armor_color,
    with_armor = true,
    explode_frame = false,

    hip_armor = false,
    explode_hip_armor = false,
    leg_upper_armor = false,
    explode_leg_upper_armor = false,
    leg_lower_armor = false,
    explode_leg_lower_armor = false,

    foot_socket = false,
    explode_foot_socket = false,
    foot = false,
    explode_foot = false,

    knee_angle = 0
) {
    hip_armor = with_armor && (explode_hip_armor ? true : hip_armor);
    leg_upper_armor = with_armor && (explode_leg_upper_armor ? true : leg_upper_armor);
    leg_lower_armor = with_armor && (explode_leg_lower_armor ? true : leg_lower_armor);
    foot_socket = explode_foot_socket ? true : foot_socket;
    foot = explode_foot ? true : foot;

    hip_offset = socket_d/2 + hip_peg_extension;
    knee_angle = explode_frame ? 40 : knee_angle;

    explode_y = 22;
    explode_z = 20;

    frame_explode_y = explode_frame ? explode_y : 0;
    hip_armor_explode_z = explode_hip_armor ? explode_z : 0;

    foot_socket_explode_y = explode_foot_socket ? explode_y : 0;
    foot_explode_y = explode_foot ? explode_y : 0;

    leg_upper_armor_explode_z = explode_leg_upper_armor ? explode_z : 0;
    leg_lower_armor_explode_z = explode_leg_lower_armor ? explode_z : 0;

    color(frame_color) hip();
    if (hip_armor) {
        translate([0, 0, hip_armor_explode_z]) {
            color(armor_color) hip_armor();
        }
        if(explode_hip_armor) {
            translate([0, 0, hip_armor_explode_z/2]) {
                rotate([90, 0, 90]) assembly_arrow();
            }
        }
    }
    translate([0, hip_offset + frame_explode_y, 0]) {
        rotate([0, 180, 0]) color(frame_color) leg_upper();
        if (leg_upper_armor) {
            reflect([0, 0, 1]) {
                translate([0, 0, -leg_upper_armor_explode_z]) {
                    color(armor_color) leg_upper_armor();
                }
                if(explode_leg_upper_armor) {
                    translate([0, leg_upper_len/2, -leg_upper_armor_explode_z/2 - 2]) {
                        rotate([270, 0, 90]) assembly_arrow();
                    }
                }
            }
        }
        if(explode_frame) {
            translate([0, -frame_explode_y/2 + 4]) rotate(180) assembly_arrow();
        }
    }
    rotate_with_offset_origin([knee_joint_offset, hip_offset + leg_upper_len + frame_explode_y, 0], [0, 0, knee_angle]) {
        if(explode_frame) {
            translate([knee_joint_offset, hip_offset + leg_upper_len + 1.5 * frame_explode_y, 0]) {
                rotate(180) assembly_arrow();
            }
        }
        translate([0, hip_offset + leg_upper_len + 2 * frame_explode_y]) {
            color(frame_color) leg_lower();
            translate([0, foot_socket_explode_y]) {
                if(foot_socket) {
                    translate([0, leg_lower_len, 0]) {
                        rotate([0, 90, 0]) {
                            foot_assembly(
                                frame_color = frame_color,
                                armor_color = armor_color,
                                foot_socket = foot_socket,
                                foot = foot,
                                explode_foot = explode_foot
                            );
                        }
                    }
                    if(explode_foot_socket) {
                        translate([0, leg_lower_len - foot_socket_explode_y/2, 0]) {
                            assembly_arrow();
                        }
                    }
                }
            }
            if (leg_lower_armor) {
                reflect([0, 0, 1]) {
                    translate([0, 0, -leg_lower_armor_explode_z]) {
                        color(armor_color) leg_lower_armor();
                    }
                    if(explode_leg_lower_armor) {
                        translate([0, leg_upper_len/2, -leg_lower_armor_explode_z/2 - 2]) {
                            rotate([270, 0, 90]) assembly_arrow();
                        }
                    }
                }
            }
        }
    }
}

function knee_max_angle() = knee_max_angle;

leg_upper_bot_width_front = get_limb_width_at_y(
    start_width = leg_upper_top_width/2,
    end_width = lower_leg_lower_width_front,
    length = leg_upper_len + leg_lower_armor_len,
    y = leg_upper_len - hinge_armor_y_offset - 0.1
);
leg_lower_width_mid = get_limb_width_at_y(
    start_width = leg_upper_top_width/2,
    end_width = lower_leg_lower_width_front,
    length = leg_upper_len + leg_lower_armor_len,
    y = leg_upper_len - hinge_armor_y_offset
);

module leg_upper_armor_blank() {
    limb_upper_armor_blank(
        length = leg_upper_len,
        height = armor_z,
        top_width = leg_upper_top_width,
        top_back_length = upper_thigh_length_back,
        bottom_front_width = leg_upper_bot_width_front,
        bottom_back_width = lower_thight_width_back,
        joint_offset = knee_joint_offset
    );
}

module leg_lower_armor_blank() {
    limb_lower_armor_blank(
        length = leg_lower_armor_len,
        height = armor_z,
        top_width_front = leg_lower_width_mid,
        width_back = lower_leg_back_width,
        bottom_front_width = lower_leg_lower_width_front,
        joint_offset = knee_joint_offset
    );
}

module hip_socket(is_cut = false) {
    height = segment_height + (is_cut ? segment_cut_height_offset : 0);
    width = socket_d + (is_cut ? segment_cut_width_offset : 0);
    cut_d = is_cut ? 0.2 : 0;

    d = socket_d + 0.5 + cut_d;
    difference() {
        apply_socket_cut(hip_shoulder_tolerance, is_cut = is_cut) {
            rounded_socket_blank(is_cut);
        }
        armor_snap_inner(
			length = 4,
			target_width = socket_d,
            depth = 0.5,
			is_cut = !is_cut,
			width_cut_adjust = 0.2
		);
    }
}

module hip(is_cut = false) {
    hip_socket(is_cut);
    translate([0, socket_d/2 + hip_peg_extension]) {
        rotate(180) rotator_peg(rotator_peg_l, hip_peg_extension, is_cut);
    }
}

hip_armor();

module hip_armor() {
    difference() {
        minkowski() {
            armor_blank(socket_d + 2.4 - edge_d, armor_z - edge_d);
            sphere(d = edge_d);
        }
        rotate([-90, 0, 0]) {
            peg_cut_d = rotator_peg_d + 0.1;
            tab_cut_x = rotator_peg_d - 1.5;
            peg_cut_len = socket_d;
            cylinder(d = peg_cut_d, h = peg_cut_len);
            translate([-tab_cut_x/2, 0]) cube([tab_cut_x, peg_cut_d + 10, peg_cut_len]);
        }
        hip(true);
        translate([0, 0, -1.5 * segment_height]) {
            linear_extrude(segment_height) {
                projection(cut = true) {
                    translate([0, 0, segment_height/2]) hip(true);
                }
            }
        }
    }

    module armor_blank(x, z) {
        intersection() {
            union() {
                rotate_extrude() {
                    intersection() {
                        armor_2d(x, z);
                        translate([0, -z/2]) square([x/2, z]);
                    }
                }
                rotate([270, 0, 0]) linear_extrude(socket_d/2 + hip_armor_tab_width - edge_d/2) armor_2d(x, z);
            }
            shoulder_cut(
                x,
                pos_y = 2.7,
                neg_y = socket_d/2 + hip_armor_tab_width - edge_d/2,
                pos_z = armor_z/2 - edge_d/2,
                neg_z = segment_height/2 - edge_d/2 + 0.3,
                0,
                3
            );
        }
    }
}

module leg_upper(is_cut = false) {
    limb_segment(
        length = leg_upper_len,
        end1_len = rotator_socket_l,
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
        length = leg_lower_len,
        end1_len = hinge_peg_size/2,
        end2_len = ball_dist,
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
