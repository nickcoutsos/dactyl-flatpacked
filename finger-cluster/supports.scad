include <definitions.scad>
include <../common/shape-profiles.scad>

use <positioning.scad>
use <../placeholders.scad>
use <../structures.scad>
use <../util.scad>

use <../scad-utils/linalg.scad>
use <../scad-utils/transformations.scad>

function transform(m, vertices) = [ for (v=vertices) takeXY(m * [v.x, v.y, 0, 1]) ];
function rotate_keyplace(row) = (
  identity4()
  * translation([0, main_row_radius, 0])
  * rotation([0, 0, alpha * (2 - row)])
  * translation(-[0, main_row_radius, 0])
);

/**
 * Create a support for a column of keys
 * @param <Integer> column
 * @param <Number> extension
 */
module column_support(column, extension=0, height=column_rib_height) {
  h = is_undef($h) ? 1 : $h;
  depth = plate_height * h;

  keywell_profile = [
    [ depth/2, 0],
    [ depth/2 - rib_thickness/2, 0],
    [ depth/2 - rib_thickness/2, -plate_thickness],
    [-(depth/2 - rib_thickness/2), -plate_thickness],
    [-(depth/2 - rib_thickness/2), 0],
    [-(depth/2), 0]
  ];

  bottom_profile = [
    [ depth/2, -height],
    [-depth/2, -height]
  ];

  back = first(columns[column]);
  front = last(columns[column]);
  back_and_down = transform(rotate_keyplace(back), [[depth/2, -plate_thickness]]);
  top_points = flatten([ for(i=[back:front]) transform(rotate_keyplace(i), keywell_profile) ]);

  function back_support_profile(row) = (
    let(t = (
      identity4()
      * rotation([0, 0, -90])
      * rotation([0, -90, 0])
      * un_key_place_transformation(column, 2)
      * place_column_support_slot_back(column)
    ))
    [
      transform(rotate_keyplace(row), [[depth/2, -height]])[0],
      takeXY(t * [0, rib_thickness*2.5/2, 0, 1]),
      takeXY(t * [0, rib_thickness/2, 0, 1]),
      takeXY(t * [0, rib_thickness/2, slot_height, 1]),
      takeXY(t * [0, -rib_thickness/2, slot_height, 1]),
      takeXY(t * [0, -rib_thickness/2, 0, 1]),
      takeXY(t * [0, -rib_thickness*2.5/2, 0, 1]),
      transform(rotate_keyplace(row), [[-depth/2, -height]])[0]
    ]
  );

  function front_support_profile(row) = (
    let(t = (
      identity4()
      * rotation([0, 0, -90])
      * rotation([0, -90, 0])
      * un_key_place_transformation(column, 2)
      * place_column_support_slot_front(column)
    ))
    [
      transform(rotate_keyplace(row), [[depth/2, -height]])[0],
      takeXY(t * [0, rib_thickness*2.5/2, 0, 1]),
      takeXY(t * [0, rib_thickness/2, 0, 1]),
      takeXY(t * [0, rib_thickness/2, slot_height, 1]),
      takeXY(t * [0, -rib_thickness/2, slot_height, 1]),
      takeXY(t * [0, -rib_thickness/2, 0, 1]),
      takeXY(t * [0, -rib_thickness*2.5/2, 0, 1]),
      transform(rotate_keyplace(row), [[-depth/2, -height]])[0]
    ]
  );

  bottom_points = reverse(flatten([
    for(i=[back:front])
    i == round(back_support_row)
      ? back_support_profile(i)
      : (i == round(front_support_row)
          ? front_support_profile(i)
          : transform(rotate_keyplace(i), bottom_profile)
      )
  ]));

  points = concat(back_and_down, top_points, bottom_points);
  polygon(points);
}

module main_support_columns(selection=[0:len(columns) - 1]) {
  sides = [-1, 1] * column_rib_center_offset;
  for (col=selection, side=sides) {
    rows = column_range(col);

    key_place(col, 2)
    translate([side, 0, 0])
    rotate([0, 90, 0])
    rotate([0, 0, 90])
    linear_extrude(height=rib_thickness, center=true)
      column_support(col);
  }
}

module main_front_cross_support() {
  top_points = flatten([
    for(col=reverse(list([0:len(columns)-1])))
    let(position = place_column_support_slot_front(col))
    [for(v=column_slots_profile) take3(position * vec4(v))]
  ]);

  right_side_point = take3(place_column_support_slot_front(len(columns)-1) * [+column_rib_center_offset + rib_thickness/2 + 1, 0, 0, 1]);
  left_side_point = take3(place_column_support_slot_front(0) * [-(column_rib_center_offset + rib_thickness/2 + 1), 0, 0, 1]);
  bottom_points = [
    take3(scaling([1, 1, 0]) * vec4(left_side_point)),
    take3(scaling([1, 1, 0]) * vec4(right_side_point)),
  ];

  points = concat([right_side_point], top_points, [left_side_point], bottom_points);

  extruded_polygon([for(v=points) [v.x, v.y, v.z]], plate_thickness);
}

module main_back_cross_support() {
  top_points = flatten([
    for(col=reverse(list([0:len(columns)-1])))
    let(position = place_column_support_slot_back(col))
    [for(v=column_slots_profile) take3(position * vec4(v))]
  ]);

  right_side_point = take3(place_column_support_slot_back(len(columns)-1) * [+column_rib_center_offset + rib_thickness/2 + 1, 0, 0, 1]);
  left_side_point = take3(place_column_support_slot_back(0) * [-(column_rib_center_offset + rib_thickness/2 + 1), 0, 0, 1]);
  bottom_points = [
    take3(scaling([1, 1, 0]) * vec4(left_side_point)),
    take3(scaling([1, 1, 0]) * vec4(right_side_point)),
  ];

  points = concat(
    [right_side_point],
    top_points,
    [left_side_point],
    bottom_points
  );

  extruded_polygon([for(v=points) [v.x, v.y, v.z]], plate_thickness);
}

color("lightcoral") main_support_columns();
color("skyblue") main_front_cross_support();
color("mediumseagreen") main_back_cross_support();
