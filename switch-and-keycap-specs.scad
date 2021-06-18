mx_keyswitch_length = 13.97;
mx_keyhole_length = 14;
mx_switch_travel = 4.0;

xda_keycap_top_height = 15.0;
xda_keycap_width = 18.11;
xda_keycap_depth = 18.11;
xda_keycap_height = 8.5;
xda_keycap_thickness = 1;
xda_top_width = 13.66;
xda_top_depth = 13.66;
xda_top_corner_radius = 1.16;
xda_bottom_corner_radius = 0.57;

choc_switch_travel = 2.18;
choc_keyhole_length = 13.8;
choc_keycap_width = 17.6;
choc_keycap_depth = 16.6;
choc_keycap_height = 3.4;
choc_keycap_top_height = 9;

switch_specs = [
  [["mx", "keyhole_length"], mx_keyhole_length],
  [["choc", "keyhole_length"], choc_keyhole_length],
];

keycap_specs = [
  [["xda", "base_width"], xda_keycap_width],
  [["xda", "base_depth"], xda_keycap_depth],
  [["xda", "top_width"], xda_top_width],
  [["xda", "top_depth"], xda_top_depth],
  [["xda", "height"], xda_keycap_height],
  [["xda", "switch_combined_height"], xda_keycap_top_height],

  [["choc", "base_width"], choc_keycap_width],
  [["choc", "base_depth"], choc_keycap_depth],
  [["choc", "height"], choc_keycap_height],
  [["choc", "switch_combined_height"], choc_keycap_top_height],
];

function get_switch_property(type, property) = (
  let(index = search([[type, property]], switch_specs))
  len(index) == 0 ? undef : switch_specs[index[0]][1]
);

function get_keycap_property(type, property) = (
  let(index = search([[type, property]], keycap_specs))
  len(index) == 0 ? undef : keycap_specs[index[0]][1]
);
