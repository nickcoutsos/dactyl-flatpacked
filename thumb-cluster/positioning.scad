include <definitions.scad>

use <../util.scad>
use <../scad-utils/transformations.scad>
use <../scad-utils/linalg.scad>


module thumb_place (column, row) {
  multmatrix(thumb_place_transformation(column, row))
    children();
}

function thumb_place_transformation (column, row) = (
  let(column_angle = beta * column)
  let(row_angle = alpha * row)

  translation([-65, -45, 16])
  * rotation([15, -40, 35])
  * translation([mount_width, 0, 0])
  * translation([0, 0, thumb_column_radius])
  * rotation([0, column_angle, 0])
  * translation([0, 0, -thumb_column_radius])
  * translation([0, 0, thumb_row_radius])
  * rotation([row_angle, 0, 0])
  * translation([0, 0, -thumb_row_radius])
);

function inverted_thumb_place_transformation (column, row) = (
  let(column_angle = beta * column)
  let(row_angle = alpha * row)

  translation(-[0, 0, -thumb_row_radius])
  * rotation(-[row_angle, 0, 0])
  * translation(-[0, 0, thumb_row_radius])
  * translation(-[0, 0, -thumb_column_radius])
  * rotation(-[0, column_angle, 0])
  * translation(-[0, 0, thumb_column_radius])
  * translation(-[mount_width, 0, 0])
  * rotation(-[15, -40, 35])
  * translation(-[-65, -45, 16])
);

module place_thumb_column_support_slot_front(col) {
  thumb_place(1, -1.3)
  rotate_down(thumb_place_transformation(1, -1.3))
  translate([0, 0, -slot_height])
  translate([0, 0, thumb_column_radius])
  rotate([0, beta * (col - 1), 0])
  translate([0, 0, -thumb_column_radius])
  translate([0, 0, -column_rib_height])
  translate([0, 0, -slot_height])
    children();
}

module place_thumb_column_support_slot_back(col) {
  thumb_place(1, 0.3)
  rotate_down(thumb_place_transformation(1, 0.3))
  translate([0, 0, -slot_height])
  translate([0, 0, thumb_column_radius])
  rotate([0, beta * (col - 1), 0])
  translate([0, 0, -thumb_column_radius])
  translate([0, 0, -column_rib_height])
  translate([0, 0, -slot_height])
    children();
}

module place_thumb_keys (columns, rows) {
  for (col=columns, row=rows) {
    if (col != 0 || row != 4) {
      thumb_place(col, row) children();
    }
  }
}
