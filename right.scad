include <definitions.scad>
use <positioning.scad>
use <placeholders.scad>
use <structures.scad>

module key (w=1, h=1) {
  color("slategrey") plate(w, h);
  switch();

  // translate([0, 0, 4])
  // color("linen") keycap(w, h);
}

module main_layout() {
  // main keys
  place_keys([0:4], [0:3]) key();

  // bottom row (mostly)
  place_keys([2:5], [4]) key();

  // this key plate intersects the thumb cluster
  place_keys([1], [4]) key();

  // modifier key column
  place_keys([5], [0:3]) translate([plate_length/4, 0, 0]) key(w=1.5);

  // inner key column
  // this seems difficult to include with the thumb cluster.
  // place_keys([-1], [0]) key();
  // place_keys([-1], [1.25, 2.75]) key(h=1.5);
}

module thumb_layout() {
  // thumb cluster
  place_thumb_keys([2], [-1:1]) key();
  place_thumb_keys([1], [1]) key();
  place_thumb_keys([0, 1], [-0.5]) key(h=2);
}

module main_support_curve() {
  radius = main_column_radius / 4;
  offset = radius + column_rib_height + plate_thickness/2;
  translate([0, 0, -offset])
  rotate([0, 90, 0])
    cylinder(r=radius, h=rib_spacing+1, center=true, $fn=120);
}

module thumb_support_curve() {
  radius = thumb_column_radius / 4;
  offset = radius + column_rib_height + plate_thickness/2;
  translate([0, 0, -offset])
  rotate([0, 90, 0])
    cylinder(r=radius, h=4, center=true, $fn=120);
}

module main_supports() {
  // inner column
  difference() {
    place_column_ribs([0]) column_rib(1, 4, 40);
    place_keys([0], [0:3]) key_well();

    place_keys([0], 3.5) main_support_curve();
    place_keys([0], -.5) main_support_curve();

    translate([0, 0, -100]) cube(200, center=true);
  }

  // main columns
  difference() {
    place_column_ribs([1:4]) column_rib(0, 4);
    place_keys([1:4], [0:4]) key_well();
  }

  // outer column
  translate([plate_length / 4, 0, 0])
  difference() {
    place_column_ribs([5]) column_rib(1, 4, 40);

    place_keys([5], [0:3]) key_well();

    place_keys([5], 3.5) main_support_curve();
    place_keys([5], -.5) main_support_curve();

    translate([0, 0, -100]) cube(200, center=true);
  }

  // corner key
  difference() {
    place_column_ribs([5]) column_rib(0, 0);
    place_keys([5], [4]) key_well();
  }
}

module thumb_supports() {
  difference() {
    place_thumb_column_ribs([2]) thumb_column_rib(0, 2);
    place_thumb_keys([2], [-1:1]) key_well();
  }

  difference() {
    place_thumb_column_ribs([0]) thumb_column_rib(0, .5);
    place_thumb_keys([0], [-.5]) key_well(h=2);
  }

  difference() {
    place_thumb_column_ribs([1]) thumb_column_rib(0, 2, 70);
    place_thumb_keys([1], [1]) key_well();
    place_thumb_keys([1], [-.5]) key_well(h=2);

    translate([-70, -40, -80]) cube(160, center=true);

    place_thumb_column_ribs([1], [1.5]) thumb_support_curve();
  }
}

module cap() {
  translate([0, 0, -column_rib_height/2])
  cube([6, 5, column_rib_height + 4], center=true);
}

module back_end_caps() {
  row = -.6;
  outer_offset = [keyswitch_width * 1.5 / 2, 0, 0];

  for (i=columns) {
    hull() {
      place_column_rib_right([i], row) cap();
      place_column_rib_left([i+1], row) cap();
    }
  }

  for (i=[0:4]) hull() place_column_ribs([i], row) cap();

  hull() {
    place_column_rib_left([5], row) cap();
    place_column_rib_right([5], row) translate(outer_offset) cap();
  }
}

module back_thumb_end_caps() {
  row = 1.6;

  for (i=[1:2]) hull() place_thumb_column_ribs([i], row) cap();
  hull() {
    place_thumb_column_rib_right([2], row) cap();
    place_thumb_column_rib_left([1], row) cap();
  }
}

module front_end_caps() {
  row = 4.6;

  for (i=[1:4]) {
    hull() {
      place_column_rib_right([i], row) cap();
      place_column_rib_left([i+1], row) cap();
    }
  }

  for (i=[1:5]) hull() place_column_ribs([i], row) cap();
}

module front_join_left() {
  row = 4.6;
  hull() place_column_ribs([0], row - 1) cap();
}

module front_join_right() {
  row = 4.6;
  outer_offset = [keyswitch_width * 1.5 / 2, 0, 0];

  hull() {
    place_column_rib_left([5], row - 1.1) cap();
    place_column_rib_right([5], row - 1.1) translate(outer_offset) cap();
  }
}

module front_thumb_end_caps() {
  row = -1.6;

  for (i=[0:2]) hull() place_thumb_column_ribs([i], row) cap();
  for (i=[0:1]) {
    hull() {
      place_thumb_column_rib_right([i+1], row) cap();
      place_thumb_column_rib_left([i], row) cap();
    }
  }
}


main_layout();
thumb_layout();
color("burlywood") main_supports();
color("burlywood") thumb_supports();

color("brown") {
  back_end_caps();
  back_thumb_end_caps();
  front_end_caps();
  front_join_left();
  front_join_right();
  front_thumb_end_caps();
}
