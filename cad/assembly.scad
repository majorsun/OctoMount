// ============================================================
// OctoMount — assembly.scad  (2-piece redesign, rev 2)
//
// Full assembly view: Base + Cover positioned together.
//
// Flags:
//   EXPLODE   = 1  → exploded view (cover lifted off base)
//   SHOW_INTERNALS = 1  → ghost RPi + LCD blocks inside cover
// ============================================================
include <params.scad>
use <base.scad>
use <cover.scad>

EXPLODE         = 0;
EXP_D           = 50;    // explode separation in mm
SHOW_INTERNALS  = 1;     // 1 = show ghost RPi + LCD inside cover

BASE_COL  = [0.3,  0.55, 0.75, 1.0];   // blue-grey
COVER_COL = [0.25, 0.45, 0.65, 0.85];  // slightly darker, semi-transparent
RPI_COL   = [0.2,  0.7,  0.3,  0.4];   // green ghost
LCD_COL   = [0.9,  0.9,  0.3,  0.4];   // yellow ghost

// ── Base at world origin ──────────────────────────────────────
color(BASE_COL)
    base();

// ── Cover + internals ─────────────────────────────────────────
_cover_dz = BASE_OUTER_Z + EXPLODE * EXP_D;

color(COVER_COL)
    translate([0, 0, _cover_dz])
        cover();

// Ghost internals — approximate bounding boxes, aligned with face
if (SHOW_INTERNALS) {
    // Inner face Z(y) = COVER_FRONT_Z - WALL/cos(θ) + y·tan(θ)
    _wz  = WALL / cos(TILT_ANGLE);
    _tan = tan(TILT_ANGLE);

    // XY centres of RPi and LCD (both share the cover centre in X and Y)
    _rx_ctr = WALL + RPI_X0 + RPI_X/2;
    _ry_ctr = WALL + RPI_Y0 + RPI_Y/2;
    _lx_ctr = OUTER_X / 2;
    _ly_ctr = OUTER_Y / 2;

    // Inner face Z evaluated at each block's Y centre
    _rface_z = COVER_FRONT_Z - _wz + _ry_ctr * _tan;
    _lface_z = COVER_FRONT_Z - _wz + _ly_ctr * _tan;

    // Assembly depth layout (local -Z = into interior):
    //   0              inner face
    //   -CLR_ABOVE_RPI LCD screen face
    //   -(CLR+LCD_T)   RPi PCB top  (= -(STOFF_H - RPI_T))
    //   -STOFF_H       RPi PCB bottom / standoff tip

    // RPi block: local z from -STOFF_H to -(STOFF_H - RPI_T)
    color(RPI_COL)
        translate([0, 0, _cover_dz])
            translate([_rx_ctr, _ry_ctr, _rface_z])
                rotate([-TILT_ANGLE, 0, 0])
                    translate([-RPI_X/2, -RPI_Y/2, -STOFF_H])
                        cube([RPI_X, RPI_Y, RPI_T]);

    // LCD block: local z from -(CLR_ABOVE_RPI + LCD_T) to -CLR_ABOVE_RPI
    color(LCD_COL)
        translate([0, 0, _cover_dz])
            translate([_lx_ctr, _ly_ctr, _lface_z])
                rotate([-TILT_ANGLE, 0, 0])
                    translate([-LCD_PCB_X/2, -LCD_PCB_SL/2, -(CLR_ABOVE_RPI + LCD_T)])
                        cube([LCD_PCB_X, LCD_PCB_SL, LCD_T]);
}
