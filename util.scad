use <scad-utils/transformations.scad>
use <scad-utils/morphology.scad>
use <scad-utils/linalg.scad>

ORIGIN = [0, 0, 0, 1];
X = [1, 0, 0, 1];
Y = [0, 1, 0, 1];
Z = [0, 0, 1, 1];

function list(list_) = [for(v=list_) v];
function reverse(list_or_range) = let(list_=list(list_or_range)) [for(i=[0:len(list_)-1]) list_[len(list_)-1-i]];
function first (vec) = vec[0];
function last (vec) = vec[ len(vec) - 1];
function flatten(arrays) = (
  len(arrays) > 1
    ? concat(arrays[0], flatten([for(i=[1:len(arrays)-1]) arrays[i]]))
    : arrays[0]
);

function slice(vec, start, end) = (
  let(e=is_undef(end) ? len(vec) - 1 : end)
  [ for(i=[start:e]) vec[i] ]
);

function takeXY (vec) = [vec.x, vec.y];
function takeXZ (vec) = [vec.x, vec.z];
function vec4(v) = (
  let(l=len(v))
  let(x = l > 0 ? v.x : 0)
  let(y = l > 1 ? v.y : 0)
  let(z = l > 2 ? v.z : 0)
  [x, y, z, 1]
);

function apply_matrix (v, m) = (
  m * [ v.x, v.y, v.z, 1 ]
);

function angleTo (a, b) = acos(
  ( take3(unit(a)) * take3(unit(b)) ) /
  ( norm(take3(unit(a))) * norm(take3(unit(b))) )
);

function rotation_down(matrix, invert=false) = (
  let(localOrigin = matrix * ORIGIN)
  let(localX = (matrix * X) - localOrigin)
  let(localY = (matrix * Y) - localOrigin)
  let(localZ = (matrix * Z) - localOrigin)
  let(localN = unit(cross(localX, -Z)))

  let(projectedZ = localZ - (take3(localZ) * localN) * localN)
  let(angle = -90 + acos(
    ( take3(projectedZ) * take3(localY) ) /
    ( norm(take3(projectedZ)) * norm(take3(localY)) )
  ))

  rotation([(invert ? -1 : 1) * angle, 0, 0])
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
  vectorA = take3(points[1] - points[0]);
  vectorB = take3(points[2] - points[0]);
  normal = unit(cross(vectorA, vectorB));
  target = [0, 0, -1];
  axis = unit(cross(normal, target));
  angle = acos(
    ( normal * target ) /
    ( norm(normal) * norm(target) )
  );

  transform = rotation(axis=axis * angle) * translation(-points[0]);
  untransform = translation(points[0]) * rotation(axis=-(axis * angle));

  transformed = [ for (p=points) apply_matrix(p, transform) ];

  multmatrix(untransform)
  linear_extrude(thickness, center=true)
  // shell(d=-5.5)
  polygon([ for(p=transformed) takeXY(p) ]);
}
