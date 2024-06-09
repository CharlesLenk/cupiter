include <OpenSCAD-Utilities/common.scad>
include <limbs.scad>
use <hands.scad>

elbow_max_angle = 160;

elbow_joint_offset = -2;

arm_armor_upper_len = arm_upper_len - ball_dist;
arm_armor_lower_len = arm_lower_len - ball_dist;

arm_width = 10;
arm_upper_top_len = 3.2;
arm_upper_bot_width_back = 1.1;
arm_lower_bot_width_front = 3.5;
arm_lower_bot_width_back = 3.4;

function elbow_max_angle() = elbow_max_angle;

module arm_assembly(
    frame_color = frame_color,
    armor_color = armor_color,
    with_armor = true,
    explode_frame = false,

    shoulder_armor = false,
    explode_shoulder_armor = false,
    arm_upper_armor = false,
    explode_arm_upper_armor = false,
    arm_lower_armor = false,
    explode_arm_lower_armor = false,

    hand = false,
    explode_hand = false,
    hand_armor = false,
    explode_hand_armor = false,

    arm_retract_angle = 0,
    elbow_angle = 0
) {
    shoulder_armor = with_armor && (explode_shoulder_armor ? true : shoulder_armor);
    arm_upper_armor = with_armor && (explode_arm_upper_armor ? true : arm_upper_armor);
    arm_lower_armor = with_armor && (explode_arm_lower_armor ? true : arm_lower_armor);
    hand_armor = with_armor && (explode_hand_armor ? true : hand_armor);
    hand = explode_hand ? true : hand;

    elbow_angle = explode_frame ? 40 : elbow_angle;

    explode_y = 22;
    frame_explode_y = explode_frame ? explode_y : 0;

    explode_z = 20;
    arm_upper_armor_explode_z = explode_arm_upper_armor ? explode_z : 0;
    arm_lower_armor_explode_z = explode_arm_lower_armor ? explode_z : 0;

    shoulder_armor_explode_z = explode_shoulder_armor ? explode_z : 0;

    hand_explode_y = explode_hand ? explode_y : 0;

    rotate(180) color(frame_color) shoulder();
    if (shoulder_armor) {
        translate([0, 0, -shoulder_armor_explode_z]) {
            rotate([0, 180, 180]) color(armor_color) shoulder_armor();
        }
        if(explode_shoulder_armor) {
            translate([0, 0, -shoulder_armor_explode_z/2]) {
                rotate([270, 0, 90]) assembly_arrow();
            }
        }
    }
    rotate([arm_retract_angle, 0, 0]) {
        translate([0, frame_explode_y, 0]) {
            rotate([0, 180, 0]) color(frame_color) arm_upper();
            if (arm_upper_armor) {
                reflect([0, 0, 1]) {
                    translate([0, 0, -arm_upper_armor_explode_z]) {
                        color(armor_color) arm_upper_armor();
                    }
                    if(explode_arm_upper_armor) {
                        translate([0, arm_upper_len/2, -arm_upper_armor_explode_z/2 - 2]) {
                            rotate([270, 0, 90]) assembly_arrow();
                        }
                    }
                }
            }
            if(explode_frame) {
                translate([0, -frame_explode_y/2]) rotate(180) assembly_arrow();
            }
        }
        rotate_with_offset_origin([elbow_joint_offset, arm_upper_len + frame_explode_y, 0], [0, 0, elbow_angle]) {
            if(explode_frame) {
                translate([elbow_joint_offset, arm_upper_len + 1.5 * frame_explode_y, 0]) {
                    rotate(180) assembly_arrow();
                }
            }
            translate([0, arm_upper_len + 2 * frame_explode_y]) {
                color(frame_color) arm_lower();
                if (arm_lower_armor) {
                    reflect([0, 0, 1]) {
                        translate([0, 0, -arm_lower_armor_explode_z]) {
                            color(armor_color) arm_lower_armor();
                        }
                        if(explode_arm_lower_armor) {
                            translate([0, arm_lower_len/2, -arm_lower_armor_explode_z/2 - 2]) {
                                rotate([270, 0, 90]) assembly_arrow();
                            }
                        }
                    }
                }
                if(hand) {
                    translate([0, arm_lower_len + hand_explode_y]) {
                        rotate([90, 180, 0]) {
                            mirror([0, 0, 1]) {
                                hand_assembly(
                                    frame_color = frame_color,
                                    armor_color = armor_color,
                                    hand_armor,
                                    explode_hand_armor
                                );
                            }
                        }
                        if(explode_hand) {
                            translate([0, -hand_explode_y/2]) assembly_arrow();
                        }
                    }
                }
            }
        }
    }
}

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

module arm_upper_armor_blank() {
    limb_upper_armor_blank(
        length = arm_armor_upper_len,
        height = segment_height + 2.7,
        top_width = arm_width,
        top_back_length = arm_upper_top_len,
        bottom_front_width = arm_upper_bot_width_front,
        bottom_back_width = arm_upper_bot_width_back,
        joint_offset = elbow_joint_offset
    );
}

module arm_lower_armor_blank() {
    limb_lower_armor_blank(
        length = arm_armor_lower_len,
        height = segment_height + 2.7,
        top_width_front = arm_lower_width_mid,
        width_back = arm_lower_bot_width_back,
        bottom_front_width = arm_lower_bot_width_front,
        joint_offset = elbow_joint_offset
    );
}

module shoulder_socket(is_cut = false) {
    height = segment_height + (is_cut ? segment_cut_height_offset : 0);
    width = socket_d + (is_cut ? segment_cut_width_offset : 0);
    cut_d = is_cut ? 0.2 : 0;

    d = socket_d + 0.5 + cut_d;
    difference() {
        apply_socket_cut(hip_shoulder_tolerance, is_cut = is_cut) {
            rounded_socket_blank(is_cut);
        }
        if (!is_cut) {
            hull() {
                cylinder(d = 4, h = 10);
                rotate([-25, 0, 0]) cylinder(d = 4, h = 10);
            }
        }
        armor_snap_inner(
            length = 4,
            target_width = socket_d,
            depth = 0.6,
            is_cut = !is_cut,
            width_cut_adjust = 0.2
        );
    }
}

module shoulder(is_cut = false) {
    shoulder_socket(is_cut);
    translate([0, socket_r + ball_dist]) {
        rotate(180) ball(is_cut);
    }
}

module shoulder_armor() {
    height = segment_height + 2.6;

    difference() {
        minkowski() {
            armor_blank(socket_d - edge_d + 2.4, segment_height - edge_d + 2.4);
            sphere(d = 1);
        }
        rotate([0, 180, 0]) shoulder(true);
        translate([0, 0, -1.5 * segment_height]) {
            linear_extrude(segment_height) {
                projection(cut = true) {
                    translate([0, 0, segment_height/2]) shoulder(true);
                }
            }
        }
    }

    module armor_blank(x, z) {
        cylinder_length = socket_d/2 - edge_d/2;
        h_ext = 1.2;

        intersection() {
            hull() {
                rotate(180) {
                    rotate_extrude(angle = 180) {
                        intersection() {
                            armor_2d(x, z);
                            translate([0, -z/2]) square([x/2, z]);
                        }
                    }
                }
                rotate([270, 0, 0]) linear_extrude(cylinder_length) armor_2d(x, z);


                translate([0, cylinder_length, h_ext/2]) {
                    rotate([270, 0, 0]) linear_extrude(0.001) armor_2d(x, z + h_ext, d = 6);
                }
            }
            shoulder_cut(
                x,
                pos_y = 2.9,
                neg_y = cylinder_length,
                pos_z = segment_height/2 + h_ext + 1.2 - edge_d/2,
                neg_z = segment_height/2 - edge_d/2 + 0.3,
                0,
                3
            );
        }
    }
}

module arm_upper(is_cut = false) {
    limb_segment(
        length = arm_upper_len,
        end1_len = ball_dist,
        end2_len = hinge_socket_d/2,
        is_cut = is_cut,
        snaps = true,
        cross_brace = true
    ) {
        ball(is_cut);
        hinge_socket(elbow_joint_offset, is_cut);
    };
}

module arm_upper_armor(is_top = false) {
    apply_armor_cut(is_top) {
        translate([0, ball_dist]) arm_upper_armor_blank();
        mirror([1, 0, 0]) arm_upper(true);
    }
}

module arm_lower(is_cut = false) {
    limb_segment(
        length = arm_lower_len,
        end1_len = hinge_peg_size/2,
        end2_len = ball_dist,
        is_cut = is_cut,
        snaps = true,
        cross_brace = true
    ) {
        hinge_peg_holder(elbow_joint_offset, is_cut);
        ball(is_cut);
    };
}

module arm_lower_armor(is_top = false) {
    apply_armor_cut(is_top) {
        mirror([0, 0, 0]) arm_lower_armor_blank();
        arm_lower(true);
    }
}
