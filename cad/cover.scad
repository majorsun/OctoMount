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

// ── Subtractive cuts ──────────────────────────────────────────
module _cover_cuts() {
    // ── Yellow cut: everything above the slab outer face plane ───────────────
    // The outer face of the slab is at Z = COVER_FRONT_Z + Y·tan(TILT_ANGLE).
    // A box rotated by TILT_ANGLE around X (origin at Y=0, Z=COVER_FRONT_Z)
    // removes all material above/outside that plane — trimming any protrusion
    // (hinge dome, arc cap, etc.) flush with the slab outer face.
    translate([WALL - 1, 0, COVER_FRONT_Z])
        rotate([TILT_ANGLE, 0, 0])
            cube([INNER_X + 2, OUTER_Y + 20, 200]);

    // ── Red cut: everything beyond the slab back face (Y > OUTER_Y) ──────────
    translate([WALL - 1, OUTER_Y, -1])
        cube([INNER_X + 2, 100, 300]);

    // ── Rotation-clearance fillet ─────────────────────────────────────────────
    // Front inner-bottom edge: exposed underside of slab at the front (Y≈0).
    // Catches on the base interior when the cover is opening through the first arc.
    translate([WALL, 0, COVER_FRONT_Z - WALL/cos(TILT_ANGLE)])
        rotate([0, 90, 0])
            cylinder(r=CORNER_R, h=INNER_X, $fn=32);
    // LCD centre in enclosure XY — derived from RPi position + GPIO coupling
    _lY = WALL + RPI_Y0 + RPI_Y/2 + LCD_OFS_Y;   // ≈ 60 mm
    _lZ = COVER_FRONT_Z + (_lY / OUTER_Y) * (COVER_BACK_Z - COVER_FRONT_Z);

    // ── LCD window: stepped (counterbored) opening ────────────────────────────
    // Two concentric cuts create a visible step from inside looking up:
    //
    //   Inner cut — full panel body (LCD_PANEL_*):
    //     Extends from 1 mm past the inner face up to LCD_PANEL_T below the outer face.
    //     Panel front face sits flush against the step shoulder.
    //
    //   Outer cut — viewable area only (LCD_VIEW_*):
    //     Extends from the step shoulder through the outer face (+1 overshoot).
    //     Only the active display area is exposed to the outside.
    //
    // In the rotated frame: local +Z = outward (sky), local −Z = inward (slab).
    // Reference _lZ is on the outer face.
    _wz   = WALL / cos(TILT_ANGLE);
    _deep = _wz + abs(CLR_ABOVE_RPI) + 1;  // depth: 1 mm past inner face
    _step = LCD_PANEL_T;                    // step shoulder: LCD_PANEL_T below outer face

    // Inner large cut: panel body
    translate([WALL + RPI_X0 + RPI_X/2 + LCD_OFS_X, _lY, _lZ])
        rotate([TILT_ANGLE, 0, 0])
            translate([LCD_PANEL_OX  - (LCD_PANEL_X/2  + LCD_FIT_CLR),
                       LCD_PANEL_OSL - (LCD_PANEL_SL/2 + LCD_FIT_CLR),
                       -_deep])
                cube([LCD_PANEL_X  + 2*LCD_FIT_CLR,
                      LCD_PANEL_SL + 2*LCD_FIT_CLR,
                      _deep - _step]);      // stops at step shoulder

    // Outer small cut: viewable area through-hole
    translate([WALL + RPI_X0 + RPI_X/2 + LCD_OFS_X, _lY, _lZ])
        rotate([TILT_ANGLE, 0, 0])
            translate([LCD_VIEW_OX  - (LCD_VIEW_X/2  + LCD_FIT_CLR),
                       LCD_VIEW_OSL - (LCD_VIEW_SL/2 + LCD_FIT_CLR),
                       -_step])
                cube([LCD_VIEW_X  + 2*LCD_FIT_CLR,
                      LCD_VIEW_SL + 2*LCD_FIT_CLR,
                      _step + 1]);          // +1 overshoots outer face

}
