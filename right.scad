include <definitions.scad>
use <positioning.scad>
use <placeholders.scad>
use <structures.scad>
use <supports.scad>
use <caps.scad>
use <util.scad>

module key (w=1, h=1) {
  plate(w, h);
  switch();

  translate([0, 0, 4])
  color("linen") keycap(w, h);
}

module main_layout() {
  // main keys
  place_keys([0:4], [0:3]) key();

  // bottom row (mostly)
  place_keys([2:5], [4]) key();

  // this key plate intersects the thumb cluster
  place_keys([1], [4]) key();

  // modifier key column
  place_keys([5], [0:3]) translate([plate_width/4, 0, 0]) key(w=1.5);

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

main_layout();
thumb_layout();

main_supports();
side_supports();
thumb_supports();

difference() {
  place_thumb_side_supports()
    thumb_side_supports();

  translate([0, 0, -100])
    cube(200, center=true);
}


color("brown") {
  back_end_caps();
  back_thumb_end_caps();

  difference() {
    front_end_caps();
    place_column_rib_left(1, 4 + rib_extension)
    translate([-rib_thickness, 0, -column_rib_height/2])
      cube([rib_thickness, 5, column_rib_height + 1], center=true);
  }

  hull() {
    place_thumb_column_ribs(0, 0) short_cap();
    place_column_ribs([0], 4 + rib_extension - 1) cap();
  }

  front_join_left();
  // front_join_right();
  front_thumb_end_caps();
}
