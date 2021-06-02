use <finger-cluster/positioning.scad>
use <thumb-cluster/positioning.scad>
include <definitions.scad>

module finger_cluster_layout() {
  for (col=[0:len(finger_columns)]) {
    for (row=finger_columns[col]) {
      place_finger_key(col, row) children();
    }
  }
}

module thumb_cluster_layout() {
  for (col=[0:len(thumb_columns)]) {
    for (row=thumb_columns[col]) {
      place_thumb_key(col, row) {
        if (row == -0.5) {
          $h = 2;
          children();
        } else {
          children();
        }
      }
    }
  }
}
