use <positioning.scad>
include <../definitions.scad>

module thumb_layout() {
  for (col=[0:len(thumb_columns)]) {
    for (row=thumb_columns[col]) {
      place_thumb_keys(col, row) {
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
