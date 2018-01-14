
X = [1, 0, 0];
Y = [0, 1, 0];
Z = [0, 0, 1];

keyswitch_height = 14.4; // Was 14.1, then 14.25
keyswitch_width = 14.4;

keycap_length = 18.1;
keycap_inner_length = 12.37;
keycap_height = 9.39;

keyhole_length = 14.4;
keywall_thickness = 1.5;

sa_profile_key_height = 12.7;

plate_thickness = 3;
mount_width = keyswitch_width + 3;
mount_height = keyswitch_height + 3;

columns = [0:4];
rows = [0:4];

alpha = 180/12;
beta = 180/36;

cap_top_height = plate_thickness + sa_profile_key_height;

main_row_radius = (mount_height + .5) / 2 / sin(alpha/2) + cap_top_height;
main_column_radius = (mount_width + 2) / 2 / sin(beta/2) + cap_top_height;

thumb_row_radius = (mount_height + 1) / 2 / sin(alpha/2) + cap_top_height;
thumb_column_radius = (mount_width + 2) / 2 / sin(beta / 2) + cap_top_height;
