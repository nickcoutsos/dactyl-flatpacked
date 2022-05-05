use <supports.scad>
use <util.scad>
include <definitions.scad>

// Using `cross_support_bottom_points()` can give us all of the contact points
// of a cross support on the XY plane. From this we can define the paths to cut
// holes out of a base for the keyboard.
//
// What this function actually returns is the bottom profile of a cross support
// which includes the new corner notch cutouts, so the "true" bottom points are
// just the ones where p.z == 0. This does assume that the cross support will
// only have cutouts in the corner, so that the remaining points will be the
// start and end points of the cross support.

xy = function (p) [p.x, p.y];
is_base = function (p) p.z == 0;

thumb_cross_support_points = [
  for (i=[0:len(thumb_columns)-1], position=["front", "back"])
  map(xy, filter(is_base, cross_support_bottom_points("thumb", position, i)))
];

finger_cross_support_points = [
  for (position=["front", "back"])
  map(xy, filter(is_base, cross_support_bottom_points("finger", position)))
];

cross_support_lines = concat(
  thumb_cross_support_points,
  finger_cross_support_points
);

cross_support_holes = [
  for(line=cross_support_lines)
  thicken_line(line, plate_thickness)
];

function inner_round (points, r) = (
  offset(
    offset(
      points,
      closed=true,
      r=-2*r
    ),
    closed=true,
    r=r
  )
);

finger_cluster_cutout = inner_round(hull_points(flatten(finger_cross_support_points)), r=4);
thumb_cluster_cutout = inner_round(hull_points(flatten(thumb_cross_support_points)), r=4);
cross_support_points = flatten(cross_support_lines);

module base() {
  outline = hull_points(cross_support_points);
  linear_extrude(height=plate_thickness)
  region(concat(
    [offset(outline, r=4, closed=true)],
    cross_support_holes,
    [finger_cluster_cutout, thumb_cluster_cutout]
  ));
}

color("red") stroke(cross_support_holes, width=0.25, joint_width=0, hull=false);
color("red") stroke(finger_cluster_cutout, width=0.25, joint_width=0, closed=true, hull=false);
color("red") stroke(thumb_cluster_cutout, width=0.25, joint_width=0, closed=true, hull=false);
color("yellow", alpha=0.3) base();
