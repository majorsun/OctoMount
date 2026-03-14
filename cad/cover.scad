// ============================================================
// OctoMount — cover.scad  (2-piece redesign, rev 6)
//
// The Cover now consists of only two elements:
//   1. Front wall  — Y = 0..WALL, full width X, height = COVER_FRONT_Z
//   2. Angled top slab — full width × full depth, WALL thick ⟂ to face
//
// Side walls and back wall have moved to base.scad (rev 4).
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
        }
        _cover_cuts();
    }
}

// ── Angled top slab (full width, WALL thick perpendicular to face) ─
// Hull between front and back thin strips gives a parallelogram slab
// whose thickness measured perpendicular to the surface is exactly WALL.
//   Front edge: outer face at Z = COVER_FRONT_Z, inner face at COVER_FRONT_Z − _wz
//   Back edge:  outer face at Z = COVER_BACK_Z,  inner face at COVER_BACK_Z  − _wz
module _cover_top_slab() {
    _wz = WALL / cos(TILT_ANGLE);
    hull() {
        translate([0, 0, COVER_FRONT_Z - _wz])
            cube([OUTER_X, 0.01, _wz]);
        translate([0, OUTER_Y - 0.01, COVER_BACK_Z - _wz])
            cube([OUTER_X, 0.01, _wz]);
    }
}

// ── Front wall (short lip closing the enclosure front face) ───
module _cover_front_wall() {
    cube([OUTER_X, WALL, COVER_FRONT_Z]);
}

// ── Subtractive cuts ──────────────────────────────────────────
module _cover_cuts() {
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
