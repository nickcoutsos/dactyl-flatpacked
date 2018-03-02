include <definitions.scad>
use <positioning.scad>
use <placeholders.scad>
use <structures.scad>
use <util.scad>

use <scad-utils/transformations.scad>

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
    cube([rib_thickness, rib_thickness, column_rib_height/2], center=true);
  }
}

module main_support_columns(columns=[1:4]) {
  offset = rib_spacing/2 - rib_thickness/2;

  difference() {
    union() {
      place_column_ribs(columns) column_rib(0, 4);
      for (col=columns, side=[-offset, offset]) {
        main_support_front(col, side);
        main_support_back(col, side);
      }
    }

    place_keys(columns, [0:4]) key_well();
    for (col=columns, side=[-offset, offset]) {
      main_support_front_slot(col, side);
      main_support_back_slot(col, side);
    }

    place_column_ribs(1, 2.5)
    translate([0, 0, -column_rib_height])
    cube([rib_thickness, rib_thickness, column_rib_height/2], center=true);
  }
}

module main_support_outer_column() {
  // outer column
  translate([plate_width / 4, 0, 0])
  difference() {
    place_column_ribs([5]) column_rib(1, 4);
    place_keys([5], [0:3]) key_well();
  }

  // corner key
  difference() {
    place_column_ribs([5]) column_rib(0, 0);
    place_keys([5], [4]) key_well();
  }
}

module main_support_column(col) {
  if (col == 0) main_support_inner_column();
  else if (col > 0 && col < 5) main_support_columns([col]);
  else main_support_outer_column_single();
}

module main_support_outer_column_single() {
  offset = rib_spacing*1.5/2 - rib_thickness*1.5/2;

  // outer column
  translate([plate_width / 4, 0, 0])
  difference() {
    union() {
      for (side=[-offset, offset]) {
        translate([side, 0, 0]) place_keys([5], 2) column_rib(0, 4);
        main_support_front(5, side);
        main_support_back(5, side);
      }
    }

    for (side=[-offset, offset]) {
      place_keys([5], [0:4])
      translate([side, 0, 0])
        key_well();

      main_support_front_slot(5, side);
      main_support_back_slot(5, side);
    }
  }

  // todo: fix this stuff
  // corner key
  // difference() {
  //   place_column_ribs([5]) column_rib(0, 0);
  //   place_keys([5], [4]) key_well();
  //   place_keys([5], 4 + rib_extension) support_joint();
  // }
}

module main_support_front(col, offset) {
  hull_pairs() {
    place_keys(col, 4 + rib_extension)
    translate([offset, 0, -1])
    rotate([0, 90, 0])
    cylinder(r=1, h=rib_thickness, center=true);

    place_keys(col, 4 + rib_extension)
    translate([offset, 0, -column_rib_height])
    rotate([0, 90, 0])
    cylinder(r=2, h=rib_thickness, center=true);

    place_keys(col, 4.5)
    translate([offset, 0, -column_rib_height])
    rotate([-alpha*(2-4.5), 0, 0])
    translate(column_offset_middle)
    translate(-column_offsets[col])
      rotate([0, 90, 0]) cylinder(r=4, h=rib_thickness, center=true);

    place_keys(col, 2)
    translate([offset, 0, main_row_radius+.01])
    rotate([0, 90, 0])
      linear_extrude(rib_thickness, center=true)
      fan(
        (main_row_radius+column_rib_height-.01),
        main_row_radius+column_rib_height,
        -alpha*(1 +  rib_extension),
        -alpha
      );
  }
}

module main_support_back(col, offset) {
  hull_pairs() {
    place_keys(col, - rib_extension)
    translate([offset, 0, -1])
    rotate([0, 90, 0])
    cylinder(r=1, h=rib_thickness, center=true);

    place_keys(col, - rib_extension)
    translate([offset, 0, -column_rib_height])
    rotate([0, 90, 0])
    cylinder(r=4, h=rib_thickness, center=true);

    place_keys(col, -.5)
    translate([offset, 0, -column_rib_height])
    rotate([-alpha*(2.5), 0, 0])
    translate(column_offset_middle)
    translate(-column_offsets[col])
      rotate([0, 90, 0]) cylinder(r=4, h=rib_thickness, center=true);

    place_keys(col, 2)
    translate([offset, 0, main_row_radius])
    rotate([0, 90, 0])
      linear_extrude(rib_thickness, center=true)
      fan(
        (main_row_radius+column_rib_height-.01),
        main_row_radius+column_rib_height,
        -alpha*(-2 - rib_extension),
        -alpha*-1.5
      );
  }
}

module main_support_front_slot(col, offset) {
  place_keys(col, 4.5)
  translate([offset, 0, -column_rib_height])
  rotate([-alpha*(2-4.5), 0, 0])
  translate(column_offset_middle)
  translate(-column_offsets[col])
  translate([0, 0, -5])
    cube([rib_thickness+1, rib_thickness, 10], center=true);
}

module main_support_back_slot(col, offset) {
  place_keys(col, -.5)
  translate([offset, 0, -column_rib_height])
  rotate([-alpha*(2.5), 0, 0])
  translate(column_offset_middle)
  translate(-column_offsets[col])
  translate([0, 0, -5])
    cube([rib_thickness+1, rib_thickness, 10], center=true);
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

    place_thumb_keys([0], [-.5]) key_well(h=2);
    for (side=[-offset, offset]) {
      thumb_support_front_slot(0, side);
      thumb_support_back_slot(0, side);
    }

    place_thumb_column_ribs(0, -.05)
    translate([0, 0, -column_rib_height])
    cube([rib_thickness, rib_thickness, column_rib_height/2], center=true);
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

    place_thumb_column_ribs(1, -.05)
    translate([0, 0, -column_rib_height])
    cube([rib_thickness, rib_thickness, column_rib_height/2], center=true);
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
  translate([offset, 0, 0])
  translate([0, 0, -column_rib_height])
  rotate_down(thumb_place_transformation(1, -1.5))
  translate([0, 0, thumb_column_radius])
  rotate([0, beta * (col - 1), 0])
  translate([0, 0, -thumb_column_radius])
  translate([0, 0, -4])
    cube([rib_thickness+1, rib_thickness, 10], center=true);
}

module thumb_support_back_slot(col, offset) {
  thumb_place(1, 1.4)
  translate([offset, 0, 0])
  translate([0, 0, -column_rib_height])
  rotate_down(thumb_place_transformation(1, 1.4))
  translate([0, 0, thumb_column_radius])
  rotate([0, beta * (col - 1), 0])
  translate([0, 0, -thumb_column_radius])
  translate([0, 0, -4])
    cube([rib_thickness+1, rib_thickness, 10], center=true);
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

module cross_support(matrix, radius, start, end, corner_radius=2) {
  steps = $fn ? $fn : 60;
  segments = (end - start) / steps;
  downward = rotation_down(matrix);

  transform = matrix
    * translation([0, 0, -column_rib_height])
    * downward
    * translation([0, 0, radius])
    * rotation([90, 0, 0])
    ;

  points = [for (i=[0:steps]) (radius - 4) * [
    cos(start + i * segments),
    sin(start + i * segments),
    0
  ]];

  transformed=[ for (p=points) apply_matrix(p, transform) ];
  first = transformed[0];
  last = transformed[len(transformed)-1];

  extruded_polygon(concat(
    transformed,
    [
      for (a=[0:steps])
      [last.x, last.y, last.z] -
      [cos(90-a/steps*90), 0, 1-sin(90-a/steps*90)] * corner_radius
    ],
    [
      [last.x - corner_radius, last.y, 0],
      [first.x + corner_radius, first.y, 0]
    ],
    [
      for (a=[0:steps])
      [first.x, first.y, first.z] +
      [cos(a/steps*90), 0, sin(a/steps*90) - 1] * corner_radius
    ]
  ), rib_thickness);
}

module main_cross_support(row, start, end) {
  cross_support(
    key_place_transformation(2, row),
    main_column_radius,
    -90 + beta * start,
    -90 + beta * end
  );
}

module thumb_cross_support(row, start, end) {
  cross_support(
    thumb_place_transformation(1, row),
    thumb_column_radius,
    -90 + beta * start,
    -90 + beta * end
  );
}


module main_front_cross_support() {
  offset = rib_spacing/2 - rib_thickness/2;
  difference() {
    main_cross_support(4.5, 3.9, -1.33);
    main_supports();


    place_keys(1, 4.5)
    translate([-offset - 5, 0, -column_rib_height])
    rotate([-alpha*(2-4.5), 0, 0])
    translate(column_offset_middle)
    translate(-column_offsets[1])
    translate([0, 0, column_rib_height/2])
      cube([10, rib_thickness+1, column_rib_height], center=true);
  }
}

module main_back_cross_support() {
  difference() { main_cross_support(-0.5, 3.9, -2.5); main_supports(); }
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
  difference() { thumb_cross_support(1.4, .5, -1.6); thumb_supports(); }
}

module thumb_inner_column_cross_support() {
  difference() {
    thumb_place(0, -.05)
    rotate([90, 0, 0])
    translate([0, thumb_column_radius, 0])
    linear_extrude(height=rib_thickness, center=true)
    fan(
      thumb_column_radius+column_rib_height/2,
      thumb_column_radius+column_rib_height,
      -90 + beta * -1.5,
      -90 + beta * .5
    );

    thumb_supports();
  }
}
