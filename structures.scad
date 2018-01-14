include <definitions.scad>

module fan(inner, outer, start, end) {
  polygon(concat(
    [ for (i=[start:end]) [inner * cos(i), inner * sin(i)] ],
    [ for (i=[start:end]) [outer * cos(end-i+start), outer * sin(end-i+start)] ]
  ));
}

module column_rib (start, end, height=column_rib_height) {
  radius = main_row_radius;
  inner = radius + plate_thickness/2;
  outer = inner + height;

  translate([0, 0, radius])
  rotate([0, 90, 0]) {
    linear_extrude(plate_thickness, center=true)
    fan(
      inner, outer,
      alpha * (start - 2 - .6),
      alpha * (end - 2 + .6)
    );
  }
}

module row_rib(start, end) {
  radius = main_column_radius;
  inner = radius + plate_thickness/2;
  outer = inner + 10;

  translate([0, 0, radius])
  rotate([0, 90, 0])
  rotate([90, 0, 0]) {
    linear_extrude(plate_thickness, center=true)
    fan(
      inner, outer,
      beta * (start - 2 - .5),
      beta * (end - 2 + .5)
    );
  }
}

module thumb_column_rib (start, end, height=column_rib_height) {
  radius = thumb_row_radius;
  inner = radius + plate_thickness/2;
  outer = inner + height;

  translate([0, 0, radius])
  rotate([0, 90, 0]) {
    linear_extrude(plate_thickness, center=true)
    fan(
      inner, outer,
      alpha * (start - 2 - .5),
      alpha * (end - 2 + .5)
    );
  }
}
