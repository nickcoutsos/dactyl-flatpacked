use <placeholders.scad>
use <finger-cluster/layout.scad>
use <finger-cluster/supports.scad>
use <thumb-cluster/layout.scad>
use <thumb-cluster/supports.scad>
include <common/definitions.scad>

keycap_offset = [0, 0, cap_top_height - keycap_height];

*color("ivory") main_layout() keycap(1, 1);
*color("gray") main_layout() switch();
color("skyblue") main_layout() plate();
finger_cluster_support_columns();
finger_cluster_cross_support_front();
finger_cluster_cross_support_back();

*color("ivory") thumb_layout() keycap(1, 1);
*color("gray") thumb_layout() switch();
color("skyblue") thumb_layout() plate();
thumb_support_columns();
thumb_front_cross_support();
thumb_back_cross_support();
