// ============================================================
// OctoMount — p1_enclosure.scad
// Main enclosure body shell.
//
// Coordinate origin: outer front-left-bottom corner of shell.
//   X = left → right
//   Y = front (display side) → rear (bracket side)
//   Z = bottom → top
//
// Orientation after printing / assembly:
//   Front face (Y=0)     → faces operator, holds LCD
//   Rear  face (Y=OUTER_Y) → rear panel with vents
//   Left  wall (X=0)     → Ethernet exit
//   Right wall (X=OUTER_X) → USB-C, HDMI, microSD exits
//   Top   face (Z=OUTER_Z) → USB-A cable exit slot
//   Bottom face (Z=0)    → attaches to bracket arm
// ============================================================
include <params.scad>

// Helper: cut a rectangular slot through the LEFT outer wall.
// pos_y = slot centre Y (absolute), pos_z = slot centre Z (absolute)
// w = slot width (in Y), h = slot height (in Z)
module left_slot(pos_y, pos_z, w, h) {
    translate([-0.05, pos_y - w/2, pos_z - h/2])
        cube([WALL + 0.1, w, h]);
}

// Helper: cut a rectangular slot through the RIGHT outer wall.
module right_slot(pos_y, pos_z, w, h) {
    translate([OUTER_X - WALL - 0.05, pos_y - w/2, pos_z - h/2])
        cube([WALL + 0.1, w, h]);
}

// Helper: cut a rectangular slot through the TOP outer face.
module top_slot(pos_x, pos_y, w, h) {
    translate([pos_x - w/2, pos_y - h/2, OUTER_Z - WALL - 0.05])
        cube([w, h, WALL + 0.1]);
}

module enclosure() {
    difference() {
        union() {
            // ── Outer shell ────────────────────────────────────
            rbox([OUTER_X, OUTER_Y, OUTER_Z]);

            // ── RPi mounting standoff bosses ───────────────────
            // 4 bosses on the divider wall FRONT FACE, pointing into
            // the main cavity (-Y direction).  The RPi PCB presses
            // against their tips; M2.5 screws enter from the cavity
            // front (+Y → -Y through RPi hole into boss).
            //
            // Boss local axis = Z; rotate([90,0,0]) maps Z→-Y so
            // the boss extends from DIV_Y toward the front (-Y).
            // The blind tapped hole is at the TIP (original Z=h),
            // which ends up at Y = DIV_Y - STOFF_H.
            for (xi = [0, RPI_HOLE_X])
            for (zi = [0, RPI_HOLE_Z])
                translate([
                    WALL + RPI_X0 + RPI_HOLE_OX + xi,
                    DIV_Y,
                    WALL + RPI_Z0 + RPI_HOLE_OZ + zi
                ])
                    rotate([90, 0, 0])
                        rpi_boss(STOFF_H);

            // ── Front-face M3 bosses (for bezel screws) ────────
            // Bosses point into main cavity (+Y from inner front face).
            // rotate([-90,0,0]) maps Z→+Y direction.
            // Blind hole at tip (original Z=h → Y = WALL + boss_h).
            // Screw enters from -Y (through front wall clearance hole),
            // through boss base (Y=WALL), threading into hole at far end.
            // NOTE: because screw enters at base (Z=0 after rotate),
            // we use a THROUGH clearance pass in the difference() below,
            // plus the tapped portion inside the boss body itself.
            for (bx = BOSS_XS) for (bz = BOSS_ZS)
                translate([bx, WALL, bz])
                    rotate([-90, 0, 0])
                        boss(WALL + 4);

            // ── Rear-face M3 bosses (for rear panel screws) ────
            // Point into main cavity (-Y from inner rear face).
            for (bx = BOSS_XS) for (bz = BOSS_ZS)
                translate([bx, OUTER_Y - WALL, bz])
                    rotate([90, 0, 0])
                        boss(WALL + 4);
        }

        // ────────────────────────────────────────────────────────
        // SUBTRACTIONS
        // ────────────────────────────────────────────────────────

        // ── Main cavity (LCD + fan + RPi section) ──────────────
        translate([WALL, WALL, WALL])
            cube([INNER_X, DIV_Y - WALL, INNER_Z]);

        // ── Buck converter cavity ───────────────────────────────
        translate([WALL, BUCK_Y, WALL])
            cube([INNER_X, REAR_Y - BUCK_Y, INNER_Z]);

        // ── Front face: LCD active-area display cutout ──────────
        // Centred on front wall; opening is active area + 0.5 mm margin.
        translate([
            WALL + LCD_X0 + LCD_BEZEL_X,
            -0.05,
            WALL + LCD_Z0 + LCD_BEZEL_Z
        ])
            cube([LCD_ACT_X, WALL + 0.1, LCD_ACT_Z]);

        // ── Rear face: opening for rear panel (lip recess) ──────
        // Slightly inset so rear panel lip seats into recess.
        translate([WALL + CLR, OUTER_Y - WALL - 0.05, WALL + CLR])
            cube([INNER_X - 2*CLR, WALL + 0.1, INNER_Z - 2*CLR]);

        // ── LEFT wall: Ethernet port opening ────────────────────
        // Ethernet is on the LEFT short edge of RPi (X ≈ 0 in RPi coords).
        // Y position: approx centre of RPi depth section.
        // Z position: RPI_ETH_Z above RPi GPIO (bottom) edge.
        // TBD — adjust after physical measurement.
        left_slot(
            _FAN_Y1 + RPI_ETH_Y,                    // centre Y (TBD)
            WALL + RPI_Z0 + RPI_ETH_Z,              // centre Z
            PORT_ETH_W,
            PORT_ETH_H
        );

        // ── RIGHT wall: USB-C power opening ─────────────────────
        // TBD — Y offset from RPi right-edge face. Currently approx.
        right_slot(
            _FAN_Y1 + RPI_USBC_Y,
            WALL + RPI_Z0 + RPI_USBC_Z,
            PORT_USBC_W,
            PORT_USBC_H
        );

        // ── RIGHT wall: micro-HDMI 0 opening ────────────────────
        right_slot(
            _FAN_Y1 + RPI_HMDI_Y,
            WALL + RPI_Z0 + RPI_HDMI0_Z,
            PORT_HDMI_W,
            PORT_HDMI_H
        );

        // ── RIGHT wall: micro-HDMI 1 opening ────────────────────
        right_slot(
            _FAN_Y1 + RPI_HMDI_Y,
            WALL + RPI_Z0 + RPI_HDMI1_Z,
            PORT_HDMI_W,
            PORT_HDMI_H
        );

        // ── RIGHT wall: microSD slot opening ────────────────────
        // RPi microSD is on the underside face of the RPi PCB which,
        // after rotation, faces the RIGHT wall.
        // PORT_SD_W (height in Z) × PORT_SD_H (depth in Y) — TBD.
        right_slot(
            _FAN_Y1 + RPI_T * 0.7,                 // Y approx (TBD)
            WALL + RPI_Z0 + RPI_SD_Z + PORT_SD_W/2, // Z centre (TBD)
            PORT_SD_H,                               // width in Y
            PORT_SD_W                                // height in Z
        );

        // ── TOP face: USB-A cable exit slot ─────────────────────
        // USB-A ports are on RPi's top (+Z) long edge.
        // Cables exit upward through this slot.
        // X centred on RPi X span.  TBD after physical measurement.
        top_slot(
            WALL + RPI_X0 + RPI_L / 2,             // centre X (TBD)
            _FAN_Y1 + RPI_T / 2,                   // centre Y (TBD)
            PORT_USBA_W,
            PORT_USBA_H
        );

        // ── Divider wall: wire pass-through hole ─────────────────
        // 8 mm dia hole for power wires (24V in / 5V out) between
        // buck cavity and main cavity.
        translate([OUTER_X/2, DIV_Y + WALL/2, OUTER_Z * 0.3])
            rotate([90, 0, 0])
                cylinder(d = 8, h = WALL + 0.2, $fn = 16);

        // ── Front face: M3 clearance holes for bezel screws ─────
        for (bx = BOSS_XS) for (bz = BOSS_ZS)
            translate([bx, -0.05, bz])
                rotate([-90, 0, 0])
                    cylinder(d = M3_CLEAR, h = WALL + 0.1, $fn = 16);

        // ── Rear face: M3 clearance holes for rear-panel screws ──
        for (bx = BOSS_XS) for (bz = BOSS_ZS)
            translate([bx, OUTER_Y - WALL - 0.05, bz])
                rotate([90, 0, 0])
                    cylinder(d = M3_CLEAR, h = WALL + 0.1, $fn = 16);

        // ── Bottom face: 4× M3 holes for bracket arm ─────────────
        // Spaced inward from corners; matches bracket arm bolt pattern.
        for (bx = BOSS_XS) {
            translate([bx, WALL + 10, -0.05])
                m3_thru(WALL);
            translate([bx, OUTER_Y - WALL - 10, -0.05])
                m3_thru(WALL);
        }
    }
}

enclosure();
