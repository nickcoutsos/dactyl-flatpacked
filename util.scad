use <scad-utils/transformations.scad>
use <scad-utils/linalg.scad>

ORIGIN = [0, 0, 0, 1];
X = [1, 0, 0, 1];
Y = [0, 1, 0, 1];
Z = [0, 0, 1, 1];

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

  rotation([invert ? -1 : 1 * angle, 0, 0])
);

// Given a known matrix transformation "from", rotate about the local X-axis
// such that the local Y-axis becomes co-planar with the XY plane.
module rotate_down(matrix) {
  multmatrix(rotation_down(matrix)) children();
}

module mirror_quadrants() {
  children();
  mirror([1, 0, 0]) children();
  mirror([1, 0, 0]) mirror([0, 1, 0]) children();
  mirror([0, 1, 0]) children();
}
