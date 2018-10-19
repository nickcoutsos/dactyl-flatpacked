include <../common/definitions.scad>

alpha = 180/24;
beta = 180/36;

thumb_row_radius = (mount_height + 0.25) / 2 / sin(alpha/2) + cap_top_height;
thumb_column_radius = (mount_width + 0.25) / 2 / sin(beta/2) + cap_top_height;
