include <../common/definitions.scad>
include <../util.scad>

column_offset_index = [0, 0, 0];
column_offset_index_stretch = [0, 0, 0];
column_offset_middle = [0, 2.82, -3.0]; // was moved -4.5
column_offset_ring = [0, 0, 0];
column_offset_pinky = [0, -5.8, 5.64];
column_offset_pinky_stretch = [0.5, -5.8, 5.64];
column_offsets = [
  column_offset_index_stretch,
  column_offset_index,
  column_offset_middle,
  column_offset_ring,
  column_offset_pinky,
  column_offset_pinky_stretch
];

columns = [
  [0, 1, 2, 3],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4]
];

back_support_row = max([for(column=columns) column[0]])-0.15;
front_support_row = min([for(column=columns) last(column)])+0.1;

function column_range (col) = [columns[col][0], last(columns[col])];

alpha = 180/12;
beta = 180/36;

main_row_radius = (mount_height + 0.5) / 2 / sin(alpha/2) + cap_top_height;
main_column_radius = (mount_width + 2) / 2 / sin(beta/2) + cap_top_height;

