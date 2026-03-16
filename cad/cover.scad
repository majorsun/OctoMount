// ============================================================
// OctoMount — cover.scad  (2-piece redesign, rev 7)
//
// The Cover fits BETWEEN the base side walls (X = WALL..OUTER_X−WALL = INNER_X wide).
// Its back edge sits over the base back wall, not flush with the outside.
//
//   1. Front wall  — X = WALL..OUTER_X−WALL, Y = 0..WALL, height = COVER_FRONT_Z
//   2. Angled top slab — same X span, full Y depth, WALL thick ⟂ to face
//   3. Two ball stubs  — protrude from each side face into the base side-wall sockets
//
// Side walls and back wall are on the base (rev 4+).
//
// TWO DESIGN CONDITIONS (all met in this file):
//
//   COND 1 — LCD exposed through a window on the TILTED part:
//     Window cut uses rotate([+TILT_ANGLE,0,0]).
//     local+Z = (0, −sin(θ), +cos(θ)) = face OUTWARD normal.
//     Cut is exactly perpendicular to the tilted face. ✓
//
//   COND 2 — Full LCD panel fits into the window:
//     Window = LCD_PANEL_X × LCD_PANEL_SL + LCD_FIT_CLR per side.
//     LCD panel (front layer, slightly smaller than PCB) seats snugly;
//     PCB layer (larger, behind panel) is retained by cover face. ✓
//
//   • Angled top slab at TILT_ANGLE from horizontal
//   • LCD panel window (through-hole) in angled slab
//   • RPi is mounted from the base via tall M2.5 bosses (no cover bosses)
//
// Origin: bottom-front-left corner of the cover
//         = top-front-left corner of the base (Z = BASE_OUTER_Z).
//
// Print: back-edge-down (angled face up, front wall upright).
// ============================================================
include <params.scad>

cover();

module cover() {
    difference() {
        union() {
            _cover_top_slab();
            _cover_front_wall();
            _cover_hinge_balls();
            _cover_back_round();
        }
        _cover_cuts();
    }
}

// ── Angled top slab (INNER_X wide, fits between side walls) ──
// Hull between front and back thin strips gives a parallelogram slab
// whose thickness measured perpendicular to the surface is exactly WALL.
//   X span: WALL .. OUTER_X−WALL  (= INNER_X, between the side walls)
//   Front edge: outer face at Z = COVER_FRONT_Z, inner face at COVER_FRONT_Z − _wz
//   Back edge:  outer face at Z = COVER_BACK_Z,  inner face at COVER_BACK_Z  − _wz
module _cover_top_slab() {
    _wz = WALL / cos(TILT_ANGLE);
    hull() {
        translate([WALL, 0, COVER_FRONT_Z - _wz])
            cube([INNER_X, 0.01, _wz]);
        translate([WALL, OUTER_Y - 0.01, COVER_BACK_Z - _wz])
            cube([INNER_X, 0.01, _wz]);
    }
}

// ── Front wall (lip closing the enclosure front face, between side walls) ───
module _cover_front_wall() {
    translate([WALL, 0, 0])
        cube([INNER_X, WALL, COVER_FRONT_Z]);
}

// ── Ball-hinge ridge (two half-spheres joined by a cylinder along the hinge axis) ──
// The cylinder has the same radius as the balls and runs along the hinge axis between
// them, creating one continuous rounded ridge across the full back edge of the cover.
// When the cover flips open this convex surface rotates smoothly against the base.
module _cover_hinge_balls() {
    _bz = BHINGE_WZ - BASE_OUTER_Z;   // cover-local Z of hinge axis (= 44.5 mm)
    // Left half-sphere
    translate([WALL,         BHINGE_Y, _bz])  sphere(r=BHINGE_R, $fn=32);
    // Right half-sphere
    translate([OUTER_X-WALL, BHINGE_Y, _bz])  sphere(r=BHINGE_R, $fn=32);
    // Connecting cylinder — same axis, same radius, spans between the two balls
    translate([WALL, BHINGE_Y, _bz])
        rotate([0, 90, 0])
            cylinder(r=BHINGE_R, h=INNER_X, $fn=32);
}

// ── Convex round on outer-top-back edge ─────────────────────────────────────
// The corner at (Y≈OUTER_Y, Z=COVER_BACK_Z) clips the base back wall past ~120° open.
// Convex (outward-bulging) cylinder: centre inset CORNER_R from both faces,
// tangent to the top face (Z=COVER_BACK_Z) and back face (Y=OUTER_Y).
// The square corner region is removed in _cover_cuts() and replaced by this curve.
module _cover_back_round() {
    translate([WALL, OUTER_Y - CORNER_R, COVER_BACK_Z - CORNER_R])
        rotate([0, 90, 0])
            cylinder(r=CORNER_R, h=INNER_X, $fn=32);
}

// ── Subtractive cuts ──────────────────────────────────────────
module _cover_cuts() {
    // ── Rotation-clearance fillets ───────────────────────────────
    // Front inner-bottom edge: exposed underside of slab at the front (Y≈0).
    // Catches on the base interior when the cover is opening through the first arc.
    translate([WALL, 0, COVER_FRONT_Z - WALL/cos(TILT_ANGLE)])
        rotate([0, 90, 0])
            cylinder(r=CORNER_R, h=INNER_X, $fn=32);
    // Outer-top-back edge: remove the square corner so the convex round (in union)
    // is the only material in that region.  Size = CORNER_R × CORNER_R, full X span.
    translate([WALL - 0.01, OUTER_Y - CORNER_R, COVER_BACK_Z - CORNER_R])
        cube([INNER_X + 0.02, CORNER_R + 0.01, CORNER_R + 0.01]);

    // LCD centre in enclosure XY — derived from RPi position + GPIO coupling
    _lY = WALL + RPI_Y0 + RPI_Y/2 + LCD_OFS_Y;   // ≈ 60 mm
    _lZ = COVER_FRONT_Z + (_lY / OUTER_Y) * (COVER_BACK_Z - COVER_FRONT_Z);

    // ── LCD window: panel layer fits snugly in opening (COND 2 + COND 3) ─
    // rotate([+TILT_ANGLE,0,0]): local+Z = face OUTWARD normal →
    // cut is exactly perpendicular to the tilted face (COND 2). ✓
    //
    // Sized to LCD_PANEL_X × LCD_PANEL_SL + LCD_FIT_CLR per side.
    // The LCD panel (front layer, slightly smaller than PCB) seats snugly
    // in the window (COND 3). ✓  The PCB layer (larger, behind panel)
    // cannot pass through — it is retained by the cover face. ✓
    //
    // Centre: LCD PCB centre + (LCD_PANEL_OX, LCD_PANEL_OSL) in local XY.
    // These offsets are non-zero when setbacks are asymmetric.
    //
    // Depth: from 1 mm outside outer face to 1 mm past the panel front face
    // (inner face + CLR_ABOVE_RPI).  Panel protrudes outward through opening.

    _win_d = WALL / cos(TILT_ANGLE) + abs(CLR_ABOVE_RPI) + 1;
    translate([WALL + RPI_X0 + RPI_X/2 + LCD_OFS_X, _lY, _lZ])
        rotate([TILT_ANGLE, 0, 0])
            translate([LCD_PANEL_OX  - (LCD_PANEL_X/2  + LCD_FIT_CLR),
                       LCD_PANEL_OSL - (LCD_PANEL_SL/2 + LCD_FIT_CLR),
                       -_win_d])
                cube([LCD_PANEL_X  + 2*LCD_FIT_CLR,
                      LCD_PANEL_SL + 2*LCD_FIT_CLR,
                      _win_d + 1]);

}
