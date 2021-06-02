include <../definitions.scad>
include <../common/shape-profiles.scad>

use <../scad-utils/linalg.scad>
use <../scad-utils/transformations.scad>
use <../positioning.scad>
use <../placeholders.scad>
use <../util.scad>

function transform(m, vertices) = [ for (v=vertices) takeXY(m * [v.x, v.y, 0, 1]) ];
function rotate_keyplace(row) = (
  identity4()
  * translation([0, thumb_column_radius, 0])
  * rotation([0, 0, alpha * row])
  * translation(-[0, thumb_column_radius, 0])
);

/**
 * Create a support for a column of keys
 * @param <Integer> columnIndex
 * @param <Number> extension
 */
module column_support(columnIndex, extension=0, height=column_rib_height) {
  column = thumb_columns[columnIndex];
  front = first(column);
  back = last(column);
  top_points = flatten([
    for(rowIndex=[0:len(column)-1])
    let(override = get_overrides("thumb", columnIndex, rowIndex))
    let(h = override[1])
    let(depth = plate_height * h)
    transform(rotate_keyplace(column[rowIndex]), reverse([
      [ depth/2, 0],
      [ depth/2 - rib_thickness/2, 0],
      [ depth/2 - rib_thickness/2, -plate_thickness],
      [-(depth/2 - rib_thickness/2), -plate_thickness],
      [-(depth/2 - rib_thickness/2), 0],
      [-(depth/2), 0]
    ]))
  ]);

  function back_support_profile(rowIndex) = (
    let(row = column[rowIndex])
    let(override = get_overrides("thumb", columnIndex, rowIndex))
    let(h = override[1])
    let(depth = plate_height * h)
    let(t = (
      identity4()
      * rotation([0, 0, -90])
      * rotation([0, -90, 0])
      * invert_place_thumb_key(columnIndex, 0)
      * place_thumb_column_support_slot_back(columnIndex)
    ))
    reverse([
      transform(rotate_keyplace(row), [[depth/2, -height]])[0],
      takeXY(t * [0, rib_thickness*2.5/2, 0, 1]),
      takeXY(t * [0, rib_thickness/2, 0, 1]),
      takeXY(t * [0, rib_thickness/2, slot_height, 1]),
      takeXY(t * [0, -rib_thickness/2, slot_height, 1]),
      takeXY(t * [0, -rib_thickness/2, 0, 1]),
      takeXY(t * [0, -rib_thickness*2.5/2, 0, 1]),
      /*
       * Originally this point is added to return to the normal column support
       * height, but in the event that a column support has both front and back
       * support slots under the same row section this would cause interference.
       */
      // TODO: can this be done more elegantly based on the known length (plate
      // height) at this section? Likewise for analogous point in the
      // front_support_profile() function.
      // transform(rotate_keyplace(row), [[-depth/2, -height]])[0]
    ])
  );

  function front_support_profile(rowIndex) = (
    let(row = column[rowIndex])
    let(override = get_overrides("thumb", columnIndex, rowIndex))
    let(h = override[1])
    let(depth = plate_height * h)
    let(t = (
      identity4()
      * rotation([0, 0, -90])
      * rotation([0, -90, 0])
      * invert_place_thumb_key(columnIndex, 0)
      * place_thumb_column_support_slot_front(columnIndex)
    ))
    reverse([
      // transform(rotate_keyplace(row), [[depth/2, -height]])[0],
      takeXY(t * [0, rib_thickness*2.5/2, 0, 1]),
      takeXY(t * [0, rib_thickness/2, 0, 1]),
      takeXY(t * [0, rib_thickness/2, slot_height, 1]),
      takeXY(t * [0, -rib_thickness/2, slot_height, 1]),
      takeXY(t * [0, -rib_thickness/2, 0, 1]),
      takeXY(t * [0, -rib_thickness*2.5/2, 0, 1]),
      transform(rotate_keyplace(row), [[-depth/2, -height]])[0]
    ])
  );

  function bottom_profile(rowIndex) = (
    let(override = get_overrides("thumb", columnIndex, rowIndex))
    let(h = override[1])
    let(depth = plate_height * h)
    reverse([
      [ depth/2, -height],
      [-depth/2, -height]
    ])
  );

  bottom_points = reverse(flatten([
    for(rowIndex=[0:len(column)-1])
    let(row=column[rowIndex])
    let(override = get_overrides("thumb", columnIndex, rowIndex))
    let(h = override[1])
    let(is_only_row = len(column) == 1)
    let(has_back_support_slot = round(row) == round(thumb_cluster_back_support_row))
    let(has_front_support_slot = round(row) == round(thumb_cluster_front_support_row))
    let(is_lowest_above_back_slot = rowIndex == 0 && row + (h * .5) > thumb_cluster_back_support_row)

    // TODO: simplify this logic
    is_only_row || is_lowest_above_back_slot || (has_back_support_slot && has_front_support_slot) ? (
      concat(front_support_profile(rowIndex), back_support_profile(rowIndex))
    ) : (has_back_support_slot ? (
      back_support_profile(rowIndex)
    ) : (has_front_support_slot ?
      front_support_profile(rowIndex)
      : transform(rotate_keyplace(row), bottom_profile(rowIndex))
    ))
  ]));

  points = concat(top_points, bottom_points);
  polygon(points);
}

module thumb_support_columns(selected=[0:len(thumb_columns) - 1]) {
  sides = [-1, 1] * column_rib_center_offset;

  for (col=selected, side=sides) {
    rows = thumb_columns[col];

    place_thumb_key(col, 0)
    translate([side, 0, 0])
    rotate([0, 90, 0])
    rotate([0, 0, 90])
    linear_extrude(height=rib_thickness, center=true)
      column_support(col);
  }
}

module thumb_front_cross_support() {
  top_points = flatten([
    for(col=list([0:len(thumb_columns)-1]))
    let(position = place_thumb_column_support_slot_front(col))
    [for(v=column_slots_profile) take3(position * vec4(v))]
  ]);

  left_side_point = take3(place_thumb_column_support_slot_front(len(thumb_columns)-1) * [-(column_rib_center_offset + rib_thickness/2 + 1), 0, 0, 1]);
  right_side_point = take3(place_thumb_column_support_slot_front(0) * [+(column_rib_center_offset + rib_thickness/2 + 1), 0, 0, 1]);
  bottom_points = [
    take3(scaling([1, 1, 0]) * vec4(left_side_point)),
    take3(scaling([1, 1, 0]) * vec4(first(top_points))),
  ];

  points = concat(top_points, [left_side_point], bottom_points);
  extruded_polygon([for(v=points) [v.x, v.y, v.z]], plate_thickness);
}

module thumb_back_cross_support() {
  top_points = flatten([
    for(col=list([0:len(thumb_columns)-1]))
    let(position = place_thumb_column_support_slot_back(col))
    [for(v=column_slots_profile) take3(position * vec4(v))]
  ]);

  left_side_point = take3(place_thumb_column_support_slot_back(len(thumb_columns)-1) * [-(column_rib_center_offset + rib_thickness/2 + 1), 0, 0, 1]);
  right_side_point = last(top_points);
  bottom_points = [
    take3(scaling([1, 1, 0]) * vec4(left_side_point)),
    take3(scaling([1, 1, 0]) * vec4(first(top_points))),
  ];

  points = concat(top_points, [left_side_point], bottom_points);
  extruded_polygon([for(v=points) [v.x, v.y, v.z]], plate_thickness);
}

color("lightcoral") thumb_support_columns();
color("skyblue") thumb_front_cross_support();
color("mediumseagreen") thumb_back_cross_support();
