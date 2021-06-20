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
    let(is_first = rowIndex == 0)
    let(is_last = rowIndex == len(column)-1)
    let(h = get_override_h(rowIndex))
    transform(
      column_rotate(column[rowIndex]),
      make_column_profile_row_plate_cavity(h)
    )
  ]))

  let(back_points = (
    let(rowIndex = 0)
    let(h = get_override_h(rowIndex))
    transform(column_rotate(column[rowIndex]), [
      [plate_height/2*h, -column_support_height]
    ])
  ))

  let(front_points = (
    let(rowIndex = len(column)-1)
    let(h = get_override_h(rowIndex))
    transform(column_rotate(column[rowIndex]), [
      [-plate_height/2 * h, -column_support_height]
    ])
  ))

  let(back_support_profile = function (rowIndex)(
    let(row = column[rowIndex])
    let(depth = plate_height * get_override_h(rowIndex))
    let(t = place_column_profile() * place_slot_back())
    [for(v=transform(t, column_profile_slot)) takeXY(v)]
  ))

  let (front_support_profile = function (rowIndex) (
    let(row = column[rowIndex])
    let(depth = plate_height * get_override_h(rowIndex))
    let(t = place_column_profile() * place_slot_front())
    [for(v=transform(t, column_profile_slot)) takeXY(v)]
  ))

  let(bottom_profile = function (rowIndex) (
    let(row = column[rowIndex])
    transform(column_rotate(row), [
      [0, -column_support_height]
    ])
  ))

  let(bottom_points = reverse(flatten([
    for(rowIndex=[0:len(column)-1])
    let(row=column[rowIndex])
    let(is_first = rowIndex == 0)
    let(is_last = rowIndex == len(column)-1)
    let(h = get_override_h(rowIndex))
    let(row_front_bound = row + h*.5)
    let(row_back_bound = row - h*.5)
    let(has_back_support_slot = back_support_row >= row_back_bound && back_support_row < row_front_bound)
    let(has_front_support_slot = front_support_row >= row_back_bound && front_support_row < row_front_bound)
    let(has_both_slots = has_back_support_slot && has_front_support_slot)

    has_both_slots
      ? concat(back_support_profile(rowIndex), front_support_profile(rowIndex))
      : has_back_support_slot
        ? back_support_profile(rowIndex)
        : has_front_support_slot
          ? front_support_profile(rowIndex)
          : bottom_profile(rowIndex)
  ])))

  concat(back_points, top_points, front_points, [for(v=bottom_points) [v.x, v.y]])
);

module finger_cluster_support_columns(selection=[0:len(finger_columns) - 1]) {
  sides = [-1, 1] * column_support_center_offset;
  for (col=selection) {
    width = get_column_width("finger", col);
    for(side=sides) {
      place_finger_key(col, 2)
      translate([side * width, 0, 0])
      rotate([0, 90, 0])
      rotate([0, 0, 90])
      linear_extrude(height=column_support_thickness, center=true)
        polygon(column_support("finger", col));
    }
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
  let(key_placer = source == "finger" ? function(col, row) place_finger_key(col, row) : function(col, row) place_thumb_key(col, row))
  let(slot_placers = source == "finger" ? [
    function (col) place_finger_column_support_slot_front(col),
    function (col) place_finger_column_support_slot_back(col),
  ] : [
    function (col) place_thumb_column_support_slot_front(col),
    function (col) place_thumb_column_support_slot_back(col),
  ])
  let(left_column = source == "finger" ? first(columns) : last(columns))
  let(left_column_u = get_column_width(source, left_column))
  let(right_column = source == "finger" ? last(columns) : first(columns))
  let(right_column_u = get_column_width(source, right_column))
  let(place_slot = position == "front" ? slot_placers[0] : slot_placers[1])
  let(slot_center_point = [0, 0, slot_height*2])
  let(top_points = flatten([
    for(col=source == "finger" ? reverse(columns) : columns)
    let(column_u = get_column_width(source, col))
    let(needs_switch_cutout = any([
      for(row=available_columns[col])
      let(switch_position = matrix_inverse(place_slot(col)) * key_placer(col, row))
      let(switch_housing_bottom = apply(switch_position, cube([keyhole_length + plate_thickness/2, keyhole_length + plate_thickness/2, 5], anchor=TOP)))
      vnf_contains_point(switch_housing_bottom, slot_center_point)
    ]))
    let(needs_switch_nub_cutout = any([
      for(row=available_columns[col])
      let(switch_position = matrix_inverse(place_slot(col)) * key_placer(col, row))
      let(switch_nub_bottom = apply(switch_position, cube([4, 4, 8], anchor=TOP)))
      vnf_contains_point(switch_nub_bottom, slot_center_point)
    ]))

    apply(place_slot(col), make_column_slots_profile(
      u=column_u,
      include_switch_cutout=needs_switch_cutout,
      include_switch_nub=needs_switch_nub_cutout
    ))
  ]))

  let(left_side_point = apply(
    place_slot(left_column),
    last(make_column_slots_profile(u=left_column_u)) - [0, 0, slot_height*2]
  ))

  let(right_side_point = apply(
    place_slot(right_column),
    first(make_column_slots_profile(u=right_column_u)) - [0, 0, slot_height*2]
  ))

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
