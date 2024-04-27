include <../OpenSCAD-Utilities/common.scad>
include <globals.scad>
use <head.scad>
use <body.scad>
use <arms.scad>
use <legs.scad>

assembled(
    with_armor = true,
    //elbow_angle = elbow_max_angle(),
    //knee_angle = knee_max_angle(),
    //neck_angle = neck_max_angle(),
    simple_hands = false
);

module assembled(
    with_armor = true,
    elbow_angle = 0,
    hip_angle = 0,
    knee_angle = 0,
    shoulder_angle = 0,
    neck_angle = 0,
    simple_hands = false
) {
    head_assembled(neck_angle);
    translate([0, 0]) {
        body_assembled(with_armor);
        reflect([1, 0, 0]) {
            translate([-shoulder_width()/2, shoulder_height()]) {
                arm_assembled(
                    with_armor = with_armor,
                    elbow_angle = elbow_angle,
                    shrug_angle = shoulder_angle,
                    arm_extension_angle = 7,
                    simple_hands = simple_hands
                );
            }
            translate([-hip_width()/2, torso_len()]) {
                rotate([hip_angle, 0, 0]) {
                    leg_assembled(with_armor, knee_angle);
                }
            }
        }
    }
}
