include <definitions.scad>

inner = main_row_radius + plate_thickness/2;
outer = inner * 2;

module fan(inner, outer, start, end) {
  polygon(concat(
    [ for (i=[start:1:end]) [inner * cos(i), inner * sin(i)] ],
    [ for (i=[start:1:end]) [outer * cos(end-i+start), outer * sin(end-i+start)] ]
  ));

  // polygon([ for (i=[start:.5:end]) [inner * cos(i), inner * sin(i)] ]);
}

module column_rib (start, end) {
  translate([0, 0, main_row_radius])
  rotate([0, 90, 0]) {
    linear_extrude(plate_thickness, center=true)
    fan(
      inner, outer,
      alpha * (start - 2 - .5),
      alpha * (end - 2 + .5)
    );
  }
}

thumb_inner = thumb_row_radius + plate_thickness/2;
thumb_outer = thumb_inner * 2;

module thumb_column_rib (start, end) {
  translate([0, 0, thumb_row_radius])
  rotate([0, 90, 0]) {
    linear_extrude(plate_thickness, center=true)
    fan(
      inner, outer,
      alpha * (start - 2 - .5),
      alpha * (end - 2 + .5)
    );
  }
}
