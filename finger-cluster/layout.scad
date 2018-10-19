use <../common/assembled-key.scad>
use <positioning.scad>

column_rows = [
  [0:3],
  [0:4],
  [0:4],
  [0:4],
  [0:4],
  [0:4]
];

module main_layout() {
  for (col=[0:5]) {
    for (row=column_rows[col]) {
      key_place(col, row) key();
    }
  }
}
