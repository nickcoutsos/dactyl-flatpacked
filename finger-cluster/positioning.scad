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

function place_column_support_slot_front(col) = (
  let(row = front_support_row + .25)
  key_place_transformation(col, row)
   * translation([0, 0, -(column_rib_height + slot_height*.25)])
   * rotation([-alpha*(2-row), 0, 0])
   * translation(column_offset_middle)
   * translation(-[0, column_offsets[col].y, 0])
);

module place_column_support_slot_front(col) multmatrix(place_column_support_slot_front(col)) children();

function place_column_support_slot_back(col) = (
  let(row = back_support_row + .25)
  key_place_transformation(col, row)
  * translation([0, 0, -column_rib_height])
  * translation(column_offset_middle)
  * rotation([-alpha*(2 - row), 0, 0])
  * translation(-[0, column_offsets[col].y, 0])
);

module place_column_support_slot_back(col) multmatrix(place_column_support_slot_back(col)) children();
