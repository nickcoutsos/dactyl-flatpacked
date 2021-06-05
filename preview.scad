use <placeholders.scad>
use <key-layouts.scad>
use <supports.scad>
include <definitions.scad>

finger_cluster_layout() xda_keycap();
finger_cluster_layout() mx_switch();
color("skyblue") finger_cluster_layout() plate();
color("mediumseagreen") finger_cluster_support_columns();
color("lightgreen") finger_cluster_cross_support_front();
color("lightgreen") finger_cluster_cross_support_back();

thumb_cluster_layout() xda_keycap();
thumb_cluster_layout() mx_switch();
color("skyblue") thumb_cluster_layout() plate();
color("mediumseagreen") thumb_support_columns();
color("lightgreen") thumb_front_cross_support();
color("lightgreen") thumb_back_cross_support();
