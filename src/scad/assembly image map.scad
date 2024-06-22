include <globals.scad>
use <camera head.scad>
use <space head.scad>
use <arms.scad>
use <hands.scad>
use <body.scad>
use <legs.scad>
use <assembly.scad>

part = "";
part_for_print(part);

module part_for_print(part) {
    if (part == "arm_frame_exploded") arm_assembly(explode_frame = true);
    if (part == "arm_frame") arm_assembly();
    if (part == "arm_upper_armor") arm_assembly(explode_arm_upper_armor = true);
    if (part == "arm_lower_armor") arm_assembly(arm_upper_armor = true, explode_arm_lower_armor = true);
    if (part == "hand") arm_assembly(arm_upper_armor = true, arm_lower_armor = true, explode_hand = true);
    if (part == "hand_armor") arm_assembly(arm_upper_armor = true, arm_lower_armor = true, hand = true, explode_hand_armor = true);
    if (part == "arm_assembled") arm_assembly(arm_upper_armor = true, arm_lower_armor = true, hand = true, hand_armor = true);

    if (part == "torso_frame_exploded") torso_assembly(explode_frame = true);
    if (part == "torso_frame") torso_assembly();
    if (part == "pelvis_armor") torso_assembly(explode_pelvis_armor = true);
    if (part == "waist_armor") torso_assembly(pelvis_armor = true, explode_waist_armor = true);
    if (part == "torso_assembled") torso_assembly(pelvis_armor = true, waist_armor = true);

    if (part == "upper_body_arms_exploded") upper_body_assembly(explode_arms = true);
    if (part == "upper_body_arms") upper_body_assembly();
    if (part == "upper_body_chest_armor") upper_body_assembly(explode_chest_armor = true);
    if (part == "upper_body_shoulder_armor") upper_body_assembly(chest_armor = true, explode_shoulder_armor = true);
    if (part == "upper_body_assembled") upper_body_assembly(chest_armor = true, shoulder_armor = true);

    if (part == "leg_frame_exploded") leg_assembly(explode_frame = true);
    if (part == "leg_frame") leg_assembly();
    if (part == "leg_upper_armor") leg_assembly(explode_leg_upper_armor = true);
    if (part == "leg_lower_armor") leg_assembly(leg_upper_armor = true, explode_leg_lower_armor = true);
    if (part == "foot_socket") leg_assembly(leg_upper_armor = true, leg_lower_armor = true, explode_foot_socket = true);
    if (part == "foot") leg_assembly(leg_upper_armor = true, leg_lower_armor = true, foot_socket = true, explode_foot = true);
    if (part == "leg_assembled") leg_assembly(leg_upper_armor = true, leg_lower_armor = true, foot_socket = true, foot = true);

    if (part == "body_legs_exploded") body_assembly(explode_legs = true);
    if (part == "body_legs_assembled") body_assembly();
    if (part == "body_hip_armor") body_assembly(explode_hip_armor = true);
    if (part == "body_assembled") body_assembly(hip_armor = true);
    if (part == "body_arms_lowered") body_assembly(hip_armor = true, arm_retract_angle = 80);

    if (part == "camera_head_exploded") camera_head_assembly(explode = true);
    if (part == "camera_head_assembled") camera_head_assembly();
    if (part == "body_camera_head_exploded") body_assembly(explode_head = true, hip_armor = true, arm_retract_angle = 80);
    if (part == "body_camera_head_assembled") assembly(arm_retract_angle = 80);

    if (part == "socket_assembly_note") socket_assembly_note();
    if (part == "shoulder_note") shoulder_note();

    if (part == "alternate_hands") color(frame_color) posed_hands();

    if (part == "space_head_exploded") space_head_assembly(explode = true);
    if (part == "space_head_assembled") space_head_assembly();
    if (part == "body_space_head_exploded") body_assembly(space_head = true, explode_head = true, hip_armor = true, arm_retract_angle = 80);
    if (part == "body_space_head_assembled") assembly(space_head = true, arm_retract_angle = 80);
}
