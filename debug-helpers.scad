
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

module axes(length=30, alpha=1, r=.5) {
  color("red", alpha) vector([1, 0, 0] * length, r);
  color("limegreen", alpha) vector([0, 1, 0] * length, r);
  color("royalblue", alpha) vector([0, 0, 1] * length, r);
}

module square_axes(length=30, alpha=1, r=.5) {
  color("tomato", alpha)    translate([1, 0, 0]*length/2) cube([length, r, r], center=true);
  color("limegreen", alpha) translate([0, 1, 0]*length/2) cube([r, length, r], center=true);
  color("steelblue", alpha) translate([0, 0, 1]*length/2) cube([r, r, length], center=true);

  color("red", alpha)         translate([-1, 0, 0]*length/2) cube([length, r, r], center=true);
  color("forestgreen", alpha) translate([0, -1, 0]*length/2) cube([r, length, r], center=true);
  color("royalblue", alpha)   translate([0, 0, -1]*length/2) cube([r, r, length], center=true);
}
