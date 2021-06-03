use <positioning.scad>
include <definitions.scad>

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
