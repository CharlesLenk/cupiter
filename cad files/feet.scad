include <../OpenSCAD-Utilities/common.scad>
include <globals.scad>
use <robot common.scad>

module foot_assembly(
    frame_color = frame_color,
    armor_color = armor_color,
    foot_socket = true,
    foot = true,
    explode_foot = false
) {
    foot = explode_foot ? true : foot;

    explode_y = 22;
    foot_explode_y = explode_foot ? explode_y : 0;

    if(foot_socket) {
        translate([0, 0]) {
            color(frame_color) socket_with_snaps();
            if (foot) {
                translate([0, foot_explode_y]) {
                    rotate([90, 0, 0]) color(armor_color) foot();
                }
                if(explode_foot) {
                    translate([0, foot_explode_y/2 + 4]) {
                        rotate(180) assembly_arrow();
                    }
                }
            }
        }
    }
}

module foot() {
    foot_width = 12;
    heal_len = 3.5;
    foot_mid_len = 8;
    toe_width = 6;
    toe_lenth = 18 + heal_len;
    arbitrary_block_height = 10;
    foot_pad_height = 1.7;

    difference() {
        translate([0, -heal_len - foot_mid_len/2, -8.2]) {
            minkowski() {
                intersection() {
                    translate([0, 0, foot_pad_height - edge_d/2]) foot_form();
                    z_cut();
                }
                sphere(d = edge_d);
            }
        }
        rotate([-90, 0, 0]) socket_with_snaps(true);
        cube([foot_width, segment_cut_height, 7], center = true);
    }

    module foot_form() {
        d = 7;
        foot_mid_height = 6;

        hull() {
            translate([0, 0, -arbitrary_block_height/2]) {
                armor_section(toe_width, toe_lenth, arbitrary_block_height, d, d);
            }
            translate([0, heal_len + foot_mid_len/2, 1]) {
                rotate([90, 0, 0]) armor_section(foot_width - edge_d, 2, foot_mid_len, d, d);
            }
            translate([0, heal_len, -arbitrary_block_height/2]) {
                armor_section(8.5, foot_mid_len, arbitrary_block_height + 2 * foot_mid_height, d, d);
            }
        }
    }


    module z_cut() {
        linear_extrude(arbitrary_block_height) {
            hull() {
                translate([-foot_width/2, heal_len]) {
                    rounded_square([foot_width, foot_mid_len], 5);
                }
                translate([-toe_width/2, 0]) {
                    rounded_square([toe_width, toe_lenth], 5);
                }
            }
        }
    }
}
