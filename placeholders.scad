include <definitions.scad>

module switch () {
  rotate([0, 0, 45]) cylinder(d1=19.77, d2=14.5, $fn=4, h=5.2);
  translate([0, 0, -2.2]) rotate([0, 0, 45]) cylinder(d=19.77, $fn=4, h=2.2);
  translate([0, 0, -2.2 - 3.1]) rotate([0, 0, 45]) cylinder(d1=18, d2=19.77, $fn=4, h=3.1);
  
  for(angle=[45:90:315]) {
    rotate([0, 0, angle])
    translate([19.77/2-.75, 0, .4])
    rotate([0, 0, 45])
      cube([2, 2, .8], center=true);
  }
}

module keycap(w, h) {
  x = w / 2 * keycap_length;
  y = h / 2 * keycap_length;
  z = keycap_height;

  x2 = x - (keycap_length - keycap_inner_length) / 2;
  y2 = y - (keycap_length - keycap_inner_length) / 2;

  lower = [ [-x, -y], [ x, -y], [ x,  y], [-x,  y] ];
  upper = [ [-x2, -y2], [ x2, -y2], [ x2,  y2], [-x2,  y2] ];

  hull() {
    translate([0, 0, z])
    linear_extrude(height=.1)
      polygon(upper);
    linear_extrude(height=.1)
      polygon(lower);
  }
}

module plate (w=1, h=1) {
  translate([0, 0, -plate_thickness/2])
  difference () {
    cube([plate_length * w, plate_length * h, plate_thickness], center=true);
    scale([1, 1, 2]) cutout();
  }
}

module cutout () {
  cube([14.4, 14.4, plate_thickness], center=true);
  translate([-6.8, -6.8, 0]) cylinder(r=0.4, h=plate_thickness, $fn=12, center=true);
  translate([ 6.8, -6.8, 0]) cylinder(r=0.4, h=plate_thickness, $fn=12, center=true);
  translate([ 6.8,  6.8, 0]) cylinder(r=0.4, h=plate_thickness, $fn=12, center=true);
  translate([-6.8,  6.8, 0]) cylinder(r=0.4, h=plate_thickness, $fn=12, center=true);

  translate([-7, -3.75, 0]) cube([1.6, 3.5, plate_thickness], center=true);
  translate([ 7, -3.75, 0]) cube([1.6, 3.5, plate_thickness], center=true);
  translate([ 7,  3.75, 0]) cube([1.6, 3.5, plate_thickness], center=true);
  translate([-7,  3.75, 0]) cube([1.6, 3.5, plate_thickness], center=true);
}
