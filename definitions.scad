use <util.scad>

X = [1, 0, 0];
Y = [0, 1, 0];
Z = [0, 0, 1];

keyswitch_height = 14.4; // Was 14.1, then 14.25
keyswitch_width = 14.4;

keycap_length = 18.1;
keycap_inner_length = 12.37;
keycap_height = 9.39;

keyhole_length = 14;
keywall_thickness = 1.5;

sa_profile_key_height = 12.7;

plate_thickness = 1.5;
plate_vertical_padding = 1.7;
plate_horizontal_padding = 1.7;

plate_width = keyhole_length + 2 * plate_horizontal_padding;
plate_height = keyhole_length + 2 * plate_vertical_padding;

rib_thickness = plate_thickness;
rib_spacing = keyhole_length + rib_thickness*2;
rib_extension = .55;

mount_width = keyswitch_width + 3;
mount_height = keyswitch_height + 3;

cap_top_height = 9;

column_rib_height = 6;
column_rib_center_offset = rib_spacing/2 - rib_thickness/2;

slot_height = 2;


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


thumb_columns = [
  [-.5],
  [-.5, 1],
  [-1, 0, 1]
];

thumb_cluster_back_support_row = 0;
thumb_cluster_front_support_row = -0.95;

thumb_row_radius = (mount_height + 0.75) / 2 / sin(alpha/2) + cap_top_height;
thumb_column_radius = (mount_width + 1.5) / 2 / sin(beta/2) + cap_top_height;

// Thumb overrides specify on a per-colum-index-and-row-index basis:
// * size multiplier (u and h)
// * rotation (in degrees)
// Note: this is only used for thumb keys and doesn't support the ergodox-style
// 1.25u outer pinky-column keys.
overrides = [
  ["thumb", 0, 0, 1, 2, 0],
  ["thumb", 1, 0, 1, 2, 0]
];

// Look up key overrides for given source, column index, and row index
function get_overrides (source, colIndex, rowIndex) = (
  let(matches = [
    for(vec=overrides)
    if (vec[0] == source && vec[1] == colIndex && vec[2] == rowIndex)
    echo(vec, slice(vec, 3))
    slice(vec, 3)
  ])

  len(matches) > 0 ? matches[0] : [1, 1, 0]
);
