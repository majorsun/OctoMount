// ============================================================
// OctoMount — cover.scad  (2-piece redesign)
//
// The Cover is a single printed part:
//   • Right-trapezoid side profile (front wall short, back wall tall)
//   • Front wall height = COVER_FRONT_Z  (thin lip = WALL)
//   • Back  wall height = COVER_BACK_Z   (derived: FRONT + OUTER_Y*tan(TILT_ANGLE))
//   • Angled top face at TILT_ANGLE from horizontal — holds LCD parallel to face
//   • LCD active-area window (through-hole) in angled face
//   • Snug PCB recess (LCD_FIT_CLR per side) around window
//   • Side walls (WALL thick each)
//   • Back wall (WALL thick)
//   • Open bottom (sits on base top rim)
//   • 4× M3 countersunk holes at corners, screw into base bosses
//
// Origin: bottom-front-left corner of the cover
//         = top-front-left corner of the base (Z = BASE_OUTER_Z).
//
// Print: back-wall-down, angled face up.  Steep angle may need minimal supports.
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
    // Inset by WALL on sides, front, and back.
    // Top face wall thickness is WALL measured perpendicular to the face,
    // which projects to WALL/cos(TILT_ANGLE) in the Z direction.
    _wall_z = WALL / cos(TILT_ANGLE);

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
    // Centre of the angled face in Y and Z
    _cY = OUTER_Y / 2;
    _cZ = COVER_FRONT_Z + (_cY / OUTER_Y) * (COVER_BACK_Z - COVER_FRONT_Z);

    // Through-hole for active display area, perpendicular to face.
    // rotate([-TILT_ANGLE, 0, 0]) aligns the cut's Z-axis with the face normal.
    translate([OUTER_X/2, _cY, _cZ])
        rotate([-TILT_ANGLE, 0, 0])
            translate([-LCD_ACT_X/2, -LCD_ACT_SL/2, -WALL - 1])
                cube([LCD_ACT_X, LCD_ACT_SL, WALL + 2]);

    // Snug recess for full LCD PCB (LCD_FIT_CLR per side → press fit into cover)
    translate([OUTER_X/2, _cY, _cZ])
        rotate([-TILT_ANGLE, 0, 0])
            translate([-LCD_PCB_X/2 - LCD_FIT_CLR,
                       -LCD_PCB_SL/2 - LCD_FIT_CLR,
                       -LCD_T - LCD_FIT_CLR])
                cube([LCD_PCB_X + 2*LCD_FIT_CLR,
                      LCD_PCB_SL + 2*LCD_FIT_CLR,
                      LCD_T + LCD_FIT_CLR + 0.1]);

    // ── M3 screw holes (4 corners, enter from bottom of cover) ──
    for (bx = BOSS_XS, by = BOSS_YS) {
        translate([bx, by, -0.05])
            cylinder(d=M3_CLEAR, h=WALL + 0.1, $fn=16);
        // Countersink on bottom face
        translate([bx, by, 0])
            cylinder(d=M3_CS_D, h=M3_CS_H + 0.05, $fn=32);
    }
}
