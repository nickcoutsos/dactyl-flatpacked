include <../definitions.scad>
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

  translation([-52, -45, 35])
  * rotation(axis=alpha * unit([1, 1, 0]))
  * rotation([0, 0, 180 * (.25 - .1875)])
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
  * rotation([0, 0, -180 * (.25 - .1875)])
  * rotation(axis=-alpha * unit([1, 1, 0]))
  * translation(-[-52, -45, 35])
);

module place_thumb_column_ribs(columns, row=1) {
  place_thumb_column_rib_left(columns, row) children();
  place_thumb_column_rib_right(columns, row) children();
}

module place_thumb_column_rib_left(columns, row=1, spacing=rib_spacing) {
  place_thumb_keys(columns, [row])
  translate([- (spacing/2 - rib_thickness / 2), 0, 0])
    children();
}

module place_thumb_column_rib_right(columns, row=1, spacing=rib_spacing) {
  place_thumb_keys(columns, [row])
  translate([spacing/2 - rib_thickness / 2, 0, 0])
    children();
}

module place_thumb_column_support_slot_front(col) {
  thumb_place(1, -1.25)
  rotate_down(thumb_place_transformation(1, -1.25))
  translate([0, 0, -slot_height])
  translate([0, 0, thumb_column_radius])
  rotate([0, beta * (col - 1), 0])
  translate([0, 0, -thumb_column_radius])
  translate([0, 0, -column_rib_height])
  translate([0, 0, -slot_height])
    children();
}

module place_thumb_column_support_slot_back(col) {
  thumb_place(1, 1.25)
  rotate_down(thumb_place_transformation(1, 1.25))
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
