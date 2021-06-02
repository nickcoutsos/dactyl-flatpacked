use <placeholders.scad>
use <key-layouts.scad>
use <finger-cluster/supports.scad>
use <thumb-cluster/supports.scad>
include <definitions.scad>

keycap_offset = [0, 0, cap_top_height - keycap_height];

*color("ivory") finger_cluster_layout() keycap(1, 1);
*color("gray") finger_cluster_layout() switch();
color("skyblue") finger_cluster_layout() plate();
finger_cluster_support_columns();
finger_cluster_cross_support_front();
finger_cluster_cross_support_back();

*color("ivory") thumb_cluster_layout() keycap(1, 1);
*color("gray") thumb_cluster_layout() switch();
color("skyblue") thumb_cluster_layout() plate();
thumb_support_columns();
thumb_front_cross_support();
thumb_back_cross_support();
