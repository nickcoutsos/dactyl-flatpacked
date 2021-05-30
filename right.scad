use <placeholders.scad>
use <finger-cluster/layout.scad>
use <finger-cluster/supports.scad>
use <thumb-cluster/layout.scad>
use <thumb-cluster/supports.scad>
include <common/definitions.scad>

$fn = 48;

keycap_offset = [0, 0, cap_top_height - keycap_height];

color("gray") main_layout() switch();
color("gray") thumb_layout() switch();

*color("ivory") {
  main_layout() translate(keycap_offset) keycap(1, 1);
  thumb_layout() translate(keycap_offset) keycap(1, 1);
}


// color("gainsboro") 
union(){
  $detail = true;

  *color("skyblue") main_layout() plate();
  main_support_columns($fn=12);
  *difference() {
    union() {
      main_front_cross_support();
      main_back_cross_support();
    }
    // if ($detail) main_support_columns();
  }

  color("skyblue") thumb_layout() plate();
  thumb_support_columns($fn=12);
  thumb_inner_column_cross_support();
  difference() {
    union() {
      thumb_front_cross_support();
      thumb_back_cross_support();
    }
    if ($detail) thumb_support_columns();
  }
}
