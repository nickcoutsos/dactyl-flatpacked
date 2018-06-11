use <util.scad>

module thumbstick(expansion=1.0) {
  // color("white")
  translate([0, 0, 1.75])
  scale(expansion * [1,1,1]) {
    cube([11.96, 19.6, 3.5], center=true);
    cube([19.6, 11.96, 3.5], center=true);
  }

  translate([0, 0, 5.5])
  scale(expansion * [1,1,1]) {
    cube([16, 16, 11.1], center=true);
    cube([21.6, 9.6, 11], center=true);
    cube([9.6, 21.6, 11], center=true);
  }

  // color("white")
  translate([8+6.49/2, 0, 2])
  scale(expansion * [1,1,1])
  cube([6.49, 10.82, 4], center=true);
}

module thumbstick_cap() {
  translate([0, 0, 11]) cylinder(d=10, h=5);
  translate([0, 0, 16]) cylinder(d=20, h=2);
  difference() {
    sphere(r=14);
    translate([0, 0, -5]) cube([30, 30, 20], center=true);
  }
  // translate([0, 0, 6]) color("red") cylinder(d=27, h=1);

  translate([0, 0, 18])
  scale([1, 1, .3])
  difference() {
    sphere(d=20);

    translate([0, 0, -10])
    cube(20, center=true);
  }
}

module thumbstick_footprint(expansion=1.0) {
  linear_extrude(height=5)
  projection()
  thumbstick(expansion);
}

module thumbstick_pins(expansion=1.0) {
  mirror_quadrants()
  translate([-13.41/2, 15.05/2, 0])
    circle(d=1.0 * expansion);

  translate([0, 9.36]) {
    circle(d=1.0 * expansion);
    translate([-2.54, 0]) circle(d=1.0 * expansion);
    translate([2.54, 0]) circle(d=1.0 * expansion);
  }

  translate([-9.6, 0]) {
    circle(d=1.0 * expansion);
    translate([0, -2.54]) circle(d=1.0 * expansion);
    translate([0, 2.54]) circle(d=1.0 * expansion);
  }

  translate([10.6, 0])
  mirror_quadrants()
  translate([-4.8/2, 6.29/2])
    circle(d=1.0 * expansion);
}

module thumbstick_placeholder() {
  linear_extrude(height=4.25)
  union() {
    circle(d=29, h=1);

    translate([8+6.49/2, 0])
    scale([1.4, 1.2, 1])
    square([6.49, 10.82], center=true);
  }
}

module thumbstick_socket() {
  difference() {
    thumbstick_placeholder();

    translate([0, 0, 1])
    thumbstick_footprint(1.07);

    linear_extrude(height=5, center=true)
    thumbstick_pins(expansion=2.5);
  }
}

module thumbstick_full() {
  thumbstick();

  color("lightgray")
  translate([0, 0, -4])
  linear_extrude(height=4)
  thumbstick_pins();

  translate([0, 0, 5.5])
  rotate([0, 30, 0])
  thumbstick_cap();
}

thumbstick_socket($fn=24);
