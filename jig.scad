include <definitions.scad>
use <positioning.scad>
use <placeholders.scad>
use <supports.scad>

$fn = 120;

// // intersection() {
//   difference() {
//     place_keys(5, 2)
//     translate([0, 0, main_row_radius - plate_thickness/2])
//     rotate([0, 90, 0])
//     cylinder(r=main_row_radius, h=18.5, center=true);

//     #place_keys(5, [0:4]) plate();

//     place_keys(5, [-0.5, 0.5, 1.5, 2.5, 3.5, 4.5])
//       translate([0, 0, -1])
//       cube([22, 5, 1], center=true);

//     // #render()
//     {
//     main_support_columns(columns=5);
//     }
//     // translate([-(plate_width / 4), 0, 0])
//     // main_support_outer_column_single();

//     // place_keys(5, 2)
//     // translate([0, 0, main_row_radius - plate_thickness/2])
//     // rotate([0, 90, 0])
//     // cylinder(r=main_row_radius-5, h=25, center=true);
//   }

// //   place_keys(5, 2) cube([50, 108, 42], center=true);
// //   // #place_keys(5, 2) cube([50, 30, 42], center=true);
// // }



// intersection() {
//   difference() {
//     thumb_place(2, 0)
//     translate([0, 0, thumb_row_radius - plate_thickness/2])
//     rotate([0, 90, 0])
//     cylinder(r=thumb_row_radius, h=18.5, center=true);

//     place_thumb_keys(2, [-1:1]) plate();

//     place_thumb_keys(2, [-0.5, 0.5])
//       translate([0, 0, -1])
//       cube([22, 5, 1], center=true);

//     // #render()
//     {
//     thumb_supports_col1();
//     }
//     // translate([-(plate_width / 4), 0, 0])
//     // main_support_outer_column_single();

//     thumb_place(2, 2)
//     translate([0, 0, thumb_row_radius - plate_thickness/2])
//     rotate([0, 90, 0])
//     cylinder(r=thumb_row_radius-5, h=25, center=true);
//   }

//   thumb_place(2, 0) cube([50, 70, 42], center=true);
//   // #thumb_place(5, 2) cube([50, 30, 42], center=true);
// }



intersection() {
  difference() {
    thumb_place(1, 0)
    translate([0, 0, thumb_row_radius - plate_thickness/2])
    rotate([0, 90, 0])
    cylinder(r=thumb_row_radius, h=18.5, center=true);

    place_thumb_keys(1, 1) plate();
    place_thumb_keys(1, -0.5) plate(h=2);

    place_thumb_keys(1, [0.5])
      translate([0, 0, -1])
      cube([22, 5, 1], center=true);

    // #render()
    {
    thumb_supports_col3();
    }
    // translate([-(plate_width / 4), 0, 0])
    // main_support_outer_column_single();

    thumb_place(1, 2)
    translate([0, 0, thumb_row_radius - plate_thickness/2])
    rotate([0, 90, 0])
    cylinder(r=thumb_row_radius-5, h=25, center=true);
  }

  thumb_place(1, 0) cube([50, 70, 42], center=true);
  // #thumb_place(5, 2) cube([50, 30, 42], center=true);
}


// thumb_place(5, [0:4])
// translate([0, 0, -2])
//   cube([keyhole_length*.96, keyhole_length*.98, 4], center=true);

length = rib_spacing - rib_thickness*2;
height = length * 1.5;

// main_support_columns(columns=5);
// color(alpha=0.4)
//     translate([-(plate_width / 4), 0, 0])
//     main_support_outer_column_single();
// place_keys(5, 4)
// translate([0, 0, -column_rib_height])
// rotate([-alpha*(2-4), 0, 0])
// translate(column_offset_middle)
// translate(-column_offsets[5]) {
//   translate([0, 0, -5])
//     cube([22, rib_thickness - .3, length], center=true);

//   translate([0, 0,  -5 + (height-length)/2]) {
//     cube([length - .3, length, height], center=true);

//     translate([rib_spacing - rib_thickness - length/4, 0, 0])
//       cube([length/2, length, height], center=true);

//     translate([-(rib_spacing - rib_thickness - length/4), 0, 0])
//       cube([length/2, length, height], center=true);
//   }
// }

// place_keys(5, 4)
// translate([0, 0, -column_rib_height])
// rotate([-alpha*(2-4), 0, 0])
// translate(column_offset_middle)
// translate(-column_offsets[5]) {
//   translate([0, 0, -5])
//     cube([22, rib_thickness - .3, length], center=true);

//   translate([0, 0,  -5 + (height-length)/2]) {
//     cube([(rib_spacing ), length, height], center=true);

//     translate([rib_spacing*1.5/2 - rib_thickness*1.5/2 + (length/2 - rib_thickness)/2+rib_thickness, 0, 0])
//       cube([length/2, length, height], center=true);

//     translate([-(rib_spacing*1.5/2 - rib_thickness*1.5/2 + (length/2 - rib_thickness)/2+rib_thickness), 0, 0])
//       cube([length/2, length, height], center=true);
//   }
// }
