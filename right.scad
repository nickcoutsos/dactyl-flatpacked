use <connectors.scad>
use <finger-cluster/layout.scad>
use <finger-cluster/supports.scad>
use <thumb-cluster/layout.scad>
use <thumb-cluster/supports.scad>

main_layout();
thumb_layout();


color("gainsboro") {
  main_supports();
  thumb_supports();

  // difference() {
  //   union() {
  //     main_front_cross_support();
  //     main_back_cross_support();
  //   }
  //   main_supports();
  // }

  // difference() {
  //   union() {
  //     thumb_front_cross_support();
  //     thumb_back_cross_support();
  //   }
  //   thumb_supports();
  // }
}
