module fan(inner, outer, start, end) {
  steps = $fn ? $fn : 60;

  segments = (end - start) / steps;
  polygon(concat(
    [ for (i=[0:steps]) [inner * cos(start + i * segments), inner * sin(start + i * segments)] ],
    [ for (i=[0:steps]) [outer * cos(start + (steps - i) * segments), outer * sin(start + (steps - i) * segments)] ]
  ));
}
