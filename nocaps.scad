include <definitions.scad>
use <positioning.scad>
use <placeholders.scad>
use <structures.scad>
use <supports.scad>
use <caps.scad>
use <util.scad>

use <scad-utils/transformations.scad>
use <scad-utils/linalg.scad>

// $fn = 36;

module key (w=1, h=1) {
  color("slategray") plate(w, h);

  kailh_lowprofile_switch();

  color("ivory")
  translate([0, 0, cap_top_height - keycap_height])
  keycap(w, h);

  // color("limegreen", alpha=0.25)
  // cylinder(d=2, h=main_column_radius);
}

module main_layout() {
  // main keys
  place_keys([0:4], [0:3]) key();

  // bottom row (mostly)
  place_keys([2:4], [4]) key();

  // this key plate intersects the thumb cluster
  place_keys([1], [4]) key();

  // // modifier key column
  // place_keys([5], [0:3]) translate([plate_width/4, 0, 0]) key(w=1.5);
  place_keys([5], [0:4]) key();

  // // corner key
  // place_keys([5], [4]) {
  //   translate([plate_width/4, 0, 0]) plate(w=1.5, w_offset=.25);
  //   // translate([0, 0, 4]) keycap(1, 1);
  //   // switch();
  // }

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

// color("goldenrod") {
//   main_layout();
//   thumb_layout();
// }

main_supports();
main_inner_column_cross_support();
main_front_cross_support();
main_back_cross_support();

thumb_supports();
thumb_inner_column_cross_support();
thumb_front_cross_support();
thumb_back_cross_support();
