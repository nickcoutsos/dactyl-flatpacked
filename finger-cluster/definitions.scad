include <../common/definitions.scad>
include <../util.scad>

finger_finger_column_offset_index = [0, 0, 0];
finger_finger_column_offset_index_stretch = [0, 0, 0];
finger_finger_column_offset_middle = [0, 2.82, -3.0]; // was moved -4.5
finger_column_offset_ring = [0, 0, 0];
finger_column_offset_pinky = [0, -5.8, 5.64];
finger_column_offset_pinky_stretch = [0.5, -5.8, 5.64];
finger_column_offsets = [
  finger_finger_column_offset_index_stretch,
  finger_finger_column_offset_index,
  finger_finger_column_offset_middle,
  finger_column_offset_ring,
  finger_column_offset_pinky,
  finger_column_offset_pinky_stretch
];

finger_columns = [
  [1, 2, 3],
  [1, 2, 3, 4],
  [1, 2, 3, 4],
  [1, 2, 3, 4],
  [1, 2, 3],
  [1, 2, 3]
];

finger_cluster_back_support_row = max([for(column=finger_columns) column[0]]);
finger_cluster_front_support_row = min([for(column=finger_columns) last(column)]);

alpha = 180/12;
beta = 180/36;

finger_column_radius = (mount_height + 0.5) / 2 / sin(alpha/2) + cap_top_height;
finger_row_radius = (mount_width + 1.5) / 2 / sin(beta/2) + cap_top_height;

