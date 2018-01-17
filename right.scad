include <definitions.scad>
use <positioning.scad>
use <placeholders.scad>
use <structures.scad>

module key (w=1, h=1) {
  plate(w, h);
  // switch();

  // translate([0, 0, plate_thickness+3])
  // keycap(w, h);
}

module main_layout() {
  // main keys
  each_key() key();

  // last little key
  place_keys([5], [4]) key();

  // modifier key column
  place_keys([5.25], [0:3]) key(w=1.5);

  // inner key column
  // this seems difficult to include with the thumb cluster.
  // place_keys([-1], [0]) key();
  // place_keys([-1], [1.25, 2.75]) key(h=1.5);
}

module thumb_layout() {
  // thumb cluster
  place_thumb_keys([2], [-1:1]) key();
  place_thumb_keys([1], [1]) key();
  place_thumb_keys([0,1], [-0.5]) key(h=2);
}

module main_support_curve() {
  radius = main_column_radius / 4;
  offset = radius + column_rib_height + plate_thickness/2;
  translate([0, 0, -offset])
  rotate([0, 90, 0])
    cylinder(r=radius, h=4, center=true);
}

module main_supports() {
  // inner column
  place_column_ribs([0]) column_rib(1, 4);


  difference() {
    union() {
      // main columns
      place_column_ribs([2:4]) column_rib(0, 4, 40);
      place_column_rib_left([1]) column_rib(1, 4, 40);
      place_column_rib_right([1]) column_rib(0, 4, 40);

      // outer column
      place_column_rib_left([5]) column_rib(0, 4, 40);
      place_column_rib_right([5], width=keyswitch_width * 2.5) column_rib(1, 4, 40);
      place_column_rib_right([5]) column_rib(0, 0, 40);
    }

    place_column_rib_left([1], 3.75) main_support_curve();
    place_column_rib_right([1], 4.5) main_support_curve();
    place_column_ribs([2:4], 4.5) main_support_curve();

    place_column_ribs([1:4], -1) main_support_curve();

    place_column_rib_left([5], -1) main_support_curve();
    place_column_rib_right([5], -1, width=keyswitch_width * 2.5) main_support_curve();
    place_column_ribs([5], 4.5) main_support_curve();

    translate([0, 0, -100]) cube(200, center=true);
  }
}

module thumb_supports() {
  place_thumb_column_ribs([2]) thumb_column_rib(0, 2);
  place_thumb_column_ribs([0]) thumb_column_rib(0, .5);

  difference() {
    union() {
      place_thumb_column_rib_left([1]) thumb_column_rib(0, 2, 70);
      place_thumb_column_rib_right([1]) thumb_column_rib(0, 2, 70);
    }

    translate([-70, -40, -80]) cube(160, center=true);

    place_thumb_column_ribs([1], [1.5])
      translate([0, 0, -70])
      rotate([90, 0, 90]) {
        cylinder(r=60, h=4, center=true);
        sphere(r=4);
      }
  }
}

module cap() {
  translate([0, 0, -plate_thickness / 2 -column_rib_height/2])
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
}

module front_end_caps() {
  row = 4.6;
  outer_offset = [keyswitch_width * 1.5 / 2, 0, 0];

  for (i=[1:4]) {
    hull() {
      place_column_rib_right([i], row) cap();
      place_column_rib_left([i+1], row) cap();
    }
  }

  for (i=[2:5]) hull() place_column_ribs([i], row) cap();
}

module front_join_left() {
  row = 4.6;
  hull() place_column_ribs([0, 1], row - 1) cap();
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
}


color("linen") main_layout();
color("linen") thumb_layout();
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
