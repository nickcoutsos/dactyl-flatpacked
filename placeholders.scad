use <util.scad>
use <shape-profiles.scad>
include <definitions.scad>
include <switch-and-keycap-specs.scad>

module switch() {
  assert(search([switch_type], ["mx", "choc"]));
  if (switch_type == "mx") mx_switch();
  else if (switch_type == "choc") kailh_lowprofile_switch();
}

module keycap() {
  assert(search([keycap_type], ["xda", "choc", "simple", "sa"]));

  if (keycap_type == "xda") xda_keycap();
  else if (keycap_type == "choc") kailh_choc_keycap();
  else if (keycap_type == "simple") simple_keycap();
  else if (keycap_type == "sa") sa_keycap();
}

module mx_switch () {
  detail = !is_undef($detail) && $detail;

  color("saddlebrown") {
    translate([0, 0, 6]) cube([7, 5.3, 2], center=true);
    translate([0, 0, 6]) cube([4.1, 1.17, 7.2], center=true);
    translate([0, 0, 6]) cube([1.17, 4.1, 7.2], center=true);
  }

  color("gray")
  difference() {
    hull() {
      translate([0, .75, 6]) linear_extrude(height=.01) square([10.25, 9], center=true);
      translate([0, 0, 1]) linear_extrude(height=.01) square(13.97, center=true);
    }

    if (detail) translate([0, -7, 5]) cube([7.8, 6, 7.5], center=true);
  }

  color("dimgray") {
    translate([ (-13.97/2 - .5 + 2.5), (-13.97/2 - .5 + 1), 0.5]) cube([5, 2, 1], center=true);
    translate([ (-13.97/2 - .5 + 2.5),-(-13.97/2 - .5 + 1), 0.5]) cube([5, 2, 1], center=true);
    translate([-(-13.97/2 - .5 + 2.5),-(-13.97/2 - .5 + 1), 0.5]) cube([5, 2, 1], center=true);
    translate([-(-13.97/2 - .5 + 2.5), (-13.97/2 - .5 + 1), 0.5]) cube([5, 2, 1], center=true);

    difference() {
      hull() {
        translate([0, 0, 1]) linear_extrude(height=0.01) square(13.97, center=true);
        translate([0, 0, 0]) linear_extrude(height=0.01) square(13.97, center=true);
        translate([0, 0, -5]) linear_extrude(height=0.01) square(12.72, center=true);
      }

      if (detail) {
        translate([(14 - 2.11)/2, 0, -4.55/2]) cube([2.11, 3.81, 4.55], center=true);
        translate([-(14 - 2.11)/2, 0, -4.55/2]) cube([2.11, 3.81, 4.55], center=true);
      }
    }

    translate([0, 0, -5 -3]) cylinder(d=4, h=3);
  }

  color("gold") {
    translate([2, 4, 0] * 1.27) translate([0, 0, -5 -3.3]) cylinder(d=1.5, h=3.3);
    translate([-3, 2, 0] * 1.27) translate([0, 0, -5 -3.3]) cylinder(d=1.5, h=3.3);
  }
}

module kailh_lowprofile_switch() {
  color("lightgray") translate([0, 0, 1.4]) cube([13.8, 13.8, 2.8], center=true);
  color("lightgray") translate([0, 6.9, 0.4]) cube([15.0, 1.2, 0.8], center=true);
  color("lightgray") translate([0, -6.9, 0.4]) cube([15.0, 1.2, 0.8], center=true);
  color("dimgray") translate([0, 0, -1.1]) cube([13.8, 13.8, 2.2], center=true);
  color("dimgray") translate([0, 0, -2.2]) rotate([180, 0, 0]) cylinder(d=3.4, h=2.65);
  color("yellow") translate([0, -5.9, -2.2]) rotate([180, 0, 0]) cylinder(d=1.2, h=2.65);
  color("yellow") translate([5, -3.8, -2.2]) rotate([180, 0, 0]) cylinder(d=1.2, h=2.65);
  color("brown")
  translate([0, 0, 2.5+1.5+.3])
  difference() {
    cube([12, 5.5, 3], center=true);
    if (!is_undef($detail) && $detail) {
      translate([-5.7/2, 0, 0]) cube([1.2, 3.0, 5], center=true);
      translate([5.7/2, 0, 0]) cube([1.2, 3.0, 5], center=true);
    }
  }
}

module kailh_choc_keycap() {
  u = !is_undef($u) ? $u : 1;
  h = !is_undef($h) ? $h : 1;
  rot = !is_undef($rot) ? $rot : 0;
  pressed = !is_undef($key_pressed) && $key_pressed == true;

  width = choc_keycap_width * (rot == 90 ? h : u);
  depth = choc_keycap_depth * (rot == 90 ? u : h);
  height = choc_keycap_height;

  top_width = width - 2.6;
  top_depth = depth - 3.4;
  mount_height = choc_keycap_top_height
    - (pressed ? choc_switch_travel : 0)
    - height;

  color("ivory")
  translate([0, 0, mount_height])
  rotate([0, 0, rot])
  difference() {
    hull() {
      linear_extrude(height=.1) square([width, depth], center=true);
      translate([0, 0, 1.7]) linear_extrude(height=.1) square([width, depth], center=true);
      translate([0, 0.8, 3.5]) linear_extrude(height=.1) square([top_width, top_depth], center=true);
    }

    if (!is_undef($detail) && $detail) {
      translate([0, 0, 3 +90])
      rotate([90, 0, 0])
      scale([u, 1, h])
      sphere(r=90, $fa=1);
    }
  }
}

module simple_keycap() {
  keycap_length = 18.1;
  keycap_height = 9.39;
  keycap_inner_length = 12.37;
  u = is_undef($u) ? 1 : $u;
  h = is_undef($h) ? 1 : $h;
  x = u / 2 * keycap_length;
  y = h / 2 * keycap_length;
  z = keycap_height;
  mount_height = keycap_height + mx_switch_travel
    - (pressed ? mx_switch_travel : 0)
    - keycap_height;

  x2 = x - (keycap_length - keycap_inner_length) / 2.25;
  y2 = y - (keycap_length - keycap_inner_length) / 2.25;

  lower = [ [-x, -y], [ x, -y], [ x,  y], [-x,  y] ];
  upper = [ [-x2, -y2], [ x2, -y2], [ x2,  y2], [-x2,  y2] ];

  color("whitesmoke")
  translate([0, 0, mount_height])
  difference() {
    hull() {
      translate([0, 0, z])
      linear_extrude(height=.1)
        polygon(upper);
      translate([0, 0, z/3])
      linear_extrude(height=.1)
        polygon(lower);
      linear_extrude(height=.1)
        polygon(lower);
    }

    if (!is_undef($detail) && $detail) {
      translate([0, 0, -2])
      hull() {
        translate([0, 0, z])
        linear_extrude(height=.1)
          polygon(upper);
        translate([0, 0, z/3])
        linear_extrude(height=.1)
          polygon(lower);
        linear_extrude(height=.1)
          polygon(lower);
      }
    }
  }
}

module xda_keycap(steps=4) {
  u = is_undef($u) ? 1 : $u;
  h = is_undef($h) ? 1 : $h;
  rot = !is_undef($rot) ? $rot : 0;
  x = rot == 90 ? h : u;
  y = rot == 90 ? u : h;
  detail = !is_undef($detail) && $detail;
  pressed = !is_undef($key_pressed) && $key_pressed;

  bottom_radius = xda_bottom_corner_radius;
  top_radius = xda_top_corner_radius;
  dish_radius = 90;

  width = xda_keycap_width * x;
  depth = xda_keycap_depth * y;
  height = xda_keycap_height;
  mount_height = xda_keycap_top_height
    - (pressed ? mx_switch_travel : 0)
    - height;

  inset = [
    (xda_keycap_width - xda_top_width) / 2,
    (xda_keycap_depth - xda_top_depth) / 2,
    0
  ];

  function l (t, s) = (
    let(cos4t=pow(cos(t), s))
    let(sin4t=pow(sin(t), s))
    let(rho=1/pow(cos4t + sin4t, 1/s))
    [
      rho * cos(t),
      rho * sin(t)
    ]
  );

  function make_squircle(r=1, s=5, steps=40) = (
    let(quadrant = concat([
      for (t=[0:steps/4])
      l(t/(steps/4)*90, s) * r
    ], [[0, r]]))

    concat(
      quadrant,
      [ for (p=quadrant) [-p.x,  p.y] ],
      [ for (p=quadrant) [-p.x, -p.y] ],
      [ for (p=quadrant) [ p.x, -p.y] ]
    )
  );

  module squircle(r=1, s=5, steps=40) {
    polygon(make_squircle(r, s, steps));
  }

  module draw_layer_profile(r, s, steps) {
    points = [for (p=make_squircle(r, s, steps)) [
      (p.x != 0 && x > 1) ? sign(p.x) * (width/2 - xda_keycap_width/2) + p.x: p.x,
      (p.y != 0 && y > 1) ? sign(p.y) * (depth/2 - xda_keycap_depth/2) + p.y: p.y
    ]];

    polygon(points);
  }

  module cap() {
    s = [3.75, 10];
    r = [xda_top_width/2, xda_keycap_width/2];

    hull()
    {
      for (i=[0:steps-1]) {
        t = i / steps;

        translate([0, 0, xda_keycap_height] * t)
        linear_extrude(height=0.1)
        draw_layer_profile(
          r=r[1] + (r[0] - r[1]) * t*t,
          s=s[1] + (s[0] - s[1]) * t,
          steps=40
        );
      }

      translate([0, 0, xda_keycap_height] * 0.99)
        linear_extrude(height=0.1)
        draw_layer_profile(
          r=xda_top_width/2 * 0.99,
          s=s[1] + (s[0] - s[1]) * 0.99,
          steps=40
        );


      translate([0, 0, xda_keycap_height] * 1.025)
        linear_extrude(height=0.1)
        draw_layer_profile(
          r=xda_top_width/2 * .95,
          s=s[1] + (s[0] - s[1]) * 1.025,
          steps=40
        );

    }
  }

  module cavity() {
    translate([0, 0, -0.01])
    scale([
      (width - xda_keycap_thickness * 2) / width,
      (depth - xda_keycap_thickness * 2) / depth,
      (height - xda_keycap_thickness) / height
    ]) cap();
  }

  module dish() {
    translate([0, 0, xda_keycap_height -.05 +dish_radius])
    rotate([90, 0, 0])
    scale([x, 1, y])
      sphere(r=dish_radius, $fa=1);
  }

  module stem() {
    cylinder(d=5.25, h=xda_keycap_height - 1);
  }

  translate([0, 0, mount_height])
  color("whitesmoke") {
    if (detail) stem();
    difference() {
      cap();
      if (detail) cavity();
      if (detail) dish();
    }
  }
}

module plate (w=1, h=1, render_2d=false, align=0) {
  w = is_undef($u) ? w : $u;
  h = is_undef($h) ? h : $h;
  paths = plate(w, h, align);

  if (render_2d) {
    region(paths);
  } else {
    translate([0, 0, -plate_thickness])
    linear_extrude(height=plate_thickness)
    region(paths);
  }
}

module sa_keycap(steps=4) {
  u = is_undef($u) ? 1 : $u;
  h = is_undef($h) ? 1 : $h;
  rot = !is_undef($rot) ? $rot : 0;
  x = rot == 90 ? h : u;
  y = rot == 90 ? u : h;
  detail = !is_undef($detail) && $detail;
  pressed = !is_undef($key_pressed) && $key_pressed;

  bottom_radius = sa_bottom_corner_radius;
  top_radius = sa_top_corner_radius;
  dish_radius = 90;

  width = sa_keycap_width * x;
  depth = sa_keycap_depth * y;
  height = sa_keycap_height;
  mount_height = sa_keycap_top_height
    - (pressed ? mx_switch_travel : 0)
    - height;

  inset = [
    (sa_keycap_width - sa_top_width) / 2,
    (sa_keycap_depth - sa_top_depth) / 2,
    0
  ];

  function l (t, s) = (
    let(cos4t=pow(cos(t), s))
    let(sin4t=pow(sin(t), s))
    let(rho=1/pow(cos4t + sin4t, 1/s))
    [
      rho * cos(t),
      rho * sin(t)
    ]
  );

  function make_squircle(r=1, s=5, steps=40) = (
    let(quadrant = concat([
      for (t=[0:steps/4])
      l(t/(steps/4)*90, s) * r
    ], [[0, r]]))

    concat(
      quadrant,
      [ for (p=quadrant) [-p.x,  p.y] ],
      [ for (p=quadrant) [-p.x, -p.y] ],
      [ for (p=quadrant) [ p.x, -p.y] ]
    )
  );

  module squircle(r=1, s=5, steps=40) {
    polygon(make_squircle(r, s, steps));
  }

  module draw_layer_profile(r, s, steps) {
    points = [for (p=make_squircle(r, s, steps)) [
      (p.x != 0 && x > 1) ? sign(p.x) * (width/2 - sa_keycap_width/2) + p.x: p.x,
      (p.y != 0 && y > 1) ? sign(p.y) * (depth/2 - sa_keycap_depth/2) + p.y: p.y
    ]];

    polygon(points);
  }

  module cap() {
    s = [3.75, 10];
    r = [sa_top_width/2, sa_keycap_width/2];

    hull()
    {
      for (i=[0:steps-1]) {
        t = i / steps;

        translate([0, 0, sa_keycap_height] * t)
        linear_extrude(height=0.1)
        draw_layer_profile(
          r=r[1] + (r[0] - r[1]) * t*t,
          s=s[1] + (s[0] - s[1]) * t,
          steps=40
        );
      }

      translate([0, 0, sa_keycap_height] * 0.99)
        linear_extrude(height=0.1)
        draw_layer_profile(
          r=sa_top_width/2 * 0.99,
          s=s[1] + (s[0] - s[1]) * 0.99,
          steps=40
        );


      translate([0, 0, sa_keycap_height] * 1.025)
        linear_extrude(height=0.1)
        draw_layer_profile(
          r=sa_top_width/2 * .95,
          s=s[1] + (s[0] - s[1]) * 1.025,
          steps=40
        );

    }
  }

  translate([0, 0, mount_height])
  color("whitesmoke")
  cap();
}
