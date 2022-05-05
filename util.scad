include <BOSL2/std.scad>

function list(list_) = [for(v=list_) v];
function reverse(list_or_range) = let(list_=list(list_or_range)) [for(i=[0:len(list_)-1]) list_[len(list_)-1-i]];
function first (vec) = vec[0];
function last (vec) = vec[ len(vec) - 1];
function flatten(arrays) = (
  len(arrays) > 1
    ? concat(arrays[0], flatten([for(i=[1:len(arrays)-1]) arrays[i]]))
    : arrays[0]
);

function any(list) = len([for(v=list) if (!!v) v]) > 0;
function every(list) = len([for(v=list) if (!!v) v]) == len(list);

function vnf_contains_point(vnf, point) = (
  let(v = vnf_vertices(vnf))
  let(planes = [
    for(f=vnf_faces(vnf))
    plane_from_points([ v[f[0]], v[f[1]], v[f[2]] ], fast=true)
  ])
  every([
    for(plane=planes)
    !in_front_of_plane(plane, point)
  ])
);

function slice(vec, start, end) = (
  let(e=is_undef(end) ? len(vec) - 1 : end)
  [ for(i=[start:e]) vec[i] ]
);

function takeXY (vec) = [vec.x, vec.y];
function vec3(v) = make_vector(v, 3);
function make_vector(v, length, default=0) = (
  [for(i=[0:length-1]) !is_undef(v[i]) ? v[i] : default]
);

function angleTo (a, b) = (
  let(a = vec3(unit(a)))
  let(b = vec3(unit(b)))
  let(divisor = norm(a) * norm(b))

  divisor == 0 ? 90 : acos(max(-1, min(1, a*b / divisor)))
);

function rotation_down(matrix) = (
  let(globalX = [1, 0, 0])
  let(globalZ = [0, 0, 1])
  let(localOrigin = apply(matrix, [0, 0, 0]))
  let(localX = apply(matrix, globalX) - localOrigin)
  let(localZ = apply(matrix, globalZ) - localOrigin)
  let(projectedZ = globalZ - (globalZ * localX) * localX)
  let(angle = angleTo(projectedZ, localZ))
  let(reverse = sign(angleTo(localX, cross(projectedZ, localZ)) - 90))

  rot([angle * reverse, 0, 0])
);

/**
 * Create a polygon from a line segment, giving it width
 */
function thicken_line (points, width) = (
  assert(len(points) > 1)
  let(vector = unit(points[1] - points[0]))
  let(normal = [-vector.y, vector.x])

  [
    points[0] + normal * width/2,
    points[0] - normal * width/2,
    points[1] - normal * width/2,
    points[1] + normal * width/2,
  ]
);

/**
 * Return a polygon hullfor the given points
 * This is just BOSL2's hull_points but as a function.
 */
function hull_points (points) = (
  let(hull_indices = hull(points))
  [ for(i=hull_indices) points[i] ]
);


// Given a known matrix transformation "from", rotate about the local X-axis
// such that the local Y-axis becomes co-planar with the XY plane.
module rotate_down(matrix) multmatrix(rotation_down(matrix)) children();

module mirror_quadrants() {
  children();
  mirror([1, 0, 0]) children();
  mirror([1, 0, 0]) mirror([0, 1, 0]) children();
  mirror([0, 1, 0]) children();
}

module hull_pairs(close=false) {
  for (i=[0:$children-2]) {
    hull() {
      children(i);
      children(i+1);
    }
  }

  if (close) {
    hull() {
      children(0);
      children($children - 1);
    }
  }
}

module extruded_polygon(points, thickness) {
  vectorA = vec3(points[1] - points[0]);
  vectorB = vec3(points[2] - points[0]);
  normal = unit(cross(vectorA, vectorB));
  target = [0, 0, -1];
  axis = unit(cross(normal, target));
  angle = acos(
    ( normal * target ) /
    ( norm(normal) * norm(target) )
  );

  transform = rot(angle, v=axis) * move(-points[0]);
  untransform = move(points[0]) * rot(-angle, v=axis);

  transformed = apply(transform, points);

  multmatrix(untransform)
  linear_extrude(thickness, center=true)
  // shell(d=-5.5)
  polygon([ for(p=transformed) takeXY(p) ]);
}
