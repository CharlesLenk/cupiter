include <openscad-utilities/common.scad>
include <globals.scad>
use <robot common.scad>
use <body.scad>
use <limbs.scad>
use <snaps.scad>

hip_len = 13.1;
waist_len = socket_r + ball_dist + 1;
chest_len = torso_len - waist_len - hip_len;
shoulder_inner_width = shoulder_width - 2 * (ball_dist + socket_d/2);
chest_armor_inner_width = shoulder_inner_width + 0.9 * ball_d;

torso_width_start = socket_d + 3;
torso_height_start = socket_d + 2.2;
waist_ball_overlap_adjust = 2.5;

socket_snap_depth = 0.35;

waist_width_chest = torso_width_start + 3;
waist_width = torso_width_start + 2;
waist_width_pelvis = torso_width_start + 4;

wing_clip_wall_width = 1.6;
wing_ball_extension = 0.5;
wing_ball_angle = 25;

wing_clip_x = (torso_height_start - segment_cut_height)/2;
wing_clip_y = chest_armor_inner_width;

clip_base = 0.4;
wing_clip_tab_width = 1 + clip_base;

wing_clip_ball_hypot = wing_ball_extension + ball_dist;

wing_clip_ball_x = wing_clip_x + wing_clip_tab_width
    + get_adjacent(wing_ball_angle, wing_clip_ball_hypot)
        + get_opposite_soh(wing_ball_angle, segment_width/2);
wing_clip_ball_y = wing_clip_y/2
    + get_opposite_soh(wing_ball_angle, wing_clip_ball_hypot)
        - get_adjacent(wing_ball_angle, segment_width/2);

function torso_len() = torso_len;
function hip_width() = hip_width;
function shoulder_width() = shoulder_width;
function shoulder_height() = shoulder_height;

wing_clip();
chest_armor_with_wing_clip();

module torso_assembly(
    frame_color = frame_color,
    armor_color = armor_color,
    with_armor = true,
    explode_frame = false,
    chest_armor = false,
    explode_chest_armor = false,
    waist_armor = false,
    explode_waist_armor = false,
    pelvis_armor = false,
    explode_pelvis_armor = false,
    wing_clip = false
) {
    chest_armor = with_armor && (explode_chest_armor ? true : chest_armor);
    waist_armor = with_armor && (explode_waist_armor ? true : waist_armor);
    pelvis_armor = with_armor && (explode_pelvis_armor ? true : pelvis_armor);

    explode_z = 30;
    explode_y = 20;

    frame_explode_y = explode_frame ? explode_y : 0;
    chest_armor_explode_z = explode_chest_armor ? explode_z : 0;
    waist_armor_explode_z = explode_waist_armor ? explode_z : 0;
    pelvis_armor_explode_z = explode_pelvis_armor ? explode_z : 0;

    translate([0, -neck_len - frame_explode_y]) {
        color(frame_color) neck();
        translate([0, -frame_explode_y]) rotate(180) color(frame_color) socket_with_snaps();
        if (explode_frame) {
            translate([0, -frame_explode_y/2, 0]) assembly_arrow();
        }
    }
    if (explode_frame) {
        translate([0, -frame_explode_y/2, 0]) {
            assembly_arrow();
        }
    }
    color(frame_color) chest();
    if (chest_armor) {
        translate([0, 0, -chest_armor_explode_z]) {
            if (wing_clip) {
                chest_armor_with_wing_clip_assembly();
            } else {
                color(armor_color) chest_armor();
            }
        }
        translate([0, 0, chest_armor_explode_z]) {
            rotate([0, 180, 0]) {
                color(armor_color) chest_armor();
            }
        }
        reflect([0, 0, 1]) {
            if (explode_chest_armor) {
                translate([0, chest_len/2, -chest_armor_explode_z/2 - 2]) {
                    rotate([270, 0, 45]) assembly_arrow();
                }
            }
        }
    }
    translate([0, chest_len + frame_explode_y, 0]) {
        color(frame_color) waist();
        if (explode_frame) {
            translate([0, -frame_explode_y/2, 0]) {
                assembly_arrow();
            }
        }
        if (waist_armor) {
            reflect([0, 0, 1]) {
                translate([0, 0, -waist_armor_explode_z]) color(armor_color) waist_armor();
                if (explode_waist_armor) {
                    translate([0, waist_len/2, -waist_armor_explode_z/2 - 2]) {
                        rotate([270, 0, 45]) assembly_arrow();
                    }
                }
            }
        }
    }
    translate([0, chest_len + waist_len + 2 * frame_explode_y, 0]) {
        color(frame_color) pelvis();
        if (explode_frame) {
            translate([0, -frame_explode_y/2, 0]) {
                assembly_arrow();
            }
        }
        if (pelvis_armor) {
            reflect([0, 0, 1]) {
                translate([0, 0, -pelvis_armor_explode_z]) color(armor_color) pelvis_armor();
                if (explode_pelvis_armor) {
                    translate([0, hip_len/2, -pelvis_armor_explode_z/2 - 2]) {
                        rotate([270, 0, 45]) assembly_arrow();
                    }
                }
            }
        }
    }
}

module chest_armor_with_wing_clip_assembly(
    explode = false
) {
    explode_dist = explode ? -15 : 0;

    color(armor_color)
        chest_armor_with_wing_clip();
    color(frame_color)
        translate([0, shoulder_height, -segment_cut_height/2 - explode_dist])
            rotate([0, 90, 270])
                wing_clip();
    translate([0, shoulder_height, -explode_dist/4])
        rotate([90, 0, 0])
            if (explode)
                assembly_arrow();
}

module chest_armor_with_wing_clip() {
    difference() {
        chest_armor();
        translate([0, shoulder_height, -segment_cut_height/2 + 0.001])
            rotate([0, 90, 270])
                wing_clip(true);
    }
}

module wing_clip(is_cut = false) {
    h = is_cut ? segment_cut_height : segment_height;
    width_cut_adjust = is_cut ? segment_cut_width_offset : 0;
    seg_width = segment_width + width_cut_adjust;

    wing_clip_tab_depth = 1.2;

    reflect([0, 1, 0])
        translate([wing_clip_ball_x, wing_clip_ball_y])
            rotate(90 + wing_ball_angle) ball(is_cut);

    difference() {
        translate([0, 0, -h/2])
            linear_extrude(h)
                clip_2d();
        if (!is_cut)
            reflect([0, 1, 0])
                translate([-segment_height/2, shoulder_inner_width/2])
                    sphere(d = ball_d + 0.4);
    }

    module clip_2d() {
        reflect([0, 1, 0])
            translate([wing_clip_x, -wing_clip_y/2 + segment_width])
                polygon(
                    [
                        [0, 0],
                        [0, wing_clip_tab_depth],
                        [clip_base, wing_clip_tab_depth],
                        [wing_clip_tab_width, 0],
                    ]
                );

        difference() {
            translate([0, -wing_clip_y/2 -width_cut_adjust/2]) {
                square([wing_clip_x + wing_clip_tab_width, wing_clip_y + width_cut_adjust]);
            }
            translate([1.2, -wing_clip_y/2 + segment_width + width_cut_adjust/2]) {
                rounded_square_2([
                    2 * wing_clip_x,
                    wing_clip_y - 2 * segment_width - width_cut_adjust
                ], 1, 0, 0, 1);
            }
        }
        reflect([0, 1, 0]) {
            translate([wing_clip_x + wing_clip_tab_width, wing_clip_y/2 + width_cut_adjust/2]) {
                rotate(270) {
                    pie_wedge(seg_width, wing_ball_angle);
                    rotate(wing_ball_angle) square([seg_width, wing_ball_extension + 0.001]);
                }
            }
        }
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
    upper_socket_opening_angle = 130;

    torso_lower_socket_gap = -0.15;

    shoulder_upper_snap_len = 3.8;
    shoulder_lower_snap_len = 4.6;
    waist_snap_len = 6;

    difference() {
        union() {
            rounded_socket_blank(is_cut);
            translate([0, chest_len]) rotate([0, 180, 180]) rounded_socket_blank(is_cut, is_cut ? socket_d/2 + 1 : socket_d/2);

            translate([0, 0]) {
                limb_segment(chest_len, is_cut = is_cut);
            }

            translate([shoulder_inner_width/2, shoulder_height]) {
                rotate([0, 180, 90]) rounded_socket_blank(is_cut);
            }
            translate([-shoulder_inner_width/2, shoulder_height]) {
                rotate(-90) rounded_socket_blank(is_cut, shoulder_inner_width - socket_r);
            }
        }
        if (!is_cut) {
            socket_cut(ball_offset = upper_chest_tolerance, cut_angle = upper_socket_opening_angle);
            translate([shoulder_inner_width/2, shoulder_height]) {
                rotate(90) socket_cut(ball_offset = upper_chest_tolerance, cut_angle = upper_socket_opening_angle);
            }
            translate([-shoulder_inner_width/2, shoulder_height]) {
                rotate(270) socket_cut(ball_offset = upper_chest_tolerance, cut_angle = upper_socket_opening_angle);
            }
            translate([0, chest_len]) rotate(180) socket_cut(ball_offset = torso_lower_socket_gap);
        }
        difference() {
            translate([0, 0.5]) {
                armor_snap_inner_double(shoulder_height, socket_d, socket_snap_depth, is_cut = !is_cut);
            }
            translate([0, shoulder_height]) {
                cube([shoulder_width, socket_d, z], center = true);
            }
        }
        translate([0, chest_len - socket_d/2 + 1]) {
            armor_snap_inner_double(socket_d/2 - 1, socket_d, socket_snap_depth, is_cut = !is_cut);
        }
        reflect([1, 0, 0]) {
            translate([-1.5, shoulder_height]) {
                rotate(90) one_side_double_snap(3, socket_d, socket_snap_depth, is_cut = !is_cut);
            }
        }
    }
    if (is_cut) {
        ball_for_armor_subtractions();
        translate([shoulder_inner_width/2, shoulder_height]) ball_for_armor_subtractions();
        translate([-shoulder_inner_width/2, shoulder_height]) ball_for_armor_subtractions();
        translate([0, chest_len]) ball_for_armor_subtractions();
    }
}

module chest_armor_blank() {
    height = torso_height_start - edge_d;

    inner_segment_width = chest_armor_inner_width - edge_d;

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
                            armor_section(13, inner_segment_width, height, round_len = height/2 - 1, right_d = 16);
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
    height = segment_height + (is_cut ? segment_cut_height_offset : 0);
    width = socket_d + (is_cut ? segment_cut_width_offset : 0);

    translate([0, -0.5 + socket_d/2]) {
        cross_brace(1, socket_d, is_cut);
    }
    difference() {
        apply_socket_cut(waist_tolerance, is_cut = is_cut) {
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
                            waist_width_chest - edge_d - 0.5,
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
                    translate([0, 1/3 * length]) {
                        armor_section(
                            waist_width - edge_d,
                            1/3 * length,
                            height - edge_d
                        );
                    }
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

    hip_ball_angle = 10;

    opposite = (ball_dist + segment_width/2) * sin(hip_ball_angle);
    mid_len = hip_len - ball_dist - segment_width/2 - opposite;

    difference() {
        ball(is_cut, mid_len);
        translate([0, ball_dist]) {
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

    translate([0, hip_len - opposite]) {
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

    length = segment_width/2 + hip_len - 0.2;

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
                        length - 4 - waist_ball_overlap_adjust - edge_d,
                        torso_height_start - edge_d
                    );
                    armor_section(
                        lower_width - edge_d,
                        length - waist_ball_overlap_adjust - edge_d,
                        torso_height_start - edge_d
                    );

                    w = lower_width;
                    translate([0, -w + length + waist_ball_overlap_adjust - edge_d]) {
                        rotate(90) {
                            armor_section(
                                lower_width - edge_d,
                                lower_width/2,
                                torso_height_start - edge_d,
                                center = true
                            );
                        }
                    }
                }
            }
            sphere(d = edge_d);
        }
        waist_ball_cut();
    }
}

module neck() {
    xy_cut(ball_cut_height, size = 2 * ball_d + neck_len) {
        sphere(d = ball_d);
        translate([0, neck_len]) sphere(d = ball_d);
        rotate([-90, 0, 0]) cylinder(d = 3.5, h = neck_len);
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
