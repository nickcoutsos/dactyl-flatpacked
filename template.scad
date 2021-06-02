use <finger-cluster/supports.scad>
use <thumb-cluster/supports.scad>
use <finger-cluster/positioning.scad>
use <thumb-cluster/positioning.scad>
use <util.scad>
use <placeholders.scad>
include <finger-cluster/definitions.scad>
include <thumb-cluster/definitions.scad>

enable_projection = false;
$detail=true;

module project() {
  if (enable_projection) {
    projection() children();
  }
  else {
    children();
  }
}

for (col=[0:5], i=[0,1]) {
  project()
  translate([col*55 + i * 27 - 150, 0, 0])
  rotate([0, 90, 0])
  multmatrix(un_key_place_transformation(col, 2))
  finger_cluster_support_columns(col);
}

translate([-140, -90, 0]) {
  for (i=[1:2]) {
    project()
    translate([20 * i - 20, 0, 0])
    rotate([0, 90, 0])
    multmatrix(inverted_thumb_place_transformation(1, 0))
      thumb_support_columns(1);

    project()
    translate([-20 * i, 0, 0])
    rotate([0, 90, 0])
    multmatrix(inverted_thumb_place_transformation(2, 0))
      thumb_support_columns(2);

    project()
    translate([20 * i + 20, 0, 0])
    rotate([0, 90, 0])
    multmatrix(inverted_thumb_place_transformation(0, 0))
      thumb_support_columns(0);
  }
}

front_matrix = thumb_place_transformation(1, -1.5);
front_invert = inverted_thumb_place_transformation(1, -1.5);
front_undown = rotation_down(front_matrix, invert=true);

project()
translate([12, -95, 0])
rotate([-90, 0, -103])
multmatrix(front_undown)
multmatrix(front_invert)
thumb_front_cross_support();

back_matrix = thumb_place_transformation(1, -1.5);
back_invert = inverted_thumb_place_transformation(1, -1.5);
back_undown = rotation_down(back_matrix, invert=true);

project()
translate([-45, -75, 0])
rotate([-90, 0, -12])
multmatrix(back_undown)
multmatrix(back_invert)
thumb_back_cross_support();

project()
translate([120, -120, 0]) rotate([90, 0, 180]) finger_cluster_cross_support_front();

project()
translate([60, -70, 0]) rotate([90, 0, 0]) finger_cluster_cross_support_back();

thumb_column_matrix = thumb_place_transformation(0, -.15);
thumb_column_invert = inverted_thumb_place_transformation(0, -.15);

for (y=[1:14], x=[0,1]) {
  project()
  translate([x * (plate_width+1) - 230, y * (plate_height+1)-165, 0])
  plate(1, 1);
}

for (y=[0:4]) {
  project()
  translate([-265, y * (plate_width*1.5+1) - 190, 0])
  rotate([0, 0, 90])
  plate(1.5, 1);
}

project()
translate([-145, -190, 0])
rotate([0, 0, 90])
plate(1.5, 1, w_offset=.25);

for (x=[0,1]) {
  project()
  translate([x * (plate_width+1) + 40, -190, 0])
  plate(1, 2);
}

