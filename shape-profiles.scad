include <definitions.scad>

function make_column_slots_profile(u=1) = (
  let(slot_offset = column_support_center_offset * u)
  let(right_slot = [
    [slot_offset + slot_width/2 +slot_padding, 0, slot_height*2],
    [slot_offset + slot_width/2, 0, slot_height*2],
    [slot_offset + slot_width/2, 0, slot_height],
    [slot_offset - slot_width/2, 0, slot_height],
    [slot_offset - slot_width/2, 0, slot_height*2],
    [slot_offset - slot_width/2 -slot_padding, 0, slot_height*2],
  ])
  let(left_slot = reverse([
    for (v=right_slot)
    [-v.x, v.y, v.z]
  ]))
  concat(right_slot, left_slot)
);

function plate (w=1, h=1, align=0) = (
  let(width = plate_width * w)
  let(height = plate_height * h)
  let(center_offset = column_support_center_offset)

  let(plate_top = height/2)
  let(plate_right = width/2)
  let(slot_right = center_offset*w + slot_width/2)
  let(slot_left = center_offset*w - slot_width/2)
  let(slot_bottom = plate_top - column_support_thickness/2)
  let(slot_distance_from_edge = width/2 - (center_offset*w + column_support_thickness/2))

  let(corner_profile = [
    [ plate_right,  slot_distance_from_edge > 0.2 ? plate_top : slot_bottom],
    [ slot_right,  slot_distance_from_edge > 0.2 ? plate_top : slot_bottom],
    [ slot_right,  slot_bottom],
    [ slot_left,  slot_bottom],
    [ slot_left,  plate_top],
  ])

  let(outer_points = flatten([
    corner_profile,
    reverse([for(v=corner_profile) [-v.x, v.y]]),
    [for(v=corner_profile) [-v.x, -v.y]],
    reverse([for(v=corner_profile) [v.x, -v.y]])
  ]))

  let(alignment = align * (w - 1) * plate_width/2)
  let(inner_points = [
    [ keyhole_length/2 + alignment,  keyhole_length/2],
    [-keyhole_length/2 + alignment,  keyhole_length/2],
    [-keyhole_length/2 + alignment, -keyhole_length/2],
    [ keyhole_length/2 + alignment, -keyhole_length/2]
  ])

  let(points = concat(outer_points, inner_points))
  let(paths = [
    [for(i=[0:len(outer_points)-1]) i],
    [for(i=[0:len(inner_points)-1]) len(outer_points)+i]
  ])

  [outer_points, inner_points]
);

function make_column_profile_row_plate_cavity(h=1) = (
  let(length = plate_height * h)
  [
    [ length/2, 0],
    [ length/2 - slot_width/2, 0],
    [ length/2 - slot_width/2, -plate_thickness],
    [-(length/2 - slot_width/2), -plate_thickness],
    [-(length/2 - slot_width/2), 0],
    [-(length/2), 0]
  ]
);

column_profile_slot = [
  [0,  slot_width/2 + slot_padding, 0],
  [0,  slot_width/2, 0],
  [0,  slot_width/2, slot_height],
  [0, -slot_width/2, slot_height],
  [0, -slot_width/2, 0],
  [0, -slot_width/2 - slot_padding, 0],
];
