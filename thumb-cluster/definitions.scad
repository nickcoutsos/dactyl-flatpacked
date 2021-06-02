include <../definitions.scad>
include <../util.scad>

alpha = 180/12;
beta = 180/36;

columns = [
  [-.5],
  [-.5, 1],
  [-1, 0, 1]
];

// Thumb overrides specify on a per-colum-index-and-row-index basis:
// * size multiplier (u and h)
// * rotation (in degrees)
// Note: this is only used for thumb keys and doesn't support the ergodox-style
// 1.25u outer pinky-column keys.
overrides = [
  [0, 0, 1, 2, 0],
  [1, 0, 1, 2, 0]
];

function slice(vec, start, end) = (
  let(e=is_undef(end) ? len(vec) - 1 : end)
  [ for(i=[start:e]) vec[i] ]
);

// Look up thumb overrides for given column and row index
function get_overrides (source, colIndex, rowIndex) = (
  let(matches = [
    for(vec=source)
    if (vec[0] == colIndex && vec[1] == rowIndex)
    slice(vec, 2)
  ])

  len(matches) > 0 ? matches[0] : [1, 1, 0]
);

back_support_row = 0;
front_support_row = -0.95;

function column_range (col) = [columns[col][0], last(columns[col])];

thumb_row_radius = (mount_height + 0) / 2 / sin(alpha/2) + cap_top_height;
thumb_column_radius = (mount_width + 1) / 2 / sin(beta/2) + cap_top_height;
