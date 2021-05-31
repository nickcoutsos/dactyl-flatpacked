include <definitions.scad>
include <../common/shape-profiles.scad>

use <positioning.scad>
use <../placeholders.scad>
use <../structures.scad>
use <../util.scad>

use <../scad-utils/linalg.scad>
use <../scad-utils/transformations.scad>

/**
 * Create a support for a column of keys
 * @param <Integer> columnIndex
 * @param <Number> extension
 */
module column_support(columnIndex, extension=0, height=column_rib_height) {
  h = is_undef($h) ? 1 : $h;
  depth = plate_height * h;

  keywell_points = [
    [depth/2, 0],
    [depth/2 - rib_thickness/2, 0],
    [depth/2 - rib_thickness/2, -plate_thickness],
    [-(depth/2 - rib_thickness/2), -plate_thickness],
    [-(depth/2 - rib_thickness/2), 0],
    [-(depth/2), 0]
  ];

  function transform(m, vertices) = [ for (v=vertices) takeXY(m * [v.x, v.y, 0, 1]) ];
  function rotate_keyplace(row) = (
    identity4()
    * translation([0, main_row_radius, 0])
    * rotation([0, 0, alpha * (2 - row)])
    * translation(-[0, main_row_radius, 0])
  );

  top = first(columns[columnIndex]);
  bottom = last(columns[columnIndex]);
  top_points = flatten([
    for(i=[top:bottom])
    transform(rotate_keyplace(i), keywell_points)
  ]);

  bottom_points = reverse(flatten([
    for(i=[top:bottom])
    transform(rotate_keyplace(i), [
      [ plate_height/2, -height],
      [ -plate_height/2, -height]
    ])
  ]));

  points = concat(top_points, bottom_points);
  polygon(points);
}

main_supports();

module main_supports() {
  main_support_columns();
}

module main_support_columns(selection=[0:len(columns) - 1]) {
  sides = [-1, 1] * column_rib_center_offset;

  difference() {
    for (col=selection, side=sides) {
      rows = column_range(col);

      key_place(col, 2)
      translate([side, 0, 0])
      rotate([0, 90, 0])
      rotate([0, 0, 90])
      linear_extrude(height=rib_thickness, center=true)
        column_support(col);

      main_support_front(col, side);
      main_support_back(col, side);
    }

    if (!is_undef($detail) && $detail) {
      for (col=selection, side=sides) {
        // for (row=columns[col]) key_place(col, row) key_well();
        main_support_front_slot(col, side);
        main_support_back_slot(col, side);
      }
    }
  }
}

module main_support_front(col, offset) {
  front_row = last(columns[col]);
  hull() {
    place_column_support_slot_front(col)
      translate([offset, 0, slot_height/2])
      cube([rib_thickness, rib_thickness*2.5, slot_height], center=true);

    key_place(col, front_row)
    translate([offset, 0, -column_rib_height + plate_thickness/2])
    cube([rib_thickness, plate_height, plate_thickness], center=true);

    *key_place(col, 2)
    translate([offset, 0, main_row_radius])
    rotate([0, 90, 0])
      linear_extrude(rib_thickness, center=true)
      fan(
        (main_row_radius+column_rib_height-.01),
        main_row_radius+column_rib_height,
        -alpha*(last(columns[col]) - 2 + 0*rib_extension),
        -alpha*0.5
      );
  }
}

module main_support_back(col, offset) {
  back_row = first(columns[col]);
  hull() {
    place_column_support_slot_back(col)
      translate([offset, 0, slot_height/2])
      cube([rib_thickness, rib_thickness*2.5, slot_height], center=true);

    key_place(col, back_row)
    translate([offset, 0, -column_rib_height + plate_thickness/2])
    cube([rib_thickness, plate_height, plate_thickness], center=true);
  }
}

module main_support_front_slot(col, offset) {
  place_column_support_slot_front(col)
  translate([offset, 0, 0])
    cube([rib_thickness+1, rib_thickness, slot_height*2], center=true);
}

module main_support_back_slot(col, offset) {
  place_column_support_slot_back(col)
  translate([offset, 0, 0])
    cube([rib_thickness+1, rib_thickness, slot_height*2], center=true);
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

module main_inner_column_cross_support() {
  difference() {
    key_place(0, 2.5)
    rotate([90, 0, 0])
    translate([0, main_column_radius, 0])
    linear_extrude(height=rib_thickness, center=true)
    fan(
      main_column_radius+column_rib_height/2,
      main_column_radius+column_rib_height+2,
      -90 + beta * 1.5,
      -90 + beta * -.5
    );

    #main_supports();
  }
}
