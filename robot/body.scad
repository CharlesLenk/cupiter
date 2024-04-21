include <../OpenSCAD-Utilities/common.scad>
include <globals.scad>
use <robot common.scad>
use <head.scad>
use <body.scad>
use <limbs.scad>
use <snaps.scad>

hip_width = 6 + 2 * ball_dist;
shoulder_width = 27.5;
shoulder_height = 7;
torso_len = 36 + shoulder_height;
hip_len = 13.1;
waist_len = socket_r + ball_dist + 1;
chest_len = torso_len - waist_len - hip_len;
shoulder_inner_width = shoulder_width - 2 * (ball_dist + socket_d/2);

torso_width_start = socket_d + 3;
torso_width_inc = 1.2;
torso_height_start = socket_d + 2.2;
torso_height_inc = 0.75;
waist_ball_overlap_adjust = 2.5;
waist_socket_gap = -0.2;

socket_snap_depth = 0.35;

waist_width_chest = torso_width_start + 2;
waist_width = torso_width_start + 2;
waist_width_pelvis = torso_width_start + 4;

//body_assembled();

function torso_len() = torso_len;
function hip_width() = hip_width;
function shoulder_width() = shoulder_width;
function shoulder_height() = shoulder_height;

module body_assembled(with_armor = true) {
    c1() chest();
    if (with_armor) c2() chest_armor_blank();
    translate([0, chest_len, 0]) {
        c1() waist();
        if (with_armor) c2() waist_armor_blank();
    }
    translate([0, chest_len + waist_len, 0]) {
        c1() pelvis();
        if (with_armor) c2() pelvis_armor_blank();
    }
}

module body_exploded() {
    chest();
    translate([0, 0, -10]) chest_armor();
    translate([0, 25]) {
        waist();
        translate([0, 0, -10]) waist_armor();
    }
    translate([0, 45]) {
        pelvis();
        translate([0, 0, -10]) pelvis_armor();
    }
}

module waist_ball_cut() {
    offset_amt = edge_d + 0.5;
    outer_width = torso_width_start - offset_amt;
    outer_height = torso_height_start - offset_amt;
    inner_width = outer_width - 4;
    inner_height = outer_height - 2;

    d = 2;
    translate([0, ball_dist - waist_ball_overlap_adjust, 0]) {
        hull () {
            translate([-inner_width/2, 0, -inner_height/2]) {
                rounded_cube([inner_width, d, inner_height], d);
            }
            translate([-outer_width/2, -1, -outer_height/2]) {
                rounded_cube([outer_width, d, outer_height], d);
            }
        }
    }
}

module chest(is_cut = false) {
    z = is_cut ? segment_cut_height : segment_height;
    socket_width = is_cut ? socket_d + 0.1 : socket_d;
    segment_width = is_cut ? segment_cut_width : segment_width;
    torso_upper_socket_gap = -0.05;
    torso_lower_socket_gap = -0.15;

    shoulder_upper_snap_len = 3.8;
    shoulder_lower_snap_len = 4.6;
    waist_snap_len = 6;

    difference() {
        union() {
            rounded_socket_blank(is_cut);
            translate([0, chest_len]) rotate([0, 180, 180]) rounded_socket_blank(is_cut, chest_len/2);
            translate([shoulder_inner_width/2, shoulder_height]) {
                rotate([0, 180, 90]) rounded_socket_blank(is_cut);
            }
            translate([-shoulder_inner_width/2, shoulder_height]) {
                rotate(-90) rounded_socket_blank(is_cut, shoulder_inner_width - socket_r);
            }
        }
        if (!is_cut) {
            place_ball_cuts() {
                socket_cut(ball_offset = torso_upper_socket_gap);
            }
        }
        difference() {
            translate([0, 0.5]) {
                armor_snap_inner_double(chest_len - 1, socket_d, socket_snap_depth, is_cut = !is_cut);
            }
            translate([0, shoulder_height]) {
                cube([shoulder_width, socket_d, z], center = true);
            }
        }
    }
    if (is_cut) {
        place_ball_cuts() {
            ball_for_armor_subtractions();
        }
    }

    module place_ball_cuts() {
        children();
        translate([shoulder_inner_width/2, shoulder_height]) rotate(90) children();
        translate([-shoulder_inner_width/2, shoulder_height]) rotate(270) children();
        translate([0, chest_len]) rotate(180) children();
    }
}

module chest_armor_blank() {
    height = torso_height_start - edge_d;

    shoulder_segment_width = shoulder_width - 2 * ball_dist;
    shoulder_width_offset = ball_dist - segment_height/2;
    inner_segment_width = shoulder_segment_width - 2 * shoulder_width_offset - edge_d;

    neck_segment_width = 8;

    minkowski() {
        difference() {
            hull() {
                translate([0, chest_len - edge_d/2]) {
                    armor_section(waist_width_chest - edge_d, 0.001, height);
                }
                translate([0, chest_len - edge_d/2 - 10]) {
                    armor_section(17.5 - edge_d, 0.001, height);
                }
                translate([0, shoulder_height + edge_d/2, 0]) {
                    rotate([0, 0, 90]) {
                        translate([0, -inner_segment_width/2, 0]) {
                            armor_section(12, inner_segment_width, height);
                        }
                    }
                }
                translate([0, shoulder_height + edge_d/2, 0]) {
                    rotate([0, 0, 90]) {
                        translate([0, -neck_segment_width/2, 0]) {
                            armor_section(14, neck_segment_width, height);
                        }
                    }
                }
            }
            reflect([1, 0, 0]) {
                translate([inner_segment_width/2, 0, -height/2]) {
                    rounded_cube([10, 12, height], d = 3, top_d = 0, bottom_d = 0);
                }
            }
        }
        sphere(d = edge_d);
    }
}

module waist(is_cut = false) {
    ball(is_cut, waist_len - ball_dist - socket_r);
    translate([0, waist_len]) {
        rotate(180) waist_socket(is_cut);
    }
}

module waist_socket(is_cut = false) {
    height = segment_height + (is_cut ? segment_cut_height_amt : 0);
    width = socket_d + (is_cut ? segment_cut_width_amt : 0);

    translate([0, -0.5 + socket_d/2]) {
        cross_brace(1, socket_d, is_cut);
    }
    difference() {
        apply_socket_cut(waist_socket_gap, is_cut = is_cut) {
            rounded_socket_blank(is_cut);
        }
        translate([0, 0.25]) {
            armor_snap_inner_double(
                length = 3.5,
                target_width = socket_d,
                depth = socket_snap_depth,
                is_cut = !is_cut
            );
        }
    }
}

module waist_armor_blank() {
    height = torso_height_start;
    length = waist_len - waist_ball_overlap_adjust - edge_d;

    difference() {
        translate([0, waist_ball_overlap_adjust]) {
            minkowski() {
                translate([0, edge_d/2]) {
                    hull() {
                        armor_section(
                            waist_width_chest - edge_d - 0.6,
                            0.1,
                            height - edge_d
                        );
                        translate([0, length/3]) {
                            armor_section(
                                waist_width - edge_d,
                                0.1,
                                height - edge_d
                            );
                        }
                    }
                    armor_section(
                        waist_width - edge_d,
                        2/3 * length,
                        height - edge_d
                    );
                    hull() {
                        translate([0, 2/3 * length]) {
                            armor_section(
                                waist_width - edge_d,
                                0.1,
                                height - edge_d
                            );
                            translate([0, length/3]) {
                                armor_section(
                                    waist_width_pelvis - edge_d - 1,
                                    0.1,
                                    height - edge_d
                                );
                            }
                        }
                    }
                }
                sphere(d = edge_d);
            }
        }
        waist_ball_cut();
    }
}

module pelvis(is_cut = false) {
    w = is_cut ? segment_cut_width : segment_width;
    h = is_cut ? segment_cut_height : segment_height;

    hip_ball_angle = 15;

    opposite = (ball_dist + segment_width/2) * sin(hip_ball_angle);
    mid_len = hip_len - segment_width/2 - socket_d/2 - opposite;

    difference() {
        ball(is_cut, mid_len);
        translate([0, ball_dist, 0]) {
            armor_snap_inner_double(mid_len - 0.2, segment_width, is_cut = !is_cut);
        }
    }
    translate([hip_width/2, hip_len]) {
        rotate(90 + hip_ball_angle) {
            ball(is_cut, segment_width/2);
        }
    }
    translate([-hip_width/2, hip_len]) {
        rotate( -90 - hip_ball_angle) {
            ball(is_cut, segment_width/2);
        }
    }

    translate([0, mid_len + ball_dist + segment_width/2]) {
        difference() {
            adjacent = (ball_dist + segment_width/2) * cos(hip_ball_angle);
            rounded_cube(
                [hip_width + segment_width - 2 * adjacent, w, h],
                d = w, top_d = 0, bottom_d = 0, center = true
            );
            rotate(90) {
                snap_width = hip_width - 2 * ball_dist - segment_width - 0.5;
                translate([0, -snap_width/2]) {
                    one_side_double_snap(snap_width, segment_width, is_cut = !is_cut);
                }
            }
        }
    }
}

module pelvis_armor_blank() {
    waist_width = torso_width_start + 3.5;
    waist_length = 6.5;

    length = 0.5 + segment_width/2 + hip_len - 1;

    lower_width = hip_width - 2 * ball_dist;
    mid_width = lower_width * 1.5;

    top_len = waist_length - waist_ball_overlap_adjust - edge_d;

    difference() {
        minkowski() {
            translate([0, edge_d/2 + waist_ball_overlap_adjust]) {
                hull() {
                    armor_section(
                        waist_width_pelvis - edge_d,
                        top_len/2,
                        torso_height_start - edge_d
                    );
                    translate([0, top_len - 0.7]) {
                        armor_section(
                            waist_width_pelvis + 1 - edge_d,
                            0.7,
                            torso_height_start - edge_d
                        );
                    }
                }
                hull() {
                    translate([0, top_len/2]) {
                        armor_section(
                            mid_width - edge_d + 3.5,
                            top_len/2,
                            torso_height_start - edge_d
                        );
                    }
                    armor_section(
                        mid_width - edge_d,
                        waist_length - waist_ball_overlap_adjust - edge_d + 1.2,
                        torso_height_start - edge_d
                    );
                }
                hull() {
                    armor_section(
                        mid_width - edge_d,
                        length - 4.5 - waist_ball_overlap_adjust - edge_d,
                        torso_height_start - edge_d
                    );
                    armor_section(
                        lower_width - edge_d,
                        length - waist_ball_overlap_adjust - edge_d,
                        torso_height_start - edge_d
                    );
                    armor_section(
                        lower_width - edge_d,
                        length - waist_ball_overlap_adjust - edge_d + 1.5,
                        torso_height_start - 4 - edge_d
                    );
                }
            }
            sphere(d = edge_d);
        }
        waist_ball_cut();
    }
}

module chest_armor() {
    apply_armor_cut() {
        chest_armor_blank();
        chest(true);
    }
}

module waist_armor() {
    apply_armor_cut() {
        waist_armor_blank();
        waist(true);
    }
}

module pelvis_armor() {
    apply_armor_cut() {
        pelvis_armor_blank();
        pelvis(true);
    }
}
