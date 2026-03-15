// ============================================================
// OctoMount — base.scad  (2-piece redesign, rev 6)
//
// OUTER_X = 145 mm (left wall at panel left edge; right wall at panel right edge).
// Right of RPi (X ≈ 96.8..142 mm) is the LM2596 buck converter zone (45 mm clear).
//
// The Base provides all enclosure walls plus the mounting bracket:
//   • Left + right side walls — tapered to match cover tilt angle
//   • Back wall + mounting plate — SAME WALL (fused, no arm-shelf gap)
//                                  Full enclosure height on enclosure span;
//                                  PLATE_H tall on PLATE_W mounting span.
//                                  M5 holes through back face into 4040 beam.
//   • Thin floor slab         — 4 mm
//   • Full-size SD slot       — notch in left wall
//   • USB-C entry slot        — notch in right wall (24V power input)
//   • M2.5 RPi mounting bosses  — 4 posts, tilted ⟂ to cover face, height varies with Y
//
// Side + back walls moved here from cover.scad (rev 6).
// The cover provides only the front wall + angled top slab.
//
// Wall heights from Z = 0:
//   Front edge:  COVER_FRONT_Z + BASE_OUTER_Z
//   Back edge:   MAX_OUTER_Z
//
// Print orientation: right-side up (back wall down, front face open).
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
    // Floor slab
    rbox([OUTER_X, OUTER_Y, BASE_OUTER_Z]);

    // Left side wall — tapered (short at front, tall at back)
    hull() {
        cube([WALL, 0.01, COVER_FRONT_Z + BASE_OUTER_Z]);
        translate([0, OUTER_Y - 0.01, 0])
            cube([WALL, 0.01, MAX_OUTER_Z]);
    }

    // Right side wall — mirror of left
    translate([OUTER_X - WALL, 0, 0])
    hull() {
        cube([WALL, 0.01, COVER_FRONT_Z + BASE_OUTER_Z]);
        translate([0, OUTER_Y - 0.01, 0])
            cube([WALL, 0.01, MAX_OUTER_Z]);
    }

    // Back wall = mounting plate — single wall at Y = OUTER_Y − WALL .. OUTER_Y
    translate([0, OUTER_Y - WALL, 0])
        cube([OUTER_X, WALL, MAX_OUTER_Z]);            // back wall, full enclosure height
    translate([PLATE_X0, OUTER_Y - WALL, 0])
        cube([PLATE_W, WALL, PLATE_H]);                // mounting plate extension (same Y, wider)

    // Front RPi bosses (BOSS_YS[0]) — cylinder posts from floor, perpendicular to RPi face.
    for (bx = BOSS_XS)
        translate([bx, BOSS_YS[0], BASE_OUTER_Z])
            rotate([TILT_ANGLE, 0, 0])
                rpi_boss(_BH_C + BOSS_YS[0] * sin(TILT_ANGLE));

    // Back RPi bosses (BOSS_YS[1]) — cube blocks fused to back wall, top face at RPi mounting plane.
    for (bx = BOSS_XS)
        translate([bx, BOSS_YS[1], BASE_OUTER_Z])
            rotate([TILT_ANGLE, 0, 0])
                rpi_back_block(_BH_C + BOSS_YS[1] * sin(TILT_ANGLE), BOSS_YS[1]);

    // Buck converter M3 bosses — horizontal posts from right side wall inner face.
    // Boss points in −X (inward); tapped end at PCB mounting hole; screw from interior.
    for (by = [BUCK_BOSS_Y1, BUCK_BOSS_Y2])
        translate([OUTER_X - WALL, by, BUCK_BOSS_Z])
            rotate([0, -90, 0])
                m3_boss(BUCK_BOSS_L);
}

// ── Subtractive cuts ──────────────────────────────────────────
module _base_cuts() {
    // ── Right wall: USB-C power entry (PORT_USBC_H tall notch) ───
    // 24V power cable enters from 4040 T-slot channel → buck on floor.
    _usbc_yz = OUTER_Y - 2*WALL;
    translate([OUTER_X - 0.05, _usbc_yz - PORT_USBC_W/2, -0.05])
        cube([WALL + 0.1, PORT_USBC_W, PORT_USBC_H + 0.1]);

    // ── Left wall: full-size SD slot (SD_H tall notch, starts above floor slab) ────────
    _sd_cy = OUTER_Y / 2;
    translate([-0.05, _sd_cy - SD_W/2, BASE_OUTER_Z])
        cube([WALL + 0.1, SD_W, SD_H + 0.1]);

    // ── M5 countersunk holes through back wall / mounting plate ──
    // Counterbore opens on the INSIDE face (Y = OUTER_Y − WALL); screw head recessed from inside.
    for (h = [MOUNT_H1, MOUNT_H2])
        translate([PLATE_X0 + h[0], OUTER_Y - WALL, h[1]])
            rotate([-90, 0, 0])
                m5_thru(WALL);

    // ── Back wall: USB-A cable routing slot ──────────────────────
    // Left zone of main back wall (X ≈ 18.5..34.5 mm); Z = 24..30 mm.
    translate([BKWALL_USB_X0 - 0.05, OUTER_Y - WALL - 0.05, BKWALL_USB_ZLO])
        cube([BKWALL_USB_W + 0.1, WALL + 0.1, BKWALL_USB_ZHI - BKWALL_USB_ZLO]);

    // ── Back wall: microSD extension cable routing slot ───────────
    // Left zone of main back wall (X ≈ 38.3..47.3 mm); Z = 21..30 mm.
    translate([BKWALL_SD_X0 - 0.05, OUTER_Y - WALL - 0.05, BKWALL_SD_ZLO])
        cube([BKWALL_SD_W + 0.1, WALL + 0.1, BKWALL_SD_ZHI - BKWALL_SD_ZLO]);

    // M3 tap holes are already inside m3_boss() — no separate cut needed.
}
