include <definitions.scad>
use <placeholders.scad>

module fan(inner, outer, start, end) {
  steps = $fn ? $fn : 60;

  segments = (end - start) / steps;
  polygon(concat(
    [ for (i=[0:steps]) [inner * cos(start + i * segments), inner * sin(start + i * segments)] ],
    [ for (i=[0:steps]) [outer * cos(start + (steps - i) * segments), outer * sin(start + (steps - i) * segments)] ]
  ));
}

module column_rib (start, end, height=column_rib_height, thickness=rib_thickness) {
  radius = main_row_radius;
  inner = radius;
  outer = inner + height;

  a = alpha * (start - 2 - rib_extension);
  b = alpha * (end - 2 + rib_extension);

  translate([0, 0, radius]) {
    rotate([0, 90, 0]) {
      linear_extrude(thickness, center=true)
      fan(inner, outer, a, b);
    }
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
      alpha * (start - 2 - rib_extension),
      alpha * (end - 2 + rib_extension)
    );
  }
}
