include <definitions.scad>

// key columns span a 15 degree arc around the Y axis
// key rows span a 30 degree arc around the X axis
// the entire keyboard is rotated 15 degrees around Y
// this results in the 5th column pointing at +Y
module key_place(column, row, unrotate=false) {
  row_angle = alpha * (2 - row);
  column_angle = beta * (2 - column);
  column_offset = column == 2
    ? [0, 2.82, -3.0] // was moved -4.5
    : (column >= 4
      ? [0, -5.8, 5.64]
      : [0, 0, 0]);

  translate([0, 0, 13])
  rotate(alpha, Y)

  translate(column_offset)
  translate([0, 0, main_column_radius])
  rotate(column_angle, Y)
  translate([0, 0, -main_column_radius])


        translate([0, 0, main_row_radius])
        rotate(row_angle, X)
        translate([0, 0, -main_row_radius])

        rotate(unrotate ? -row_angle : 0, X)
        rotate(unrotate ? -column_angle : 0, Y)
        rotate(unrotate ? -alpha : 0, Y)
          children();
}

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

module thumb_place (column, row, unrotate=false) {
  column_angle = beta * column;
  row_angle = alpha * row;

  translate([-52, -45, 40])
  rotate(alpha, [1, 1, 0])
  rotate(180 * (.25 - .1875), Z)
  translate([mount_width, 0, 0])
  translate([0, 0, thumb_column_radius])
  rotate(column_angle, Y)
  translate([0, 0, -thumb_column_radius])
  translate([0, 0, thumb_row_radius])
  rotate(row_angle, X)
  translate([0, 0, -thumb_row_radius])

    rotate(unrotate ? -row_angle : 0, X)
    rotate(unrotate ? -column_angle : 0, Y)
    rotate(unrotate ? -alpha : 0, [1, 1, 0])

    children();
}

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
