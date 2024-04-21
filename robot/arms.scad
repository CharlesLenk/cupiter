include <../OpenSCAD-Utilities/common.scad>
include <limbs.scad>

elbow_max_angle = 160;

arm_upper_len = 21;
arm_lower_len = 0.9 * arm_upper_len;
elbow_joint_offset = -2;

arm_armor_upper_len = arm_upper_len - ball_dist;
arm_armor_lower_len = arm_lower_len - ball_dist;

arm_width = 10;
arm_upper_top_len = 3.2;
arm_lower_bot_width_front = 3.5;
arm_lower_bot_width_back = 3.4;
arm_upper_bot_width_back = 1.1;

arm_assembled();

function elbow_max_angle() = elbow_max_angle;

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
    height = segment_height + (is_cut ? segment_cut_height_amt : 0);
    width = socket_d + (is_cut ? segment_cut_width_amt : 0);
    cut_d = is_cut ? 0.2 : 0;

    d = socket_d + 0.5 + cut_d;
    difference() {
        apply_socket_cut(shoulder_socket_gap, is_cut = is_cut) {
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
            xy_cut(-segment_height/2 + edge_d/2, size = 15) {
                difference() {
                    armor_blank(socket_d - edge_d + 2.4, segment_height - edge_d + 2.4);
                    translate([0, -9.8 - ball_d/2 + edge_d/2]) cube([20, 20, 20], center = true);
                }
            }
            sphere(d = 1);
        }
        rotate([0, 180, 0]) shoulder(true);
    }

    module armor_blank(x, z) {
        cylinder_length = socket_d/2 - edge_d/2;

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

            h_ext = 1.1;
            translate([0, cylinder_length, h_ext/2]) {
                rotate([270, 0, 0]) linear_extrude(0.001) armor_2d(x, z + h_ext, d = 6);
            }
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
        mirror([1, 0, 0]) translate([0, ball_dist]) arm_upper_armor_blank();
        arm_upper(true);
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

module arm_assembled(
    with_armor = true,
    elbow_angle = 0,
    shrug_angle = 0,
    arm_extension_angle = 0,
    simple_hands = false
) {
    rotate_relative_to_point([socket_d/2 + ball_dist, 0], shrug_angle) {
        rotate([0, 90, 270]) {
            rotate([0, 180, 0]) c1() shoulder();
            if (with_armor) c2() shoulder_armor();
        }
        rotate(arm_extension_angle) {
            rotate([0, 270, 0]) {
                c1() arm_upper();

            }
            if (with_armor) {
                translate([0, ball_dist]) {
                    rotate([0, 90, 0]) c2() arm_upper_armor_blank();
                }
            }
            translate([0, arm_upper_len, 0]) {
                rotate_with_offset_origin([0, 0, -elbow_joint_offset], [elbow_angle, 0, 0]) {
                    translate([0, 0, 0]) {
                        rotate([0, 90, 0]) {
                            c1() arm_lower();
                        }
                    }
                    if (with_armor) rotate([0, 90, 0]) c2() arm_lower_armor_blank();
                    translate([0, arm_lower_len]) {
                        if (simple_hands) {
                            hand_simple_assembled(with_armor);
                        } else {
                            hand_assembled(with_armor);
                        }
                    }
                }
            }
        }
    }
}
