use <util.scad>
include <definitions.scad>

$fn = 24;

HEADER_PITCH = 27.71/11;
CLEARANCE = 0.15;

module pro_micro() {
  color("green")
  linear_extrude(height=1.6)
  square([33, 18], center=true);


  color("silver")
  for(i=[0:11]) {
    translate([-16.5 + (i + .5) * HEADER_PITCH, -7.75, -1])
    cube([.9 + CLEARANCE, .9 + CLEARANCE, 10], center=true);

    translate([-16.5 + (i + .5) * HEADER_PITCH, 7.75, -1])
    cube([.9 + CLEARANCE, .9 + CLEARANCE, 10], center=true);
  }

  color("black") {
    translate([-HEADER_PITCH/2, -7.75, -1.25])
    cube([30, 2.5, 2.5], center=true);

    translate([-HEADER_PITCH/2, 7.75, -1.25])
    cube([30, 2.5, 2.5], center=true);
  }
}

module trrs_breakout() {
  color("red")
  // linear_extrude(height=1.7 + CLEARANCE)
  // square([11 + CLEARANCE, 12 + CLEARANCE], center=true);
  translate([0, 0, 1.6/2 + CLEARANCE])
  cube([11.5 + CLEARANCE, 12 + CLEARANCE, 1.8 + CLEARANCE], center=true);

  color("gray")
  translate([0, 0, 1.6])
  linear_extrude(height=5 + CLEARANCE)
  square([6 + CLEARANCE, 12 + CLEARANCE], center=true);

  color("gray")
  translate([0, 6, 1.6+2.5])
  rotate([-90, 0, 0])
  cylinder(d=5 + CLEARANCE, h=1.77 + CLEARANCE);
}

module usb_jack() {
  color("silver") {
    linear_extrude(height=10.92)
    square([12.4 + CLEARANCE, 16.40 + CLEARANCE], center=true);
    translate([0, 8, 5.5])
    cube([11, 5, 10], center=true);
  }
}

module button() {
  linear_extrude(height=3.4)
  square(6.16, center=true);

  translate([0, 0, 3.4])
  cylinder(d=3.5, h=1.58);

  mirror_quadrants()
  translate([-2.6, 3, 0])
  cube([1 + CLEARANCE, 2 + CLEARANCE, 3], center=true);
}

module back() {
  // linear_extrude(height=rib_thickness)
  // square([30, 37], center=true);

  translate([0, 0, rib_thickness/2])
  cube([30, 37, rib_thickness], center=true);

  translate([1.25, -8, rib_thickness])
  {
    translate([-HEADER_PITCH/2, -7.75, 1.25])
    cube([34, 4, 2.5], center=true);

    translate([-HEADER_PITCH/2, 7.75, 1.25])
    cube([34, 4, 2.5], center=true);
  }
}

difference() {
  back();

  translate([-11, 11, 2])
  button();

  translate([0, 10, 7])
  rotate([0, 0, 90])
  rotate([-90, 0, 0])
  trrs_breakout();

  translate([1.25, -8, rib_thickness * 3])
  rotate([0, 0, 0])
  pro_micro();

  translate([8, 5, 10])
  rotate([-90, 0, 0])
  usb_jack();
}

// back_matrix = thumb_place_transformation(1, -1.5);
// back_invert = inverted_thumb_place_transformation(1, -1.5);
// back_undown = rotation_down(back_matrix, invert=true);


// rotate([-90, 0, 0])
// multmatrix(back_undown)
// multmatrix(back_invert)
// thumb_back_cross_support();
