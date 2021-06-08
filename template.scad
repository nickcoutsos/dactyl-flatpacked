use <supports.scad>
use <positioning.scad>
use <util.scad>
use <placeholders.scad>
include <definitions.scad>

include <BOSL2/std.scad>

translate([0, -32, 0])
for(columnIndex=[0:len(finger_columns)-1], i=[0,1])
  translate([columnIndex*24 + i*12, 0, 0])
  rotate([0, 0, 90])
  polygon(column_support("finger", columnIndex));

translate([0, 32, 0])
for(columnIndex=[0:len(thumb_columns)-1], i=[0,1])
  translate([columnIndex*24 + i*12, 0, 0])
  rotate([0, 0, 90])
  polygon(column_support("thumb", columnIndex));

function align_cross_support(vertices) = (
  let(base_points = [for(v=vertices) if (v.z < .0001) v])
  let(vec = last(base_points) - first(base_points))
  let(angle = angleTo(vec, X))
  let(matrix = (
    affine3d_identity()
    * rot([-90, 0, 0])
    * rot([0, 0, -angle])
    * move(-first(base_points))
  ))
  [for (v=apply(matrix, vertices)) [v.x, v.y]]
);

translate([-65, 0, 0]) polygon(align_cross_support(thumb_front_cross_support([2])));
translate([-45, 0, 0]) polygon(align_cross_support(thumb_front_cross_support([1])));
translate([-25, 0, 0]) polygon(align_cross_support(thumb_front_cross_support([0])));
translate([-125, 0, 0]) polygon(align_cross_support(thumb_back_cross_support([2])));
translate([-105, 0, 0]) polygon(align_cross_support(thumb_back_cross_support([1])));
translate([-85, 0, 0]) polygon(align_cross_support(thumb_back_cross_support([0])));
translate([-125, -40, 0]) polygon(align_cross_support(finger_cluster_cross_support_front()));
translate([-125, -80, 0]) polygon(align_cross_support(finger_cluster_cross_support_back()));

translate([-115, 90, 0])
for(x=[0,1], y=[0,1])
translate([x*(plate_width+2), y*(plate_height*2+2), 0])
  plate(1, 2, render_2d=true);

translate([-75, 80, 0])
for (x=[0:11], y=[0:3]) {
  translate([x*(plate_width+2), y*(plate_height+2), 0])
  plate(1, 1, render_2d=true);
}
