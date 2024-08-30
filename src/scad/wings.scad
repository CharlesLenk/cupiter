include <openscad-utilities/common.scad>
include <globals.scad>
use <robot common.scad>

//socket_with_snaps();

//rounded_socket_blank();

wing_assembly();

module wing_assembly() {
    translate([0, 0, socket_d/2]) {
        translate([0, 0, 0.5])
        minkowski() {
        hull() {
        linear_extrude(0.001) armor_2d(socket_d + 2.4, segment_height + 2.4, 2, 8);
        //feather();
        translate([11, 0, 8])
        rotate([0, 270, 90]) linear_extrude(1.5) thingum(6, 160);
        }
        sphere(d = 1);
        }
        rotate([90, 270, 0]) feather();
        rotate([90, 240, 0]) feather();
        rotate([90, 290, 0]) feather();
    }
}

module thingum(segment_len, angle) {
    // adjacent = segment_len * cos(angle);
    // opposite = segment_len * sin(angle);


    start_angle = 90 - (angle - (90 - angle/2));
    a1 = 90 - angle/2;
    echo(a1);
    a2 = 3 * a1;
    echo(a2);
    a3 = 90 - a2;
    echo(a3);

    //echo(start_angle);
    polygon(
        [
            [0, 0],
            //[opposite(start_angle), adjacent(start_angle)],
            [opposite(a2), adjacent(a2)],
            [opposite(a2) + opposite(a1), adjacent(a2) + adjacent(a1)],
            [opposite(a2), adjacent(a2) + 2 * adjacent(a1)],
            [0, 2 * adjacent(a2) + 2 * adjacent(a1)],
            //[opposite(a1) + opposite(a2), adjacent(a1) + adjacent(a2)],
            //[opposite(a1), adjacent(a1)],
            //[10, 10],
            //[opposite(start_angle) + opposite(90 - angle/2), adjacent(start_angle) + adjacent(90 - angle/2)],
            // [opposite(2 * angle) + opposite(angle), adjacent(2 * angle) + adjacent(angle)],
            // [opposite(2 * angle), adjacent(2 * angle) + 2 * adjacent(angle)],
            // [0, 2 * adjacent(2 * angle) + 2 * adjacent(angle)],
        ]
    );

    function adjacent(angle) = segment_len * cos(angle);
    function opposite(angle) = segment_len * sin(angle);
}



module feather() {
    length = 40;
    width = 7;
    height = 1.5;

    hull() {
        linear_extrude(0.001) {
            feather_polygon(width, length);
        }
        translate([0, 0, -height/2]) {
            linear_extrude(1.5) {
                feather_polygon(width - height, length - height/2);
            }
        }
    }

    module feather_polygon(width, length) {
        polygon(
            [
                [0, width/2],
                [length - width/2, width/2],
                [length, 0],
                [length - width/2, -width/2],
                [0, -width/2],
            ]
        );
    }
}
