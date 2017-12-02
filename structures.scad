include <definitions.scad>

inner = main_row_radius + plate_thickness/2;
outer = inner * 2;

module column_rib (start, end) {
  translate([0, 0, main_row_radius])
  rotate([0, 90, 0]) {
    difference() {
      cylinder(
        r=outer,
        h=plate_thickness,
        center=true
      );

      cylinder(r=inner, h=plate_thickness+1, center=true);

      rotate([0, 0, -90 - alpha * (start - 2 - .5)])
      difference() {
        cylinder(r=outer*2, h=plate_thickness+1, center=true, $fn=12);
        scale([outer*2, outer*4, plate_thickness*5])
        translate([0, -.5, -.5])
        cube(1);
      }
      rotate([0, 0, 90 - alpha * (end - 2 + .5)])
      difference() {
        cylinder(r=outer*2, h=plate_thickness+1, center=true, $fn=12);
        scale([outer*2, outer*4, plate_thickness*5])
        translate([0, -.5, -.5])
        cube(1);
      }
    }
  }
}
