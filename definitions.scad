use <util.scad>
include <switch-and-keycap-specs.scad>

X = [1, 0, 0];
Y = [0, 1, 0];
Z = [0, 0, 1];

switch_type = "mx";
keycap_type = "xda";

keyhole_length = mx_keyhole_length;
keycap_width   = xda_keycap_width;
keycap_depth   = xda_keycap_depth;
keycap_height  = xda_keycap_height;
cap_top_height = xda_keycap_top_height;

plate_thickness = 1.5;
plate_vertical_padding = 1.7;
plate_horizontal_padding = 1.7;

plate_width = keyhole_length + 2 * plate_horizontal_padding;
plate_height = keyhole_length + 2 * plate_vertical_padding;

// overall space allotted for each keycap
mount_width = keycap_width + 0.5;
mount_depth = keycap_depth - 1;

column_support_height = 6;
column_support_thickness = plate_thickness;
column_support_spacing = keyhole_length + column_support_thickness*2;
column_support_center_offset = (column_support_spacing - column_support_thickness) / 2;

slot_height = 2;

alpha = 180/12;
beta = 180/36;

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

thumb_columns = [
  [1.5],
  [0, 1.5],
  [0, 1, 2]
];

finger_cluster_back_support_row = max([for(column=finger_columns) column[0]]);
finger_cluster_front_support_row = min([for(column=finger_columns) last(column)]);

thumb_cluster_back_support_row = 0.5;
thumb_cluster_front_support_row = 2.45;

finger_column_radius = mount_depth / 2 / sin(alpha/2) + cap_top_height;
finger_row_radius = mount_width / 2 / sin(beta/2) + cap_top_height;

thumb_column_radius = mount_depth / 2 / sin(alpha/2) + cap_top_height;
thumb_row_radius = mount_width / 2 / sin(beta/2) + cap_top_height;

// Thumb overrides specify on a per-colum-index-and-row-index basis:
// * size multiplier (u and h)
// * rotation (in degrees)
// Note: this is only used for thumb keys and doesn't support the ergodox-style
// 1.25u outer pinky-column keys.
overrides = [
  ["thumb", 0, 0, 1, 2, 0],
  ["thumb", 1, 1, 1, 2, 0]
];

// Look up key overrides for given source, column index, and row index
function get_overrides (source, colIndex, rowIndex) = (
  let(matches = [
    for(vec=overrides)
    if (vec[0] == source && vec[1] == colIndex && vec[2] == rowIndex)
    slice(vec, 3)
  ])

  len(matches) > 0 ? matches[0] : [1, 1, 0]
);
