include <../OpenSCAD-Utilities/common.scad>
include <globals.scad>
use <robot common.scad>
use <head.scad>
use <body.scad>
use <arms.scad>
use <legs.scad>
use <hands.scad>
use <feet.scad>

part = "";
part_for_print(part);

module part_for_print(part) {
    if (part == "head") head();
    else if (part == "lens") lens();
    else if (part == "antenna_left") antenna_left();
    else if (part == "antenna_right") mirror([1, 0, 0]) antenna_left();
    else if (part == "neck") neck();
    else if (part == "chest") rotate(180) chest();
    else if (part == "chest_armor") chest_armor();
    else if (part == "waist") rotate(180) waist();
    else if (part == "waist_armor") rotate(180) waist_armor();
    else if (part == "pelvis") pelvis();
    else if (part == "pelvis_armor") rotate(180) pelvis_armor();
    else if (part == "hip") hip();
    else if (part == "hip_armor") rotate([270, 0, 0]) hip_armor();
    else if (part == "arm_upper") rotate(180) arm_upper();
    else if (part == "arm_upper_armor_left") arm_upper_armor(true);
    else if (part == "arm_upper_armor_right") arm_upper_armor();
    else if (part == "arm_lower") rotate(180)arm_lower();
    else if (part == "arm_lower_armor_left") arm_lower_armor(true);
    else if (part == "arm_lower_armor_right") arm_lower_armor();
    else if (part == "leg_upper") leg_upper();
    else if (part == "leg_upper_armor_left") leg_upper_armor(true);
    else if (part == "leg_upper_armor_right") leg_upper_armor();
    else if (part == "leg_lower") rotate(180) leg_lower();
    else if (part == "leg_lower_armor_left") leg_lower_armor(true);
    else if (part == "leg_lower_armor_right") leg_lower_armor();
    else if (part == "foot") foot();
    else if (part == "shoulder") shoulder();
    else if (part == "shoulder_armor") rotate([270, 0, 0]) shoulder_armor();
    else if (part == "socket_with_snap_tabs") socket_with_snaps();
    else if (part == "hand_simple_right") mirror([1, 0, 0]) hand_simple_left();
    else if (part == "hand_simple_left") hand_simple_left();
    else if (part == "hand_simple_armor") hand_simple_armor();
    else if (part == "hand_grip_right") modify_hand_for_print() grip();
    else if (part == "hand_grip_left") mirror([1, 0, 0]) modify_hand_for_print() grip();
    else if (part == "hand_flat_right") modify_hand_for_print() flat();
    else if (part == "hand_flat_left") mirror([1, 0, 0]) modify_hand_for_print() flat();
    else if (part == "hand_relaxed_right") modify_hand_for_print() relaxed();
    else if (part == "hand_relaxed_left") mirror([1, 0, 0]) modify_hand_for_print() relaxed();
    else if (part == "hand_fist_right") modify_hand_for_print() fist();
    else if (part == "hand_fist_left") mirror([1, 0, 0]) modify_hand_for_print() fist();
    else if (part == "hand_love_right") modify_hand_for_print() love();
    else if (part == "hand_love_left") mirror([1, 0, 0]) modify_hand_for_print() love();
    else if (part == "hand_prosper_right") modify_hand_for_print() prosper();
    else if (part == "hand_prosper_left") mirror([1, 0, 0]) modify_hand_for_print() prosper();
    else if (part == "hand_peace_right") modify_hand_for_print() peace();
    else if (part == "hand_peace_left") mirror([1, 0, 0]) modify_hand_for_print() peace();
    else if (part == "hand_five_right") modify_hand_for_print() five();
    else if (part == "hand_five_left") mirror([1, 0, 0]) modify_hand_for_print() five();
    else if (part == "hand_open_grip_right") modify_hand_for_print() open_grip();
    else if (part == "hand_open_grip_left") mirror([1, 0, 0]) modify_hand_for_print() open_grip();
    else if (part == "hand_armor_right") hand_armor();
    else if (part == "hand_armor_left") mirror([1, 0, 0]) hand_armor();
}
