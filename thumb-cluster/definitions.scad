include <../common/definitions.scad>
include <../util.scad>

alpha = 180/12;
beta = 180/36;

columns = [
  [-.5],
  [-.5, 1],
  [-1, 0, 1]
];

back_support_row = 1;
front_support_row = -1;

function column_range (col) = [columns[col][0], last(columns[col])];

thumb_row_radius = (mount_height + 0.25) / 2 / sin(alpha/2) + cap_top_height;
thumb_column_radius = (mount_width + 0.25) / 2 / sin(beta/2) + cap_top_height;
