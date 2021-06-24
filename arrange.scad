include <BOSL2/std.scad>

function calculate_bounding_box (points_or_region) = (
  let(points = (
    is_path(points_or_region[0])
      ? flatten(points_or_region)
      : flatten(flatten(points_or_region))
  ))
  let(x = [ for(v=points) v.x ])
  let(y = [ for(v=points) v.y ])
  let(min_ = [min(x), min(y)])
  let(max_ = [max(x), max(y)])
  [min_, max_, max_ - min_, (max_ + min_) / 2]
);

function arrange(regions, direction="row", spacing=0, align_items="center") = (
  assert(direction == "row" || direction == "row-reverse" || direction == "column" || direction == "column-reverse")
  assert(align_items == "center" || align_items == "start" || align_items == "end")
  let(bounding_boxes = [ for(r=regions) calculate_bounding_box(r) ])

  let(is_reversed = direction == "row-reverse" || direction == "column-reverse")
  let(is_row = direction == "row" || direction == "row-reverse")

  let(main_axis_component = is_row ? 0 : 1)
  let(main_axis = (is_row ? [1, 0] : [0, 1]))
  let(main_length = sum([
    for(box=bounding_boxes)
    box[2][main_axis_component]
  ]) + spacing * (len(regions)-1))

  let(cross_axis_component = is_row ? 1 : 0)
  let(cross_axis = is_row ? [0, 1] : [1, 0])
  let(cross_length = max([
    for(box=bounding_boxes)
    box[2][cross_axis_component]
  ]))

  let(total_bounding_box = (
    main_axis * main_length +
    cross_axis * cross_length
  ))

  flatten([
    for(i=[0:len(regions)-1])
    let(paths = regions[i])
    let(size = bounding_boxes[i][2])
    let(center = bounding_boxes[i][3])
    let(prev_group_sizes = i == 0 ? 0 : sum([
      for(j=[0:max(0, i-1)])
      bounding_boxes[j][2][main_axis_component] + spacing
    ]))
    let(main_offset = (
      (size/2)[main_axis_component]
      - (total_bounding_box/2)[main_axis_component]
      + prev_group_sizes
    ))

    let(cross_offset = align_items == "center" ? 0 : (
      (align_items == "start" ? -1 : 1) * (
      (size/2)[cross_axis_component]
      -(total_bounding_box/2)[cross_axis_component]
    )))
    let(offset_ = -center - (cross_axis * cross_offset) + main_axis * (
      is_reversed
        ? total_bounding_box[main_axis_component] - main_offset
        : main_offset
    ))
    [ for(path=paths) move(offset_, path) ]
  ])
);

/**
 * Arrange regions using a CSS flexbox-like rules.
 *
 * Some terminology first:
 *  - a path is an array of vertices ([ [x, y], ... ])
 *  - a region is an array of paths ([[ [x, y], ... ]])
 *
 * This module will arrange and render regions along an axis with the specified
 * alignment and spacing.
 *
 * Given a direction of "row" these regions will be laid out end-to-end (plus
 * "spacing" between eeach) on a "main-axis" going from left to right (x-axis),
 * and vertically aligned on the "cross-axis" (y-axis). Specifying "column" will
 * swap the main and cross axes. Including "-reverse" will lay the regions out
 * in reverse order on the main-axis.
 *
 * By default, regions will be centered on the cross-axis, but can be aligned to
 * the low or high end of the overall bounding box by settign align_items to
 * "start" or "end" respectively.
 *
 * Lastly "anchor" can be used to shift the origin relative to the regions'
 * overall bounding box.
 *
 * These arrangements may also be nested by supplying an array of arrange()'d
 * values.
 *
 * @param <array> regions
 * @param <string> [direction="row"] - one of (row|row-reverse|column|column-reverse)
 * @param <number> [spacing=0] - spacing between bounding boxes of regions
 * @param <string> [align_items="center"] alignment on cross-axis
 * @param <vector[x,y]> anchor
 */
module arrange(regions, direction="row", spacing=0, align_items="center", anchor=[0, 0]) {
  assert(direction == "row" || direction == "row-reverse" || direction == "column" || direction == "column-reverse");
  assert(align_items == "center" || align_items == "start" || align_items == "end");

  arranged = arrange(
    regions,
    direction=direction,
    spacing=spacing,
    align_items=align_items
  );

  box = calculate_bounding_box(arranged);
  size = box[2];
  center = box[3];

  offset_ = [
    -anchor.x * size.x/2,
    -anchor.y * size.y/2
  ];

  translate(-center + offset_)
    region(arranged);
}
