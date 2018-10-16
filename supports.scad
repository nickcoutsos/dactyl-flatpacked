include <definitions.scad>
use <positioning.scad>
use <placeholders.scad>
use <structures.scad>
use <util.scad>

use <scad-utils/transformations.scad>

module main_support_inner_column() {
  offset = rib_spacing/2 - rib_thickness/2;

  difference() {
    union() {
      place_column_ribs([0]) column_rib(1, 4);
      for (side=[-offset, offset]) {
        main_support_back(0, side);
      }
    }

    place_keys([0], [0:3]) key_well();
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
      place_keys([col], 2) translate([side, 0, 0]) column_rib(col == 0 ? 1 : 0, 4);
      main_support_front(col, side);
      main_support_back(col, side);
    }

    place_keys(columns, [0:4]) key_well();
    for (col=columns, side=sides) {
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
}

module main_support_back(col, offset) {
  hull() {
    place_column_support_slot_back(col)
      translate([offset, 0, slot_height/2])
      cube([rib_thickness, rib_thickness*2.5, slot_height], center=true);

    place_keys(col, 2)
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

module thumb_supports_col1() {
  offset = rib_spacing/2 - rib_thickness/2;

  difference() {
    union() {
      place_thumb_column_ribs([2]) thumb_column_rib(0, 2);
      for (side=[-offset, offset]) {
        thumb_support_front(2, side);
        thumb_support_back(2, side);
      }
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
  offset = rib_spacing/2 - rib_thickness/2;

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
  hull_pairs() {
    thumb_place(col, -1 - rib_extension)
    translate([offset, 0, -1])
    rotate([0, 90, 0])
    cylinder(r=1, h=rib_thickness, center=true);

    thumb_place(col, -1.5)
    translate([0, 0, -column_rib_height])
    translate([offset, 0, 0])
      rotate([0, 90, 0]) cylinder(r=4, h=rib_thickness, center=true);

    thumb_place(col, -1)
    translate([offset, 0, thumb_row_radius])
    rotate([0, 90, 0])
      linear_extrude(rib_thickness, center=true)
      fan(
        (thumb_row_radius+column_rib_height-.01),
        thumb_row_radius+column_rib_height,
        alpha*-0.5,
        alpha*0.5
      );
  }
}

module thumb_support_back(col, offset) {
  hull_pairs() {
    thumb_place(col, 1 + rib_extension)
    translate([offset, 0, -1])
    rotate([0, 90, 0])
    cylinder(r=1, h=rib_thickness, center=true);

    thumb_place(col, 1.5)
    translate([offset, 0, -column_rib_height])
      rotate([0, 90, 0]) cylinder(r=4, h=rib_thickness, center=true);

    thumb_place(col, 1)
    translate([offset, 0, thumb_row_radius])
    rotate([0, 90, 0])
      linear_extrude(rib_thickness, center=true)
      fan(
        (thumb_row_radius+column_rib_height-.01),
        thumb_row_radius+column_rib_height,
        alpha*-0.5,
        alpha*0.5
      );
  }
}


module thumb_support_front_slot(col, offset) {
  thumb_place(1, -1.5)
  translate([0, 0, -column_rib_height])
  rotate_down(thumb_place_transformation(1, -1.5))
  translate([0, 0, thumb_column_radius])
  rotate([0, beta * (col - 1), 0])
  translate([offset, 0, 0])
  translate([0, 0, -thumb_column_radius])
  translate([0, 0, -4])
    cube([rib_thickness+1, rib_thickness, 10], center=true);
}

module thumb_support_back_slot(col, offset) {
  thumb_place(1, 1.4)
  translate([0, 0, -column_rib_height])
  rotate_down(thumb_place_transformation(1, 1.4))
  translate([0, 0, thumb_column_radius])
  rotate([0, beta * (col - 1), 0])
  translate([offset, 0, 0])
  translate([0, 0, -thumb_column_radius])
  translate([0, 0, -4])
    cube([rib_thickness+1, rib_thickness, 10], center=true);
}

module main_supports() {
  main_support_columns();
}

module thumb_supports() {
  thumb_supports_col1();
  thumb_supports_col2();
  thumb_supports_col3();
}

module main_front_cross_support() {
  offset = rib_spacing/2 - rib_thickness/2;
  difference() {
    main_cross_support(4, 3.6, -1.33);
    main_supports();


    place_keys(1, 4)
    translate([-offset - 5, 0, -column_rib_height])
    rotate([-alpha*(2-4), 0, 0])
    translate(column_offset_middle)
    translate(-column_offsets[1])
    translate([0, 0, column_rib_height/2])
      cube([10, rib_thickness+1, column_rib_height], center=true);
  }
}

module main_back_cross_support() {
  difference() { main_cross_support(-0.5, 3.6, -2.5); main_supports(); }
}

module main_inner_column_cross_support() {
  difference() {
    key_place(0, 2.5)
    rotate([90, 0, 0])
    translate([0, main_column_radius, 0])
    linear_extrude(height=rib_thickness, center=true)
    fan(
      main_column_radius+column_rib_height/2,
      main_column_radius+column_rib_height,
      -90 + beta * 1.5,
      -90 + beta * -.5
    );

    main_supports();
  }
}

module thumb_front_cross_support() {
  difference() { thumb_cross_support(-1.5, 1.5, -1.5); thumb_supports(); }
}

module thumb_back_cross_support() {
  difference() { thumb_cross_support(1.4, .35, -1.6); thumb_supports(); }
}

module thumb_inner_column_cross_support() {
  difference() {
    thumb_place(0, -.15)
    rotate([90, 0, 0])
    translate([0, thumb_column_radius, 0])
    linear_extrude(height=rib_thickness, center=true)
    fan(
      thumb_column_radius+column_rib_height/2,
      thumb_column_radius+column_rib_height,
      -90 + beta * -1.45,
      -90 + beta * .45
    );

    thumb_supports();
  }
}
