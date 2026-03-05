// ============================================================
// OctoMount — p2_bracket.scad
// Front mounting plate + horizontal arm shelf (L-bracket).
//
// PLATE  — vertical panel (145 × WALL × 40 mm) bolts to the
//          Ender 3 Pro control box front face via 2× M5 flat-head
//          screws (diagonal) into the 4040 beam end face.
//          Covers the stock control box front panel entirely.
//          Stock USB cable routes internally to the RPi.
//
// ARM SHELF — horizontal shelf (ARM_W wide × ARM_THICK tall)
//          spans the full enclosure Y depth + ARM_L cable gap.
//          Left face: SD card slot (microSD extension from control box).
//          Top face: 4× M3 clearance holes matching enclosure bottom.
//
// Coordinate origin: shared with enclosure world origin.
//   X = 0      left edge (beam/left side)
//   Y = 0      front face of arm  = front face of enclosure
//   Z = 0      arm top face       = enclosure bottom face
//
//   Arm:   X=[0, ARM_W],   Y=[0, OUTER_Y+ARM_L],        Z=[-ARM_THICK, 0]
//   Plate: X=[0, PLATE_W], Y=[OUTER_Y+ARM_L, OUTER_Y+ARM_L+WALL], Z=[-PLATE_H, 0]
//
// Assembly: bracket();  (no translation — shares enclosure world origin)
// Explode:  translate([0, EXPLODE*EXP_D, 0]) bracket();
// ============================================================
include <params.scad>

// ── M5 countersink (flat-head screw, opens at cylinder Z=0 face) ──
// Call with rotate([-90,0,0]) so the opening faces the plate front face.
module m5_csk(depth) {
    // Conical countersink — wide at face, narrows to clearance bore
    cylinder(d1 = M5_CS_D, d2 = M5_CLEAR, h = M5_CS_H + 0.05, $fn = 32);
    // Clearance shaft through full plate thickness
    cylinder(d  = M5_CLEAR, h = depth + 0.1,                   $fn = 16);
}

// ── Mounting plate ────────────────────────────────────────────
// Vertical panel at the rear of the assembly.
// Plate front face (accessible to installer): Y = OUTER_Y + ARM_L
module mount_plate() {
    py = OUTER_Y + ARM_L;   // Y position of plate front face

    difference() {
        translate([0, py, -PLATE_H])
            cube([PLATE_W, WALL, PLATE_H]);

        // 2× M5 countersink holes on plate front face (Y = py).
        // Flat-head M5 screws sit flush; shafts exit plate rear,
        // pass through stock control box panel, thread into 4040 beam.
        // Hole positions: top-left and bottom-right of 4040 end face.
        //   MOUNT_H1 = [10, 30]  → top-left   (X=10, Z_from_bottom=30)
        //   MOUNT_H2 = [30, 10]  → bottom-right (X=30, Z_from_bottom=10)
        for (h = [MOUNT_H1, MOUNT_H2])
            translate([h[0], py - 0.05, h[1] - PLATE_H])
                rotate([-90, 0, 0])
                    m5_csk(WALL);
    }
}

// ── Arm shelf ─────────────────────────────────────────────────
// Horizontal shelf; top face aligns with enclosure bottom (Z=0).
// Spans the full enclosure depth (OUTER_Y) plus cable gap (ARM_L)
// to meet the plate at Y = OUTER_Y + ARM_L.
module arm_shelf() {
    // SD slot: centred between the two M3 hole rows in Y to avoid conflicts.
    // Card width (26 mm, Y direction) sits between Y=WALL+10 and Y=OUTER_Y-WALL-10.
    sd_y = (OUTER_Y - CTRL_SD_W) / 2;   // ≈ 25.5 mm — midpoint of arm Y span

    difference() {
        // Solid shelf
        translate([0, 0, -ARM_THICK])
            cube([ARM_W, OUTER_Y + ARM_L, ARM_THICK]);

        // 4× M3 clearance holes — arm top face down.
        // Positions match p1_enclosure bottom m3_thru holes:
        //   X = BOSS_XS, Y = WALL+10 and OUTER_Y-WALL-10
        for (bx = BOSS_XS)
            for (by = [WALL + 10, OUTER_Y - WALL - 10]) {
                // Clearance shaft (full arm thickness)
                translate([bx, by, -ARM_THICK - 0.05])
                    cylinder(d = M3_CLEAR, h = ARM_THICK + 0.1, $fn = 16);
                // Counterbore on arm bottom face for M3 bolt head
                translate([bx, by, -ARM_THICK - 0.05])
                    cylinder(d = M3_CS_D, h = M3_CS_H + 0.05, $fn = 32);
            }

        // SD card slot — opens on left face (X = 0).
        // Card inserts in +X direction.
        //   Y: card width (24 mm) direction — CTRL_SD_W = 26 mm
        //   Z: card thickness direction    — CTRL_SD_H = 3.5 mm, centred in ARM_THICK
        //   X: SD card length pocket       — SD_POCKET = 34 mm  (TBD)
        translate([-0.05,
                   sd_y,
                   -ARM_THICK / 2 - CTRL_SD_H / 2])
            cube([SD_POCKET + 0.05, CTRL_SD_W, CTRL_SD_H]);
    }
}

// ── Full bracket ──────────────────────────────────────────────
module bracket() {
    mount_plate();
    arm_shelf();
}

bracket();
