// ============================================================
// OctoMount — base.scad  (2-piece redesign)
//
// The Base is a single printed part combining:
//   • Mounting plate  — bolts to 4040 beam end face via 2× M5
//   • Arm shelf       — extends forward from plate, RPi sits on it
//   • Enclosure tray  — open-top box: floor + 4 walls
//   • RPi standoff bosses  — 4× M2.5, raise RPi off floor
//   • Full-size SD slot    — left wall, fed from microSD extension
//   • USB-A port opening   — back wall (to Ender mainboard)
//   • USB-C entry slot     — right wall bottom-right corner
//   • Buck converter pocket — beside RPi in X, open top for wiring
//   • M3 cover-attachment bosses — 4 corners of top rim
//
// Print orientation: right-side up (plate at back, open top).
// Material: PETG.
// ============================================================
include <params.scad>

base();

module base() {
    difference() {
        _base_solid();
        _base_cuts();
    }
}

// ── Solid geometry ────────────────────────────────────────────
module _base_solid() {
    // Enclosure tray (floor + 4 walls, open top)
    difference() {
        rbox([OUTER_X, OUTER_Y, BASE_OUTER_Z]);
        // hollow interior
        translate([WALL, WALL, WALL])
            cube([INNER_X, INNER_Y, BASE_INNER_Z + 1]);  // +1 opens the top
    }

    // Arm shelf: extends from enclosure rear face (Y=OUTER_Y) further back
    // by ARM_L, then the mounting plate is at the far end.
    // Shelf runs full X width of enclosure, thickness = ARM_THICK.
    translate([0, OUTER_Y, 0])
        cube([OUTER_X, ARM_L, ARM_THICK]);

    // Mounting plate: vertical plate at Y = OUTER_Y + ARM_L
    // Height = PLATE_H, width = PLATE_W, thickness = WALL
    // Centred in X relative to the enclosure
    _plate_x0 = PLATE_X0;
    translate([_plate_x0, OUTER_Y + ARM_L, 0])
        cube([PLATE_W, WALL, PLATE_H]);

    // RPi standoff bosses (4 corners of hole pattern)
    // RPi -X edge at: WALL + RPI_X0
    // RPi -Y edge at: WALL + RPI_Y0
    _rpi_ox = WALL + RPI_X0;
    _rpi_oy = WALL + RPI_Y0;
    for (dx = [RPI_HOLE_OX, RPI_HOLE_OX + RPI_HOLE_DX])
    for (dy = [RPI_HOLE_OY, RPI_HOLE_OY + RPI_HOLE_DY])
        translate([_rpi_ox + dx, _rpi_oy + dy, WALL])
            rpi_boss(STOFF_H);

    // M3 cover-attachment bosses on top rim (4 corners)
    for (bx = BOSS_XS, by = BOSS_YS)
        translate([bx, by, BASE_OUTER_Z])
            m3_boss(BOSS_H);
}

// ── Subtractive cuts ──────────────────────────────────────────
module _base_cuts() {
    // ── Back wall: USB-A opening ──────────────────────────────
    // Centred over RPi USB-A port (RPi centred in X → port ~centred too)
    _usba_cx = WALL + RPI_X0 + PORT_USBA_X;
    _usba_cz = WALL + STOFF_H + RPI_T/2;   // approximate centre height — TBD
    translate([_usba_cx - PORT_USBA_W/2, OUTER_Y - 0.05, _usba_cz - PORT_USBA_H/2])
        cube([PORT_USBA_W, WALL + 0.1, PORT_USBA_H]);

    // ── Back wall: Ethernet opening ───────────────────────────
    _eth_cx = WALL + RPI_X0 + PORT_ETH_X;
    _eth_cz = WALL + STOFF_H + RPI_T/2 - 2;   // Ethernet slightly lower — TBD
    translate([_eth_cx - PORT_ETH_W/2, OUTER_Y - 0.05, _eth_cz - PORT_ETH_H/2])
        cube([PORT_ETH_W, WALL + 0.1, PORT_ETH_H]);

    // ── Right wall: USB-C entry slot (bottom-right corner) ────
    // Cable enters from the 4040 beam T-slot channel at right-bottom.
    // Opening: right wall (X=OUTER_X), near the floor, toward the back.
    _usbc_yz = OUTER_Y - 2*WALL;   // near the back, above the arm shelf zone
    translate([OUTER_X - 0.05, _usbc_yz - PORT_USBC_W/2, WALL])
        cube([WALL + 0.1, PORT_USBC_W, PORT_USBC_H]);

    // ── Left wall: full-size SD slot ──────────────────────────
    // Centred in Y, near the floor (operator inserts card from left).
    _sd_cy = OUTER_Y / 2;
    _sd_cz = WALL + SD_H/2 + 2;   // just above floor
    translate([-0.05, _sd_cy - SD_W/2, _sd_cz - SD_H/2])
        cube([WALL + 0.1, SD_W, SD_H]);

    // ── M5 countersunk holes through mounting plate ───────────
    _plate_x0 = PLATE_X0;
    _plate_y  = OUTER_Y + ARM_L;
    for (h = [MOUNT_H1, MOUNT_H2])
        translate([_plate_x0 + h[0], _plate_y + WALL, h[1]])
            rotate([90, 0, 0])
                m5_thru(WALL);

    // ── M2.5 clearance holes through RPi standoff bosses ──────
    _rpi_ox = WALL + RPI_X0;
    _rpi_oy = WALL + RPI_Y0;
    for (dx = [RPI_HOLE_OX, RPI_HOLE_OX + RPI_HOLE_DX])
    for (dy = [RPI_HOLE_OY, RPI_HOLE_OY + RPI_HOLE_DY])
        translate([_rpi_ox + dx, _rpi_oy + dy, WALL])
            cylinder(d=M25_CLEAR, h=STOFF_H+0.1, $fn=16);

    // ── M3 clearance holes through cover bosses ───────────────
    for (bx = BOSS_XS, by = BOSS_YS)
        translate([bx, by, BASE_OUTER_Z + BOSS_H - M3_BOSS_DEPTH])
            cylinder(d=M3_TAP, h=M3_BOSS_DEPTH+0.1, $fn=16);
}
