use <placeholders.scad>
use <finger-cluster/layout.scad>
use <finger-cluster/supports.scad>
use <thumb-cluster/layout.scad>
use <thumb-cluster/supports.scad>
include <common/definitions.scad>

keycap_offset = [0, 0, cap_top_height - keycap_height];

main_layout() kailh_lowprofile_switch();
thumb_layout() kailh_lowprofile_switch();

color("ivory") {
  main_layout() translate(keycap_offset) keycap(1, 1);
  thumb_layout() translate(keycap_offset) keycap(1, 1);
}

color("gainsboro") {
  main_layout() plate();
  thumb_layout() plate();

  main_supports();
  thumb_supports();

  // difference() {
  //   union() {
  //     main_front_cross_support();
  //     main_back_cross_support();
  //   }
  //   main_supports();
  // }

  // difference() {
  //   union() {
  //     thumb_front_cross_support();
  //     thumb_back_cross_support();
  //   }
  //   thumb_supports();
  // }
}
