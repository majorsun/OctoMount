// ============================================================
// OctoMount — assembly.scad  (2-piece redesign, rev 6)
//
// Full assembly view: Base + Cover positioned together.
// OUTER_X = 145 mm (left wall at panel left edge; right wall at panel right edge).
//
// Flags:
//   SHOW_BASE      = 1  → render the base
//   SHOW_COVER     = 0  → render the cover (semi-transparent)
//   EXPLODE        = 0  → exploded view (cover lifted off base)
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

FLIP_OPEN       = 0;     // 1 = show cover flipped open around hinge axis (overrides EXPLODE)
FLIP_ANGLE      = 60;    // degrees open (90 = cover horizontal, 120 = leaning back)

SHOW_RPI        = 1;     // 1 = show ghost RPi PCB inside
SHOW_LCD        = 1;     // 1 = show ghost LCD module inside
SHOW_BUCK       = 1;     // 1 = show ghost LM2596 buck converter
SHOW_FAN40      = 1;     // 1 = show ghost 4010 fan (right-wall mounted)
SHOW_DEBUG      = 1;     // 1 = red spheres at boss-tip world positions

BASE_COL       = [0.3,  0.55, 0.75, 1.0];   // blue-grey, opaque
COVER_COL      = [0.25, 0.45, 0.65, 0.7];   // slightly darker, semi-transparent
RPI_COL        = [0.2,  0.7,  0.3,  0.85];  // green ghost
LCD_PCB_COL    = [0.9,  0.9,  0.3,  0.5];   // yellow ghost — PCB layer (behind)
LCD_PANEL_COL  = [0.95, 0.55, 0.1,  0.8];   // orange ghost — panel layer (front, in window)
BUCK_COL       = [0.7,  0.35, 0.1,  0.9];   // brown ghost — LM2596 buck converter
FAN40_COL      = [0.6,  0.6,  0.6,  0.7];   // grey ghost  — 4010 fan
SCREW_COL      = [0.75, 0.75, 0.8,  1.0];   // steel — M3 screws + nuts

// ── Shared M3 hardware dims ───────────────────────────────────
_m3_head_d  = 5.5;   // M3 pan-head diameter
_m3_head_h  = 2.0;   // M3 pan-head height
_m3_nut_r   = (5.5 / 2) / cos(30);  // M3 hex-nut circumscribed radius (AF=5.5mm)
_m3_nut_h   = 2.4;   // M3 hex-nut thickness

// ── Base at world origin ──────────────────────────────────────
if (SHOW_BASE)
    color(BASE_COL)
        base();

// ── Ghost: LM2596 buck converter (right of RPi, on base floor) ─
// Cube BUCK_X × BUCK_Y × BUCK_Z with four BUCK_HOLE_D clearance holes at boss positions.
// Right edge 2 mm from right wall inner face; PCB bottom at BASE_OUTER_Z + BUCK_FLOOR_H.
if (SHOW_BUCK)
    color(BUCK_COL)
        translate([OUTER_X - WALL - BUCK_WALL_GAP - BUCK_X,
                   WALL + BUCK_Y0,
                   BASE_OUTER_Z + BUCK_FLOOR_H])
            difference() {
                cube([BUCK_X, BUCK_Y, BUCK_Z]);
                for (bx = [(BUCK_X - BUCK_HOLE_X)/2, (BUCK_X + BUCK_HOLE_X)/2],
                     by = [(BUCK_Y - BUCK_HOLE_Y)/2, (BUCK_Y + BUCK_HOLE_Y)/2])
                    translate([bx, by, -0.05])
                        cylinder(d=BUCK_HOLE_D, h=BUCK_Z + 0.1, $fn=16);
            }

// ── Ghost: M3 screws for buck converter bosses ────────────────
// Four M3×10 pan-head screws through PCB mounting holes into base bosses.
// Heads shown above the full component height (BUCK_Z) so they're visible in the assembly.
// Shaft descends from head through PCB (1.6mm) into the boss (BUCK_FLOOR_H).
_buck_screw_l = BUCK_FLOOR_H + 1.6;  // shaft: through PCB + full boss depth

if (SHOW_BUCK)
    color(SCREW_COL)
        for (bx = [BUCK_FLOOR_X1, BUCK_FLOOR_X2],
             by = [BUCK_FLOOR_Y1, BUCK_FLOOR_Y2])
            translate([bx, by, BASE_OUTER_Z + BUCK_FLOOR_H + BUCK_Z]) {
                cylinder(d=_m3_head_d, h=_m3_head_h, $fn=16);           // head above module top
                translate([0, 0, -_buck_screw_l])
                    cylinder(d=3.0, h=_buck_screw_l, $fn=16);            // shaft down into boss
            }

// ── Ghost: 4010 fan (right-wall mounted, blowing inward −X) ──────────────
// Outer face at X = OUTER_X − WALL_S; body extends inward FAN40_T mm.
// Four M3 holes at ±FAN40_HOLE_P/2 in Y and Z from centre.
// STL bounding box: X=−20..20, Y=0..10, Z=−20..20 (centred in XZ, depth in Y).
// Face in XZ plane (normal = STL −Y).  rotate([0,0,90]) maps:
//   STL X → world Y (width), STL Y → world −X (depth inward), STL Z → world Z (height).
//   Face normal (STL −Y) → world +X (facing right wall from inside).
// Translate to fan-centre world pos so the centred-at-origin XZ extents land correctly.
if (SHOW_FAN40)
    color(FAN40_COL)
        translate([OUTER_X - WALL_S, FAN40_CY, FAN40_CZ])
            rotate([0, 0, 90])
                import("../reference/4010fanv1.stl", convexity=5);

// ── Ghost: M3 screws + hex nuts for fan mounting ──────────────
// Screws enter from outside right wall (+X side), nuts trapped on fan inner face.
// M3×16 pan-head: head protrudes outside wall, shaft through wall (2mm) + fan (10mm).
_m3_screw_l = 16.0;  // total screw length (head-face to tip)

if (SHOW_FAN40)
    color(SCREW_COL)
        for (dy = [-FAN40_HOLE_P/2, FAN40_HOLE_P/2],
             dz = [-FAN40_HOLE_P/2, FAN40_HOLE_P/2]) {
            // Screw: head on outer wall face, shaft going inward (−X)
            // rotate([0,90,0]) aligns local +Z with world +X
            translate([OUTER_X, FAN40_CY + dy, FAN40_CZ + dz])
                rotate([0, 90, 0]) {
                    cylinder(d=_m3_head_d, h=_m3_head_h, $fn=16);       // head outside
                    translate([0, 0, -_m3_screw_l])
                        cylinder(d=FAN40_HOLE_D, h=_m3_screw_l, $fn=16); // shaft inward
                }
            // Nut: on fan inner face (X = OUTER_X − WALL_S − FAN40_T)
            // rotate([0,-90,0]) aligns local +Z with world −X
            translate([OUTER_X - WALL_S - FAN40_T, FAN40_CY + dy, FAN40_CZ + dz])
                rotate([0, -90, 0])
                    cylinder(r=_m3_nut_r, h=_m3_nut_h, $fn=6);
        }

// ── Debug: red spheres at boss-tip world positions ────────────
// Uses the exact same transform chain as base.scad bosses → guaranteed correct.
if (SHOW_DEBUG)
    for (bx = BOSS_XS, by = BOSS_YS)
        color([1, 0, 0])
            translate([bx, by, BASE_OUTER_Z])
                rotate([TILT_ANGLE, 0, 0])
                    translate([0, 0, _BH_C + by * sin(TILT_ANGLE)])
                        sphere(r=2.0, $fn=16);

// ── Cover + internals ─────────────────────────────────────────
_cover_dz = BASE_OUTER_Z + EXPLODE * EXP_D;

if (SHOW_COVER)
    color(COVER_COL) {
        if (FLIP_OPEN)
            // Rotate cover around the hinge axis (X-parallel line at Y=BHINGE_Y, Z=BHINGE_WZ).
            // rotate([-FLIP_ANGLE,0,0]): front edge lifts upward (+Z), away from base.
            translate([0, BHINGE_Y, BHINGE_WZ])
                rotate([-FLIP_ANGLE, 0, 0])
                    translate([0, -BHINGE_Y, BASE_OUTER_Z - BHINGE_WZ])
                        cover();
        else
            translate([0, 0, _cover_dz])
                cover();
    }

// ── Ghost internals — RPi + LCD parallel to inner angled face ─
if (SHOW_RPI || SHOW_LCD) {
    _tan = tan(TILT_ANGLE);

    // RPi PCB centre in enclosure XY
    _rx_ctr = WALL + RPI_X0 + RPI_X/2;
    _ry_ctr = WALL + RPI_Y0 + RPI_Y/2;

    // LCD PCB centre = RPi centre + GPIO-coupled offset
    _lx_ctr = _rx_ctr + LCD_OFS_X;
    _ly_ctr = _ry_ctr + LCD_OFS_Y;

    // Pivot Z anchored to boss-tip plane so RPi bare-bottom sits flush on boss tops.
    // Boss tips lie at world Z = BASE_OUTER_Z + (_BH_C + by·sin θ)·cos θ.
    // Solving for the pivot that puts local Z = STOFF_H at that world Z:
    //   pivot_z = (_BH_C + STOFF_H)/cos θ + Y_centre·tan θ
    _boss_face_z = (_BH_C + STOFF_H) / cos(TILT_ANGLE);
    _rface_z = _boss_face_z + _ry_ctr * _tan;
    _lface_z = _boss_face_z + _ly_ctr * _tan;

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
                                mirror([1, 0, 0])
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
