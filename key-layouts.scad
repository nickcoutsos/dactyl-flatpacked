use <positioning.scad>
use <placeholders.scad>
include <definitions.scad>

$render_keycaps = false;
$render_switches = false;
$render_plates = false;
$render_all = false;

module layout(cluster) {
  assert(cluster == "finger" || cluster == "thumb", "'cluster' must be one of (finger|thumb)");

  columns = cluster == "finger" ? finger_columns : thumb_columns;
  transform = function (col, row) cluster == "finger"
    ? place_finger_key(col, row)
    : place_thumb_key(col, row);

  for (col=[0:len(columns)-1]) {
    column_u = get_column_width(cluster, col);

    for (rowIndex=[0:len(columns[col])-1]) {
      row = columns[col][rowIndex];
      align = get_alignment_override(cluster, col, rowIndex);
      size_overrides = get_overrides(cluster, col, rowIndex);
      $u = size_overrides[0];
      $h = size_overrides[1];

      multmatrix(transform(col, row)) {
        if ($render_plates) plate($u=column_u, align=align);
        translate([$u < column_u ? -plate_width * $u/4 : 0, 0, 0]) {
          if ($render_keycaps) keycap();
          if ($render_switches) switch();
        }
      }
    }
  }
}

module finger_cluster_layout() {
  for (col=[0:len(finger_columns)-1]) {
    for (row=finger_columns[col]) {
      place_finger_key(col, row) children();
    }
  }
}

module thumb_cluster_layout() {
  for (col=[0:len(thumb_columns)-1]) {
    for (rowIndex=[0:len(thumb_columns[col])-1]) {
      row = thumb_columns[col][rowIndex];
      overrides = get_overrides("thumb", col, rowIndex);
      $u = overrides[0];
      $h = overrides[1];
      place_thumb_key(col, row) children();
    }
  }
}
