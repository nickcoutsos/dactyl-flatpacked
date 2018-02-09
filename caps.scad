include <definitions.scad>
use <positioning.scad>

module cap() {
  translate([0, 0, -column_rib_height/2])
  cube([6, 4, column_rib_height], center=true);
}

module short_cap() {
  translate([0, 0, -(column_rib_height/2 + plate_thickness)])
  cube([6, 4, column_rib_height - plate_thickness], center=true);
}

module back_end_caps() {
  row = -rib_extension;
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
  row = (1 + rib_extension);

  for (i=[1:2]) hull() place_thumb_column_ribs([i], row) cap();
  hull() {
    place_thumb_column_rib_right([2], row) cap();
    place_thumb_column_rib_left([1], row) cap();
  }
}

module front_end_caps() {
  row = (4 + rib_extension);

  for (i=[1:4]) {
    hull() {
      place_column_rib_right([i], row) translate([2, 0, 0]) scale([.5, 1, 1]) cap();
      place_column_rib_left([i+1], row) translate([-2, 0, 0]) scale([.5, 1, 1]) cap();
    }
  }

  for (i=[1:5]) hull() place_column_ribs([i], row) cap();
}

module front_join_left() {
  row = (4 + rib_extension);
  hull() place_column_ribs([0], row - 1) cap();
}

module front_join_right() {
  row = (4 + rib_extension);
  outer_offset = [keyswitch_width * 1.5 / 2, 0, 0];

  hull() {
    place_column_rib_left([5], row - 1.1) cap();
    place_column_rib_right([5], row - 1.1) translate(outer_offset) cap();
  }
}

module front_thumb_end_caps() {
  row = -(1 + rib_extension);

  for (i=[0:2]) hull() place_thumb_column_ribs([i], row) cap();
  for (i=[0:1]) {
    hull() {
      place_thumb_column_rib_right([i+1], row) cap();
      place_thumb_column_rib_left([i], row) cap();
    }
  }
}
