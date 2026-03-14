// ============================================================
// OctoMount — assembly.scad  (2-piece redesign, rev 6)
//
// Full assembly view: Base + Cover positioned together.
// OUTER_X = 145 mm (left wall at panel left edge; right wall at panel right edge).
//
// Flags:
//   SHOW_BASE      = 1  → render the base
//   SHOW_COVER     = 1  → render the cover (semi-transparent)
//   EXPLODE        = 1  → exploded view (cover lifted off base)
//   SHOW_RPI       = 1  → ghost RPi PCB inside
//   SHOW_LCD       = 1  → ghost LCD module (PCB + panel) inside
//   SHOW_BUCK      = 1  → ghost LM2596 buck converter (right of RPi)
//
// Ghost orientation: rotate([180+TILT_ANGLE,0,0]) from cover inner-face reference.
// RPi is mounted on BASE bosses; ghosts use BASE_OUTER_Z so they stay with
// the base in an exploded view (cover lifts independently via _cover_dz).
//   local +Z  → into cover interior (mostly world −Z)
//   local −Z  → outward through cover face (screen faces user / upward)
//   RPi PCB   → local Z: (STOFF_H−RPI_PCB_T) … STOFF_H
//              (bare-bottom at STOFF_H, rests on base bosses)
//   LCD PCB layer  → local Z: CLR_ABOVE_RPI+LCD_PANEL_T … CLR_ABOVE_RPI+LCD_T
//   LCD panel layer → local Z: CLR_ABOVE_RPI … CLR_ABOVE_RPI+LCD_PANEL_T
//                     (panel protrudes through cover window toward viewer)
// ============================================================
include <params.scad>
use <base.scad>
use <cover.scad>

SHOW_BASE       = 1;     // 1 = render base
SHOW_COVER      = 1;     // 1 = render cover

EXPLODE         = 0;
EXP_D           = 60;    // explode separation in mm

SHOW_RPI        = 1;     // 1 = show ghost RPi PCB inside
SHOW_LCD        = 1;     // 1 = show ghost LCD module inside
SHOW_BUCK       = 1;     // 1 = show ghost LM2596 buck converter
SHOW_DEBUG      = 0;     // 1 = red spheres at boss-tip world positions

BASE_COL       = [0.3,  0.55, 0.75, 1.0];   // blue-grey, opaque
COVER_COL      = [0.25, 0.45, 0.65, 0.7];   // slightly darker, semi-transparent
RPI_COL        = [0.2,  0.7,  0.3,  0.85];  // green ghost
LCD_PCB_COL    = [0.9,  0.9,  0.3,  0.5];   // yellow ghost — PCB layer (behind)
LCD_PANEL_COL  = [0.95, 0.55, 0.1,  0.8];   // orange ghost — panel layer (front, in window)
BUCK_COL       = [0.7,  0.35, 0.1,  0.9];   // brown ghost — LM2596 buck converter

// ── Base at world origin ──────────────────────────────────────
if (SHOW_BASE)
    color(BASE_COL)
        base();

// ── Ghost: LM2596 buck converter (right of RPi, on base floor) ─
// STL bbox: X(-2.418..48.466) Y(22.010..37.796) Z(26.226..50.512)
// No rotation: PCB lies flat in XY plane; long axis (50.9 mm) runs in enclosure X.
// Translate: X_min(-2.418) → WALL+BUCK_X0; Y_min(22.010) → WALL+BUCK_Y0; Z_min(26.226) → BASE_OUTER_Z
if (SHOW_BUCK)
    color(BUCK_COL)
        translate([WALL + BUCK_X0 + 2.418,
                   WALL + BUCK_Y0 - 22.010,
                   BASE_OUTER_Z - 26.226])
            import("../reference/6811d70143b4d50b11a59159.stl", convexity=10);

// ── Debug: red spheres at boss-tip world positions ────────────
// Uses the exact same transform chain as base.scad bosses → guaranteed correct.
if (SHOW_DEBUG)
    for (bx = BOSS_XS, by = BOSS_YS)
        color([1, 0, 0])
            translate([bx, by, BASE_OUTER_Z])
                rotate([TILT_ANGLE, 0, 0])
                    translate([0, 0, _BH_C + by * sin(TILT_ANGLE)])
                        sphere(r=1.2, $fn=16);

// ── Cover + internals ─────────────────────────────────────────
_cover_dz = BASE_OUTER_Z + EXPLODE * EXP_D;

if (SHOW_COVER)
    color(COVER_COL)
        translate([0, 0, _cover_dz])
            cover();

// ── Ghost internals — RPi + LCD parallel to inner angled face ─
if (SHOW_RPI || SHOW_LCD) {
    _wz  = WALL / cos(TILT_ANGLE);
    _tan = tan(TILT_ANGLE);

    // RPi PCB centre in enclosure XY
    _rx_ctr = WALL + RPI_X0 + RPI_X/2;
    _ry_ctr = WALL + RPI_Y0 + RPI_Y/2;

    // LCD PCB centre = RPi centre + GPIO-coupled offset
    _lx_ctr = _rx_ctr + LCD_OFS_X;
    _ly_ctr = _ry_ctr + LCD_OFS_Y;

    // Inner face Z at each block's Y centre
    _rface_z = COVER_FRONT_Z - _wz + _ry_ctr * _tan;
    _lface_z = COVER_FRONT_Z - _wz + _ly_ctr * _tan;

    // rotate([180+TILT_ANGLE,0,0]):  local +Z into interior, local −Z toward screen
    // RPi PCB: spans local Z = (STOFF_H−RPI_PCB_T) … STOFF_H
    //          GPIO face at lower Z (outward), bare-bottom face at STOFF_H (inward, rests on bosses)
    if (SHOW_RPI)
        color(RPI_COL)
            translate([0, 0, BASE_OUTER_Z])
                translate([_rx_ctr, _ry_ctr, _rface_z])
                    rotate([180 + TILT_ANGLE, 0, 0])
                        // STL is centered at (0,0) in XY; PCB bare-bottom at Z=3.0.
                        // mirror([0,0,1]) flips Z so components face local -Z (toward cover face).
                        // translate Z by STOFF_H+3.0 so PCB bare-bottom lands at local Z=STOFF_H.
                        translate([0, 0, STOFF_H + 3.0])
                            mirror([0, 0, 1])
                                import("../reference/Raspberry_Pi_4_B_3D_Model.stl", convexity=10);

    // LCD PCB layer: chip side faces RPi; spans local Z = CLR_ABOVE_RPI+LCD_PANEL_T … CLR_ABOVE_RPI+LCD_T
    if (SHOW_LCD)
        color(LCD_PCB_COL)
            translate([0, 0, BASE_OUTER_Z])
                translate([_lx_ctr, _ly_ctr, _lface_z])
                    rotate([180 + TILT_ANGLE, 0, 0])
                        translate([-LCD_PCB_X/2, -LCD_PCB_SL/2,
                                   CLR_ABOVE_RPI + LCD_PANEL_T])
                            cube([LCD_PCB_X, LCD_PCB_SL, LCD_T - LCD_PANEL_T]);

    // LCD panel layer: front display glass, sits within cover wall in window opening.
    // Spans local Z = CLR_ABOVE_RPI … CLR_ABOVE_RPI+LCD_PANEL_T.
    // Centre is offset from PCB centre by (LCD_PANEL_OX, LCD_PANEL_OSL) in local XY.
    if (SHOW_LCD)
        color(LCD_PANEL_COL)
            translate([0, 0, BASE_OUTER_Z])
                translate([_lx_ctr, _ly_ctr, _lface_z])
                    rotate([180 + TILT_ANGLE, 0, 0])
                        translate([LCD_PANEL_OX  - LCD_PANEL_X/2,
                                   LCD_PANEL_OSL - LCD_PANEL_SL/2,
                                   CLR_ABOVE_RPI])
                            cube([LCD_PANEL_X, LCD_PANEL_SL, LCD_PANEL_T]);
}
