include <definitions.scad>
include <shape-profiles.scad>

use <scad-utils/linalg.scad>
use <scad-utils/transformations.scad>
use <positioning.scad>
use <placeholders.scad>
use <util.scad>

function transform(m, vertices) = [ for (v=vertices) takeXY(m * vec4(v)) ];
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
module column_support(source, columnIndex, height=column_support_height) {
  assert(source == "thumb" || source == "finger");
  place_column = function () source == "thumb" ? place_thumb_key(columnIndex, 1) : place_finger_key(columnIndex, 2);
  invert_place_column = function () source == "thumb" ? invert_place_thumb_key(columnIndex, 1) : un_key_place_transformation(columnIndex, 2);
  place_slot_back = function () source == "thumb" ? place_thumb_column_support_slot_back(columnIndex) : place_finger_column_support_slot_back(columnIndex);
  place_slot_front = function () source == "thumb" ? place_thumb_column_support_slot_front(columnIndex) : place_finger_column_support_slot_front(columnIndex);
  place_column_profile = function () source == "thumb" ? place_thumb_column_in_profile(columnIndex) : place_finger_column_in_profile(columnIndex);
  get_override_h = function (rowIndex) get_overrides(source, columnIndex, rowIndex)[1];

  column_rotate = function (row) source == "thumb" ? thumb_column_rotate(row) : finger_column_rotate(row);
  columns = source == "thumb" ? thumb_columns : finger_columns;
  column = columns[columnIndex];

  back_support_row = source == "thumb" ? thumb_cluster_back_support_row : finger_cluster_back_support_row;
  front_support_row = source == "thumb" ? thumb_cluster_front_support_row : finger_cluster_front_support_row;

  top_points = flatten([
    for(rowIndex=[0:len(column)-1])
    let(h = get_override_h(rowIndex))
    transform(
      column_rotate(column[rowIndex]),
      make_column_profile_row_plate_cavity(h)
    )
  ]);

  function back_support_profile(rowIndex) = (
    let(row = column[rowIndex])
    let(depth = plate_height * get_override_h(rowIndex))
    let(t = place_column_profile() * place_slot_back())
    flatten([
      transform(column_rotate(row), [[depth/2, -height]]),
      [for(v=transform(t, column_profile_slot)) takeXY(v)],
      /*
       * Originally this point is added to return to the normal column support
       * height, but in the event that a column support has both front and back
       * support slots under the same row section this would cause interference.
       */
      // TODO: can this be done more elegantly based on the known length (plate
      // height) at this section? Likewise for analogous point in the
      // front_support_profile() function.
      // transform(column_rotate(row), [[-depth/2, -height]])
    ])
  );

  function front_support_profile(rowIndex) = (
    let(row = column[rowIndex])
    let(depth = plate_height * get_override_h(rowIndex))
    let(t = place_column_profile() * place_slot_front())
    flatten([
      // transform(column_rotate(row), [[depth/2, -height]]),
      [for(v=transform(t, column_profile_slot)) takeXY(v)],
      transform(column_rotate(row), [[-depth/2, -height]])
    ])
  );

  function bottom_profile(rowIndex) = (
    let(h = get_override_h(rowIndex))
    make_column_profile_row_bottom(h)
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

module finger_cluster_support_columns(selection=[0:len(finger_columns) - 1]) {
  sides = [-1, 1] * column_support_center_offset;
  for (col=selection, side=sides) {
    place_finger_key(col, 2)
    translate([side, 0, 0])
    rotate([0, 90, 0])
    rotate([0, 0, 90])
    linear_extrude(height=column_support_thickness, center=true)
      column_support("finger", col);
  }
}

module finger_cluster_cross_support_front() {
  top_points = flatten([
    for(col=reverse(list([0:len(finger_columns)-1])))
    let(position = place_finger_column_support_slot_front(col))
    [for(v=column_slots_profile) take3(position * vec4(v))]
  ]);

  right_side_point = take3(place_finger_column_support_slot_front(len(finger_columns)-1) * [+column_support_center_offset + column_support_thickness/2 + 1, 0, 0, 1]);
  left_side_point = take3(place_finger_column_support_slot_front(0) * [-(column_support_center_offset + column_support_thickness/2 + 1), 0, 0, 1]);
  bottom_points = [
    take3(scaling([1, 1, 0]) * vec4(left_side_point)),
    take3(scaling([1, 1, 0]) * vec4(right_side_point)),
  ];

  points = concat([right_side_point], top_points, [left_side_point], bottom_points);

  extruded_polygon([for(v=points) [v.x, v.y, v.z]], plate_thickness);
}

module finger_cluster_cross_support_back() {
  top_points = flatten([
    for(col=reverse(list([0:len(finger_columns)-1])))
    let(position = place_finger_column_support_slot_back(col))
    [for(v=column_slots_profile) take3(position * vec4(v))]
  ]);

  right_side_point = take3(place_finger_column_support_slot_back(len(finger_columns)-1) * [+column_support_center_offset + column_support_thickness/2 + 1, 0, 0, 1]);
  left_side_point = take3(place_finger_column_support_slot_back(0) * [-(column_support_center_offset + column_support_thickness/2 + 1), 0, 0, 1]);
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

module thumb_support_columns(selected=[0:len(thumb_columns) - 1]) {
  sides = [-1, 1] * column_support_center_offset;

  for (col=selected, side=sides) {
    rows = thumb_columns[col];

    place_thumb_key(col, 1)
    translate([side, 0, 0])
    rotate([0, 90, 0])
    rotate([0, 0, 90])
    linear_extrude(height=column_support_thickness, center=true)
      column_support("thumb", col);
  }
}

module thumb_front_cross_support() {
  top_points = flatten([
    for(col=list([0:len(thumb_columns)-1]))
    let(position = place_thumb_column_support_slot_front(col))
    [for(v=column_slots_profile) take3(position * vec4(v))]
  ]);

  left_side_point = take3(place_thumb_column_support_slot_front(len(thumb_columns)-1) * [-(column_support_center_offset + column_support_thickness/2 + 1), 0, 0, 1]);
  right_side_point = take3(place_thumb_column_support_slot_front(0) * [+(column_support_center_offset + column_support_thickness/2 + 1), 0, 0, 1]);
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

  left_side_point = take3(place_thumb_column_support_slot_back(len(thumb_columns)-1) * [-(column_support_center_offset + column_support_thickness/2 + 1), 0, 0, 1]);
  right_side_point = last(top_points);
  bottom_points = [
    take3(scaling([1, 1, 0]) * vec4(left_side_point)),
    take3(scaling([1, 1, 0]) * vec4(first(top_points))),
  ];

  points = concat(top_points, [left_side_point], bottom_points);
  extruded_polygon([for(v=points) [v.x, v.y, v.z]], plate_thickness);
}

color("lightcoral") finger_cluster_support_columns();
color("skyblue") finger_cluster_cross_support_front();
color("mediumseagreen") finger_cluster_cross_support_back();

color("lightcoral") thumb_support_columns();
color("skyblue") thumb_front_cross_support();
color("mediumseagreen") thumb_back_cross_support();
