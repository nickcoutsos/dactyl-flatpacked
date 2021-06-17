use <arrange.scad>
use <placeholders.scad>
use <supports.scad>
use <util.scad>

include <definitions.scad>
include <BOSL2/std.scad>

function orient_cross_support(vertices) = (
  let(base_points = [for(v=vertices) if (v.z < .0001) v])
  let(vec = last(base_points) - first(base_points))
  let(angle = angleTo(vec, X))
  let(matrix = (
    affine3d_identity()
    * rot([-90, 0, 0])
    * rot([0, 0, -angle])
    * move(-first(base_points))
  ))
  [for (v=apply(matrix, vertices)) [v.x, v.y]]
);

function arrange_key_plates(cluster, spacing=2, reverse_columns=false, align_items="end") = (
  assert(cluster == "finger" || cluster == "thumb")
  let(columns = cluster == "finger" ? finger_columns : thumb_columns)
  arrange([
    for (colIndex=[0:len(columns)-1])
    arrange([
      for (rowIndex=[0:len(columns[colIndex])-1])
      let (overrides = get_overrides(cluster, colIndex, rowIndex))
      let (u = overrides[0])
      let (h = overrides[1])
      plate(u, h)
    ], direction="column-reverse", spacing=spacing)
  ], direction=reverse_columns ? "row-reverse" : "row", spacing=spacing, align_items=align_items)
);

function arrange_column_supports(cluster, spacing=0, align_items="center") = (
  assert(cluster == "finger" || cluster == "thumb")
  let(columns = cluster == "finger" ? finger_columns : thumb_columns)
  arrange(flatten([
    for(columnIndex=[0:len(columns)-1], i=[0,1])
    [[rot([0, 0, 90], p=column_support(cluster, columnIndex))]]
  ]), spacing=spacing, align_items=align_items)
);

finger_cluster_front = rot([0, 0, 90], p=orient_cross_support(finger_cluster_cross_support_front()));
finger_cluster_back = rot([0, 0, 90], p=orient_cross_support(finger_cluster_cross_support_back()));

arrange([
  arrange([
    arrange_key_plates("finger"),
    arrange_column_supports("finger", spacing=-6, align_items="end"),
    [finger_cluster_front],
    [finger_cluster_back]
  ], spacing=2, align_items="start"),
  arrange([
    arrange_key_plates("thumb", reverse_columns=true, align_items="start"),
    arrange_column_supports("thumb", align_items="start", spacing=-2),
    arrange([
      [orient_cross_support(thumb_front_cross_support([2]))],
      [orient_cross_support(thumb_front_cross_support([1]))],
      [orient_cross_support(thumb_front_cross_support([0]))],
      [orient_cross_support(thumb_back_cross_support([2]))],
      [orient_cross_support(thumb_back_cross_support([1]))],
      [orient_cross_support(thumb_back_cross_support([0]))],
    ], spacing=2, align_items="start")
  ], spacing=2, align_items="start"),
], direction="column", align_items="start", spacing=-20, anchor=[-1, -1]);
