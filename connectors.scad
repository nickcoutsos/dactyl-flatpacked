use <supports.scad>

posts = [
  [-52.8, -8.24, 0],
  [-46.73, 63.25, 0],
  [-26.78, -46.81, 0],
  [-16.68, -75.09, 0],

  [-93.8, -18, 0],
  [-78.5, -89.8, 0],
  [84.29, 63.25, 0],
  [82.4, -46.81, 0]
];

// translate(posts[7]) {
//   cylinder(d=7, h=6);
//   color("red")
//   translate([0, 0, 60])
//     sphere(r=1, $fn=4);
// }

module connectors() {
  $fn=12;
  // hull_pairs (close=true) {
  //   translate(posts[0]) cylinder(d=5, h=6);
  //   translate(posts[1]) cylinder(d=5, h=6);
  //   translate(posts[2]) cylinder(d=5, h=6);
  //   translate(posts[3]) cylinder(d=5, h=6);
  // }

  // hull_pairs (close=false) {
  //   translate(posts[0]) cylinder(d=5, h=6);
  //   translate(posts[1]) cylinder(d=5, h=6);
  //   translate(posts[6]) cylinder(d=5, h=6);
  //   translate(posts[7]) cylinder(d=5, h=6);
  // }

  // hull_pairs (close=false) {
  //   translate(posts[2]) cylinder(d=5, h=6);
  //   translate(posts[3]) cylinder(d=5, h=6);
  // }

  // hull_pairs (close=false) {
  //   translate(posts[0]) cylinder(d=5, h=6);
  //   translate(posts[1]) cylinder(d=5, h=6);
  //   translate(posts[6]) cylinder(d=5, h=6);
  //   translate(posts[7]) cylinder(d=5, h=6);
  //   translate(posts[2]) cylinder(d=5, h=6);
  //   translate(posts[3]) cylinder(d=5, h=6);
  // }

  // // back
  // hull() {
  //   translate(posts[0]) cylinder(d=7, h=4);
  //   translate(posts[4]) cylinder(d=7, h=4);
  // }

  // hull() {
  //   translate(posts[0]) cylinder(d=7, h=4);
  //   translate(posts[1]) cylinder(d=7, h=4);
  // }

  // hull() {
  //   translate(posts[1]) cylinder(d=7, h=4);
  //   translate(posts[6]) cylinder(d=7, h=4);
  // }

  // front
  hull() {
    translate(posts[2]) cylinder(d=7, h=4);
    translate(posts[3]) cylinder(d=7, h=4);
  }

  hull() {
    translate(posts[2]) cylinder(d=7, h=4);
    translate(posts[7]) cylinder(d=7, h=4);
  }

  hull() {
    translate(posts[3]) cylinder(d=7, h=4);
    translate(posts[5]) cylinder(d=7, h=4);
  }



  // for (post=posts) {
  //   translate(post) cylinder(d=7, h=6);
  // }








  // hull() {
  //   translate(posts[0]) cylinder(d=5, h=6);
  //   translate(posts[1]) cylinder(d=5, h=6);
  // }


  // translate(posts[0]) cylinder(d=7, h=6);
  // translate(posts[1]) cylinder(d=7, h=6);
  // translate(posts[2]) cylinder(d=7, h=6);
  // translate(posts[3]) cylinder(d=7, h=6);
}



difference ()
{
  connectors();

  #translate([0, 0, -1])
  linear_extrude(height=10)
  projection() {
    // finger_cluster_cross_support_front();
    // thumb_front_cross_support();
    finger_cluster_cross_support_back();
    thumb_back_cross_support();
  }

  main_supports();
}


// translate([0, 0, 9])
// color("red", alpha=.4)
// for(pos=posts) {
//   translate(pos) sphere(d=rib_thickness, $fn=36);
// }
// translate()  {
// }

// translate() {
//   cylinder(d=5, h=6);
//   // translate([0, 0, 50])color("red") sphere(d=rib_thickness);
// }

// translate() {
//   cylinder(d=5, h=6);
//   // translate([0, 0, 50])color("red") sphere(d=rib_thickness);
// }

// translate() {
//   cylinder(d=5, h=6);
//   // translate([0, 0, 50])color("red") sphere(d=rib_thickness);
// }
// }
