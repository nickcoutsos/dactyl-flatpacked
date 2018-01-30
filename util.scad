use <scad-utils/linalg.scad>

ORIGIN = [0, 0, 0, 1];
X = [1, 0, 0, 1];
Y = [0, 1, 0, 1];
Z = [0, 0, 1, 1];


// Given a known matrix transformation "from", rotate about the local X-axis
// such that the local Y-axis becomes co-planar with the XY plane.
module rotate_down(matrix) {
  localOrigin = matrix * ORIGIN;
  localX = (matrix * X) - localOrigin;
  localY = (matrix * Y) - localOrigin;
  localZ = (matrix * Z) - localOrigin;
  localN = unit(cross(localX, -Z));

  projectedZ = localZ - (take3(localZ) * localN) * localN;
  angle = -90 + acos(
    ( take3(projectedZ) * take3(localY) ) /
    ( norm(take3(projectedZ)) * norm(take3(localY)) )
  );

  rotate([angle, 0, 0]) children();
}

module mirror_quadrants() {
  children();
  mirror([1, 0, 0]) children();
  mirror([1, 0, 0]) mirror([0, 1, 0]) children();
  mirror([0, 1, 0]) children();
}
