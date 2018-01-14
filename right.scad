include <definitions.scad>
use <positioning.scad>
use <placeholders.scad>
use <structures.scad>

module key (w=1, h=1) {
  plate(w, h);
  switch();

  translate([0, 0, plate_thickness+3])
  keycap(w, h);
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

module main_supports() {
  // inner column
  place_column_ribs([0]) column_rib(1, 4);

  // main columns
  place_column_ribs([1:4]) column_rib(0, 4);

  // outer column
  place_column_rib_left([5]) column_rib(0, 4);
  place_column_rib_right([5], width=keyswitch_width * 2.5) column_rib(1, 4);
  place_column_rib_right([5]) column_rib(0, 0);
}

module thumb_supports() {
  place_thumb_column_ribs([1, 2]) thumb_column_rib(0, 2);
  place_thumb_column_ribs([0]) thumb_column_rib(0, .5);
}


color("linen") main_layout();
color("linen") thumb_layout();
color("burlywood") main_supports();
color("burlywood") thumb_supports();
