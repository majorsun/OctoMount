// ============================================================
// OctoMount — base.scad  (2-piece redesign, rev 2)
//
// The Base is a thin wiring/SD slab (BASE_OUTER_Z = 10 mm).
// RPi + LCD assembly has moved to the Cover.
//
//   • Mounting plate  — bolts to 4040 beam end face via 2× M5
//   • Arm shelf       — extends forward from plate, cable gap
//   • Thin open-top tray — floor + 4 walls for wiring & buck
//   • Full-size SD slot  — left wall
//   • USB-C entry slot   — right wall bottom corner (24V power input)
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
    // Thin enclosure tray (floor + 4 walls, open top)
    difference() {
        rbox([OUTER_X, OUTER_Y, BASE_OUTER_Z]);
        // hollow interior — +1 opens the top
        translate([WALL, WALL, WALL])
            cube([INNER_X, INNER_Y, BASE_OUTER_Z - WALL + 1]);
    }

    // Arm shelf: extends from enclosure rear face (Y=OUTER_Y) by ARM_L
    translate([0, OUTER_Y, 0])
        cube([OUTER_X, ARM_L, ARM_THICK]);

    // Mounting plate: left-aligned to 4040 beam face (PLATE_X0)
    translate([PLATE_X0, OUTER_Y + ARM_L, 0])
        cube([PLATE_W, WALL, PLATE_H]);

    // M3 cover-attachment bosses on top rim (4 corners)
    for (bx = BOSS_XS, by = BOSS_YS)
        translate([bx, by, BASE_OUTER_Z])
            m3_boss(BOSS_H);
}

// ── Subtractive cuts ──────────────────────────────────────────
module _base_cuts() {
    // ── Right wall: USB-C power entry (bottom-right corner) ───
    // 24V power cable enters from 4040 T-slot channel → buck on floor.
    _usbc_yz = OUTER_Y - 2*WALL;
    translate([OUTER_X - 0.05, _usbc_yz - PORT_USBC_W/2, WALL])
        cube([WALL + 0.1, PORT_USBC_W, PORT_USBC_H]);

    // ── Left wall: full-size SD slot ──────────────────────────
    _sd_cy = OUTER_Y / 2;
    _sd_cz = WALL + SD_H/2 + 2;   // just above floor
    translate([-0.05, _sd_cy - SD_W/2, _sd_cz - SD_H/2])
        cube([WALL + 0.1, SD_W, SD_H]);

    // ── M5 countersunk holes through mounting plate ───────────
    _plate_y = OUTER_Y + ARM_L;
    for (h = [MOUNT_H1, MOUNT_H2])
        translate([PLATE_X0 + h[0], _plate_y + WALL, h[1]])
            rotate([90, 0, 0])
                m5_thru(WALL);

    // ── M3 tapped holes in cover-attachment bosses ────────────
    for (bx = BOSS_XS, by = BOSS_YS)
        translate([bx, by, BASE_OUTER_Z + BOSS_H - M3_BOSS_DEPTH])
            cylinder(d=M3_TAP, h=M3_BOSS_DEPTH+0.1, $fn=16);
}
