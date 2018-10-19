use <../common/assembled-key.scad>
use <positioning.scad>

module thumb_layout() {
  // thumb cluster
  place_thumb_keys([2], [-1:1]) key();
  place_thumb_keys([1], [1]) key();
  place_thumb_keys([0, 1], [-0.5]) key(h=2);
  // place_thumb_keys([0:1], [0]) key();
  // place_thumb_keys([0:2], [-1]) key();
}
