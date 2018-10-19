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
      alpha * (start - 2 - rib_extension),
      alpha * (end - 2 + rib_extension)
    );
  }
}

module thumb_supports_col1() {
  offset = column_rib_center_offset;
  sides = [-1, 1] * column_rib_center_offset;

  difference() {
    for (side=sides) {
      thumb_place(2, 1) translate([side, 0, 0]) thumb_column_rib(0, 2);
      thumb_support_front(2, side);
      thumb_support_back(2, side);
    }

    place_thumb_keys([2], [-1:1]) key_well();
    for (side=[-offset, offset]) {
      thumb_support_front_slot(2, side);
      thumb_support_back_slot(2, side);
    }
  }
}

module thumb_supports_col2() {
  offset = rib_spacing/2 - rib_thickness/2;

  difference() {
    union() {
      place_thumb_column_ribs([0]) thumb_column_rib(0, .5);
      for (side=[-offset, offset]) {
        thumb_support_front(0, side);
      }
    }

    place_thumb_column_ribs(0, -.15)
    translate([0, 0, -column_rib_height/2])
    difference() {
      rotate([-90, 0, 0]) translate([-rib_thickness, 0, 0]) cube([rib_thickness*2, column_rib_height, column_rib_height]);
      rotate([0, 90, 0]) cylinder(r=column_rib_height/2, h=rib_thickness, center=true);
    }

    place_thumb_keys([0], [-.5]) key_well(h=2);
    for (side=[-offset, offset]) {
      thumb_support_front_slot(0, side);
      thumb_support_back_slot(0, side);
    }

    place_thumb_column_ribs(0, -.15)
    translate([0, 0, -column_rib_height])
    cube([rib_thickness+1, rib_thickness, column_rib_height/2], center=true);
  }
}

module thumb_supports_col3() {
  offset = column_rib_center_offset;

  difference() {
    // place_thumb_column_ribs([1]) thumb_column_rib(0, 2);
    union() {
      place_thumb_column_ribs([1]) thumb_column_rib(0, 2);
      for (side=[-offset, offset]) {
        thumb_support_front(1, side);
        thumb_support_back(1, side);
      }
    }
    place_thumb_keys([1], [1]) key_well();
    place_thumb_keys([1], [-.5]) key_well(h=2);
    for (side=[-offset, offset]) {
      thumb_support_front_slot(1, side);
      thumb_support_back_slot(1, side);
    }

    place_thumb_column_ribs(1, -.15)
    translate([0, 0, -column_rib_height])
    cube([rib_thickness+1, rib_thickness, column_rib_height/2], center=true);
  }
}

module thumb_support_column(col) {
  if (col == 1) thumb_support_col1();
  if (col == 2) thumb_support_col2();
  if (col == 3) thumb_support_col3();
}

module thumb_support_front(col, offset) {
  /*
  hull() {
    place_column_support_slot_front(col)
      translate([offset, 0, slot_height/2])
      cube([rib_thickness, rib_thickness*2.5, slot_height], center=true);

    place_keys(col, 2)
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
  */
  hull() {
    thumb_place(col, -1.25)
    translate([offset, 0, -column_rib_height -slot_height/2])
      cube([rib_thickness, rib_thickness*2.5, slot_height], center=true);

    thumb_place(col, -1)
    translate([offset, 0, thumb_row_radius])
    rotate([0, 90, 0])
      linear_extrude(rib_thickness, center=true)
      fan(
        (thumb_row_radius+column_rib_height-.01),
        thumb_row_radius+column_rib_height,
        alpha*-0.6,
        alpha*0.1
      );
  }
}

module thumb_support_back(col, offset) {
  hull() {
    thumb_place(col, 1.25)
    translate([0, 0, -(column_rib_height + slot_height)])
    translate([offset, 0, 0])
      cube([rib_thickness, rib_thickness*2.5, slot_height], center=true);

    thumb_place(col, 1)
    translate([offset, 0, thumb_row_radius])
    rotate([0, 90, 0])
      linear_extrude(rib_thickness, center=true)
      fan(
        (thumb_row_radius+column_rib_height-.01),
        thumb_row_radius+column_rib_height,
        alpha*-0.1,
        alpha*.6
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

module thumb_supports() {
  thumb_supports_col1();
  thumb_supports_col2();
  thumb_supports_col3();
}

module thumb_front_cross_support() {
  offset = [column_rib_center_offset, 0, 0];
  hull_pairs() {
    dropdown() place_thumb_column_support_slot_front(0) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_front(0) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_front(1) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_front(1) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_front(2) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_front(2) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
  }
}

module thumb_back_cross_support() {
  offset = [column_rib_center_offset, 0, 0];
  hull_pairs() {
    dropdown() place_thumb_column_support_slot_back(1) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_back(1) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_back(2) translate(-offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
    dropdown() place_thumb_column_support_slot_back(2) translate(+offset) translate([0, 0, slot_height]) cube([rib_thickness + 2, rib_thickness, slot_height*2], center=true);
  }
}
