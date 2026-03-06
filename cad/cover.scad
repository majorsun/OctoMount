// ============================================================
// OctoMount — cover.scad  (2-piece redesign, rev 2)
//
// The Cover houses the RPi + MPI4008 LCD assembly on its
// inner angled face.  The whole RPi+LCD unit is tilted with
// the cover face — no separate tilt mechanism needed.
//
//   • Right-trapezoid side profile (front wall TALL, back wall taller)
//   • Front wall height = COVER_FRONT_Z = 31 mm  (= WALL + ASSEMBLY_DEPTH)
//   • Back  wall height = COVER_BACK_Z  = 42 mm  (= MAX_OUTER_Z − BASE_OUTER_Z)
//   • Angled top face at TILT_ANGLE ≈ 6.7° from horizontal
//   • LCD active-area window (through-hole) in angled face
//   • 4× RPi standoff bosses on inner face — M2.5 self-tap, STOFF_H tall
//   • Side walls and back wall (WALL thick each)
//   • Open bottom (sits on base top rim)
//   • 4× M3 countersunk holes at corners, screw into base bosses
//
// Assembly order from inner face outward (toward window):
//   standoff base (on face) → STOFF_H → RPi PCB bottom (mounting holes)
//   → RPi stack (RPI_T) → LCD PCB (LCD_T) → LCD screen → window
//
// USB-A / Ethernet routing: exit via cover open bottom — TBD after measurement.
//
// Origin: bottom-front-left corner of the cover
//         = top-front-left corner of the base (Z = BASE_OUTER_Z).
//
// Print: back-wall-down, angled face up.
// ============================================================
include <params.scad>

cover();

module cover() {
    difference() {
        union() {
            // Outer shell minus inner void → just the walls + angled face
            difference() {
                _cover_shell();
                _cover_inner_void();
            }
            // RPi standoff bosses added back (they live in the void space)
            _cover_rpi_bosses();
        }
        // All through-cuts applied to the combined solid
        _cover_cuts();
    }
}

// ── Outer shell ───────────────────────────────────────────────
module _cover_shell() {
    hull() {
        // Front edge: Y=0, height = COVER_FRONT_Z
        cube([OUTER_X, 0.01, COVER_FRONT_Z]);
        // Back edge: Y=OUTER_Y, height = COVER_BACK_Z
        translate([0, OUTER_Y - 0.01, 0])
            cube([OUTER_X, 0.01, COVER_BACK_Z]);
    }
}

// ── Inner void (removes interior, leaving walls + angled face) ─
module _cover_inner_void() {
    // Wall thickness perpendicular to the angled face = WALL / cos(θ)
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

// ── RPi standoff bosses on inner angled face ──────────────────
// Boss base sits on the inner face surface.
// rotate([180 + TILT_ANGLE, 0, 0]) points local +Z perpendicular
// into the cover interior (mostly world -Z, slight +Y).
// Boss tip (with M2.5 blind hole) faces the cover interior;
// RPi PCB bottom rests on tips, M2.5 screws go up from below.
module _cover_rpi_bosses() {
    _rpi_ox     = WALL + RPI_X0;
    _rpi_oy     = WALL + RPI_Y0;
    _wall_z_perp = WALL / cos(TILT_ANGLE);

    for (dx = [RPI_HOLE_OX, RPI_HOLE_OX + RPI_HOLE_DX])
    for (dy = [RPI_HOLE_OY, RPI_HOLE_OY + RPI_HOLE_DY]) {
        _bx = _rpi_ox + dx;
        _by = _rpi_oy + dy;
        // Z of inner face surface at this Y position
        _bz = COVER_FRONT_Z - _wall_z_perp + _by * tan(TILT_ANGLE);
        translate([_bx, _by, _bz])
            rotate([180 + TILT_ANGLE, 0, 0])
                rpi_boss(STOFF_H);
    }
}

// ── Subtractive cuts ──────────────────────────────────────────
module _cover_cuts() {
    // Centre of angled face in Y and Z (on outer face surface)
    _cY = OUTER_Y / 2;
    _cZ = COVER_FRONT_Z + (_cY / OUTER_Y) * (COVER_BACK_Z - COVER_FRONT_Z);

    // ── LCD active-area window (through-hole, perp. to face) ──
    translate([OUTER_X/2, _cY, _cZ])
        rotate([-TILT_ANGLE, 0, 0])
            translate([-LCD_ACT_X/2, -LCD_ACT_SL/2, -WALL - 1])
                cube([LCD_ACT_X, LCD_ACT_SL, WALL + 2]);

    // ── M3 screw holes at corners (countersunk from cover bottom) ─
    for (bx = BOSS_XS, by = BOSS_YS) {
        translate([bx, by, -0.05])
            cylinder(d=M3_CLEAR, h=WALL + 0.1, $fn=16);
        translate([bx, by, 0])
            cylinder(d=M3_CS_D, h=M3_CS_H + 0.05, $fn=32);
    }
}
