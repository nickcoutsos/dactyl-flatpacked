include <definitions.scad>
use <positioning.scad>
use <placeholders.scad>
use <util.scad>

module key (w=1, h=1) {
  plate(w, h);
  switch();

  translate([0, 0, plate_thickness+3])
  scale([w, h, 1 ]) keycap();
}

/// KEY LAYOUT

// main keys
each_key() key();

// last little key
place_keys([5], [4]) key();

// modifier key column
place_keys([5.125], [0:3]) key(w=1.25);

// inner key column
// this seems difficult to include with the thumb cluster.
// place_keys([-1], [0]) key();
// place_keys([-1], [1.25, 2.75]) key(h=1.5);

// thumb cluster
place_thumb_keys([2], [-1:1]) key();
place_thumb_keys([1], [1]) key();
place_thumb_keys([0,1], [-0.5]) key(h=2);
