use <supports.scad>
use <positioning.scad>
use <util.scad>
use <placeholders.scad>
include <definitions.scad>

$fn = 120;

projection()
{
  for (col=[0:5], i=[0,1]) {
    translate([col*50 + i * 25 - 150, 0, 0])
    rotate([0, 90, 0])
    multmatrix(un_key_place_transformation(col, 2))
    main_support_column(col);
  }

  translate([-120, -90, 0]) {
    for (i=[1:2]) {
      translate([15 * i - 15, 0, 0])
      rotate([0, 90, 0])
      multmatrix(inverted_thumb_place_transformation(1, 0))
      difference() {
        thumb_supports_col3();
        thumb_side_supports();
      }

      translate([-15 * i, 0, 0])
      rotate([0, 90, 0])
      multmatrix(inverted_thumb_place_transformation(2, 0))
        thumb_supports_col1();

      translate([15 * i + 15, 0, 0])
      rotate([0, 90, 0])
      multmatrix(inverted_thumb_place_transformation(0, 0))
        thumb_supports_col2();
    }
  }

  front_matrix = thumb_place_transformation(1, -1.5);
  front_invert = inverted_thumb_place_transformation(1, -1.5);
  front_undown = rotation_down(front_matrix, invert=true);

  translate([10.5, -95, 0])
  rotate([-90, 0, -103])
  multmatrix(front_undown)
  multmatrix(front_invert)
  thumb_front_cross_support();

  back_matrix = thumb_place_transformation(1, -1.5);
  back_invert = inverted_thumb_place_transformation(1, -1.5);
  back_undown = rotation_down(back_matrix, invert=true);

  translate([-45, -75, 0])
  rotate([-90, 0, -12])
  multmatrix(back_undown)
  multmatrix(back_invert)
  thumb_back_cross_support();

  translate([120, -120, 0]) rotate([90, 0, 180]) main_front_cross_support();
  translate([60, -70, 0]) rotate([90, 0, 0]) main_back_cross_support();

  translate([30, -70, 0])
  rotate([90, 0, 0])
  multmatrix(un_key_place_transformation(0, 2.5))
  main_inner_column_cross_support();

  thumb_column_matrix = thumb_place_transformation(0, -.05);
  thumb_column_invert = inverted_thumb_place_transformation(0, -.05);
  thumb_column_undown = rotation_down(thumb_column_matrix, invert=true);

  translate([100, -58, 0])
  rotate([-90, 0, 0])
  multmatrix(thumb_column_undown)
  multmatrix(thumb_column_invert)
  thumb_inner_column_cross_support();
}

