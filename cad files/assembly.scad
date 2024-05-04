include <../OpenSCAD-Utilities/common.scad>
include <globals.scad>
use <robot common.scad>
use <head.scad>
use <body.scad>
use <arms.scad>
use <legs.scad>

assembly();
echo_cam();

module socket_assembly_note() {
    socket_dist = 15;
    translate([0, socket_dist]) {
        rotate([0, 90, 0]) color(frame_color) socket_with_snaps();
    }
    translate([0, socket_dist/2]) assembly_arrow();
    translate([0, -leg_lower_len]) color(frame_color) leg_lower();
}

module shoulder_note() {
    color(frame_color) {
        shoulder();
        translate([0, -18]) rotate([0, 180, 0]) shoulder();
        translate([0, -27]) rotate(180) waist();
    }
}

module assembly(
    frame_color = frame_color,
    armor_color = armor_color,
    with_armor = true,
    arm_extension_angle = 80,
    arm_lift_angle = 0,
    elbow_angle = 0,
    hip_angle = 0,
    knee_angle = 0
) {
    body_assembly(
        frame_color = frame_color,
        armor_color = armor_color,
        with_armor = with_armor,
        head = true,
        hip_armor = true,
        arm_extension_angle = arm_extension_angle,
        arm_lift_angle = arm_lift_angle,
        elbow_angle = elbow_angle,
        hip_angle = hip_angle,
        knee_angle = knee_angle
    );
}

module body_assembly(
    frame_color = frame_color,
    armor_color = armor_color,
    with_armor = true,
    head = false,
    explode_head = false,
    explode_legs = false,
    hip_armor = false,
    explode_hip_armor = false,
    arm_extension_angle = 0,
    arm_lift_angle = 0,
    elbow_angle = 0,
    hip_angle = 0,
    hip_extension_angle = 0,
    knee_angle = 0
) {
    leg_explode_y = explode_legs ? 20 : 0;
    hip_extension_angle = explode_legs ? 45 : 0;

    upper_body_assembly(
        frame_color = frame_color,
        armor_color = armor_color,
        with_armor = with_armor,
        chest_armor = true,
        shoulder_armor = true,
        head = head,
        explode_head = explode_head,
        arm_extension_angle = arm_extension_angle,
        arm_lift_angle = arm_lift_angle,
        elbow_angle = elbow_angle
    );

    reflect([1, 0, 0]) {
        rotate_with_offset_origin([-hip_width/2, torso_len, 0], [hip_angle, 0, hip_extension_angle]) {
            translate([-hip_width/2, torso_len + leg_explode_y]) {
                rotate([0, 270, 0]) {
                    leg_assembly(
                        frame_color = frame_color,
                        armor_color = armor_color,
                        with_armor = with_armor,
                        hip_armor = hip_armor,
                        explode_hip_armor = explode_hip_armor,
                        leg_upper_armor = true,
                        leg_lower_armor = true,
                        foot_socket = true,
                        foot = true,
                        knee_angle = knee_angle
                    );
                }
                if (explode_legs) {
                    translate([0, -leg_explode_y/2]) {
                        assembly_arrow();
                    }
                }
            }
        }
    }
}

module upper_body_assembly(
    frame_color = frame_color,
    armor_color = armor_color,
    with_armor = true,
    explode_arms = false,
    chest_armor = false,
    explode_chest_armor = false,
    shoulder_armor = false,
    explode_shoulder_armor = false,

    head = false,
    explode_head = false,

    arm_extension_angle = 0,
    arm_lift_angle = 0,
    elbow_angle = 0
) {
    head = explode_head ? true : head;

    arm_explode_x = explode_arms ? 20 : 0;
    head_explode_y = explode_head ? 30 : 0;

    if (head) {
        translate([0, -neck_len - head_explode_y]) {
            rotate(180) head_assembly(
                frame_color = frame_color,
                armor_color = armor_color
            );
        }
        if (explode_head) {
            translate([0, -neck_len - head_explode_y/2 - 2]) {
                rotate(180) assembly_arrow();
            }
        }
    }
    torso_assembly(
        frame_color = frame_color,
        armor_color = armor_color,
        with_armor = with_armor,
        pelvis_armor = true,
        waist_armor = true,
        chest_armor = chest_armor,
        explode_chest_armor = explode_chest_armor
    );
    reflect([1, 0, 0]) {
        translate([-shoulder_width/2 - arm_explode_x, shoulder_height]) {
            rotate([0, 90 - arm_lift_angle, 90]) {
                arm_assembly(
                    frame_color = frame_color,
                    armor_color = armor_color,
                    with_armor = with_armor,
                    shoulder_armor = shoulder_armor,
                    explode_shoulder_armor = explode_shoulder_armor,
                    arm_upper_armor = true,
                    arm_lower_armor = true,
                    hand = true,
                    hand_armor = true,
                    arm_extension_angle = arm_extension_angle,
                    elbow_angle = elbow_angle
                );
            }
            if (explode_arms) {
                translate([arm_explode_x, 0]) {
                    rotate(90) assembly_arrow();
                }
            }
        }
    }
}
