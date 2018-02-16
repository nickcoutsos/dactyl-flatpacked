include <definitions.scad>
use <positioning.scad>
use <placeholders.scad>
use <structures.scad>
use <supports.scad>
use <caps.scad>
use <util.scad>

use <scad-utils/transformations.scad>
use <scad-utils/linalg.scad>

module key (w=1, h=1) {
  plate(w, h);
  switch();

  translate([0, 0, 4])
  keycap(w, h);
}

module main_layout() {
  // main keys
  place_keys([0:4], [0:3]) key();

  // bottom row (mostly)
  place_keys([2:5], [4]) key();

  // this key plate intersects the thumb cluster
  place_keys([1], [4]) key();

  // modifier key column
  place_keys([5], [0:3]) translate([plate_width/4, 0, 0]) key(w=1.5);

  // inner key column
  // this seems difficult to include with the thumb cluster.
  // place_keys([-1], [0]) key();
  // place_keys([-1], [1.25, 2.75]) key(h=1.5);
}

module thumb_layout() {
  // thumb cluster
  place_thumb_keys([2], [-1:1]) key();
  place_thumb_keys([1], [1]) key();
  place_thumb_keys([0, 1], [-0.5]) key(h=2);
}

main_layout();
thumb_layout();

main_supports();
thumb_supports();
// side_supports();

// difference() {
//   place_thumb_side_supports()
//     thumb_side_supports();

//   translate([0, 0, -100])
//     cube(200, center=true);
// }

module cross_support(row, radius, start, end) {
  steps = 4;
  segments = (end - start) / steps;
  matrix = 
    key_place_transformation(2, row)
    * rotation([-alpha*(2-row), 0, 0])
    * translation([0, 0, -column_rib_height])
    * translation([0, 0, main_column_radius])
    * rotation([90, 0, 0]);

  points = [for (i=[0:steps]) [
    radius*cos(start + i * segments),
    radius*sin(start + i * segments),
    0,
    1
  ]];

  // echo(points);
  echo(matrix=matrix);
  echo(original=[ for (p=points) p ]);
  transformed=[ for (p=points) matrix*p ];
  y_offset = transformed[0].y;

  translate([0, y_offset, 0])
  rotate([90, 0, 0])
  // multmatrix(matrix)
  // translate([0, -main_column_radius, 0])
  // translate([0, column_rib_height, 0])
  linear_extrude(rib_thickness, center=true)
  // polygon([ for (p=points) takeXY(p) ]);
  // polygon([ for (p=points) takeXZ(matrix*p) ]);
  polygon(concat(
    [ for (p=transformed) takeXZ(p) ],
    radius * [
      [cos(end), 0],
      [cos(start), 0]
    ]
  ));
  // ));
}

cross_support(4.5, main_column_radius-1, -90+beta * 3.5, -90+-beta*1.5);
cross_support(-0.5, main_column_radius-1, -90+beta * 3.5, -90+-beta*2.5);

for (col=[1:5]) {
  offset = rib_spacing/2 - rib_thickness/2;

  for (side=[-offset, offset]) {
    hull() {
      place_keys(col, 4.5)
      rotate([-alpha*(2-4.5), 0, 0])
      translate([side, 0, -column_rib_height])
      translate(column_offset_middle)
      translate(-column_offsets[col])
      translate([0, 0, -2])
        rotate([0, 90, 0]) cylinder(r=4, h=rib_thickness, center=true);

      place_keys(col, 2)
      translate([side, 0, main_row_radius])
      rotate([0, 90, 0])
        linear_extrude(rib_thickness, center=true)
        fan(
          (main_row_radius+column_rib_height-.01),
          main_row_radius+column_rib_height,
          -alpha*(2 +  rib_extension),
          -alpha
        );
    }
  }
}

for (col=[0:5]) {
  offset = rib_spacing/2 - rib_thickness/2;

  for (side=[-offset, offset]) {
    hull() {
      place_keys(col, -.5)
      rotate([-alpha*(2.5), 0, 0])
      translate([side, 0, -column_rib_height])
      translate(column_offset_middle)
      translate(-column_offsets[col])
      translate([0, 0, -2])
        rotate([0, 90, 0]) cylinder(r=4, h=rib_thickness, center=true);

      place_keys(col, 2)
      translate([side, 0, main_row_radius])
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
}


place_keys([0,1], 2.5)
translate([0, 0, -column_rib_height])
cube([rib_spacing*1.39, rib_thickness, column_rib_height/2], center=true);

// place_thumb_keys(0, -.1) translate([-rib_spacing/8, 0, -column_rib_height]) cube([rib_spacing*1.25, rib_thickness, column_rib_height/2], center=true);
// place_thumb_keys(1, -.1) translate([+rib_spacing/8, 0, -column_rib_height]) cube([rib_spacing*1.25, rib_thickness, column_rib_height/2], center=true);

module project_hull() {
  hull() {
    children();

    linear_extrude(.01)
    projection()
      children();
  }
}

function takeXY (vec) = [vec.x, vec.y];
function takeXZ (vec) = [vec.x, vec.z];


// // back
// place_keys(2, -.5)
//   rotate([-alpha*2.5, 0, 0])
//   translate([0, 0, -column_rib_height])
//   translate([0, 0, main_column_radius])
//   rotate([90, 0, 0])
//     linear_extrude(rib_thickness, center=true)
//     fan(
//       main_column_radius-1,
//       main_column_radius+3,
//       -90 + beta * 3.5,
//       -90 + -beta*2.5,
//       120);

// // front
// place_keys(2, 4.5)
//   rotate([-alpha*-2.5, 0, 0])
//   translate([0, 0, -column_rib_height])
//   translate([0, 0, main_column_radius])
//   rotate([90, 0, 0])
//     linear_extrude(rib_thickness, center=true)
//     fan(
//       main_column_radius-1,
//       main_column_radius+3,
//       -90 + beta * 3.5,
//       -90 + -beta*1.5,
//       120);

