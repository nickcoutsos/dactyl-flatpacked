include <../definitions.scad>

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

  translation([-52, -45, 40])
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
  * translation(-[-52, -45, 40])
);

function place_thumb_column_support_slot_front(col) = (
  let(row = thumb_cluster_front_support_row - .25)
  thumb_place_transformation(1, row)
  * rotation_down(thumb_place_transformation(1, row))
  * translation([0, 0, -slot_height])
  * translation([0, 0, thumb_column_radius])
  * rotation([0, beta * (col - 1), 0])
  * translation([0, 0, -thumb_column_radius])
  * translation([0, 0, -column_rib_height])
  * translation([0, 0, -slot_height])
);

function place_thumb_column_support_slot_back(col) = (
  let(row = thumb_cluster_back_support_row + .25)
  thumb_place_transformation(1, row)
  * rotation_down(thumb_place_transformation(1, row))
  * translation([0, 0, -slot_height])
  * translation([0, 0, thumb_column_radius])
  * rotation([0, beta * (col - 1), 0])
  * translation([0, 0, -thumb_column_radius])
  * translation([0, 0, -column_rib_height])
  * translation([0, 0, -slot_height])
);

module place_thumb_column_support_slot_front(col) multmatrix(place_thumb_column_support_slot_front(col)) children();
module place_thumb_column_support_slot_back(col) multmatrix(place_thumb_column_support_slot_back(col)) children();

module place_thumb_keys (columns, rows) {
  for (col=columns, row=rows) {
    if (col != 0 || row != 4) {
      thumb_place(col, row) children();
    }
  }
}
