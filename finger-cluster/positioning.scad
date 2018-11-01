include <definitions.scad>

use <../util.scad>
use <../scad-utils/transformations.scad>
use <../scad-utils/linalg.scad>

module key_place(column, row) {
  transformation = key_place_transformation(column, row);
  multmatrix(transformation)
    children();
}

function key_place_transformation(column, row) = (
  let(row_angle = alpha * (2 - row))
  let(column_angle = beta * (2 - column))
  let(column_offset = column_offsets[column])

  translation([0, 0, 13])
  * rotation(beta*3 * Y)
  * translation(column_offset)
  * translation([0, 0, main_column_radius])
  * rotation(column_angle * Y)
  * translation([0, 0, -main_column_radius])
  * translation([0, 0, main_row_radius])
  * rotation(row_angle * X)
  * translation([0, 0, -main_row_radius])
);

function un_key_place_transformation(column, row) = (
  let(row_angle = alpha * (2 - row))
  let(column_angle = beta * (2 - column))
  let(column_offset = column_offsets[column])

  translation(-[0, 0, -main_row_radius])
  * rotation(-row_angle * X)
  * translation(-[0, 0, main_row_radius])
  * translation(-[0, 0, -main_column_radius])
  * rotation(-column_angle * Y)
  * translation(-[0, 0, main_column_radius])
  * translation(-column_offset)
  * rotation(-beta*3 * Y)
  * translation(-[0, 0, 13])
);

module place_column_ribs(columns, row=2, spacing=rib_spacing) {
  place_column_rib_left(columns, row, spacing) children();
  place_column_rib_right(columns, row, spacing) children();
}

module place_column_rib_left(columns, row=2, spacing=rib_spacing) {
  key_place(columns, row)
  translate([- (spacing/2 - rib_thickness / 2), 0, 0])
    children();
}

module place_column_rib_right(columns, row=2, spacing=rib_spacing) {
  key_place(columns, row)
  translate([spacing/2 - rib_thickness / 2, 0, 0])
    children();
}

module place_column_support_slot_front(col) {
  key_place(col, 3.6)
  translate([0, 0, -(column_rib_height + slot_height*.25)])
  rotate([-alpha*(2-3.6), 0, 0])
  translate(column_offset_middle)
  translate(-[0, column_offsets[col].y, 0])
    children();
}

module place_column_support_slot_back(col) {
  key_place(col, .25)
  translate([0, 0, -column_rib_height])
  translate(column_offset_middle)
  rotate([-alpha*(1.75), 0, 0])
  translate(-[0, column_offsets[col].y, 0])
    children();
}
