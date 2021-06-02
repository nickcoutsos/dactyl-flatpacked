use <positioning.scad>
include <definitions.scad>

module main_layout() {
  for (col=[0:len(finger_columns)]) {
    for (row=finger_columns[col]) {
      place_finger_key(col, row) children();
    }
  }
}
