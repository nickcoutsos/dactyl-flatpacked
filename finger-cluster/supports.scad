include <definitions.scad>
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
  hull()
  {
    place_column_support_slot_front(col)
      translate([offset, 0, slot_height/2])
      cube([rib_thickness, rib_thickness*2.5, slot_height], center=true);

    key_place(col, front_support_row)
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
  hull() {
    place_column_support_slot_back(col)
      translate([offset, 0, slot_height/2])
      cube([rib_thickness, rib_thickness*2.5, slot_height], center=true);

    key_place(col, back_support_row)
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
  offset = [column_rib_center_offset, 0, 0];
  hull_pairs() {
    dropdown() place_column_support_slot_front(0) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_front(0) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_front(1) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_front(1) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_front(2) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_front(2) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_front(3) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_front(3) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_front(4) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_front(4) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_front(5) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_front(5) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
  }
}

module main_back_cross_support() {
  offset = [column_rib_center_offset, 0, 0];
  hull_pairs() {
    dropdown() place_column_support_slot_back(0) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_back(0) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_back(1) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_back(1) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_back(2) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_back(2) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_back(3) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_back(3) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_back(4) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_back(4) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_back(5) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_column_support_slot_back(5) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
  }
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
