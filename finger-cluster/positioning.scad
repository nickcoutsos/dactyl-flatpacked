include <definitions.scad>

use <../util.scad>
use <../scad-utils/transformations.scad>
use <../scad-utils/linalg.scad>

module place_finger_key(column, row) multmatrix(place_finger_key(column, row)) children();
module place_finger_column_support_slot_front(col) multmatrix(place_finger_column_support_slot_front(col)) children();
module place_finger_column_support_slot_back(col) multmatrix(place_finger_column_support_slot_back(col)) children();

function place_finger_key(column, row) = (
  let(row_angle = alpha * (2 - row))
  let(column_angle = beta * (2 - column))
  let(column_offset = finger_column_offsets[column])

  translation([0, 0, 13])
  * rotation(beta*3 * Y)
  * translation(column_offset)
  * translation([0, 0, finger_row_radius])
  * rotation(column_angle * Y)
  * translation([0, 0, -finger_row_radius])
  * translation([0, 0, finger_column_radius])
  * rotation(row_angle * X)
  * translation([0, 0, -finger_column_radius])
);

function un_key_place_transformation(column, row) = (
  let(row_angle = alpha * (2 - row))
  let(column_angle = beta * (2 - column))
  let(column_offset = finger_column_offsets[column])

  translation(-[0, 0, -finger_column_radius])
  * rotation(-row_angle * X)
  * translation(-[0, 0, finger_column_radius])
  * translation(-[0, 0, -finger_row_radius])
  * rotation(-column_angle * Y)
  * translation(-[0, 0, finger_row_radius])
  * translation(-column_offset)
  * rotation(-beta*3 * Y)
  * translation(-[0, 0, 13])
);

function place_finger_column_support_slot_front(col) = (
  let(row = finger_cluster_front_support_row + .25)
  place_finger_key(col, row)
   * translation([0, 0, -(column_rib_height + slot_height*.25)])
   * rotation([-alpha*(2-row), 0, 0])
   * translation(finger_finger_column_offset_middle)
   * translation(-[0, finger_column_offsets[col].y, 0])
);

function place_finger_column_support_slot_back(col) = (
  let(row = finger_cluster_back_support_row + .25)
  place_finger_key(col, row)
  * translation([0, 0, -column_rib_height])
  * translation(finger_finger_column_offset_middle)
  * rotation([-alpha*(2 - row), 0, 0])
  * translation(-[0, finger_column_offsets[col].y, 0])
);
