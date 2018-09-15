include <definitions.scad>
use <stick.scad>
use <positioning.scad>
use <supports.scad>
use <util.scad>
use <connectors.scad>
use <nocaps.scad>

use <scad-utils/transformations.scad>
use <scad-utils/linalg.scad>

$fn = 24;

HINGE_ANGLE = 40;
HINGE_OFFSET = [0, 0, -30];
HINGE_COLUMN = 0.8;
HINGE_ROW = -1.8;
HINGE_DIAMETER = 32;

// thumb_place(-.25, -1.9)
//   translate([0, 0, -28])

module attachment_position() {
  thumb_place(HINGE_COLUMN, HINGE_ROW)
  translate(HINGE_OFFSET)
  // rotate([HINGE_ANGLE, 0, 0])
  // rotate([0, -60, 0])
  rotate([0, -90, 0])
  rotate([30, 0, 0])
  rotate([0, 0, 90])
    children();
}

// module thumb_slot_position(col) {
//   thumb_place(1, -1.5)
//   translate([0, 0, -column_rib_height])
//   rotate_down(thumb_place_transformation(1, -1.5))
//   translate([0, 0, thumb_column_radius])
//   rotate([0, beta * (col - 1), 0])
//   // translate([offset, 0, 0])
//   translate([0, 0, -thumb_column_radius])
//   translate([0, 0, 2])
//     children();
// }

function place_thumb_slot(col) = (
  thumb_place_transformation(1, -1.5)
  * translation([0, 0, -column_rib_height])
  * rotation_down(thumb_place_transformation(1, -1.5))
  * translation([0, 0, thumb_column_radius])
  * rotation([0, beta * (col - 1), 0])
  * translation([0, 0, -thumb_column_radius])
  * translation([0, 0, 2])
);

module thumb_slot_position(col) {
  multmatrix(place_thumb_slot(col))
    children();
}


module hook() {
  translate([0, 0, 2])
  difference() {
    cube([4, rib_thickness*3, 6], center=true);
    // translate([0, 0, -3])
    // cube([4.1, rib_thickness, 6], center=true);
  }
}

module thumbstick_attachment() {
  hull() {
    // color("red") thumb_slot_position(1.5) translate([0, -rib_thickness*1.5, 0]) cube([4, 1, 10], center=true);

    thumb_slot_position(0)
    translate([0, -rib_thickness*1.5, 2.3])
    cube([24.5, 1, 6], center=true);

    attachment_position()
    rotate([0, 0, 90])
    translate([0, 0, .1])
    scale([1, 1, .5])
    thumbstick_placeholder();

    attachment_position()
    translate([0, 0, -.5])
    cylinder(d=HINGE_DIAMETER, h=rib_thickness+.5);

    attachment_position()
    rotate([0, 0, 90])
    translate([15.5, 0, 2.5])
    cube([1, 13, 5], center=true);
  }
}

module front() {
  offset = [-29.84, -74.99, 0];
  thickness = 7;

  difference() {
    hull_pairs() {
      translate(offset)
      rotate([0, 0, 13])
      intersection() {
        cylinder(d=20, h=rib_thickness);
        translate([0, -10, 0])
        cube(20, center=true);
      }

      // translate(offset + [0, 0, 5])
      // rotate([0, 0, 13])
      // difference() {
      //   cylinder(d=20, h=rib_thickness);
      //   translate([-10, 0, -10]) cube(20);
      // }

      // translate(offset + [0, 0, 5])
      // rotate([0, 0, 13])
      // translate([0, -10, 0])
      // rotate([20, 0, 0])
      // translate([0, 10, 2])
      // difference() {
      //   cylinder(d=20, h=rib_thickness);
      //   translate([-10, 0, -10]) cube(20);
      // }

      attachment_position()
      rotate([0, 0, -45])
      rotate([35, 0, 0])
      intersection() {
        cylinder(d=HINGE_DIAMETER, h=rib_thickness);
        
        rotate([0, 0, 180])
        translate([-HINGE_DIAMETER/2-.5, 0, -2])
        cube([HINGE_DIAMETER+1, 25, 7]);
      }

      attachment_position()
      rotate([0, 0, -45])
      rotate([20, 0, 0])
      intersection() {
        cylinder(d=HINGE_DIAMETER, h=rib_thickness);
        
        rotate([0, 0, 180])
        translate([-HINGE_DIAMETER/2-.5, 0, -2])
        cube([HINGE_DIAMETER+1, 25, 7]);
      }

      attachment_position()
      rotate([0, 0, -45])
      intersection() {
        cylinder(d=HINGE_DIAMETER, h=rib_thickness);
        
        rotate([0, 0, 180])
        translate([-HINGE_DIAMETER/2-.5, 0, -2])
        cube([HINGE_DIAMETER+1, 25, 7]);
      }
    }

    attachment_position()
    // rotate([0, 0, 180])
    rotate([0, 0, -45])
    translate([-HINGE_DIAMETER/2-.5, 0, -.5])
    cube([HINGE_DIAMETER+1, 25, rib_thickness + 1]);

    hull_pairs() {
      translate(offset)
      rotate([0, 0, 13])
      translate([0, 1, -1])
      intersection() {
        cylinder(d=18-thickness, h=rib_thickness);
        translate([0, -10, 5])
        cube(20, center=true);
      }

      // translate(offset + [0, 0, 5])
      // rotate([0, 0, 13])
      // translate([0, 1, -1])
      // intersection() {
      //   cylinder(d=18-thickness, h=rib_thickness);
      //   translate([0, -9, 0])
      //   cube(18, center=true);
      // }

      // translate(offset + [0, 0, 5])
      // rotate([0, 0, 13])
      // translate([0, -10, 0])
      // rotate([20, 0, 0])
      // translate([0, 11, 2])
      // difference() {
      //   cylinder(d=18-thickness, h=rib_thickness);
      //   translate([-10, 0, -10]) cube(20);
      // }

      attachment_position()
      rotate([0, 0, -45])
      rotate([35, 0, 0])
      translate([0, 2, 1])
      intersection() {
        cylinder(d=HINGE_DIAMETER - thickness, h=rib_thickness);
        translate([0, -13, 0])
        cube(HINGE_DIAMETER - 4, center=true);
      }

      attachment_position()
      rotate([0, 0, -45])
      rotate([20, 0, 0])
      translate([0, 2, 1])
      intersection() {
        cylinder(d=HINGE_DIAMETER - thickness, h=rib_thickness);
        translate([0, -13, 0])
        cube(HINGE_DIAMETER - 4, center=true);
      }

      attachment_position()
      rotate([0, 0, -45])
      translate([0, 2, 1])
      intersection() {
        cylinder(d=HINGE_DIAMETER - thickness, h=rib_thickness);
        translate([0, -13, 0])
        cube(HINGE_DIAMETER - 4, center=true);
      }
    }

    attachment_position()
    rotate([0, 0, -45])
    translate([-HINGE_DIAMETER/2-.5, 0, 0])
    cube([HINGE_DIAMETER+1, 25, 7]);
  }
}

// color("mediumseagreen")
// difference() {
//   front();

//   thumb_front_cross_support();
//   connectors();

//   attachment_position()
//   rotate([0, 0, 90])
//     thumbstick_placeholder();
// }

// // hooks
// color("tomato")
// difference() {
//   union() {
//     thumbstick_attachment();
//     thumb_slot_position(0) hook();
//     thumb_slot_position(0.5) hook();
//     thumb_slot_position(-.5) hook();
//   }

//   attachment_position() {
//     rotate([0, 0, 90]) scale([1, 1, 1.5]) thumbstick_placeholder();
//     rotate([0, 0, 90]) translate([0, 0, -10]) scale([1, 1, 5]) thumbstick_footprint();
//     rotate([0, 0, 180 - 45]) translate([-HINGE_DIAMETER/2-.5, 0, -6]) cube([HINGE_DIAMETER+1, 25, 11]);
//   }

//   thumb_front_cross_support();
// }

  // main_layout();
  // thumb_layout();


  // main_supports();
  // main_inner_column_cross_support();
  // main_front_cross_support();
  // main_back_cross_support();

  // thumb_supports();
  // thumb_inner_column_cross_support();
  // thumb_front_cross_support();
  // thumb_back_cross_support();

// attachment_position()
// // rotate([0, 0, 90])
// {
//   color("skyblue") thumbstick_socket();
//   // color("mediumpurple") thumbstick_full();
// }


module clips() {
  hull_pairs() {
    // thumb_slot_position(2.1) translate([0, 0, -3]) cube([1, 6, 3], center=true);
    // thumb_slot_position(2.0) translate([0, 0, -3]) cube([1, 6, 3], center=true);
    // thumb_slot_position(1.5) translate([0, 0, -3]) cube([1, 6, 3], center=true);
    thumb_slot_position(1.0) translate([0, 0, -3.5]) cube([1, 6, 4], center=true);
    thumb_slot_position(0.5) translate([0, 0, -3.5]) cube([1, 6, 4], center=true);
    thumb_slot_position(0.0) translate([0, 0, -3.5]) cube([1, 6, 4], center=true);
    thumb_slot_position(-0.2) translate([0, 0, -3.5]) cube([1, 6, 4], center=true);
  }

  translate([0, 0, 3])
  linear_extrude(height=5)
  projection()
  hull_pairs() {
    // thumb_slot_position(2.1) translate([0, 0, -3]) cube([1, 6, 3], center=true);
    // thumb_slot_position(2.0) translate([0, 0, -3]) cube([1, 6, 3], center=true);
    // thumb_slot_position(1.5) translate([0, 0, -3]) cube([1, 6, 3], center=true);
    thumb_slot_position(1.0) translate([0, 0, -3]) cube([1, 6, 3], center=true);
    thumb_slot_position(0.5) translate([0, 0, -3]) cube([1, 6, 3], center=true);
    thumb_slot_position(0.0) translate([0, 0, -3]) cube([1, 6, 3], center=true);
    thumb_slot_position(-0.2) translate([0, 0, -3]) cube([1, 6, 3], center=true);
  }
}

column_stops = [-0.2, 1.0];
offset_stops = [[0, -rib_thickness, -13], [0, -rib_thickness, -15.25]];
diameter_stops = [22, 26];
scale_stops = [[1, 1, 1], [1, 1.85, 1]];
rotation_stops = [[0, 0, 0], [0, 0, 35]];

function lerp (stops, t) = t * (stops[1] - stops[0]) + stops[0];

module rib (t, $columns=column_stops, $offsets=offset_stops, $diameters=diameter_stops, $scales=scale_stops, $rotations=rotation_stops) {
  column = lerp($columns, t);
  offset = lerp($offsets, t);
  diameter = lerp($diameters, t);
  scaling = lerp($scales, t);
  angle = lerp($rotations, t);

  thumb_slot_position(column)
  rotate_down_x(place_thumb_slot(column))
  translate(offset)
  rotate(angle)
  scale(scaling)
  rotate([0, 90, 0])
  difference() {
    cylinder(d=diameter, h=.01, center=true);
    translate([-diameter/2, 0, -1])
      cube(diameter);
  }
}


module shell() {
  inner_diameters = [15.0, 19.3];
  inner_scales = [ scale_stops[0], scale_stops[1] + [0, .2, 0]];
  inner_offsets = [
    offset_stops[0] + [0.1, .1, 0],
    offset_stops[1] + [-.6, 0, 0]
  ];

  difference() {
    hull_pairs() {
      rib(0);
      rib(.25);
      rib(.50);
      rib(.75);
      rib(1.0);

      attachment_position()
      difference() {
        cylinder(d=33, h=5, center=true);
        translate([19, 0, 0]) cube(34, center=true);
      }
    }

    hull_pairs() {
      rib(0, $diameters=inner_diameters, $offsets=inner_offsets, $scales=inner_scales);
      rib(.25, $diameters=inner_diameters, $offsets=inner_offsets, $scales=inner_scales);
      rib(.50, $diameters=inner_diameters, $offsets=inner_offsets, $scales=inner_scales);
      rib(.75, $diameters=inner_diameters, $offsets=inner_offsets, $scales=inner_scales);
      rib(1.0, $diameters=inner_diameters, $offsets=inner_offsets, $scales=inner_scales);

      attachment_position() {
        cylinder(d=26, h=5.1, center=true);
        // translate([12, 0, .1]) cube([26, 22, 5], center=true);
      }
    }

    attachment_position() thumbstick_placeholder();
  }
}

difference() {
  union() {
    color("tomato") shell();
    color("orange") clips();

    color("seagreen")
    hull() {
      translate([0, 0, 3])
      linear_extrude(height=5)
      projection()
      thumb_slot_position(0.95)
      translate([0, 0, -3.5])
        cube([3.1, 6, 4], center=true);

      attachment_position() {
        // translate([0, 0, -.5])
        difference() {
          cylinder(d=32, h=1, center=true);
          cylinder(d=30, h=1.1, center=true);

          rotate([0, 0, -65]) translate([0, -16, -1]) cube([16, 32, 2]);
          rotate([0, 0, (90+75)]) translate([0, -16, -1]) cube([16, 32, 2]);
        }
      }
    }

    color("seagreen")
    hull() {
      thumb_slot_position(0.9)
      translate([0, 0, -3.5])
        cube([5.5, 6, 4], center=true);

      attachment_position() {
        difference() {
          cylinder(d=33, h=2.5);
          translate([0, 0, -4]) cylinder(d=30, h=8);

          rotate([0, 0, 65]) translate([0, -18, -1]) cube([18, 33, 4]);
          rotate([0, 0, -(90+63)]) translate([0, -18, -1]) cube([18, 33, 4]);
        }
      }
    }

    attachment_position()
    translate([0, 0, .1])
      cylinder(d=33, h=2.5);
  }

  // attachment_position() translate([0, -15, 0]) cube(30);
  // attachment_position() thumbstick_placeholder();
  //   attachment_position()
  //   // rotate([0, 0, -17])
  //   translate([12, 0, .1])
  //   cube([12, 13, 13], center=true);

  attachment_position() {
    thumbstick_placeholder();
    translate([15, 0, 0]) cube(10, center=true);
  }
  thumb_supports();
  // thumb_front_cross_support();
  connectors();

  hull_pairs() {
    thumb_slot_position(1.2) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(1.0) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(0.8) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(0.6) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(0.4) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(0.2) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(0.0) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(-0.2) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(-0.4) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
  }

  translate([0, 0, 3])
  linear_extrude(height=rib_thickness+.3)
  projection()
  hull_pairs() {
    thumb_slot_position(1.4) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(1.2) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(1.0) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(0.8) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(0.6) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(0.4) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(0.2) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(0.0) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(-0.2) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
    thumb_slot_position(-0.4) translate([0, 0, -rib_thickness/2 - .45]) cube([.1, rib_thickness+.3, rib_thickness+.4], center=true);
  }

  thumb_slot_position(-0.20)
  rotate_down_x(place_thumb_slot(-0.20))
  translate([5, 0, -10])
  cube([10, 40, 40], center=true);
}


offset = rib_spacing/2 - rib_thickness/2;

// attachment_position() thumbstick_placeholder();

// union() {
//   place_thumb_column_ribs([0]) thumb_column_rib(0, 2);
//   for (side=[-offset, offset]) {
//     thumb_support_front(0, side);
//     thumb_support_back(0, side);
//   }
// }
// place_thumb_column_ribs([0], -1) cube(rib_thickness, center=true);
