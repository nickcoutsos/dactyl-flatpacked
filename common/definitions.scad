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

cap_top_height = sa_profile_key_height;

column_rib_height = 6;
column_rib_center_offset = rib_spacing/2 - rib_thickness/2;

slot_height = 2;
