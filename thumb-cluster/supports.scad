include <definitions.scad>
use <positioning.scad>
use <../placeholders.scad>
use <../structures.scad>
use <../util.scad>

/**
 * Create a support for a column of keys
 * @param <Integer> columnIndex
 * @param <Number> extension
 */
module column_support(columnIndex, extension=0, height=column_rib_height) {
  keywell_points = reverse([
    [plate_height/2, 0],
    [plate_height/2 - rib_thickness/2, 0],
    [plate_height/2 - rib_thickness/2, -plate_thickness],
    [-(plate_height/2 - rib_thickness/2), -plate_thickness],
    [-(plate_height/2 - rib_thickness/2), 0],
    [-(plate_height/2), 0]
  ]);

  function transform(m, vertices) = [ for (v=vertices) takeXY(m * [v.x, v.y, 0, 1]) ];
  function rotate_keyplace(row) = (
    identity4()
    * translation([0, thumb_row_radius, 0])
    * rotation([0, 0, alpha * (row - 2)])
    * translation(-[0, thumb_row_radius, 0])
    * scaling([row == -0.5 ? 2 : 1, 1, 1])
  );

  column = columns[columnIndex];
  top = first(columns[columnIndex]);
  bottom = last(columns[columnIndex]);
  top_points = flatten([
    for(i=[0:len(column)-1])
    transform(rotate_keyplace(column[i]), keywell_points)
  ]);

  bottom_points = reverse(flatten([
    for(i=[0:len(column)-1])
    transform(rotate_keyplace(column[i]), reverse([
      [ plate_height/2, -height],
      [ -plate_height/2, -height]
    ]))
  ]));

  points = concat(top_points, bottom_points);
  polygon(points);
}

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

module thumb_supports() {
  thumb_support_columns();
}

module thumb_support_columns(selected=[0:len(columns) - 1]) {
  sides = [-1, 1] * column_rib_center_offset;

  difference() {
    for (col=selected, side=sides) {
      rows = columns[col];

      thumb_place(col, 2)
      translate([side, 0, 0])
      rotate([0, 90, 0])
      rotate([0, 0, 90])
      linear_extrude(height=rib_thickness, center=true)
        column_support(col);

      thumb_support_front(col, side);
      if (back_support_row < last(rows)) thumb_support_back(col, side);
    }

    if (!is_undef($detail) && $detail) {
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
  front_row = first(columns[col]);
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
        thumb_row_radius+column_rib_height+2,
        alpha*(front_support_row + (1)),
        alpha*(front_support_row + (1 - 0.5))
      );
  }
}

module thumb_support_back(col, offset) {
  hull() {
    thumb_place(col, back_support_row)
    translate([0, 4, -(column_rib_height + slot_height)])
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
  translate([offset, 0, -2])
    cube([rib_thickness+1, rib_thickness, 10], center=true);
}

module thumb_support_back_slot(col, offset) {
  place_thumb_column_support_slot_back(col)
  translate([offset, 0, -2])
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

module thumb_inner_column_cross_support() {
  difference() {
    thumb_place(0, -.15)
    rotate([90, 0, 0])
    translate([0, thumb_column_radius, 0])
    linear_extrude(height=rib_thickness, center=true)
    fan(
      thumb_column_radius+column_rib_height/2-2,
      thumb_column_radius+column_rib_height,
      -90 + beta * -1.45,
      -90 + beta * .45
    );

    thumb_supports();
  }
}
