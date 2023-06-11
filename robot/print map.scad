include <robot imports.scad>

part = "";
part_for_print(part);

module part_for_print(part) { 
	if (part == "head") head();
	else if (part == "lens") lens();
	else if (part == "neck") neck();
	else if (part == "torso") rotate(180) torso();
	else if (part == "torso_armor") torso_armor();
	else if (part == "waist") rotate(180) waist();
	else if (part == "waist_armor") waist_armor();
	else if (part == "hips") hips();
	else if (part == "hips_armor") hips_armor();
	else if (part == "hip") hip();
	else if (part == "hip_armor") rotate([270, 0, 0]) hip_armor();
	else if (part == "arm_upper") rotate(180) arm_upper();
	else if (part == "arm_upper_armor_top") arm_upper_armor(true);
	else if (part == "arm_upper_armor_bottom") arm_upper_armor();
	else if (part == "arm_lower") rotate(180)arm_lower();
	else if (part == "arm_lower_armor_top") arm_lower_armor(true);
	else if (part == "arm_lower_armor_bottom") arm_lower_armor();
	else if (part == "hand_right") mirror([1, 0, 0]) hand_left();
	else if (part == "hand_left") hand_left();
	else if (part == "hand_armor") hand_armor();
	else if (part == "leg_upper") leg_upper();
	else if (part == "leg_upper_armor_top") leg_upper_armor(true);
	else if (part == "leg_upper_armor_bottom") leg_upper_armor();
	else if (part == "leg_lower") rotate(180) leg_lower();
	else if (part == "leg_lower_armor_top") leg_lower_armor(true);
	else if (part == "leg_lower_armor_bottom") leg_lower_armor();
	else if (part == "foot") foot();
	else if (part == "shoulder") shoulder();
	else if (part == "shoulder_armor") rotate([270, 0, 0]) shoulder_armor();
	else if (part == "head_and_foot_socket") head_and_foot_socket();
}
