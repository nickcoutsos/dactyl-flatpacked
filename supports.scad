include <definitions.scad>
use <positioning.scad>
use <placeholders.scad>
use <structures.scad>
use <util.scad>

module main_support_curve() {
  radius = main_column_radius / 4;
  offset = radius + column_rib_height;
  translate([0, 0, -offset])
  rotate([0, 90, 0])
    cylinder(r=radius, h=rib_spacing+1, center=true, $fn=120);
}

module support_joint() {
  cube([rib_spacing+1, 4, 4], center=true);
  translate([0, 0, -column_rib_height + 1]) cube([rib_spacing+1, 4, 2.5], center=true);
}

module short_support_joint() {
  translate([0, 0, -(plate_thickness)]) cube([rib_spacing+1, 4, 4], center=true);
  translate([0, 0, -(column_rib_height - plate_thickness + 1)]) cube([rib_spacing+1, 4, 2.5], center=true);
}

module thumb_support_curve() {
  radius = thumb_column_radius / 8;
  offset = radius + column_rib_height;
  translate([0, 0, -offset])
  rotate([0, 90, 0])
    cylinder(r=radius, h=rib_spacing+1, center=true, $fn=120);
}

module main_support_inner_column() {
  // inner column
  difference() {
    place_column_ribs([0]) column_rib(1, 4, 20);
    place_keys([0], [0:3]) key_well();

    place_keys([0], 3.5) main_support_curve();
    place_keys([0], -rib_extension) main_support_curve();
    place_keys([0], -rib_extension) support_joint();
    place_keys([0], 3+rib_extension) support_joint();

    translate([0, 0, -100]) cube(200, center=true);
  }
}

module main_support_columns(columns=[1:4]) {
  // main columns
  difference() {
    place_column_ribs(columns) column_rib(0, 4);
    place_keys(columns, [0:4]) key_well();
    place_keys(columns, -rib_extension) support_joint();
    place_keys(columns, 4 + rib_extension) support_joint();
  }
}

module main_support_outer_column() {
  // outer column
  translate([plate_width / 4, 0, 0])
  difference() {
    place_column_ribs([5]) column_rib(1, 4, 40);

    place_keys([5], [0:3]) key_well();

    place_keys([5], 3.5) main_support_curve();
    place_keys([5], -rib_extension) main_support_curve();
    place_keys([5], -rib_extension) support_joint();

    translate([0, 0, -100]) cube(200, center=true);
  }

  // corner key
  difference() {
    place_column_ribs([5]) column_rib(0, 0);
    place_keys([5], [4]) key_well();
    place_keys([5], 4 + rib_extension) support_joint();
  }
}

module main_support_outer_column_single() {
  // outer column
  // translate([plate_width / 4, 0, 0])
  difference() {
    place_column_ribs([5]) column_rib(0, 4, 40);

    place_keys([5], [0:4]) key_well();

    place_keys([5], 4.5) main_support_curve();
    place_keys([5], -rib_extension) main_support_curve();
    place_keys([5], -rib_extension) support_joint();
    place_keys([5], 4 + rib_extension) support_joint();

    translate([0, 0, -100]) cube(200, center=true);
  }

  // todo: fix this stuff
  // corner key
  // difference() {
  //   place_column_ribs([5]) column_rib(0, 0);
  //   place_keys([5], [4]) key_well();
  //   place_keys([5], 4 + rib_extension) support_joint();
  // }
}

module thumb_supports_col1() {
  difference() {
    place_thumb_column_ribs([2]) thumb_column_rib(0, 2);
    place_thumb_keys([2], [-1:1]) key_well();
    place_thumb_keys([2], -(1 + rib_extension)) support_joint();
    place_thumb_keys([2], (1 + rib_extension)) support_joint();
  }
}

module thumb_supports_col2() {
  difference() {
    place_thumb_column_ribs([0]) thumb_column_rib(0, .5);
    place_thumb_keys([0], [-.5]) key_well(h=2);
    place_thumb_keys([0], -(1 + rib_extension)) support_joint();
    place_thumb_keys([0], (-.5 + rib_extension)) short_support_joint();
  }
}

module thumb_supports_col3() {
  difference() {
    place_thumb_column_ribs([1]) thumb_column_rib(0, 2, 20);
    place_thumb_keys([1], [1]) key_well();
    place_thumb_keys([1], [-.5]) key_well(h=2);
    place_thumb_keys([1], -(1 + rib_extension)) support_joint();
    place_thumb_keys([1], (1 + rib_extension)) support_joint();
    place_thumb_keys([1], (1 + rib_extension)) thumb_support_curve();
    place_thumb_keys([1], -(1 + rib_extension)) thumb_support_curve();

    translate([-70, -40, -80]) cube(160, center=true);

    place_thumb_column_ribs([1], [1.5]) thumb_support_curve();
  }
}

module side_supports() {
  placement = key_place_transformation(0, 2);
  difference() {
    multmatrix(placement)
    rotate_down(placement)
    translate([0, 0, -30]) {
      translate([0, -rib_spacing/2, 0]) cube([rib_spacing + 6, rib_thickness, 30], center=true);
      translate([0, +rib_spacing/2, 0]) cube([rib_spacing + 6, rib_thickness, 30], center=true);
    }

    translate([0, 0, -100]) cube(200, center=true);

    multmatrix(placement)
    rotate_down(placement)
    translate([0, 0, -(15 + rib_thickness*.75*.5)]) {
      translate([-(rib_spacing - rib_thickness)/2, -rib_spacing/2, 0]) cube([rib_thickness, rib_thickness, rib_thickness*.75+.1], center=true);
      translate([+(rib_spacing - rib_thickness)/2, -rib_spacing/2, 0]) cube([rib_thickness, rib_thickness, rib_thickness*.75+.1], center=true);
      translate([-(rib_spacing - rib_thickness)/2, +rib_spacing/2, 0]) cube([rib_thickness, rib_thickness, rib_thickness*.75+.1], center=true);
      translate([+(rib_spacing - rib_thickness)/2, +rib_spacing/2, 0]) cube([rib_thickness, rib_thickness, rib_thickness*.75+.1], center=true);
    }
  }
}

module main_supports() {
  main_support_inner_column();
  main_support_columns();
  main_support_outer_column_single();
}

module thumb_supports() {
  thumb_supports_col1();
  thumb_supports_col2();
  thumb_supports_col3();
}

module place_thumb_side_supports() {
  placement = thumb_place_transformation(1, 0);
  multmatrix(placement)
  rotate_down(placement)
    children();
}

module thumb_side_supports() {
  difference() {
    translate([0, 0, -30]) {
      cube([rib_spacing + 6, rib_thickness, 30], center=true);
      translate([0, -rib_spacing, 0]) cube([rib_spacing + 6, rib_thickness, 30], center=true);
    }

    translate([0, 0, -(15 + rib_thickness*.75*.5)]) {
      translate([-(rib_spacing - rib_thickness)/2, -rib_spacing, 0]) cube([rib_thickness, rib_thickness, rib_thickness*.75+.1], center=true);
      translate([+(rib_spacing - rib_thickness)/2, -rib_spacing, 0]) cube([rib_thickness, rib_thickness, rib_thickness*.75+.1], center=true);
      translate([-(rib_spacing - rib_thickness)/2, 0, 0]) cube([rib_thickness, rib_thickness, rib_thickness*.75+.1], center=true);
      translate([+(rib_spacing - rib_thickness)/2, 0, 0]) cube([rib_thickness, rib_thickness, rib_thickness*.75+.1], center=true);
    }
  }
}
