include <definitions.scad>
use <positioning.scad>
use <../placeholders.scad>
use <../structures.scad>
use <../util.scad>

module column_rib (start, end, height=column_rib_height, thickness=rib_thickness) {
  radius = main_row_radius;
  inner = radius;
  outer = inner + height;

  a = alpha * (start - 2 - rib_extension);
  b = alpha * (end - 2 + rib_extension);

  translate([0, 0, radius]) {
    rotate([0, 90, 0]) {
      linear_extrude(thickness, center=true)
      fan(inner, outer, a, b);
    }
  }
}

module main_support_inner_column() {
  offset = rib_spacing/2 - rib_thickness/2;

  difference() {
    union() {
      place_column_ribs([0]) column_rib(1, 4);
      for (side=[-offset, offset]) {
        main_support_back(0, side);
      }
    }

    for (row=[0:3]) key_place(0, row) key_well();
    for (side=[-offset, offset]) {
      main_support_back_slot(0, side);
    }

    place_column_ribs(0, 2.5)
    translate([0, 0, -column_rib_height])
    cube([rib_thickness+1, rib_thickness, column_rib_height/2], center=true);
  }
}

module main_support_columns(columns=[0:5]) {
  sides = [-1, 1] * column_rib_center_offset;

  difference() {
    for (col=columns, side=sides) {
      key_place(col, 2) translate([side, 0, 0]) column_rib(col == 0 ? 1 : 0, 4);
      main_support_front(col, side);
      main_support_back(col, side);
    }

    for (col=columns, side=sides) {
      for (row=[0:col == 0 ? 3 : 4]) key_place(col, row) key_well();
      main_support_front_slot(col, side);
      main_support_back_slot(col, side);
    }
  }
}

module main_support_column(col) {
  if (col == 0) main_support_inner_column();
  else main_support_columns([col]);
}

module main_support_front(col, offset) {
  hull() {
    place_column_support_slot_front(col)
      translate([offset, 0, slot_height/2])
      cube([rib_thickness, rib_thickness*2.5, slot_height], center=true);

    key_place(col, 2)
    translate([offset, 0, main_row_radius])
    rotate([0, 90, 0])
      linear_extrude(rib_thickness, center=true)
      fan(
        (main_row_radius+column_rib_height-.01),
        main_row_radius+column_rib_height,
        -alpha*(col == 0 ? 1.6 : 2.3),
        -alpha*-1
      );
  }
}

module main_support_back(col, offset) {
  hull() {
    place_column_support_slot_back(col)
      translate([offset, 0, slot_height/2])
      cube([rib_thickness, rib_thickness*2.5, slot_height], center=true);

    key_place(col, 2)
    translate([offset, 0, main_row_radius])
    rotate([0, 90, 0])
      linear_extrude(rib_thickness, center=true)
      fan(
        (main_row_radius+column_rib_height-.01),
        main_row_radius+column_rib_height,
        -alpha*(-2 - rib_extension),
        -alpha*-1.4
      );
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

module main_supports() {
  main_support_columns();
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
