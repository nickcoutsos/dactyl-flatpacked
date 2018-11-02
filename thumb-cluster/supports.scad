include <definitions.scad>
use <positioning.scad>
use <../placeholders.scad>
use <../structures.scad>
use <../util.scad>

module thumb_column_rib (start, end, height=column_rib_height) {
  radius = thumb_row_radius;
  inner = radius;
  outer = inner + height;

  translate([0, 0, radius])
  rotate([0, 90, 0]) {
    linear_extrude(rib_thickness, center=true)
    fan(
      inner, outer,
      alpha * (start - 1 - rib_extension),
      alpha * (end - 1 + rib_extension)
    );
  }
}

module thumb_support_columns(selected=[0:len(columns) - 1]) {
  sides = [-1, 1] * column_rib_center_offset;

  difference() {
    for (col=selected, side=sides) {
      rows = columns[col];
      thumb_place(col, 1) translate([side, 0, 0]) thumb_column_rib(first(rows), last(rows));
      thumb_support_front(col, side);
      thumb_support_back(col, side);
    }

    if ($detail) {
      for (col=selected) {
        for (row=columns[col]) thumb_place(col, row) key_well();
        for (side=sides) {
          thumb_support_front_slot(col, side);
          thumb_support_back_slot(col, side);
        }
      }
    }
  }
}

module thumb_support_front(col, offset) {
  hull() {
    thumb_place(col, front_support_row - .25)
    translate([offset, 0, -column_rib_height -slot_height/2])
      cube([rib_thickness, rib_thickness*2.5, slot_height], center=true);

    thumb_place(col, front_support_row)
    translate([offset, 0, thumb_row_radius])
    rotate([0, 90, 0])
      linear_extrude(rib_thickness, center=true)
      fan(
        (thumb_row_radius+column_rib_height-.01),
        thumb_row_radius+column_rib_height,
        alpha*(front_support_row + (1 - rib_extension)),
        alpha*(front_support_row + 1)
      );
  }
}

module thumb_support_back(col, offset) {
  hull() {
    thumb_place(col, back_support_row + .25)
    translate([0, 0, -(column_rib_height + slot_height)])
    translate([offset, 0, 0])
      cube([rib_thickness, rib_thickness*2.5, slot_height], center=true);

    thumb_place(col, back_support_row)
    translate([offset, 0, thumb_row_radius])
    rotate([0, 90, 0])
      linear_extrude(rib_thickness, center=true)
      fan(
        (thumb_row_radius+column_rib_height-.01),
        thumb_row_radius+column_rib_height,
        alpha*(rib_extension),
        alpha*(-.1)
      );
  }
}

module thumb_support_front_slot(col, offset) {
  place_thumb_column_support_slot_front(col)
  translate([offset, 0, 0])
    cube([rib_thickness+1, rib_thickness, 10], center=true);
}

module thumb_support_back_slot(col, offset) {
  place_thumb_column_support_slot_back(col)
  translate([offset, 0, 0])
    cube([rib_thickness+1, rib_thickness, 10], center=true);
}

module thumb_front_cross_support() {
  offset = [column_rib_center_offset, 0, 0];
  hull_pairs() {
    dropdown() place_thumb_column_support_slot_front(2) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_front(2) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_front(1) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_front(1) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_front(0) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_front(0) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
  }
}

module thumb_back_cross_support() {
  offset = [column_rib_center_offset, 0, 0];
  hull_pairs() {
    dropdown() place_thumb_column_support_slot_back(2) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_back(2) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_back(1) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_back(1) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_back(0) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_back(0) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
  }
}
