include <definitions.scad>
use <stick.scad>
use <positioning.scad>
use <supports.scad>
use <util.scad>
use <connectors.scad>
use <nocaps.scad>

$fn = 64;

HINGE_ANGLE = 40;
HINGE_OFFSET = [0, 0, -22];
HINGE_COLUMN = 1.5;
HINGE_ROW = -2.15;
HINGE_DIAMETER = 32;

module attachment_position() {
  thumb_place(HINGE_COLUMN, HINGE_ROW)
  translate(HINGE_OFFSET)
  rotate([HINGE_ANGLE, 0, 0])
    children();
}

module thumb_slot_position(col) {
  thumb_place(1, -1.5)
  translate([0, 0, -column_rib_height])
  rotate_down(thumb_place_transformation(1, -1.5))
  translate([0, 0, thumb_column_radius])
  rotate([0, beta * (col - 1), 0])
  // translate([offset, 0, 0])
  translate([0, 0, -thumb_column_radius])
  translate([0, 0, 2])
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

    thumb_slot_position(1.5)
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
  offset = [-62.5, -84.5, 0];
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

      translate(offset + [0, 0, 5])
      rotate([0, 0, 13])
      difference() {
        cylinder(d=20, h=rib_thickness);
        translate([-10, 0, -10]) cube(20);
      }

      translate(offset + [0, 0, 5])
      rotate([0, 0, 13])
      translate([0, -10, 0])
      rotate([20, 0, 0])
      translate([0, 10, 2])
      difference() {
        cylinder(d=20, h=rib_thickness);
        translate([-10, 0, -10]) cube(20);
      }

      attachment_position()
      rotate([35, 0, 0])
      intersection() {
        cylinder(d=HINGE_DIAMETER, h=rib_thickness);
        
        rotate([0, 0, 180])
        translate([-HINGE_DIAMETER/2-.5, 0, -2])
        cube([HINGE_DIAMETER+1, 25, 7]);
      }

      attachment_position()
      rotate([20, 0, 0])
      intersection() {
        cylinder(d=HINGE_DIAMETER, h=rib_thickness);
        
        rotate([0, 0, 180])
        translate([-HINGE_DIAMETER/2-.5, 0, -2])
        cube([HINGE_DIAMETER+1, 25, 7]);
      }

      attachment_position()
      intersection() {
        cylinder(d=HINGE_DIAMETER, h=rib_thickness);
        
        rotate([0, 0, 180])
        translate([-HINGE_DIAMETER/2-.5, 0, -2])
        cube([HINGE_DIAMETER+1, 25, 7]);
      }
    }

    attachment_position()
    // rotate([0, 0, 180])
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

      translate(offset + [0, 0, 5])
      rotate([0, 0, 13])
      translate([0, 1, -1])
      intersection() {
        cylinder(d=18-thickness, h=rib_thickness);
        translate([0, -9, 0])
        cube(18, center=true);
      }

      translate(offset + [0, 0, 5])
      rotate([0, 0, 13])
      translate([0, -10, 0])
      rotate([20, 0, 0])
      translate([0, 11, 2])
      difference() {
        cylinder(d=18-thickness, h=rib_thickness);
        translate([-10, 0, -10]) cube(20);
      }

      attachment_position()
      rotate([35, 0, 0])
      translate([0, 2, 1])
      intersection() {
        cylinder(d=HINGE_DIAMETER - thickness, h=rib_thickness);
        translate([0, -13, 0])
        cube(HINGE_DIAMETER - 4, center=true);
      }

      attachment_position()
      rotate([20, 0, 0])
      translate([0, 2, 1])
      intersection() {
        cylinder(d=HINGE_DIAMETER - thickness, h=rib_thickness);
        translate([0, -13, 0])
        cube(HINGE_DIAMETER - 4, center=true);
      }

      attachment_position()
      translate([0, 2, 1])
      intersection() {
        cylinder(d=HINGE_DIAMETER - thickness, h=rib_thickness);
        translate([0, -13, 0])
        cube(HINGE_DIAMETER - 4, center=true);
      }
    }

    attachment_position()
    translate([-HINGE_DIAMETER/2-.5, 0, 0])
    cube([HINGE_DIAMETER+1, 25, 7]);
  }
}

color("mediumseagreen")
difference() {
  front();

  thumb_front_cross_support();
  connectors();

  attachment_position()
  rotate([0, 0, 90])
    thumbstick_placeholder();
}

// hooks
color("tomato")
difference() {
  union() {
    thumbstick_attachment();
    thumb_slot_position(1) hook();
    thumb_slot_position(1.5) hook();
    thumb_slot_position(2) hook();
  }

  attachment_position() {
    rotate([0, 0, 90]) scale([1, 1, 1.5]) thumbstick_placeholder();
    rotate([0, 0, 90]) translate([0, 0, -4]) scale([1, 1, 2]) thumbstick_footprint();
    rotate([0, 0, 180]) translate([-HINGE_DIAMETER/2-.5, 0, -2]) cube([HINGE_DIAMETER+1, 25, 7]);
  }

  thumb_front_cross_support();
}

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

attachment_position()
rotate([0, 0, 90]) {
  color("skyblue") thumbstick_socket();
  color("mediumpurple") thumbstick_full();
}
