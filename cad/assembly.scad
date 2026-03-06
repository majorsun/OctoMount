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
    // Helper: Z of inner face at a given Y within the cover local frame
    // Inner face Z(y) = COVER_FRONT_Z - WALL/cos(θ) + y*tan(θ)
    _wz  = WALL / cos(TILT_ANGLE);
    _tan = tan(TILT_ANGLE);

    // RPi bounding box (RPI_X × RPI_Y × RPI_T), parallel to inner face.
    // Front edge at Y = WALL + RPI_Y0; centred in X.
    _ry0 = WALL + RPI_Y0;       // cover-local Y of RPi front edge
    _rx0 = WALL + RPI_X0;       // cover-local X of RPi left edge

    // Inner face Z at RPi front edge
    _rface_z = COVER_FRONT_Z - _wz + _ry0 * _tan;

    // RPi block: from face inward by (STOFF_H + RPI_T/2) to (STOFF_H - RPI_T/2)
    // Placed at inner face, rotated to lie parallel to it, then shifted down
    color(RPI_COL)
        translate([0, 0, _cover_dz])   // into cover frame
            translate([_rx0 + RPI_X/2, _ry0 + RPI_Y/2, _rface_z])
                rotate([-TILT_ANGLE, 0, 0])
                    translate([-RPI_X/2, -RPI_Y/2, -(STOFF_H + RPI_T)])
                        cube([RPI_X, RPI_Y, RPI_T]);

    // LCD bounding box (LCD_PCB_X × LCD_PCB_SL × LCD_T), same orientation,
    // stacked between the inner face and the RPi (LCD closest to face).
    _lx0 = OUTER_X/2;
    _ly0 = OUTER_Y/2;
    _lface_z = COVER_FRONT_Z - _wz + _ly0 * _tan;

    color(LCD_COL)
        translate([0, 0, _cover_dz])
            translate([_lx0, _ly0, _lface_z])
                rotate([-TILT_ANGLE, 0, 0])
                    translate([-LCD_PCB_X/2, -LCD_PCB_SL/2, -(CLR_ABOVE_RPI + LCD_T)])
                        cube([LCD_PCB_X, LCD_PCB_SL, LCD_T]);
}
