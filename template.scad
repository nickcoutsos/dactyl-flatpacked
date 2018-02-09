use <supports.scad>
use <positioning.scad>
use <util.scad>
use <placeholders.scad>
include <definitions.scad>

// projection()
translate([-40, 50, 0])
{
  for (i=[1:2]) {
    translate([30 * i, -55, 0])
    rotate([-90, 0, 0])
    side_supports();
  }

  for (i=[1:2]) {
    translate([i * -25 + 25, 0, 0])
    rotate([0, 90, 0])
    rotate([0, -beta*5, 0])
    difference() {
      main_support_inner_column();
      side_supports();
    }
  }

  for (i=[1:8]) {
    translate([i*15, 0, 0])
    rotate([0, 90, 0])
    rotate([0, -beta*3, 0])
    main_support_columns([2]);
  }

  for (i=[1:2]) {
    translate([-20 * i - 40, 10, 0])
    rotate([0, 90, 0])
    main_support_outer_column_single();
  }
}

// projection()
translate([0, -50, 0])
{
  for (i=[1:2]) {
    translate([25 * i - 20, 0, 0])
    rotate([0, 90, 0])
    multmatrix(inverted_thumb_place_transformation(1, 0))
    difference() {
      thumb_supports_col3();
      thumb_side_supports();
    }

    translate([-20 * i, 0, 0])
    rotate([0, 90, 0])
    multmatrix(inverted_thumb_place_transformation(2, 0))
      thumb_supports_col1();

    translate([20 * i + 25, 0, 0])
    rotate([0, 90, 0])
    multmatrix(inverted_thumb_place_transformation(0, 0))
      thumb_supports_col2();

    unplace_thumb = inverted_thumb_place_transformation(1, 0);
    translate([25 + 25 * i, 50, 0])
    rotate([-90, 0, 0])
    difference() {
      thumb_side_supports();
      multmatrix(rotation_down(unplace_thumb))
      multmatrix(unplace_thumb)
      translate([0, 0, -100])
        cube(200, center=true);
    }
  }
}

