use <placeholders.scad>
use <key-layouts.scad>
use <supports.scad>
include <definitions.scad>

layout("finger", $render_plates=true, $render_switches=true, $render_keycaps=true);
color("mediumseagreen") finger_cluster_support_columns();
color("lightgreen") finger_cluster_cross_support_front();
color("lightgreen") finger_cluster_cross_support_back();

layout("thumb", $render_plates=true, $render_switches=true, $render_keycaps=true);
color("mediumseagreen") thumb_support_columns();
color("lightgreen") thumb_front_cross_support([0]);
color("lightgreen") thumb_front_cross_support([1]);
color("lightgreen") thumb_front_cross_support([2]);
color("lightgreen") thumb_back_cross_support([0]);
color("lightgreen") thumb_back_cross_support([1]);
color("lightgreen") thumb_back_cross_support([2]);
