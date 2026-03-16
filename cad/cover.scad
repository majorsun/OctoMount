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
            _cover_back_arc();
        }
        _cover_cuts();
        // Remove rectangular back of slab (Y ≥ BHINGE_Y) — replaced by the arc
        translate([WALL - 0.01, BHINGE_Y + 0.01, -0.01])
            cube([INNER_X + 0.02, OUTER_Y - BHINGE_Y + 1, COVER_BACK_Z + 1]);
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

// ── Circular arc back face — centred on hinge axis ───────────────────────────
// The back section (Y ≥ BHINGE_Y) is replaced by a cylindrical arc of radius
// _ro = distance(hinge → back-top corner).  When the cover rotates it sweeps
// exactly this cylinder → the back face never clips the base back wall.
//
// Construction:
//   outer cylinder (radius _ro, centred on hinge) ∩ Y≥BHINGE_Y ∩ slab volume
//   The slab-volume intersection (_cover_top_slab_ext) clips the arc to the
//   angled face planes so the result is seamlessly flush with the rest of the slab.
module _cover_back_arc() {
    _bz = BHINGE_WZ - BASE_OUTER_Z;
    _ro = sqrt(pow(OUTER_Y - BHINGE_Y, 2) + pow(COVER_BACK_Z - _bz, 2)) + 0.01;
    intersection() {
        // Outer cylinder centred on hinge axis
        translate([WALL, BHINGE_Y, _bz])
            rotate([0, 90, 0])
                cylinder(r = _ro, h = INNER_X, $fn = 64);
        // Keep only the back half (Y ≥ BHINGE_Y)
        translate([WALL - 0.01, BHINGE_Y, _bz - _ro - 1])
            cube([INNER_X + 0.02, _ro + 2, _ro * 2 + 2]);
        // Clip to slab angled volume (extended past OUTER_Y for full arc coverage)
        _cover_top_slab_ext(10);
    }
}

// Slab bounding volume extended extra_y mm past OUTER_Y — same parallelogram,
// longer.  Used only as a clipping volume for _cover_back_arc.
module _cover_top_slab_ext(extra_y) {
    _wz = WALL / cos(TILT_ANGLE);
    hull() {
        translate([WALL, 0, COVER_FRONT_Z - _wz])
            cube([INNER_X, 0.01, _wz]);
        translate([WALL, OUTER_Y + extra_y - 0.01,
                   COVER_BACK_Z + extra_y * tan(TILT_ANGLE) - _wz])
            cube([INNER_X, 0.01, _wz]);
    }
}

// ── Subtractive cuts ──────────────────────────────────────────
module _cover_cuts() {
    // ── Rotation-clearance fillets ───────────────────────────────
    // Front inner-bottom edge: exposed underside of slab at the front (Y≈0).
    // Catches on the base interior when the cover is opening through the first arc.
    translate([WALL, 0, COVER_FRONT_Z - WALL/cos(TILT_ANGLE)])
        rotate([0, 90, 0])
            cylinder(r=CORNER_R, h=INNER_X, $fn=32);
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
