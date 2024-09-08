include <openscad-utilities/common.scad>
include <globals.scad>
use <robot common.scad>
use <snaps.scad>

//socket_with_snaps();

//rounded_socket_blank();

wing_assembly();

// base();
// translate([10, 0]) socket_with_snaps();
// translate([25, 0]) feather(15);

feather_count = 5;
feather_width = 4;
feather_socket_width = feather_width + 2;
feather_depth = 2.5;
feather_angle = 20;
feather_pos = [0, 15, 4.5];

fangle2 = 20;

//blade_antenna(30);

module blade_antenna(l, is_cut = false, holes = 0) {
    w = 8;
    base_wa = 3.5;
    bot_notcha = 2;
    edge_margin = 0;
    top_w = 2;

    translate([0, 0, feather_socket_width/2])
    rotate([-90, 0, 90])
    union() {
        if (!is_cut) {
            translate([0, -base_wa/2, -feather_depth/2 + edge_d/2]) {
                difference() {
                    minkowski() {
                        linear_extrude(feather_depth - edge_d) {
                            offset(delta = -edge_d/2) {
                                blade_2d(l, base_wa, bot_notcha, top_w, holes);
                            }
                        }
                        sphere(d = 1);
                    }
                    translate([-base_wa, 0, -base_wa/2]) {
                        cube([base_wa, base_wa, 2 * base_wa]);
                    }
                }
            }
        }
        translate([-0.5, 0]) {
            union() {
                translate([0, -base_wa/2, -feather_depth/2]) {
                    cube([0.5, base_wa, feather_depth]);
                }
                rotate(90) snaps_tabs(base_wa, 3, feather_depth, is_cut = is_cut, snap_tab_width = 1.2);
            }
        }
    }
}

module blade_2d(l, base_w, bot_notch, top_w, holes = 0) {
    hole_dist = 4;
    translate([-base_w, 0]) {
        square([base_w, base_w]);
    }
    difference() {
        hull() {
            translate([top_w, -top_w]) {
                square([l - 2 * top_w, top_w]);
            }
            square([l, base_w]);
            translate([2.5 * bot_notch, base_w]) {
                square([l - 2.5 * bot_notch, bot_notch]);
            }
        }
        for (i = [0 : holes]) {
            translate([i * hole_dist + 3.5, (base_w + bot_notch + top_w)/2 - top_w]) {
                circle(d = 2);
            }
        }
        r = (base_w + bot_notch)/2;
        translate([r + holes * hole_dist + 6.5, base_w + bot_notch]) {
            hull() {
                circle(r = r);
                translate([l, 0]) {
                    circle(r = r);
                }
            }
        }
    }
}

module ttt(l) {
    translate([0, 0, feather_socket_width/2]) {
        rotate([90, 90, 90]) {
tuning(l);
        }
    }

}

module tuning(l) {
    d = 1;
    w = 5;
    rotate([270, 0, 0])
    linear_extrude(l/3)
    rounded_square_2([w, 2.5], 1, 1, 1, 1, center = true);

    reflect([1, 0, 0])
    translate([-d/2 - w/2, l/2, 0])
    rotate([270, 0, 0])
    linear_extrude(l/3)
    rounded_square_2([w, 2.5], 1, 1, 1, 1, center = true);

    translate([0, l/2, -1.25])
    rotate(180)
    rotate_extrude(angle = 180)
    translate([d/2, 0]) rounded_square_2([w, 2.5], 1, 1, 1, 1);
}

module place_feathers(count, angle, h, i = 0) {
    //rotate([-angle, 0, 0])
    if (i < count) {
        rotate([i > 0 ? angle : 0, 0, 0]) {
            translate([0, 0, i > 0 ? h : 0]) {
                rotate([angle, 0, 0]) {
                    children();
                }
                place_feathers(count, angle, h, i + 1) {
                    children();
                }
            }
        }
    }
}

// place_feather_at_index(feather_angle, feather_width, 0, 3) {
//     translate([0, 0, feather_width/2]) rotate([90, 0, 90]) feather(40);
// }

module place_feather_at_index(angle, h, placement_index, i = 0) {
    if (i <= placement_index) {
        rotate([i > 0 ? angle : 0, 0, 0]) {
            translate([0, 0, i > 0 ? h : 0]) {
                if (i == placement_index) {
                    rotate([angle, 0, 0]) {
                        children();
                    }
                }
                place_feather_at_index(angle, h, placement_index, i + 1) {
                    children();
                }
            }
        }
    }
}

            //  rotate([90, 0, 0]) linear_extrude(0.001) rounded_square_2([3, feather_width], 1, 1, 1, 1);
            // //cube([3, 0.001, feather_width]);

module wing_base() {
    difference() {
        translate([0, 0, 0]) {
            minkowski() {
                hull() {
                    derpth = feather_depth + 0.5;
                    translate([-derpth/2, 0, 0] + feather_pos) {
                        rotate([fangle2, 0, 0])
                        place_feathers(feather_count, feather_angle, feather_socket_width) {
                            rotate([90, 0, 0]) linear_extrude(0.001) rounded_square_2([derpth, feather_socket_width], derpth/2, derpth/2, derpth/2, derpth/2);
                            //cube([derpth, 0.001, feather_width]);
                        }
                    }
                    x = segment_height + 2.4 - edge_d;
                    y = socket_d + 2.4 - edge_d;
                    linear_extrude(socket_d/2) rounded_square_2([x, y], 2, 2, 2, 2, center = true);
                    translate([0, 0, socket_d/2]) rotate([0, 90, 0]) cylinder(h = x, d = socket_d/2, center = true);
                    translate([0, 9]) cylinder(h = 0.001, d = 0.001);
                }
                sphere(d = edge_d);
            }
        }
        rotate([90, 0, 90]) socket_with_snaps(is_cut = true);
        rotate([0, 90, 0]) cylinder(d = 4.5, h = 20, center = true);
        translate(feather_pos) {
            rotate([fangle2, 0, 0]) {
                for (i = [0 : feather_count - 1]) {
                    place_feather_at_index(feather_angle, feather_socket_width, i) {
                        translate([0, edge_d/2]) blade_antenna(15 + 4 * i, is_cut = true);
                    }
                }
            }
        }
        translate([0, -50]) cube([100, 100, 100]);
    }
}

module wing_assembly() {
    color(armor_color) wing_base();
    translate(feather_pos) {
        rotate([fangle2, 0, 0]) {
            for (i = [0 : feather_count - 1]) {
                place_feather_at_index(feather_angle, feather_socket_width, i) {
                    translate([0, edge_d/2]) color(frame_color)  {
                        blade_antenna(20 + 4 * i, holes = i);//feather(22 + 4 * i);
                    }
                }
            }
        }
    }
    rotate([90, 0, 90]) {
        color(frame_color) socket_with_snaps();
    }
}
