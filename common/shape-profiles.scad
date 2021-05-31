include <definitions.scad>

column_slots_profile = [
  [+column_rib_center_offset + rib_thickness / 2 + 1, 0, slot_height*2],
  [+column_rib_center_offset + rib_thickness / 2, 0, slot_height*2],
  [+column_rib_center_offset + rib_thickness / 2, 0, slot_height],
  [+column_rib_center_offset - rib_thickness / 2, 0, slot_height],
  [+column_rib_center_offset - rib_thickness / 2, 0, slot_height*2],
  [+column_rib_center_offset - rib_thickness / 2 - 1, 0, slot_height*2],

  [-(column_rib_center_offset - rib_thickness / 2 - 1), 0, slot_height*2],
  [-(column_rib_center_offset - rib_thickness / 2), 0, slot_height*2],
  [-(column_rib_center_offset - rib_thickness / 2), 0, slot_height],
  [-(column_rib_center_offset + rib_thickness / 2), 0, slot_height],
  [-(column_rib_center_offset + rib_thickness / 2), 0, slot_height*2],
  [-(column_rib_center_offset + rib_thickness / 2 + 1), 0, slot_height*2],
];
