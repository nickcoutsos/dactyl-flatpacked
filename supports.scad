include <definitions.scad>
include <shape-profiles.scad>

include <BOSL2/std.scad>
include <BOSL2/fnliterals.scad>

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

function get_row_index_containing_back_slot (cluster, columnIndex) = (
  let(back_support_row = cluster == "thumb" ? thumb_cluster_back_support_row : finger_cluster_back_support_row)
  let(columns = cluster == "finger" ? finger_columns : thumb_columns)
  let(column = columns[columnIndex])

  find_first(function (rowIndex) (
    let(row=column[rowIndex])
    let(is_first = rowIndex == 0)
    let(is_last = rowIndex == len(column)-1)
    let(h = get_overrides(cluster, columnIndex, rowIndex)[1])
    let(row_front_bound = row + h*.5)
    let(row_back_bound = row - h*.5)

    back_support_row >= row_back_bound && back_support_row < row_front_bound
  ), list([0:len(column)-1]))
);

function get_row_index_containing_front_slot (cluster, columnIndex) = (
  let(front_support_row = cluster == "thumb" ? thumb_cluster_front_support_row : finger_cluster_front_support_row)
  let(columns = cluster == "finger" ? finger_columns : thumb_columns)
  let(column = columns[columnIndex])

  find_first(function (rowIndex) (
    let(row=column[rowIndex])
    let(is_first = rowIndex == 0)
    let(is_last = rowIndex == len(column)-1)
    let(h = get_overrides(cluster, columnIndex, rowIndex)[1])
    let(row_front_bound = row + h*.5)
    let(row_back_bound = row - h*.5)

    front_support_row >= row_back_bound && front_support_row < row_front_bound
  ), list([0:len(column)-1]))
);

/**
 * Create a support for a column of keys
 * @param <Integer> columnIndex
 * @param <Number> extension
 */
function column_support(cluster, columnIndex, height=column_support_height) = (
  assert(cluster == "thumb" || cluster == "finger")
  let(place_column = function () cluster == "thumb" ? place_thumb_key(columnIndex, 1) : place_finger_key(columnIndex, 2))
  let(invert_place_column = function () cluster == "thumb" ? invert_place_thumb_key(columnIndex, 1) : un_key_place_transformation(columnIndex, 2))
  let(place_column_profile = function () cluster == "thumb" ? place_thumb_column_in_profile(columnIndex) : place_finger_column_in_profile(columnIndex))
  let(get_override_h = function (rowIndex) get_overrides(cluster, columnIndex, rowIndex)[1])

  let(column_rotate = function (row) cluster == "thumb" ? thumb_column_rotate(row) : finger_column_rotate(row))
  let(columns = cluster == "thumb" ? thumb_columns : finger_columns)
  let(column = columns[columnIndex])

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
    let(t = place_column_profile() * place_support_slot(cluster, "back", columnIndex))
    [for(v=transform(t, column_profile_slot)) takeXY(v)]
  ))

  let (front_support_profile = function (rowIndex) (
    let(row = column[rowIndex])
    let(depth = plate_height * get_override_h(rowIndex))
    let(t = place_column_profile() * place_support_slot(cluster, "front", columnIndex))
    [for(v=transform(t, column_profile_slot)) takeXY(v)]
  ))

  let(bottom_profile = function (rowIndex) (
    let(row = column[rowIndex])
    transform(column_rotate(row), [
      [0, -column_support_height]
    ])
  ))

  let(row_containing_back_slot = get_row_index_containing_back_slot(cluster, columnIndex))
  let(row_containing_front_slot = get_row_index_containing_front_slot(cluster, columnIndex))

  let(bottom_points = reverse(flatten([
    for(rowIndex=[0:len(column)-1])
    let(has_back_support_slot = row_containing_back_slot == rowIndex)
    let(has_front_support_slot = row_containing_front_slot == rowIndex)
    let(has_both_slots = has_back_support_slot && has_front_support_slot)

    has_both_slots
      ? concat(back_support_profile(rowIndex), front_support_profile(rowIndex))
      : has_back_support_slot
        ? back_support_profile(rowIndex)
        : has_front_support_slot
          ? front_support_profile(rowIndex)
          : bottom_profile(rowIndex)
  ])))

  // TODO: the small `slot_depth` can result in very thin protrusions at the
  // ends of the support columns that may snap off. Should these just be removed
  // to avoid more serious damage, or shortened so that there's less leverage to
  // cause them to break off?
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

function cross_support(cluster, position, columns=undef) = (
  assert(cluster == "finger" || cluster == "thumb")
  assert(position == "back" || position == "front")
  let(available_columns = cluster == "finger" ? finger_columns : thumb_columns)
  let(columns = list(is_undef(columns) ? [0:len(available_columns)-1] : columns))
  let(key_placer = cluster == "finger" ? function(col, row) place_finger_key(col, row) : function(col, row) place_thumb_key(col, row))
  let(left_column = cluster == "finger" ? first(columns) : last(columns))
  let(left_column_u = get_column_width(cluster, left_column))
  let(right_column = cluster == "finger" ? last(columns) : first(columns))
  let(right_column_u = get_column_width(cluster, right_column))

  // TODO: use switch specs instead of hardcoding switch and nub size
  // TODO: also, explain that "nub" refers to the protrusion on the switch base
  // where the spring extends.
  let(switch_base_poly = [for(v=square([14, 14 + plate_thickness], center=true)) [v.x, v.y, -5]])
  let(switch_nub_poly = [for(v=square([4, 4 + plate_thickness], center=true)) [v.x, v.y, -8]])
  let(top_points = flatten([
    for(col=cluster == "finger" ? reverse(columns) : columns)
    let(row_index = position == "front"
      ? get_row_index_containing_front_slot(cluster, col)
      : get_row_index_containing_back_slot(cluster, col)
    )
    let(row = available_columns[col][row_index])
    let(column_u = get_column_width(cluster, col))
    let(transform = matrix_inverse(place_support_slot(cluster, position, col)) * key_placer(col, row))
    let(switch_base_line_test = [[-5, 0, -slot_height], [-5, 0, slot_height*2]])
    let(switch_base_poly_test = apply(transform, switch_base_poly))
    let(switch_base_intersection = polygon_line_intersection(switch_base_poly_test, switch_base_line_test, bounded=true))
    let(switch_nub_line_test = [[0, 0, -slot_height], [0, 0, slot_height*2]])
    let(switch_nub_poly_test = apply(transform, switch_nub_poly))
    let(switch_nub_intersection = polygon_line_intersection(switch_nub_poly_test, switch_nub_line_test, bounded=true))
    let(switch_base_intersection_height = min([slot_height*2, switch_base_intersection ? switch_base_intersection.z - 1 : undef]))
    let(switch_nub_intersection_height = min([switch_base_intersection_height, switch_nub_intersection ? switch_nub_intersection.z - 1 : undef]))

    apply(place_support_slot(cluster, position, col), make_column_slots_profile(
      u=column_u,
      switch_base_intersection_height=switch_base_intersection_height,
      switch_nub_intersection_height=switch_nub_intersection_height
    ))
  ]))

  let(left_side_point = apply(
    place_support_slot(cluster, position, left_column),
    last(make_column_slots_profile(u=left_column_u)) - [0, 0, slot_height*2]
  ))

  let(right_side_point = apply(
    place_support_slot(cluster, position, right_column),
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
