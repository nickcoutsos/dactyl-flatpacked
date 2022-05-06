use <supports.scad>
use <util.scad>
include <definitions.scad>
include <BOSL2/beziers.scad>

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

thumb_back = [for(i=[0:len(thumb_columns)-1]) map(xy, filter(is_base, cross_support_bottom_points("thumb", "back", i)))];
thumb_front = [for(i=[0:len(thumb_columns)-1]) map(xy, filter(is_base, cross_support_bottom_points("thumb", "front", i)))];
thumb_points = concat(thumb_back, thumb_front);

finger_back = map(xy, filter(is_base, cross_support_bottom_points("finger", "back")));
finger_front = map(xy, filter(is_base, cross_support_bottom_points("finger", "front")));
finger_points = [finger_back, finger_front];

cross_support_holes = [
  for(line=concat(
    thumb_back,
    thumb_front,
    [finger_back,
    finger_front]
  ))

  thicken_line(line, plate_thickness)
];

function inner_round (points, r) = (
  let(inset = offset(points, closed=true, r=-2*r))
  offset(inset, closed=true, r=r)
);

finger_cluster_cutout = inner_round(hull_points(flatten(finger_points)), r=4);
thumb_cluster_cutout = inner_round(hull_points(flatten(thumb_points)), r=4);

outline = concat(
  [finger_back[1]],
  bezier_curve(flatten([
    bez_begin(finger_back[0], 270, 80),
    bez_end(thumb_back[2][0], 0, 0),
  ])),
  [thumb_front[2][0]],
  bezier_curve(flatten([
    bez_begin(thumb_front[0][1], 0, 0),
    bez_end(finger_front[1], 180, 90),
  ]))
);

module base() {
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
