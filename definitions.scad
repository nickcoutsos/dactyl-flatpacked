
X = [1, 0, 0];
Y = [0, 1, 0];
Z = [0, 0, 1];

column_offset_index = [0, 0, 0];
column_offset_middle = [0, 2.82, -3.0]; // was moved -4.5
column_offset_ring = [0, 0, 0];
column_offset_pinky = [0, -5.8, 5.64];
column_offsets = [
  column_offset_index,
  column_offset_index,
  column_offset_middle,
  column_offset_ring,
  column_offset_pinky,
  column_offset_pinky
];

keyswitch_height = 14.4; // Was 14.1, then 14.25
keyswitch_width = 14.4;

keycap_length = 18.1;
keycap_inner_length = 12.37;
keycap_height = 9.39;

keyhole_length = 14;
keywall_thickness = 1.5;

sa_profile_key_height = 12.7;

plate_thickness = 3;
plate_vertical_padding = 3;
plate_horizontal_padding = 2.4;

plate_width = keyhole_length + 2 * plate_horizontal_padding;
plate_height = keyhole_length + 2 * plate_vertical_padding;

rib_thickness = 3;
rib_spacing = 14 + rib_thickness/2;
rib_extension = .6;

mount_width = keyswitch_width + 3;
mount_height = keyswitch_height + 3;

columns = [0:4];
rows = [0:4];

alpha = 180/12;
beta = 180/36;

cap_top_height = sa_profile_key_height;

main_row_radius = (mount_height + .5) / 2 / sin(alpha/2) + cap_top_height;
main_column_radius = (mount_width + 2) / 2 / sin(beta/2) + cap_top_height;

thumb_row_radius = (mount_height + 1) / 2 / sin(alpha/2) + cap_top_height;
thumb_column_radius = (mount_width + 2) / 2 / sin(beta / 2) + cap_top_height;

column_rib_height = 10;
