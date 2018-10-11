include <definitions.scad>

use <scad-utils/transformations.scad>
use <scad-utils/linalg.scad>

// key columns span a 15 degree arc around the Y axis
// key rows span a 30 degree arc around the X axis
// the entire keyboard is rotated 15 degrees around Y
// this results in the 5th column pointing at +Y
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
  place_keys(columns, [row])
  translate([- (spacing/2 - rib_thickness / 2), 0, 0])
    children();
}

module place_column_rib_right(columns, row=2, spacing=rib_spacing) {
  place_keys(columns, [row])
  translate([spacing/2 - rib_thickness / 2, 0, 0])
    children();
}

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

module each_key () {
  for (col=columns, row=rows) {
    if (col != 0 || row != 4) {
      key_place(col, row) children();
    }
  }
}

module row_keys (row) {
  for (col=columns) {
    if (col != 0 || row != 4) {
      key_place(col, row) children();
    }
  }
}

module place_keys (columns, rows) {
  for (col=columns, row=rows) {
    if (col != 0 || row != 4) {
      key_place(col, row) children();
    }
  }
}

module place_thumb_keys (columns, rows) {
  for (col=columns, row=rows) {
    if (col != 0 || row != 4) {
      thumb_place(col, row) children();
    }
  }
}
