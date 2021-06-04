include <definitions.scad>

column_slots_profile = [
  [+column_support_center_offset + column_support_thickness / 2 + 1, 0, slot_height*2],
  [+column_support_center_offset + column_support_thickness / 2, 0, slot_height*2],
  [+column_support_center_offset + column_support_thickness / 2, 0, slot_height],
  [+column_support_center_offset - column_support_thickness / 2, 0, slot_height],
  [+column_support_center_offset - column_support_thickness / 2, 0, slot_height*2],
  [+column_support_center_offset - column_support_thickness / 2 - 1, 0, slot_height*2],

  [-(column_support_center_offset - column_support_thickness / 2 - 1), 0, slot_height*2],
  [-(column_support_center_offset - column_support_thickness / 2), 0, slot_height*2],
  [-(column_support_center_offset - column_support_thickness / 2), 0, slot_height],
  [-(column_support_center_offset + column_support_thickness / 2), 0, slot_height],
  [-(column_support_center_offset + column_support_thickness / 2), 0, slot_height*2],
  [-(column_support_center_offset + column_support_thickness / 2 + 1), 0, slot_height*2],
];

function plate (w=1, h=1) = (
  let(width = plate_width * w)
  let(height = plate_height * h)
  let(center_offset = column_support_center_offset)

  let(outer_points = [
    [ width/2,  height/2],
    [ center_offset*w + column_support_thickness/2,  height/2],
    [ center_offset*w + column_support_thickness/2,  height/2 - column_support_thickness/2],
    [ center_offset*w - column_support_thickness/2,  height/2 - column_support_thickness/2],
    [ center_offset*w - column_support_thickness/2,  height/2],

    [ -(center_offset*w - column_support_thickness/2),  height/2],
    [ -(center_offset*w - column_support_thickness/2),  height/2 - column_support_thickness/2],
    [ -(center_offset*w + column_support_thickness/2),  height/2 - column_support_thickness/2],
    [ -(center_offset*w + column_support_thickness/2),  height/2],
    [-width/2,  height/2],

    [-width/2, -height/2],
    [ -(center_offset*w + column_support_thickness/2),  -height/2],
    [ -(center_offset*w + column_support_thickness/2),  -height/2 + column_support_thickness/2],
    [ -(center_offset*w - column_support_thickness/2),  -height/2 + column_support_thickness/2],
    [ -(center_offset*w - column_support_thickness/2),  -height/2],

    [ (center_offset*w - column_support_thickness/2),  -height/2],
    [ (center_offset*w - column_support_thickness/2),  -height/2 + column_support_thickness/2],
    [ (center_offset*w + column_support_thickness/2),  -height/2 + column_support_thickness/2],
    [ (center_offset*w + column_support_thickness/2),  -height/2],
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
    [ length/2 - column_support_thickness/2, 0],
    [ length/2 - column_support_thickness/2, -plate_thickness],
    [-(length/2 - column_support_thickness/2), -plate_thickness],
    [-(length/2 - column_support_thickness/2), 0],
    [-(length/2), 0]
  ]
);

function make_column_profile_row_bottom(h=1) = (
  let(length = plate_height * h)
  [
    [ length/2, -column_support_height],
    [-length/2, -column_support_height]
  ]
);

column_profile_slot = [
  [0, column_support_thickness*2.5/2, 0],
  [0, column_support_thickness/2, 0],
  [0, column_support_thickness/2, slot_height],
  [0, -column_support_thickness/2, slot_height],
  [0, -column_support_thickness/2, 0],
  [0, -column_support_thickness*2.5/2, 0],
];
