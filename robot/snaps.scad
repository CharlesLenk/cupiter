include <../OpenSCAD-Utilities/common.scad>
include <globals.scad>

snap_angle = 100;
default_snap_depth = 0.3;

module snap_bump(
    length,
    target_width,
    depth = default_snap_depth,
    is_cut = false,
    width_cut_adjust = 0
) {
    depth_cut_adjust = is_cut ? 0.15 : 0;
    width_cut_adjust = is_cut ? width_cut_adjust : 0;

    translate([depth - target_width/2 + depth_cut_adjust, -width_cut_adjust/2]) {
        rotate([0, 90, 90]) {
            wedge(snap_angle, depth + depth_cut_adjust + 0.1, length + width_cut_adjust);
        }
    }
}

module armor_snap_inner_double(
    length,
    target_width,
    depth = default_snap_depth,
    is_cut = false
) {
    reflect([1, 0, 0]) {
        one_side_double_snap(
            length = length,
            target_width = target_width,
            depth = depth,
            is_cut = is_cut
        );
    }
}

module one_side_double_snap(
    length,
    target_width,
    depth = default_snap_depth,
    is_cut = false
) {
    snap_triangle_height = (depth + segment_cut_width_offset/2);
    dist_between_edges = 0.5;
    z_dist = snap_triangle_height / tan(90 - snap_angle/2) + dist_between_edges;

    translate([0, length]) {
        rotate(180) {
            translate([0, 0, z_dist]) snap_bump(length, target_width, depth, is_cut);
            translate([0, 0, -z_dist]) snap_bump(length, target_width, depth, is_cut);
        }
    }
}

module armor_snap_inner(
    length,
    target_width,
    depth = default_snap_depth,
    is_cut = false,
    width_cut_adjust = 0
) {
    snap_bump(length, target_width, depth, is_cut, width_cut_adjust);
    translate([0, length]) rotate(180) snap_bump(length, target_width, depth, is_cut, width_cut_adjust);
}

module armor_snap_outer(
    length,
    target_width,
    depth = default_snap_depth,
    is_cut = false
) {
    cut_adjust = is_cut ? 0.1 : 0;

    snap_bump();
    translate([0, length]) rotate(180) snap_bump();

    module snap_bump() {
        translate([depth + target_width/2 + cut_adjust, 0]) {
            rotate([0, 90, 90]) {
                wedge(snap_angle, depth + cut_adjust, length);
            }
        }
    }
}
