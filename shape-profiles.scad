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

function plate (w=1, h=1) = (
  let(width = plate_width * w)
  let(height = plate_height * h)
  let(rib_offset = (rib_spacing - rib_thickness) / 2)

  let(outer_points = [
    [ width/2,  height/2],
    [ rib_offset*w + rib_thickness/2,  height/2],
    [ rib_offset*w + rib_thickness/2,  height/2 - rib_thickness/2],
    [ rib_offset*w - rib_thickness/2,  height/2 - rib_thickness/2],
    [ rib_offset*w - rib_thickness/2,  height/2],

    [ -(rib_offset*w - rib_thickness/2),  height/2],
    [ -(rib_offset*w - rib_thickness/2),  height/2 - rib_thickness/2],
    [ -(rib_offset*w + rib_thickness/2),  height/2 - rib_thickness/2],
    [ -(rib_offset*w + rib_thickness/2),  height/2],
    [-width/2,  height/2],

    [-width/2, -height/2],
    [ -(rib_offset*w + rib_thickness/2),  -height/2],
    [ -(rib_offset*w + rib_thickness/2),  -height/2 + rib_thickness/2],
    [ -(rib_offset*w - rib_thickness/2),  -height/2 + rib_thickness/2],
    [ -(rib_offset*w - rib_thickness/2),  -height/2],

    [ (rib_offset*w - rib_thickness/2),  -height/2],
    [ (rib_offset*w - rib_thickness/2),  -height/2 + rib_thickness/2],
    [ (rib_offset*w + rib_thickness/2),  -height/2 + rib_thickness/2],
    [ (rib_offset*w + rib_thickness/2),  -height/2],
    [ width/2, -height/2]
  ])

  let(inner_points = [
    [ keyhole_length/2,  keyhole_length/2],
    [-keyhole_length/2,  keyhole_length/2],
    [-keyhole_length/2, -keyhole_length/2],
    [ keyhole_length/2, -keyhole_length/2]
  ])

  let(points = concat(outer_points, inner_points))
  let(paths = [
    [for(i=[0:len(outer_points)-1]) i],
    [for(i=[0:len(inner_points)-1]) len(outer_points)+i]
  ])

  [points, paths]
);

function make_column_profile_row_plate_cavity(h=1) = (
  let(length = plate_height * h)
  [
    [ length/2, 0],
    [ length/2 - rib_thickness/2, 0],
    [ length/2 - rib_thickness/2, -plate_thickness],
    [-(length/2 - rib_thickness/2), -plate_thickness],
    [-(length/2 - rib_thickness/2), 0],
    [-(length/2), 0]
  ]
);

function make_column_profile_row_bottom(h=1) = (
  let(length = plate_height * h)
  [
    [ length/2, -column_rib_height],
    [-length/2, -column_rib_height]
  ]
);

column_profile_slot = [
  [0, rib_thickness*2.5/2, 0],
  [0, rib_thickness/2, 0],
  [0, rib_thickness/2, slot_height],
  [0, -rib_thickness/2, slot_height],
  [0, -rib_thickness/2, 0],
  [0, -rib_thickness*2.5/2, 0],
];
