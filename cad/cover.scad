// ============================================================
// OctoMount — cover.scad  (2-piece redesign, rev 7)
//
// The Cover fills the enclosure interior (X = WALL_S..OUTER_X−WALL_S).
// Boss-pad relief cuts step it back to X = WALL at the hinge pad zone.
// Its back edge sits over the base back wall, not flush with the outside.
//
//   1. Front wall  — X = WALL_S..OUTER_X−WALL_S, Y = 0..WALL, height = COVER_FRONT_Z
//   2. Angled top slab — same X span, full Y depth, WALL thick ⟂ to face
//   3. Two ball stubs  — protrude from cover side face into base boss-pad sockets
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
    // Y where the angled slab outer face reaches COVER_FLAT_Z — start of flat top.
    _y_cut = (COVER_FLAT_Z - COVER_FRONT_Z) * OUTER_Y / (COVER_BACK_Z - COVER_FRONT_Z);
    // Stylus groove is applied at the outermost level so it cuts through both
    // the flat slab and the underlying angled slab material at the same location.
    difference() {
        union() {
            // ── Angled slab + front wall, trimmed at flat boundary ─────────────
            difference() {
                union() {
                    _cover_top_slab();
                    _cover_front_wall();
                }
                _cover_trim_cuts();
                _lcd_window_cuts();
                // Remove angled slab above COVER_FLAT_Z (flat top boundary cut)
                translate([-1, _y_cut - 0.01, COVER_FLAT_Z])
                    cube([OUTER_X + 2, OUTER_Y - _y_cut + 21, 200]);
            }
            // ── Flat top slab + hinge pins/axle (outside angled-slab cuts) ─────
            difference() {
                union() {
                    translate([WALL_S, _y_cut, COVER_FLAT_Z - WALL])
                        cube([OUTER_X - 2*WALL_S, OUTER_Y - _y_cut, WALL]);
                    _cover_hinge_pins();
                    _stylus_groove_bottom(_y_cut);
                }
                // Back clip: nothing beyond OUTER_Y
                translate([-1, OUTER_Y, -1])
                    cube([OUTER_X + 2, 100, 300]);
                // Rear top edge rounding — corner_cut = quadrant_cube − quadrant_cylinder,
                // both centred at (OUTER_Y−r, COVER_FLAT_Z−r) in cover-local coordinates.
                difference() {
                    translate([WALL_S - 0.01, OUTER_Y - REAR_CORNER_R, COVER_FLAT_Z - REAR_CORNER_R])
                        cube([OUTER_X - 2*WALL_S + 0.02, REAR_CORNER_R + 1, REAR_CORNER_R + 1]);
                    translate([WALL_S - 0.01, OUTER_Y - REAR_CORNER_R, COVER_FLAT_Z - REAR_CORNER_R])
                        rotate([0, 90, 0])
                            cylinder(r=REAR_CORNER_R, h=OUTER_X - 2*WALL_S + 0.02, $fn=32);
                }
            }
        }
        // Stylus groove — cuts both flat slab and angled slab material
        _stylus_groove(_y_cut);
        // Finger relief scoop at groove midpoint
        _stylus_finger_relief(_y_cut);
        // 4010 fan body clearance — shape-conforming cut using the fan STL.
        _fan40_clearance_cut();
    }
}

// ── 4010 fan body clearance cut ───────────────────────────────
// Scales the fan STL uniformly from its body centre so the cut conforms
// to the actual fan profile. Cover-local Z = FAN40_CZ − BASE_OUTER_Z
// places the fan centre correctly (bottom at floor, same as assembly.scad).
// Scale factors add CLR on every side; face at X = OUTER_X−WALL_S+CLR
// ensures a clean cut through the cover's right edge.
module _fan40_clearance_cut() {
    // Cap at Y = BHINGE_Y − BHINGE_R: fan back (Y≈71) extends past the hinge axle
    // (Y≈69.3), but cover material there starts at Z≈41.2 mm — 1.2 mm above the
    // fan top — so no cut is needed beyond the axle near-edge.
    intersection() {
        translate([OUTER_X - WALL_S, FAN40_CY, FAN40_CZ - BASE_OUTER_Z])
            translate([-FAN40_T / 2, 0, 0])
                scale([(FAN40_T + 2*CLR) / FAN40_T,
                       (FAN40_SIZE + 2*CLR) / FAN40_SIZE,
                       (FAN40_SIZE + 2*CLR) / FAN40_SIZE])
                    translate([FAN40_T / 2, 0, 0])
                        rotate([0, 0, 90])
                            hull()
                                import("../reference/4010fanv1.stl", convexity=5);
        translate([-1, -1, -1])
            cube([OUTER_X + 2, BHINGE_Y - BHINGE_R + 1, COVER_FLAT_Z + WALL + 6]);
    }
    // Rectangular extension inward (−X) beyond the fan back face for M3 nut clearance.
    // The STL-hull cut reaches FAN40_T/2 + CLR from the wall inner face; this box
    // adds FAN40_NUT_CLR further so the nut has room.
    translate([OUTER_X - WALL_S - FAN40_T / 2 - CLR - FAN40_NUT_CLR,
               FAN40_CY - FAN40_SIZE / 2 - CLR,
               FAN40_CZ - BASE_OUTER_Z - FAN40_SIZE / 2 - CLR])
        cube([FAN40_NUT_CLR + 0.1,
              FAN40_SIZE + 2 * CLR,
              FAN40_SIZE + 2 * CLR]);
}

// ── Angled top slab (fills between thin side walls, WALL_S based) ──
// Hull between front and back thin strips gives a parallelogram slab
// whose thickness measured perpendicular to the surface is exactly WALL.
//   X span: WALL_S .. OUTER_X−WALL_S  (flush with thin side wall inner faces)
//   Front edge: outer face at Z = COVER_FRONT_Z, inner face at COVER_FRONT_Z − _wz
//   Back edge:  outer face at Z = COVER_BACK_Z,  inner face at COVER_BACK_Z  − _wz
module _cover_top_slab() {
    _wz  = WALL / cos(TILT_ANGLE);
    _dz  = FRONT_EXT * tan(TILT_ANGLE);  // Z drop at front extension
    hull() {
        translate([WALL_S, -FRONT_EXT, COVER_FRONT_Z - _wz - _dz])
            cube([OUTER_X - 2*WALL_S, 0.01, _wz]);
        translate([WALL_S, OUTER_Y - 0.01, COVER_BACK_Z - _wz])
            cube([OUTER_X - 2*WALL_S, 0.01, _wz]);
    }
}

// ── Front wall (lip closing the enclosure front face, flush with thin side walls) ───
// Shifted forward by FRONT_EXT so its inner face clears the RPi front edge by CLR.
module _cover_front_wall() {
    translate([WALL_S, -FRONT_EXT, 0])
        cube([OUTER_X - 2*WALL_S, WALL, COVER_FRONT_Z]);
}

// ── Pin-hinge stubs + connecting axle (fused with cover) ──────
// Left and right pins protrude outward into matching base side-wall holes.
// Axle runs along X between both pin bases, fused to the cover slab.
module _cover_hinge_pins() {
    _bz = BHINGE_WZ - BASE_OUTER_Z;   // cover-local Z of hinge axis
    // Left pin — from cover left face (X=WALL_S) outward in −X
    translate([WALL_S, BHINGE_Y, _bz])
        rotate([0, -90, 0])
            cylinder(r=BHINGE_R, h=BHINGE_PIN_L, $fn=32);
    // Right pin — from cover right face (X=OUTER_X-WALL_S) outward in +X
    translate([OUTER_X - WALL_S, BHINGE_Y, _bz])
        rotate([0, 90, 0])
            cylinder(r=BHINGE_R, h=BHINGE_PIN_L, $fn=32);
    // Axle — spans full interior width, connecting both pin bases, fused with cover
    translate([WALL_S, BHINGE_Y, _bz])
        rotate([0, 90, 0])
            cylinder(r=BHINGE_R, h=OUTER_X - 2*WALL_S, $fn=32);
}

// ── Trim cuts ─────────────────────────────────────────────────
module _cover_trim_cuts() {
    // Yellow cut: everything above the slab outer face plane (starts at extended front edge)
    translate([-1, -FRONT_EXT, COVER_FRONT_Z - FRONT_EXT * tan(TILT_ANGLE)])
        rotate([TILT_ANGLE, 0, 0])
            cube([OUTER_X + 2, OUTER_Y + FRONT_EXT + 20, 200]);

    // Red cut: everything beyond Y > OUTER_Y
    translate([-1, OUTER_Y, -1])
        cube([OUTER_X + 2, 100, 300]);

}

// ── LCD window cuts (applied to everything incl. clips) ───────
module _lcd_window_cuts() {
    _lY = WALL + RPI_Y0 + RPI_Y/2 + LCD_OFS_Y;
    _lZ = COVER_FRONT_Z + (_lY / OUTER_Y) * (COVER_BACK_Z - COVER_FRONT_Z);

    _wz   = WALL / cos(TILT_ANGLE);
    _deep = _wz + abs(CLR_ABOVE_RPI) + 1;
    _step = LCD_WIN_SKIN;

    // Inner large cut: panel body
    translate([WALL + RPI_X0 + RPI_X/2 + LCD_OFS_X, _lY, _lZ])
        rotate([TILT_ANGLE, 0, 0])
            translate([LCD_PANEL_OX  - (LCD_PANEL_X/2  + LCD_FIT_CLR),
                       LCD_PANEL_OSL - (LCD_PANEL_SL/2 + LCD_FIT_CLR),
                       -_deep])
                cube([LCD_PANEL_X  + 2*LCD_FIT_CLR,
                      LCD_PANEL_SL + 2*LCD_FIT_CLR,
                      _deep - _step]);

    // Outer small cut: viewable area — full through-hole
    translate([WALL + RPI_X0 + RPI_X/2 + LCD_OFS_X, _lY, _lZ])
        rotate([TILT_ANGLE, 0, 0])
            translate([LCD_VIEW_OX  - (LCD_VIEW_X/2  + LCD_FIT_CLR),
                       LCD_VIEW_OSL - (LCD_VIEW_SL/2 + LCD_FIT_CLR),
                       -_deep])
                cube([LCD_VIEW_X  + 2*LCD_FIT_CLR,
                      LCD_VIEW_SL + 2*LCD_FIT_CLR,
                      _deep + 1]);
}

// ── Stylus groove floor (curved bottom matching groove profile) ─
// A second cylinder — same radius and axis as the groove — offset
// downward by _ft.  The outer difference's groove cut removes the
// lens-shaped overlap, leaving a crescent-section shell that exactly
// follows the groove curvature.  Protrudes below cover interior — intentional.
module _stylus_groove_bottom(y_cut) {
    _r  = STYLUS_HOLDER_D / 2;
    _hy = y_cut + (OUTER_Y - y_cut) / 3;
    _gx = (OUTER_X - STYLUS_HOLDER_L) / 2;
    _gz = COVER_FLAT_Z + _r - WALL;   // groove centre Z
    _ft = 1.5;   // floor offset below groove centre (= floor thickness at bottom point)
    intersection() {
        translate([_gx, _hy, _gz - _ft])
            rotate([0, 90, 0])
                cylinder(r=_r, h=STYLUS_HOLDER_L, $fn=48);
        // Clip to below flat slab top — prevents coplanar z-fighting with slab top face
        translate([_gx - 1, _hy - _r - 1, -1000])
            cube([STYLUS_HOLDER_L + 2, 2*_r + 2, 1000 + COVER_FLAT_Z]);
    }
}

// ── Stylus holder groove (sinks into flat top) ─────────────────
// Half-cylinder groove, axis along X, centered in X.
// Y = 1/3 from the front edge of the flat-top area toward the back.
// Centre raised by (r − WALL) so the groove bottom is tangent to the
// slab bottom — no punch-through, full 8 mm groove opening at surface.
module _stylus_groove(y_cut) {
    _r   = STYLUS_HOLDER_D / 2;
    _hy  = y_cut + (OUTER_Y - y_cut) / 3;
    _gx  = (OUTER_X - STYLUS_HOLDER_L) / 2;
    translate([_gx, _hy, COVER_FLAT_Z + _r - WALL])
        rotate([0, 90, 0])
            cylinder(r=_r, h=STYLUS_HOLDER_L, $fn=48);
}

// ── Stylus finger relief (ergonomic scoop at groove midpoint) ──
// Ellipsoid centred flush with the flat top surface, same Y as groove.
// Z radius = WALL so the deepest point is tangent to the slab bottom —
// same depth as the groove, no punch-through.
//   X radius : 13 mm  (26 mm span — room for two finger pads)
//   Y radius :  7 mm  (14 mm wide — wider than 8 mm groove)
//   Z radius : WALL   (matches groove depth, tangent to slab bottom)
module _stylus_finger_relief(y_cut) {
    _hy = y_cut + (OUTER_Y - y_cut) / 3;
    translate([OUTER_X / 2, _hy, COVER_FLAT_Z])
        scale([13, 7, WALL])
            sphere(r=1, $fn=48);
}
