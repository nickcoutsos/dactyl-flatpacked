include <definitions.scad>

// key columns span a 15 degree arc around the Y axis
// key rows span a 30 degree arc around the X axis
// the entire keyboard is rotated 15 degrees around Y
// this results in the 5th column pointing at +Y
module key_place(column, row) {
  row_radius = (mount_height + .5) / 2 / sin(alpha/2) + cap_top_height;
  column_radius = (mount_width + 2) / 2 / sin(beta/2) + cap_top_height;
  column_angle = beta * (2 - column);
  column_offset = column == 2
    ? [0, 2.82, -3.0] // was moved -4.5
    : (column >= 4
      ? [0, -5.8, 5.64]
      : [0, 0, 0]);

  translate([0, 0, 13])
  rotate(alpha, Y)

    translate(column_offset)
    translate([0, 0, column_radius])
    rotate(column_angle, Y)
    translate([0, 0, -column_radius])

      translate([0, 0, row_radius])
      rotate(alpha * (2 - row), X)
      translate([0, 0, -row_radius])

        children();
}

module thumb_place (column, row) {
  row_radius = (mount_height + 1) / 2 / sin(alpha/2) + cap_top_height;
  column_radius = (mount_width + 2) / 2 / sin(beta / 2) + cap_top_height;

  translate([-52, -45, 40])
  rotate(alpha, [1, 1, 0])
  rotate(180 * (.25 - .1875), Z)
  translate([mount_width, 0, 0])
  translate([0, 0, column_radius])
  rotate(beta * column, Y)
  translate([0, 0, -column_radius])
  translate([0, 0, row_radius])
  rotate(alpha * row, X)
  translate([0, 0, -row_radius])
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
