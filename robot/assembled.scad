include <../common.scad>
include <globals.scad>
use <head.scad>
use <body.scad>
use <arms.scad>
use <legs.scad>

assembled(
	with_armor = true, 
	neck_angle_test = false,
	simple_hands = false
//	elbow_angle = elbow_max_angle(),
//	knee_angle = knee_max_angle(),
//	shoulder_angle = 24
);

module assembled(
	with_armor = true,
	elbow_angle = 0,
	hip_angle = 0,
	knee_angle = 0,
	shoulder_angle = 0,
	neck_angle_test = false,
	simple_hands = false,
	armature_color = "#464646", 
	armor_color = "#DDDDDD"
) {
	head_assembled(neck_angle_test ? 16 : 0);
	translate([0, head_height()]) {
		body_assembled(with_armor);
		reflect([1, 0, 0]) {
			translate([-shoulder_width()/2, shoulder_height()]) {
				arm_assembled(
					with_armor = with_armor,
					elbow_angle = elbow_angle,
					shrug_angle = shoulder_angle,
					arm_extension_angle = 4,
					simple_hands = simple_hands
				);
			}
			translate([-hip_width()/2, torso_len()]) {
				rotate([-hip_angle, 0, 0]) {
					leg_assembled(with_armor, knee_angle);
				}
			}
		}
	}
}
