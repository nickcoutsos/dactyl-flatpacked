include <definitions.scad>
include <shape-profiles.scad>

include <BOSL2/std.scad>

use <positioning.scad>
use <placeholders.scad>
use <util.scad>

module finger_cluster_cross_support_front() extruded_polygon(finger_cluster_cross_support_front(), plate_thickness);
module finger_cluster_cross_support_back() extruded_polygon(finger_cluster_cross_support_back(), plate_thickness);

module thumb_front_cross_support(selected=[0:len(thumb_columns)-1]) extruded_polygon(thumb_front_cross_support(selected), plate_thickness);
module thumb_back_cross_support(selected=[0:len(thumb_columns)-1]) extruded_polygon(thumb_back_cross_support(selected), plate_thickness);

function transform(m, vertices) = [ for (v=vertices) takeXY(apply(m, v)) ];
function thumb_column_rotate(row) = (
  affine3d_identity()
  * move([0, thumb_column_radius, 0])
  * rot([0, 0, alpha * (1 - row)])
  * move(-[0, thumb_column_radius, 0])
);

function finger_column_rotate(row) = (
  affine3d_identity()
  * move([0, finger_column_radius, 0])
  * rot([0, 0, alpha * (2 - row)])
  * move(-[0, finger_column_radius, 0])
);

/**
 * Create a support for a column of keys
 * @param <Integer> columnIndex
 * @param <Number> extension
 */
function column_support(source, columnIndex, height=column_support_height) = (
  assert(source == "thumb" || source == "finger")
  let(place_column = function () source == "thumb" ? place_thumb_key(columnIndex, 1) : place_finger_key(columnIndex, 2))
  let(invert_place_column = function () source == "thumb" ? invert_place_thumb_key(columnIndex, 1) : un_key_place_transformation(columnIndex, 2))
  let(place_slot_back = function () source == "thumb" ? place_thumb_column_support_slot_back(columnIndex) : place_finger_column_support_slot_back(columnIndex))
  let(place_slot_front = function () source == "thumb" ? place_thumb_column_support_slot_front(columnIndex) : place_finger_column_support_slot_front(columnIndex))
  let(place_column_profile = function () source == "thumb" ? place_thumb_column_in_profile(columnIndex) : place_finger_column_in_profile(columnIndex))
  let(get_override_h = function (rowIndex) get_overrides(source, columnIndex, rowIndex)[1])

  let(column_rotate = function (row) source == "thumb" ? thumb_column_rotate(row) : finger_column_rotate(row))
  let(columns = source == "thumb" ? thumb_columns : finger_columns)
  let(column = columns[columnIndex])

  let(back_support_row = source == "thumb" ? thumb_cluster_back_support_row : finger_cluster_back_support_row)
  let(front_support_row = source == "thumb" ? thumb_cluster_front_support_row : finger_cluster_front_support_row)

  let(top_points = flatten([
    for(rowIndex=[0:len(column)-1])
    let(h = get_override_h(rowIndex))
    transform(
      column_rotate(column[rowIndex]),
      make_column_profile_row_plate_cavity(h)
    )
  ]))

  let(back_support_profile = function (rowIndex)(
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
  ))

  let (front_support_profile = function (rowIndex) (
    let(row = column[rowIndex])
    let(depth = plate_height * get_override_h(rowIndex))
    let(t = place_column_profile() * place_slot_front())
    flatten([
      // transform(column_rotate(row), [[depth/2, -height]]),
      [for(v=transform(t, column_profile_slot)) takeXY(v)],
      transform(column_rotate(row), [[-depth/2, -height]])
    ])
  ))

  let(bottom_profile = function (rowIndex) (
    let(h = get_override_h(rowIndex))
    make_column_profile_row_bottom(h)
  ))

  let(bottom_points = reverse(flatten([
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
  ])))

  concat(top_points, bottom_points)
);

module finger_cluster_support_columns(selection=[0:len(finger_columns) - 1]) {
  sides = [-1, 1] * column_support_center_offset;
  for (col=selection, side=sides) {
    place_finger_key(col, 2)
    translate([side, 0, 0])
    rotate([0, 90, 0])
    rotate([0, 0, 90])
    linear_extrude(height=column_support_thickness, center=true)
      polygon(column_support("finger", col));
  }
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
      polygon(column_support("thumb", col));
  }
}

function cross_support(source, position, columns=undef) = (
  assert(source == "finger" || source == "thumb")
  assert(position == "back" || position == "front")
  let(available_columns = source == "finger" ? finger_columns : thumb_columns)
  let(columns = list(is_undef(columns) ? [0:len(available_columns)-1] : columns))
  let(slot_placers = source == "finger" ? [
    function (col) place_finger_column_support_slot_front(col),
    function (col) place_finger_column_support_slot_back(col),
  ] : [
    function (col) place_thumb_column_support_slot_front(col),
    function (col) place_thumb_column_support_slot_back(col),
  ])
  let(left_column = source == "finger" ? first(columns) : last(columns))
  let(right_column = source == "finger" ? last(columns) : first(columns))
  let(place_slot = position == "front" ? slot_placers[0] : slot_placers[1])
  let(top_points = flatten([
    for(col=source == "finger" ? reverse(columns) : columns)
    apply(place_slot(col), column_slots_profile)
  ]))
  let(side_point_offset = [column_support_center_offset + column_support_thickness/2 + 1, 0, 0])
  let(left_side_point = apply(place_slot(left_column), -side_point_offset))
  let(right_side_point = apply(place_slot(right_column), side_point_offset))
  let(bottom_points = [
    apply(scale([1, 1, 0]), left_side_point),
    apply(scale([1, 1, 0]), right_side_point),
  ])

  concat(
    [right_side_point],
    top_points,
    [left_side_point],
    bottom_points
  )
);

function finger_cluster_cross_support_front() = cross_support("finger", "front");
function finger_cluster_cross_support_back() = cross_support("finger", "back");

function thumb_front_cross_support(columns) = cross_support("thumb", "front", columns);
function thumb_back_cross_support(columns) = cross_support("thumb", "back", columns);


color("lightcoral") finger_cluster_support_columns();
color("skyblue") finger_cluster_cross_support_front();
color("mediumseagreen") finger_cluster_cross_support_back();

color("lightcoral") thumb_support_columns();
color("skyblue") thumb_front_cross_support([0]);
color("skyblue") thumb_front_cross_support([1]);
color("skyblue") thumb_front_cross_support([2]);
color("mediumseagreen") thumb_back_cross_support([0]);
color("mediumseagreen") thumb_back_cross_support([1]);
color("mediumseagreen") thumb_back_cross_support([2]);
