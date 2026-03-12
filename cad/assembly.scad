// ============================================================
// OctoMount — assembly.scad  (2-piece redesign, rev 5)
//
// Full assembly view: Base + Cover positioned together.
//
// Flags:
//   SHOW_BASE      = 1  → render the base
//   SHOW_COVER     = 1  → render the cover
//   EXPLODE        = 1  → exploded view (cover lifted off base)
//   SHOW_RPI       = 1  → ghost RPi PCB inside cover
//   SHOW_LCD       = 1  → ghost LCD module (PCB + panel) inside cover
//
// Ghost orientation matches cover.scad boss rotation [180+TILT_ANGLE,0,0]:
//   local +Z  → into cover interior (mostly world −Z)
//   local −Z  → outward through cover face (screen faces user / upward)
//   RPi PCB   → local Z: (STOFF_H−RPI_PCB_T) … STOFF_H
//   LCD PCB layer  → local Z: CLR_ABOVE_RPI+LCD_PANEL_T … CLR_ABOVE_RPI+LCD_T
//   LCD panel layer → local Z: CLR_ABOVE_RPI … CLR_ABOVE_RPI+LCD_PANEL_T
//                     (panel protrudes through cover window toward viewer)
// ============================================================
include <params.scad>
use <base.scad>
use <cover.scad>

SHOW_BASE       = 1;     // 1 = render base
SHOW_COVER      = 0;     // 1 = render cover

EXPLODE         = 0;
EXP_D           = 60;    // explode separation in mm

SHOW_RPI        = 1;     // 1 = show ghost RPi PCB inside cover
SHOW_LCD        = 1;     // 1 = show ghost LCD module inside cover

BASE_COL       = [0.3,  0.55, 0.75, 1.0];   // blue-grey, opaque
COVER_COL      = [0.25, 0.45, 0.65, 0.7];   // slightly darker, semi-transparent
RPI_COL        = [0.2,  0.7,  0.3,  0.85];  // green ghost
LCD_PCB_COL    = [0.9,  0.9,  0.3,  0.5];   // yellow ghost — PCB layer (behind)
LCD_PANEL_COL  = [0.95, 0.55, 0.1,  0.8];   // orange ghost — panel layer (front, in window)

// ── Base at world origin ──────────────────────────────────────
if (SHOW_BASE)
    color(BASE_COL)
        base();

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
            translate([0, 0, _cover_dz])
                translate([_rx_ctr, _ry_ctr, _rface_z])
                    rotate([180 + TILT_ANGLE, 0, 0])
                        translate([-RPI_X/2, -RPI_Y/2, STOFF_H - RPI_PCB_T])
                            difference() {
                                cube([RPI_X, RPI_Y, RPI_PCB_T]);
                                for (dx = [RPI_HOLE_OX, RPI_HOLE_OX + RPI_HOLE_DX])
                                for (dy = [RPI_HOLE_OY, RPI_HOLE_OY + RPI_HOLE_DY])
                                    translate([dx, dy, -0.05])
                                        cylinder(d=M25_CLEAR, h=RPI_PCB_T + 0.1, $fn=16);
                            }

    // LCD PCB layer: chip side faces RPi; spans local Z = CLR_ABOVE_RPI+LCD_PANEL_T … CLR_ABOVE_RPI+LCD_T
    if (SHOW_LCD)
        color(LCD_PCB_COL)
            translate([0, 0, _cover_dz])
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
            translate([0, 0, _cover_dz])
                translate([_lx_ctr, _ly_ctr, _lface_z])
                    rotate([180 + TILT_ANGLE, 0, 0])
                        translate([LCD_PANEL_OX  - LCD_PANEL_X/2,
                                   LCD_PANEL_OSL - LCD_PANEL_SL/2,
                                   CLR_ABOVE_RPI])
                            cube([LCD_PANEL_X, LCD_PANEL_SL, LCD_PANEL_T]);
}
