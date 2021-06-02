
module vector(v, r=.5) {
  x = v[0];
  y = v[1];
  z = v[2];

  length = norm(v);
  theta = atan2(x, -y); // equator angle around z-up axis
  phi = acos( min( max(z / length, -1), 1) ); // polar angle

  rotate([0, 0, theta])
  rotate([phi, 0, 0]) {
    cylinder(r1=r, r2=r * .8, h=length * .95);
    translate([0, 0, length * .95])
      cylinder(r1=r * .8, r2=0, h=length * .05);
  }
}

module axes(length=30) {
  color("red") vector([1, 0, 0] * length);
  color("limegreen") vector([0, 1, 0] * length);
  color("royalblue") vector([0, 0, 1] * length);
}
