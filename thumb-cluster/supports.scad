include <../definitions.scad>
include <../common/shape-profiles.scad>

use <../scad-utils/linalg.scad>
use <../scad-utils/transformations.scad>
use <../positioning.scad>
use <../placeholders.scad>
use <../util.scad>

function transform(m, vertices) = [ for (v=vertices) takeXY(m * [v.x, v.y, 0, 1]) ];
function thumb_column_rotate(row) = (
  identity4()
  * translation([0, thumb_column_radius, 0])
  * rotation([0, 0, alpha * (1 - row)])
  * translation(-[0, thumb_column_radius, 0])
);

function finger_column_rotate(row) = (
  identity4()
  * translation([0, finger_column_radius, 0])
  * rotation([0, 0, alpha * (2 - row)])
  * translation(-[0, finger_column_radius, 0])
);

/**
 * Create a support for a column of keys
 * @param <Integer> columnIndex
 * @param <Number> extension
 */
module column_support(source, columnIndex, height=column_rib_height) {
  assert(source == "thumb" || source == "finger");
  place_column = function () source == "thumb" ? place_thumb_key(columnIndex, 1) : place_finger_key(columnIndex, 2);
  invert_place_column = function () source == "thumb" ? invert_place_thumb_key(columnIndex, 1) : un_key_place_transformation(columnIndex, 2);
  place_slot_back = function () source == "thumb" ? place_thumb_column_support_slot_back(columnIndex) : place_finger_column_support_slot_back(columnIndex);
  place_slot_front = function () source == "thumb" ? place_thumb_column_support_slot_front(columnIndex) : place_finger_column_support_slot_front(columnIndex);
  get_override_h = function (rowIndex) get_overrides(source, columnIndex, rowIndex)[1];

  column_rotate = function (row) source == "thumb" ? thumb_column_rotate(row) : finger_column_rotate(row);
  columns = source == "thumb" ? thumb_columns : finger_columns;
  column = columns[columnIndex];

  back_support_row = source == "thumb" ? thumb_cluster_back_support_row : finger_cluster_back_support_row;
  front_support_row = source == "thumb" ? thumb_cluster_front_support_row : finger_cluster_front_support_row;

  top_points = flatten([
    for(rowIndex=[0:len(column)-1])
    let(depth = plate_height * get_override_h(rowIndex))
    transform(column_rotate(column[rowIndex]), [
      [ depth/2, 0],
      [ depth/2 - rib_thickness/2, 0],
      [ depth/2 - rib_thickness/2, -plate_thickness],
      [-(depth/2 - rib_thickness/2), -plate_thickness],
      [-(depth/2 - rib_thickness/2), 0],
      [-(depth/2), 0]
    ])
  ]);

  function back_support_profile(rowIndex) = (
    let(row = column[rowIndex])
    let(depth = plate_height * get_override_h(rowIndex))
    let(t = (
      identity4()
      * rotation([0, 0, -90])
      * rotation([0, -90, 0])
      * invert_place_column()
      * place_slot_back()
    ))
    [
      transform(column_rotate(row), [[depth/2, -height]])[0],
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
      // transform(column_rotate(row), [[-depth/2, -height]])[0]
    ]
  );

  function front_support_profile(rowIndex) = (
    let(row = column[rowIndex])
    let(depth = plate_height * get_override_h(rowIndex))
    let(t = (
      identity4()
      * rotation([0, 0, -90])
      * rotation([0, -90, 0])
      * invert_place_column()
      * place_slot_front()
    ))
    [
      // transform(column_rotate(row), [[depth/2, -height]])[0],
      takeXY(t * [0, rib_thickness*2.5/2, 0, 1]),
      takeXY(t * [0, rib_thickness/2, 0, 1]),
      takeXY(t * [0, rib_thickness/2, slot_height, 1]),
      takeXY(t * [0, -rib_thickness/2, slot_height, 1]),
      takeXY(t * [0, -rib_thickness/2, 0, 1]),
      takeXY(t * [0, -rib_thickness*2.5/2, 0, 1]),
      transform(column_rotate(row), [[-depth/2, -height]])[0]
    ]
  );

  function bottom_profile(rowIndex) = (
    let(depth = plate_height * get_override_h(rowIndex))
    [
      [ depth/2, -height],
      [-depth/2, -height]
    ]
  );

  bottom_points = reverse(flatten([
    for(rowIndex=[0:len(column)-1])
    let(row=column[rowIndex])
    let(h = get_override_h(rowIndex))
    let(row_front_bound = row + h*.5)
    let(row_back_bound = row - h*.5)
    let(has_back_support_slot = back_support_row >= row_back_bound && back_support_row < row_front_bound)
    let(has_front_support_slot = front_support_row >= row_back_bound && front_support_row < row_front_bound)

    // TODO: simplify this logic
    (has_back_support_slot && has_front_support_slot) ? (
      concat(back_support_profile(rowIndex), front_support_profile(rowIndex))
    ) : (has_back_support_slot ? (
      back_support_profile(rowIndex)
    ) : (
    has_front_support_slot ?
      front_support_profile(rowIndex)
      : transform(column_rotate(row), bottom_profile(rowIndex))
    ))
  ]));

  points = concat(top_points, bottom_points);
  polygon(points);
}

module thumb_support_columns(selected=[0:len(thumb_columns) - 1]) {
  sides = [-1, 1] * column_rib_center_offset;

  for (col=selected, side=sides) {
    rows = thumb_columns[col];

    place_thumb_key(col, 1)
    translate([side, 0, 0])
    rotate([0, 90, 0])
    rotate([0, 0, 90])
    linear_extrude(height=rib_thickness, center=true)
      column_support("thumb", col);
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
