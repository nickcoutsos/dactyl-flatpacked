include <definitions.scad>

module fan(inner, outer, start, end) {
  polygon(concat(
    [ for (i=[start:end]) [inner * cos(i), inner * sin(i)] ],
    [ for (i=[start:end]) [outer * cos(end-i+start), outer * sin(end-i+start)] ]
  ));
}

module column_rib (start, end, height=column_rib_height, thickness=rib_thickness) {
  radius = main_row_radius;
  inner = radius;
  outer = inner + height;

  translate([0, 0, radius])
  rotate([0, 90, 0]) {
    linear_extrude(thickness, center=true)
    fan(
      inner, outer,
      alpha * (start - 2 - .6),
      alpha * (end - 2 + .6)
    );
  }
}

module thumb_column_rib (start, end, height=column_rib_height) {
  radius = thumb_row_radius;
  inner = radius;
  outer = inner + height;

  translate([0, 0, radius])
  rotate([0, 90, 0]) {
    linear_extrude(rib_thickness, center=true)
    fan(
      inner, outer,
      alpha * (start - 2 - .5),
      alpha * (end - 2 + .5)
    );
  }
}
