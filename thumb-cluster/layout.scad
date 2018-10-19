use <positioning.scad>
include <definitions.scad>

module thumb_layout() {
  for (col=[0:len(columns)]) {
    for (row=columns[col]) {
      place_thumb_keys(col, row) children();
    }
  }
}
