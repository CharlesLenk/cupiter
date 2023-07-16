include <../common.scad>
include <globals.scad>
use <robot common.scad>

foot_assembled();
translate([15, 0]) foot_exploded();

module foot_assembled() {
	rotate([90, 0, 0]) c2() foot();
	c1() socket_with_snaps();
}

module foot_exploded() {
	translate([0, 10]) rotate([90, 0, 0]) foot();
	socket_with_snaps();
}

module foot() {
	toe_lenth = 19;
	toe_width = 7;
	heal_len = 4;
	heal_width = 5;
	
	socket_bump_len = socket_d;
    foot_width = 11;
	
	bottom_d = 1;
    
	difference() {
		translate([0, -4.75, -8.5]) {
			hull() {
				translate([-toe_width/2, -4 + toe_lenth, 0]) {
					rounded_cube([toe_width, 4, 2], bottom_d, 4);
				}
				translate([-heal_width/2, -heal_len, 0]) {
					rounded_cube([heal_width, 4, 2], bottom_d, 4);
				}
				translate([-toe_width/2, 0, 0]) {
					rounded_cube([toe_width, socket_bump_len, 8], 2, 4);
				}
				translate([-foot_width/2, 0, 0]) {
					rounded_cube([foot_width, socket_bump_len, 2], bottom_d, 4);
				}
			}
			translate([0, 4.75, bottom_d/2]) {
				rounded_cylinder(d = socket_d + 1.2, h = 5, bottom_d = 3, top_d = 0.5);
			}
		}
		rotate([-90, 0, 0]) socket_with_snaps(true); 
	}
}
