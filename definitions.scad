use <util.scad>
include <switch-and-keycap-specs.scad>

X = [1, 0, 0];
Y = [0, 1, 0];
Z = [0, 0, 1];

switch_type = "mx";
keycap_type = "xda";

keyhole_length = get_switch_property(switch_type, "keyhole_length");
keycap_width   = get_keycap_property(keycap_type, "base_width");
keycap_depth   = get_keycap_property(keycap_type, "base_depth");
keycap_height  = get_keycap_property(keycap_type, "height");
cap_top_height = get_keycap_property(keycap_type, "switch_combined_height");

plate_thickness = 2;
plate_vertical_padding = 1.7;
plate_horizontal_padding = 1.7;

plate_width = keyhole_length + 2 * plate_horizontal_padding;
plate_height = keyhole_length + 2 * plate_vertical_padding;

// overall space allotted for each keycap
// Normally 0.5mm x 0.5mm is sufficient but the curvature can cause collisions
// between keys in more than one row away from home.
mount_width = keycap_width + 1.0;
mount_depth = keycap_depth + 0.5;

column_support_height = 6;
column_support_thickness = plate_thickness;
column_support_spacing = keyhole_length + column_support_thickness*2;
column_support_center_offset = (column_support_spacing - column_support_thickness) / 2;

slot_height = 2;
slot_width = plate_thickness;
slot_padding = 1;

alpha = 180/12;
beta = 180/36;

finger_column_offset_index = [0, 0, 0];
finger_column_offset_index_stretch = [0, 0, 0];
finger_column_offset_middle = [0, 2.82, -3.0]; // was moved -4.5
finger_column_offset_ring = [0, 0, 0];
finger_column_offset_pinky = [0, -5.8, 5.64];
finger_column_offset_pinky_stretch = [plate_width*1.5/6, -5.8, 5.64];
finger_column_offsets = [
  finger_column_offset_index_stretch,
  finger_column_offset_index,
  finger_column_offset_middle,
  finger_column_offset_ring,
  finger_column_offset_pinky,
  finger_column_offset_pinky_stretch
];

finger_columns = [
  [0, 1, 2, 3],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4]
];

thumb_columns = [
  [1.5],
  [0, 1.5],
  [0, 1, 2]
];

finger_cluster_back_support_row = max([for(column=finger_columns) column[0]]) + 0.15;
finger_cluster_front_support_row = min([for(column=finger_columns) last(column)]) + 0.2;

thumb_cluster_back_support_row = 0.85;
thumb_cluster_front_support_row = 2.2;

finger_column_radius = mount_depth / 2 / sin(alpha/2) + (cap_top_height - keycap_height);
finger_row_radius = mount_width / 2 / sin(beta/2) + (cap_top_height - keycap_height);

thumb_column_radius = mount_depth / 2 / sin(alpha/2) + (cap_top_height - keycap_height);
thumb_row_radius = mount_width / 2 / sin(beta/2) + (cap_top_height - keycap_height);

// Overrides specify on a per- cluster/column-/row-index basis:
// * size multiplier (u and h)
// * rotation (in degrees)
overrides = [
  ["thumb", 0, 0, 1, 2],
  ["thumb", 1, 1, 1, 2],
  ["finger", 5, 0, 1.5, 1],
  ["finger", 5, 1, 1.5, 1],
  ["finger", 5, 2, 1.5, 1],
  ["finger", 5, 3, 1.5, 1],
];

alignment_overrides = [
  ["finger", 5, 4, -1]
];

column_offsets = [
  ["finger", 0, finger_column_offset_index_stretch],
  ["finger", 1, finger_column_offset_index],
  ["finger", 2, finger_column_offset_middle],
  ["finger", 3, finger_column_offset_ring],
  ["finger", 4, finger_column_offset_pinky],
  ["finger", 5, finger_column_offset_pinky_stretch],
];

/**
 * Return overrides for matching array of criteria in a given collection.
 *
 * Given an array of arrays (collection), an array of values (criteria), this
 * function will search each array in collection to find those where the first N
 * values match the criteria array.
 *
 * If a match is found, the remainder of the array is returned. That means the
 * first N elements (where N is the length of criteria) are excluded.
 * If none match the value of default is returned
 *
 */
function lookup_overrides(collection, criteria, default) = (
  let(num_criteria = len(criteria))
  let(matches = [
    for(candidate=collection)
    if (len([
      for(i=[0:len(criteria)-1])
      if (!is_undef(candidate[i]) && candidate[i] == criteria[i])
      true
    ]) == num_criteria)
    slice(candidate, num_criteria)
  ])

  len(matches) > 0 ? matches[0] : default
);

// Look up key overrides for given cluster, column index, and row index
function get_overrides (cluster, colIndex, rowIndex) = (
  lookup_overrides(overrides, [cluster, colIndex, rowIndex], [1, 1])
);

/**
 * Get the largest key width ($u value) of a column in the given key cluster.
 */
function get_column_width (cluster, colIndex) = (
  assert(cluster == "finger" || cluster == "thumb", "'cluster' must be one of (finger|thumb)")
  let(column = cluster == "finger" ? finger_columns[colIndex] : thumb_columns[colIndex])
  let(column_widths = [
    for(rowIndex=[0:len(column)-1])
    get_overrides(cluster, colIndex, rowIndex)[0]
  ])
  max(column_widths)
);

function get_alignment_override (cluster, colIndex, rowIndex) = (
  lookup_overrides(alignment_overrides, [cluster, colIndex, rowIndex], [0])[0]
);
