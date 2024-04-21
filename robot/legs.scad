include <../OpenSCAD-Utilities/common.scad>
include <globals.scad>
include <limbs.scad>

hip_armor_tab_width = 1.3;
leg_len = 33;
leg_upper_len = leg_len - socket_d/2 - hip_armor_tab_width;

knee_joint_offset = -2.3;
knee_max_angle = 165;

leg_upper_top_width = socket_d + 2.4;
upper_thigh_length_back = 6.5;
lower_thight_width_back = 1.2;
leg_lower_armor_len = leg_len - ball_dist;
lower_leg_back_width = 3.7;
lower_leg_lower_width_front = 4;
armor_z = segment_height + 3;

//leg_assembled();

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
    height = segment_height + (is_cut ? segment_cut_height_amt : 0);
    width = socket_d + (is_cut ? segment_cut_width_amt : 0);
    cut_d = is_cut ? 0.2 : 0;

    d = socket_d + 0.5 + cut_d;
    difference() {
        apply_socket_cut(shoulder_socket_gap, is_cut = is_cut) {
            rounded_socket_blank(is_cut);
        }
    }
}

module hip(is_cut = false) {
    hip_socket(is_cut);
    translate([0, hip_armor_tab_width + socket_d/2]) {
        rotate(180) rotator_peg(rotator_peg_l, hip_armor_tab_width, is_cut);
    }
}

module hip_armor() {
    difference() {
        minkowski() {
            xy_cut(-segment_height/2 + edge_d/2, size = 15) {
                difference() {
                    armor_blank(socket_d + 2.4 - edge_d, armor_z - edge_d);
                    translate([0, -9.8 - ball_d/2 + edge_d/2]) cube([20, 20, 20], center = true);
                }
            }
            sphere(d = edge_d);
        }
        rotate([-90, 0, 0]) {
            peg_cut_d = rotator_peg_d + 0.1;
            tab_cut_x = rotator_peg_d - 1.5;
            peg_cut_len = socket_d;
            cylinder(d = peg_cut_d, h = peg_cut_len);

            translate([-tab_cut_x/2, 0]) cube([tab_cut_x, peg_cut_d/2, peg_cut_len]);
        }
        hip(true);
    }

    module armor_blank(x, z) {
        rotate_extrude() {
            intersection() {
                armor_2d(x, z);
                translate([0, -z/2]) square([x/2, z]);
            }
        }
        rotate([270, 0, 0]) linear_extrude(socket_d/2 + hip_armor_tab_width - edge_d/2 - 0.1) armor_2d(x, z);
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
        if (with_armor) c2() hip_armor();
    }
    translate([0, hip_offset, 0]) {
        rotate([0, 90, 0]) c1() leg_upper();
        rotate([0, 270, 0]) if (with_armor) c2() leg_upper_armor_blank();
    }
    translate([0, leg_len]) {
        rotate_with_offset_origin([0, 0, knee_joint_offset], [-leg_angle, 0, 0]) {
            rotate([0, 270, 0]) c1() leg_lower();
            if (with_armor) rotate([0, 270, 0]) c2() leg_lower_armor_blank();
            translate([0, leg_len]) foot_assembled();
        }
    }
}
