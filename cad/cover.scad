// ============================================================
// OctoMount — cover.scad  (2-piece redesign)
//
// The Cover is a single printed part:
//   • Right-trapezoid side profile (back wall taller than front)
//   • Front wall height = COVER_FRONT_Z  (thin lip)
//   • Back  wall height = COVER_BACK_Z   (48 mm - base height)
//   • Angled top face spans front→back — holds the LCD
//   • LCD window slot through the angled face
//   • Side walls (WALL thick each)
//   • Back wall (WALL thick)
//   • Open bottom (sits on base top rim)
//   • 4× M3 countersunk holes at corners, screw into base bosses
//
// Origin: bottom-front-left corner of the cover
//         = top-front-left corner of the base (Z = BASE_OUTER_Z).
//
// Print: back-wall-down, angled face up.  ~8° tilt needs no supports.
// ============================================================
include <params.scad>

cover();

module cover() {
    difference() {
        _cover_shell();
        _cover_cuts();
    }
}

// ── Outer shell using hull() ──────────────────────────────────
// Hull of a thin front slab (height=COVER_FRONT_Z) and a thin
// back slab (height=COVER_BACK_Z) gives exactly the trapezoid.
module _cover_shell() {
    hull() {
        // Front slab: Y=0..epsilon, full X, height=COVER_FRONT_Z
        cube([OUTER_X, 0.01, COVER_FRONT_Z]);
        // Back slab: Y=OUTER_Y-epsilon..OUTER_Y, full X, height=COVER_BACK_Z
        translate([0, OUTER_Y - 0.01, 0])
            cube([OUTER_X, 0.01, COVER_BACK_Z]);
    }
}

// ── Inner void (remove interior, leaving walls + angled face) ─
module _cover_inner_void() {
    // Same hull trick, but inset by WALL on sides, front, and back.
    // Top is inset by WALL measured perpendicularly to the angled face
    // (for small angles, ~WALL in Z is close enough).
    _dZ       = COVER_BACK_Z - COVER_FRONT_Z;
    _face_ang = atan(_dZ / OUTER_Y);     // degrees from horizontal
    _wall_z   = WALL / cos(_face_ang);   // wall thickness projected onto Z

    hull() {
        translate([WALL, WALL, 0])
            cube([OUTER_X - 2*WALL, 0.01,
                  max(0.01, COVER_FRONT_Z - _wall_z)]);
        translate([WALL, OUTER_Y - WALL - 0.01, 0])
            cube([OUTER_X - 2*WALL, 0.01,
                  COVER_BACK_Z - _wall_z]);
    }
}

// ── Subtractive cuts ──────────────────────────────────────────
module _cover_cuts() {
    // Interior void
    _cover_inner_void();

    // ── LCD window in angled face ─────────────────────────────
    // Tilt angle from horizontal
    _dZ   = COVER_BACK_Z - COVER_FRONT_Z;
    _tilt = atan(_dZ / OUTER_Y);

    // Centre of the angled face in Y and Z
    _cY = OUTER_Y / 2;
    _cZ = COVER_FRONT_Z + (_cY / OUTER_Y) * _dZ;

    // Cut a slot perpendicular to the angled face, centred in X and face.
    // Rotate a box so its Z-axis aligns with the face normal.
    translate([OUTER_X/2, _cY, _cZ])
        rotate([-_tilt, 0, 0])               // tilt to match face angle
            translate([-LCD_ACT_X/2, -LCD_ACT_SL/2, -WALL - 1])
                cube([LCD_ACT_X, LCD_ACT_SL, WALL + 2]);

    // Shallow recess for full LCD PCB (around the active window)
    translate([OUTER_X/2, _cY, _cZ])
        rotate([-_tilt, 0, 0])
            translate([-LCD_PCB_X/2 - CLR, -LCD_PCB_SL/2 - CLR, -LCD_T - CLR])
                cube([LCD_PCB_X + 2*CLR, LCD_PCB_SL + 2*CLR, LCD_T + CLR + 0.1]);

    // ── M3 screw holes (4 corners, enter from bottom of cover) ──
    for (bx = BOSS_XS, by = BOSS_YS) {
        // Z height of cover bottom at this Y (bottom of cover is at Z=0 everywhere)
        translate([bx, by, -0.05])
            cylinder(d=M3_CLEAR, h=WALL + 0.1, $fn=16);
        // Countersink on bottom face
        translate([bx, by, 0])
            cylinder(d=M3_CS_D, h=M3_CS_H + 0.05, $fn=32);
    }
}
