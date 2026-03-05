// ============================================================
// OctoMount — assembly.scad  (2-piece redesign)
//
// Full assembly view: Base + Cover positioned together.
// Set EXPLODE = 1 for exploded view (cover lifted off base).
// ============================================================
include <params.scad>
use <base.scad>
use <cover.scad>

EXPLODE = 0;
EXP_D   = 30;

BASE_COL  = [0.3, 0.55, 0.75, 1.0];   // blue-grey
COVER_COL = [0.25, 0.45, 0.65, 1.0];  // slightly darker

// Base at world origin
color(BASE_COL)
    base();

// Cover sits on top of base (Z = BASE_OUTER_Z), explodes upward
color(COVER_COL)
    translate([0, 0, BASE_OUTER_Z + EXPLODE * EXP_D])
        cover();
