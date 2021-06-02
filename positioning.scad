use <scad-utils/transformations.scad>
use <scad-utils/linalg.scad>

use <util.scad>

include <definitions.scad>


module place_finger_key(column, row) multmatrix(place_finger_key(column, row)) children();
module place_finger_column_support_slot_front(col) multmatrix(place_finger_column_support_slot_front(col)) children();
module place_finger_column_support_slot_back(col) multmatrix(place_finger_column_support_slot_back(col)) children();

module place_thumb_key (column, row) multmatrix(place_thumb_key(column, row)) children();
module place_thumb_column_support_slot_front(col) multmatrix(place_thumb_column_support_slot_front(col)) children();
module place_thumb_column_support_slot_back(col) multmatrix(place_thumb_column_support_slot_back(col)) children();

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

function place_thumb_key (column, row) = (
  let(column_angle = beta * column)
  let(row_angle = alpha * row)

  translation([-52, -45, 40])
  * rotation(axis=alpha * unit([1, 1, 0]))
  * rotation([0, 0, 180 * (.25 - .1875)])
  * translation([mount_width, 0, 0])
  * translation([0, 0, thumb_row_radius])
  * rotation([0, column_angle, 0])
  * translation([0, 0, -thumb_row_radius])
  * translation([0, 0, thumb_column_radius])
  * rotation([row_angle, 0, 0])
  * translation([0, 0, -thumb_column_radius])
);

function invert_place_thumb_key (column, row) = (
  let(column_angle = beta * column)
  let(row_angle = alpha * row)

  translation(-[0, 0, -thumb_column_radius])
  * rotation(-[row_angle, 0, 0])
  * translation(-[0, 0, thumb_column_radius])
  * translation(-[0, 0, -thumb_row_radius])
  * rotation(-[0, column_angle, 0])
  * translation(-[0, 0, thumb_row_radius])
  * translation(-[mount_width, 0, 0])
  * rotation([0, 0, -180 * (.25 - .1875)])
  * rotation(axis=-alpha * unit([1, 1, 0]))
  * translation(-[-52, -45, 40])
);

function place_thumb_column_support_slot_front(col) = (
  let(row = thumb_cluster_front_support_row - .25)
  place_thumb_key(1, row)
  * rotation_down(place_thumb_key(1, row))
  * translation([0, 0, -slot_height])
  * translation([0, 0, thumb_row_radius])
  * rotation([0, beta * (col - 1), 0])
  * translation([0, 0, -thumb_row_radius])
  * translation([0, 0, -column_rib_height])
  * translation([0, 0, -slot_height])
);

function place_thumb_column_support_slot_back(col) = (
  let(row = thumb_cluster_back_support_row + .25)
  place_thumb_key(1, row)
  * rotation_down(place_thumb_key(1, row))
  * translation([0, 0, -slot_height])
  * translation([0, 0, thumb_row_radius])
  * rotation([0, beta * (col - 1), 0])
  * translation([0, 0, -thumb_row_radius])
  * translation([0, 0, -column_rib_height])
  * translation([0, 0, -slot_height])
);
