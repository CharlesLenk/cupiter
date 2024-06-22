antenna_depth = 1.35;

function antenna_depth() = antenna_depth;

antenna_left();

module antenna_left(is_cut = false, antenna_angle = 0, antenna_depth = antenna_depth) {
    base_d = 5;
    peg_h = 3;

    translate([0, 0, -antenna_depth]) {
        if (is_cut) {
            rotate(45 - antenna_angle) {
                translate([0, 0, antenna_depth]) {
                    linear_extrude(peg_h + 0.15) {
                        offset(0.01) {
                            peg_polygon();
                        }
                    }
                }
            }
            translate([0, 0, antenna_depth]) cylinder(d = base_d + 0.1, h = 1);
        } else {
            rotate(45 - antenna_angle) {
                translate([0, 0, antenna_depth]) {
                    linear_extrude(peg_h) {
                        peg_polygon();
                    }
                }
            }
            translate([0, 0, antenna_depth]) cylinder(d = 5, h = 1);
            x = 1.6;
            y1 = 5;
            y2 = y1 + 6;
            gap = 0.3;
            cylinder(d1 = base_d - 1.5, d2 = base_d, h = antenna_depth);
            linear_extrude(antenna_depth) {
                polygon(
                    [
                        [x/2, 0],
                        [x/2, y1],
                        [x + gap, y1 + x/2],
                        [x + gap, y2],
                        [gap, y2],
                        [gap, y1 + x],
                        [-gap, y1 + x],
                        [-gap, y2],
                        [-x - gap, y2],
                        [-x - gap, y1 + x/2],
                        [-x/2, y1],
                        [-x/2, 0],
                    ]
                );
            }
        }
    }

    module peg_polygon() {
        peg_xy = 2.5;
        chamfer = 1;
        polygon(
            [
                [peg_xy/2, peg_xy/2],
                [peg_xy/2, -peg_xy/2],
                [-peg_xy/2 + chamfer, -peg_xy/2],
                [-peg_xy/2, -peg_xy/2 + chamfer],
                [-peg_xy/2, peg_xy/2]
            ]
        );
    }
}