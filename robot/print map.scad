include <robot imports.scad>

part = "";
part_for_print(part);

module part_for_print(part) { 
	if (part == "head") head();
	else if (part == "lens") lens();
	else if (part == "neck") neck();
	else if (part == "chest") rotate(180) chest();
	else if (part == "chest_armor") chest_armor();
	else if (part == "waist") rotate(180) waist();
	else if (part == "waist_armor") waist_armor();
	else if (part == "pelvis") pelvis();
	else if (part == "pelvis_armor") pelvis_armor();
	else if (part == "hip") hip();
	else if (part == "hip_armor") rotate([270, 0, 0]) hip_armor();
	else if (part == "arm_upper") rotate(180) arm_upper();
	else if (part == "arm_upper_armor_left") arm_upper_armor(true);
	else if (part == "arm_upper_armor_right") arm_upper_armor();
	else if (part == "arm_lower") rotate(180)arm_lower();
	else if (part == "arm_lower_armor_left") arm_lower_armor(true);
	else if (part == "arm_lower_armor_right") arm_lower_armor();
	else if (part == "hand_right") mirror([1, 0, 0]) hand_left();
	else if (part == "hand_left") hand_left();
	else if (part == "hand_armor") hand_armor();
	else if (part == "leg_upper") leg_upper();
	else if (part == "leg_upper_armor_left") leg_upper_armor(true);
	else if (part == "leg_upper_armor_right") leg_upper_armor();
	else if (part == "leg_lower") rotate(180) leg_lower();
	else if (part == "leg_lower_armor_left") leg_lower_armor(true);
	else if (part == "leg_lower_armor_right") leg_lower_armor();
	else if (part == "foot") foot();
	else if (part == "shoulder") shoulder();
	else if (part == "shoulder_armor") rotate([270, 0, 0]) shoulder_armor();
	else if (part == "head_and_foot_socket") head_and_foot_socket();
}
