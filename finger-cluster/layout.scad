use <positioning.scad>
include <definitions.scad>

module main_layout() {
  for (col=[0:len(columns)]) {
    for (row=columns[col]) {
      key_place(col, row) children();
    }
  }
}
