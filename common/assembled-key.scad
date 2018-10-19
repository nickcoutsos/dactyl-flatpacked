include <../common/definitions.scad>
use <../placeholders.scad>

module key (w=1, h=1) {
  color("gainsboro") plate(w, h);

  kailh_lowprofile_switch();

  color("ivory")
  translate([0, 0, cap_top_height - keycap_height])
  keycap(w, h);
}
