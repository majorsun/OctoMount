// ============================================================
// OctoMount — base.scad  (2-piece redesign, rev 5)
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

    // M2.5 RPi mounting bosses — h = _BH_C + by·sin θ  (see params.scad for derivation).
    // Boss base Y is offset from hole world_y so the tilted tip lands on the PCB bare-bottom.
    for (bx = BOSS_XS, by = BOSS_YS)
        translate([bx, by, BASE_OUTER_Z])
            rotate([TILT_ANGLE, 0, 0])
                rpi_boss(_BH_C + by * sin(TILT_ANGLE));
}

// ── Subtractive cuts ──────────────────────────────────────────
module _base_cuts() {
    // ── Right wall: USB-C power entry (PORT_USBC_H tall notch) ───
    // 24V power cable enters from 4040 T-slot channel → buck on floor.
    _usbc_yz = OUTER_Y - 2*WALL;
    translate([OUTER_X - 0.05, _usbc_yz - PORT_USBC_W/2, -0.05])
        cube([WALL + 0.1, PORT_USBC_W, PORT_USBC_H + 0.1]);

    // ── Left wall: full-size SD slot (SD_H tall notch) ────────
    _sd_cy = OUTER_Y / 2;
    translate([-0.05, _sd_cy - SD_W/2, -0.05])
        cube([WALL + 0.1, SD_W, SD_H + 0.1]);

    // ── M5 countersunk holes through back wall / mounting plate ──
    for (h = [MOUNT_H1, MOUNT_H2])
        translate([PLATE_X0 + h[0], OUTER_Y, h[1]])
            rotate([90, 0, 0])
                m5_thru(WALL);

    // M3 tap holes are already inside m3_boss() — no separate cut needed.
}
