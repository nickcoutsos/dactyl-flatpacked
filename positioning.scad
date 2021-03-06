include <BOSL2/std.scad>

use <util.scad>

include <definitions.scad>


module place_finger_key(column, row) multmatrix(place_finger_key(column, row)) children();
module place_thumb_key (column, row) multmatrix(place_thumb_key(column, row)) children();

function place_key(cluster, column, row) = (
  assert(cluster == "finger" || cluster == "thumb")
  cluster == "finger"
    ? place_finger_key(column, row)
    : place_thumb_key(column, row)
);

function place_finger_key(column, row) = (
  let(row_angle = alpha * (2 - row))
  let(column_angle = beta * (2 - column))
  let(column_offset = finger_column_offsets[column])

  affine3d_identity()
  * move([0, 0, 13])
  * rot(beta*3 * Y)
  * move([0, column_offset.y, column_offset.z])
  * move([0, 0, finger_row_radius])
  * rot(column_angle * Y)
  * move([0, 0, -finger_row_radius])
  * move([0, 0, finger_column_radius])
  * rot(row_angle * X)
  * move([0, 0, -finger_column_radius])
  * move([column_offset.x, 0, 0])
);

function un_key_place_transformation(column, row) = matrix_inverse(place_finger_key(column, row));

function place_finger_column_in_profile(col) = (
  affine3d_identity()
  * rot([0, 0, -90])
  * rot([0, -90, 0])
  * un_key_place_transformation(col, 2)
);

function place_thumb_column_in_profile(col) = (
  affine3d_identity()
  * rot([0, 0, -90])
  * rot([0, -90, 0])
  * invert_place_thumb_key(col, 1)
);

function place_thumb_key (column, row) = (
  let(column_angle = beta * column)
  let(row_angle = alpha * (1 - row))

  affine3d_identity()
  * move([-52, -45, 40])
  * rot(alpha, v=unit([1, 1, 0]))
  * rot([0, 0, 180 * (.25 - .1875)])
  * move([mount_width, 0, 0])
  * move([0, 0, thumb_row_radius])
  * rot([0, column_angle, 0])
  * move([0, 0, -thumb_row_radius])
  * move([0, 0, thumb_column_radius])
  * rot([row_angle, 0, 0])
  * move([0, 0, -thumb_column_radius])
);

function invert_place_thumb_key (column, row) = matrix_inverse(place_thumb_key(column, row));

function place_support_slot(cluster, position, column) = (
  let(column_offset = lookup_overrides(column_offsets, [cluster, column], [0, 0, 0])[0])
  let(row = cluster == "finger"
    ? (position == "front"
      ? finger_cluster_front_support_row
      : finger_cluster_back_support_row)
    : (position == "front"
      ? thumb_cluster_front_support_row
      : thumb_cluster_back_support_row)
  )
  let(transform = place_key(cluster, column, row))

  transform
  * move([0, 0, -column_support_height])
  * move([0, 0, -slot_height*2])
  * rotation_down(transform)
  * move(-[0, column_offset.y, 0])
);
