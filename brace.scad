include <BOSL2/std.scad>
include <BOSL2/beziers.scad>
include <definitions.scad>
use <supports.scad>

xy = function (p) [p.x, p.y];
is_base = function (p) p.z == 0;

thumb_back = [for(i=[0:len(thumb_columns)-1]) map(xy, filter(is_base, cross_support_bottom_points("thumb", "back", i)))];
thumb_front = [for(i=[0:len(thumb_columns)-1]) map(xy, filter(is_base, cross_support_bottom_points("thumb", "front", i)))];
thumb_points = concat(thumb_back, thumb_front);

finger_back = map(xy, filter(is_base, cross_support_bottom_points("finger", "back")));
finger_front = map(xy, filter(is_base, cross_support_bottom_points("finger", "front")));
finger_points = [finger_back, finger_front];


function thumb_outer_column_end() = (
  let(
    u = plate_thickness,
    col = thumb_back[2],
    a=col[0],
    b=col[1],
    v=unit(b-a),
    n=line_normal(col)
  )
  [
    a + n*u/2 - v*u,
    a - n*u/2 - v*u,
  ]
);

function thumb_columns () = (
  flatten([
    for (col=reverse(thumb_back))
    let(
      u = plate_thickness,
      a = col[0],
      b = col[1],
      v = unit(b-a),
      n=line_normal(col)
    )
    [
      a - n*u/2,
      a + n*u/2,
      b + n*u/2,
      b - n*u/2,
    ]
  ])
);

function thumb_inner_column_end() = (
  let(
    u = plate_thickness,
    col = thumb_back[0],
    a=col[0],
    b=col[1],
    v=unit(b-a),
    n=line_normal(col)
  )
  [
    b - n*u/2 + v*u,
    b + n*u + v*u
  ]
);

function finger_front_slot() = (
  let(
    finger = finger_front,
    u = plate_thickness,
    p = finger[0],
    v = unit(finger[1] - finger[0]),
    n = line_normal(finger)
  )
  [
    p - n * u/2 + v * 10,
    p - n * u/2,
    p + n * u/2,
    p + n * u/2 + v * 4
  ]
);

function finger_back_slot() = (
  let(
    u = plate_thickness,
    finger = finger_back,
    p = finger[0],
    v = unit(finger[1] - finger[0]),
    n = line_normal(finger)
  )
  [
    p - n * u/2 + v * 4,
    p - n * u/2,
    p + n * u/2,
    p + n * u/2 - v * u,
  ]
);

function finger_to_thumb_curve() = (
  let(
    u = plate_thickness,
    thumb = thumb_back[2],
    tp = thumb[0],
    tv = unit(thumb[1] - thumb[0]),
    tn = line_normal(thumb),
    finger = finger_back,
    fp = finger[0],
    fv = unit(finger[1] - finger[0]),
    fn = line_normal(finger)
  )
  bezier_curve(flatten([
    bez_begin(fp + fn * u/2 - fv * u, 270, 80),
    bez_end(tp + tn * u*2 - tv * u, 0, 0),
  ]))
);

module brace() {
  linear_extrude(height=plate_thickness)
  region(
    concat(
      thumb_outer_column_end(),
      thumb_columns(),
      thumb_inner_column_end(),
      finger_front_slot(),
      finger_back_slot(),
      finger_to_thumb_curve()
    )
  );
}
