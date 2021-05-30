include <common/definitions.scad>
use <util.scad>


module vector(v, r=.5) {
  x = v[0];
  y = v[1];
  z = v[2];

  length = norm(v);
  theta = atan2(x, -y); // equator angle around z-up axis
  phi = acos( min( max(z / length, -1), 1) ); // polar angle

  rotate([0, 0, theta])
  rotate([phi, 0, 0]) {
    cylinder(r1=r, r2=r * .8, h=length * .95);
    translate([0, 0, length * .95])
      cylinder(r1=r * .8, r2=0, h=length * .05);
  }
}

module axes(length=30) {
  color("red") vector([1, 0, 0] * length);
  color("limegreen") vector([0, 1, 0] * length);
  color("royalblue") vector([0, 0, 1] * length);
}

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

module kailh_lowprofile_switch() {
  color("lightgray") translate([0, 0, 1.4]) cube([13.8, 13.8, 2.8], center=true);
  color("lightgray") translate([0, 6.9, 0.4]) cube([15.0, 1.2, 0.8], center=true);
  color("lightgray") translate([0, -6.9, 0.4]) cube([15.0, 1.2, 0.8], center=true);
  color("dimgray") translate([0, 0, -1.1]) cube([13.8, 13.8, 2.2], center=true);
  color("dimgray") translate([0, 0, -2.2]) rotate([180, 0, 0]) cylinder(d=3.4, h=2.65);
  color("yellow") translate([0, -5.9, -2.2]) rotate([180, 0, 0]) cylinder(d=1.2, h=2.65);
  color("yellow") translate([5, -3.8, -2.2]) rotate([180, 0, 0]) cylinder(d=1.2, h=2.65);
  color("brown")
  translate([0, 0, 2.5+1.5+.3])
  difference() {
    cube([12, 5.5, 3], center=true);
    if ($detail) {
      translate([-5.7/2, 0, 0]) cube([1.2, 3.0, 5], center=true);
      translate([5.7/2, 0, 0]) cube([1.2, 3.0, 5], center=true);
    }
  }
}

module keycap(w, h) {
  x = w / 2 * keycap_length;
  y = h / 2 * keycap_length;
  z = keycap_height;

  x2 = x - (keycap_length - keycap_inner_length) / 2.25;
  y2 = y - (keycap_length - keycap_inner_length) / 2.25;

  lower = [ [-x, -y], [ x, -y], [ x,  y], [-x,  y] ];
  upper = [ [-x2, -y2], [ x2, -y2], [ x2,  y2], [-x2,  y2] ];

  difference() {
    hull() {
      translate([0, 0, z])
      linear_extrude(height=.1)
        polygon(upper);
      translate([0, 0, z/3])
      linear_extrude(height=.1)
        polygon(lower);
      linear_extrude(height=.1)
        polygon(lower);
    }

    if ($detail) {
      translate([0, 0, -2])
      hull() {
        translate([0, 0, z])
        linear_extrude(height=.1)
          polygon(upper);
        translate([0, 0, z/3])
        linear_extrude(height=.1)
          polygon(lower);
        linear_extrude(height=.1)
          polygon(lower);
      }
    }
  }
}

module plate (w=1, h=1, w_offset=0, h_offset=0) {
  w = is_undef($u) ? w : $u;
  h = is_undef($h) ? h : $h;
  width = plate_width * w;
  height = plate_height * h;
  rib_offset = (rib_spacing - rib_thickness) / 2;

  translate([0, 0, -plate_thickness/2])
  difference () {
    cube([width, height, plate_thickness], center=true);
    translate([-plate_width * w_offset, 0, 0])
    scale([1, 1, 2]) cutout();

    mirror_quadrants()
      translate([rib_offset * w, height / 2, 0])
      scale(1.15)
      cube([
        rib_thickness,
        rib_thickness/2,
        plate_thickness
      ], center=true);
  }
}

module key_well (w=1, h=1) {
  width = plate_width * w;
  height = plate_height * h;
  rib_offset = (rib_spacing - rib_thickness) / 2;

  cube([width+.1, 15, 5], center=true);
  translate([0, 0, plate_thickness]) cube([width+.1, height - rib_thickness/2, plate_thickness * 4], center=true);
}

module cutout () {
  cube([keyhole_length, keyhole_length, plate_thickness], center=true);
}
