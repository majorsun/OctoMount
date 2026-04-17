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
    union() {
        difference() {
            _base_solid();
            _base_cuts();
        }
        // Front RPi bosses — tilted blind-hole boss with floor-flush base.
        // Hull of upright base disc + tilted cylinder fills the back-side gap
        // (where the tilted bottom circle lifts off the floor).
        // Intersection with z≥0 clips any front-side material below the floor bottom.
        let(_h0 = max(0.5, _BH_C + BOSS_YS[0] * sin(TILT_ANGLE)))
        for (bx = BOSS_XS)
            difference() {
                intersection() {
                    hull() {
                        // Upright base disc — anchors boss to floor, fills back gap
                        translate([bx, BOSS_YS[0], 0])
                            cylinder(r=M25_BOSS_R, h=BASE_OUTER_Z, $fn=32);
                        // Tilted boss cylinder
                        translate([bx, BOSS_YS[0], BASE_OUTER_Z])
                            rotate([TILT_ANGLE, 0, 0])
                                cylinder(r=M25_BOSS_R, h=_h0, $fn=32);
                    }
                    // Clip: no material below z=0 (floor bottom)
                    translate([bx - M25_BOSS_R - 1, BOSS_YS[0] - M25_BOSS_R - 1, 0])
                        cube([2*(M25_BOSS_R+1), 2*(M25_BOSS_R+1), MAX_OUTER_Z]);
                }
                // Blind tap hole at boss tip (tilted frame)
                translate([bx, BOSS_YS[0], BASE_OUTER_Z])
                    rotate([TILT_ANGLE, 0, 0])
                        translate([0, 0, _h0 - M25_BOSS_DEPTH])
                            cylinder(d=M25_CLEAR, h=M25_BOSS_DEPTH + 0.1, $fn=16);
            }
    }
}

// ── Solid geometry ────────────────────────────────────────────
module _base_solid() {
    // Floor slab — extended FRONT_EXT toward viewer (-Y)
    translate([0, -FRONT_EXT, 0])
        rbox([OUTER_X, OUTER_Y + FRONT_EXT, BASE_OUTER_Z]);

    // Left side wall — angled from front to _LCD_WIN_BACK_Y, then flat to back.
    // Three-point hull: slope = tan(TILT_ANGLE) up to the flat-top junction,
    // then constant MAX_OUTER_Z height to the back wall.
    hull() {
        translate([0, -FRONT_EXT, 0])
            cube([WALL_S, 0.01, COVER_FRONT_Z + BASE_OUTER_Z - FRONT_EXT * tan(TILT_ANGLE)]);
        translate([0, _LCD_WIN_BACK_Y - 0.01, 0])
            cube([WALL_S, 0.01, MAX_OUTER_Z]);
        translate([0, OUTER_Y - 0.01, 0])
            cube([WALL_S, 0.01, MAX_OUTER_Z]);
    }

    // Right side wall — mirror of left
    translate([OUTER_X - WALL_S, 0, 0])
    hull() {
        translate([0, -FRONT_EXT, 0])
            cube([WALL_S, 0.01, COVER_FRONT_Z + BASE_OUTER_Z - FRONT_EXT * tan(TILT_ANGLE)]);
        translate([0, _LCD_WIN_BACK_Y - 0.01, 0])
            cube([WALL_S, 0.01, MAX_OUTER_Z]);
        translate([0, OUTER_Y - 0.01, 0])
            cube([WALL_S, 0.01, MAX_OUTER_Z]);
    }

    // Back wall = mounting plate — single wall at Y = OUTER_Y − WALL_S .. OUTER_Y
    translate([0, OUTER_Y - WALL_S, 0])
        cube([OUTER_X, WALL_S, BKWALL_H]);               // back wall, shortened by cover slab thickness
    translate([PLATE_X0, OUTER_Y - WALL_S, 0])
        cube([PLATE_W, WALL_S, PLATE_H]);                // mounting plate extension (same Y, wider)

    // Extra 2 mm interior thickness on back wall: left side → left edge of bottom window.
    // Brings total thickness to WALL_S+2 in that region; the 2 mm counterbore for M5 heads sits here.
    translate([0, OUTER_Y - WALL_S - 2, 0])
        cube([BKWALL_WIN2_X0, 2, max(BKWALL_H, PLATE_H)]);

    // Front RPi bosses rendered in base() union.

    // Back RPi boss pads + triangular support ribs (replaces full-width connecting plate).
    // Two separate pads — one per back boss — each 2×M25_BOSS_R wide.
    // Below each pad: a triangular rib whose tip is the pad front-bottom edge and whose
    // base is a vertical strip at the back wall from BASE_OUTER_Z up to the pad-bottom face.
    // Rib 4: trapezoidal wedge on right side (BKWALL_WIN2 right edge → right boss outer edge).
    let(_by = BOSS_YS[1],
        _hb = _BH_C + BOSS_YS[1] * sin(TILT_ANGLE),
        _ts = max(WALL, M25_BOSS_DEPTH),
        _D  = (OUTER_Y - WALL_S - _by + (_hb - _ts) * sin(TILT_ANGLE)) / cos(TILT_ANGLE) + M25_BOSS_R,
        _x0 = BOSS_XS[0] - M25_BOSS_R,
        _x1 = BOSS_XS[1] + M25_BOSS_R,
        _pz = BASE_OUTER_Z + (_hb - _ts) / cos(TILT_ANGLE),
        _pz_back  = _pz + (OUTER_Y - WALL_S - _by) * tan(TILT_ANGLE),
        _rib_y0   = _by - M25_BOSS_R * cos(TILT_ANGLE) - (_hb - _ts) * sin(TILT_ANGLE),
        _pz_front = _pz + (_rib_y0 - _by) * tan(TILT_ANGLE)) {

        for (bx = BOSS_XS) {
            // Tilted mounting pad for this boss (same frame as old plate, narrowed to boss width)
            translate([bx - M25_BOSS_R, _by, BASE_OUTER_Z])
                rotate([TILT_ANGLE, 0, 0])
                    translate([0, -M25_BOSS_R, _hb - _ts])
                        cube([2*M25_BOSS_R, _D, _ts]);

            // Triangular support rib:
            //   tip  — front-bottom edge of pad (world Y=_rib_y0, Z=_pz_front)
            //   base — vertical strip at back wall from floor to pad-bottom (Z=BASE_OUTER_Z.._pz_back)
            hull() {
                translate([bx - M25_BOSS_R, _rib_y0, _pz_front])
                    cube([2*M25_BOSS_R, 0.01, 0.01]);
                translate([bx - M25_BOSS_R, OUTER_Y - WALL_S - 0.01, BASE_OUTER_Z])
                    cube([2*M25_BOSS_R, 0.01, _pz_back - BASE_OUTER_Z + 0.01]);
            }
        }

        // Rib 4 — narrow triangular rib (WALL_S wide) at right boss outer edge.
        hull() {
            translate([_x1 - WALL_S, _rib_y0, _pz_front])
                cube([WALL_S, 0.01, 0.01]);
            translate([_x1 - WALL_S, OUTER_Y - WALL_S - 0.01, BASE_OUTER_Z])
                cube([WALL_S, 0.01, _pz_back - BASE_OUTER_Z + 0.01]);
        }
    }

    // Buck converter M3 floor bosses — 4-post pattern, vertical from base slab.
    // PCB rests on boss tops; screw from above through PCB into tapped boss.
    for (bx = [BUCK_FLOOR_X1, BUCK_FLOOR_X2], by = [BUCK_FLOOR_Y1, BUCK_FLOOR_Y2])
        translate([bx, by, BASE_OUTER_Z])
            m3_boss(BUCK_FLOOR_H);

}

// ── Subtractive cuts ──────────────────────────────────────────
module _base_cuts() {
    // ── Right wall: ventilation grill (round holes on regular grid) ────
    // Main grid: 9 columns × 5 rows.
    for (vy = [VENT_Y0 : VENT_HOLE_PITCH : VENT_Y1],
         vz = [VENT_Z0 + VENT_HOLE_R : VENT_HOLE_PITCH : VENT_Z1 - VENT_HOLE_R])
        translate([OUTER_X - WALL_S - 0.05, vy, vz])
            rotate([0, 90, 0])
                cylinder(r=VENT_HOLE_R, h=WALL_S + 0.1, $fn=24);
    // Front columns: 4 holes each (top row omitted — wall too short there).
    for (vy = [VENT_Y0 - VENT_HOLE_PITCH, VENT_Y0 - 2*VENT_HOLE_PITCH],
         vz = [VENT_Z0 + VENT_HOLE_R : VENT_HOLE_PITCH : VENT_Z1 - VENT_HOLE_PITCH - VENT_HOLE_R])
        translate([OUTER_X - WALL_S - 0.05, vy, vz])
            rotate([0, 90, 0])
                cylinder(r=VENT_HOLE_R, h=WALL_S + 0.1, $fn=24);

    // ── Left wall: single combined USB-A + Ethernet window, tilted with RPi PCB ────
    // Window is defined in the same tilted frame as the bosses:
    //   bottom (local Z = _h0) aligns with the RPi PCB bare-bottom face
    //   top    (local Z = _h0 + RPI_T) clears the tallest port connector
    //   local Y span covers both ETH and USB-A port extents
    // _ly_min / _ly_max convert world port edges → boss-frame local Y.
    // PORT_WIN_OFS shifts the window toward the back of the enclosure (+Y).
    let(_h0     = max(0.5, _BH_C + BOSS_YS[0] * sin(TILT_ANGLE)),
        _port_ofs = 6.0,                            // shift window backward — adjust once ports measured
        _w_ylo  = WALL + RPI_Y0 + _port_ofs,        // port window front edge (world Y)
        _w_yhi  = WALL + RPI_Y0 + RPI_Y + _port_ofs, // port window back edge (world Y)
        _ly_min = (_w_ylo - BOSS_YS[0] + _h0 * sin(TILT_ANGLE)) / cos(TILT_ANGLE),
        _ly_max = (_w_yhi - BOSS_YS[0] + _h0 * sin(TILT_ANGLE)) / cos(TILT_ANGLE))
    translate([-0.05, BOSS_YS[0], BASE_OUTER_Z])
        rotate([TILT_ANGLE, 0, 0])
            translate([0, _ly_min, _h0])
                cube([WALL_S + 0.1, _ly_max - _ly_min, RPI_T + 0.1]);

    // ── Left wall: SD slot notch (bottom flush with inside floor) ────────────────────
    _sd_cy = SD_CY;
    translate([-0.05, _sd_cy - SD_W/2, BASE_OUTER_Z])
        cube([WALL_S + 0.1, SD_W, SD_H + 0.1]);

    // ── Base floor: two M2 screw holes for SD card holder ─────────────────────────
    // Evenly flanking slot centre at Y = _sd_cy ± SD_SCREW_SPAN/2; X = SD_SCREW_X.
    for (sy = [_sd_cy - SD_SCREW_SPAN/2, _sd_cy + SD_SCREW_SPAN/2])
        translate([SD_SCREW_X, sy, -0.05])
            cylinder(d=SD_SCREW_D, h=BASE_OUTER_Z + 0.1, $fn=16);

    // ── M5 clearance holes through back wall / mounting plate ──
    for (h = [MOUNT_H1, MOUNT_H2])
        translate([PLATE_X0 + h[0], OUTER_Y - WALL_S, h[1]])
            rotate([-90, 0, 0])
                translate([0, 0, -0.05])
                    cylinder(d=M5_CLEAR, h=WALL_S + 0.1, $fn=16);

    // ── M5 counterbores — 2 mm deep on interior face of thickened wall section ──
    // Counterbore covers the extra 2 mm; existing clearance hole covers the original WALL_S.
    for (h = [MOUNT_H1, MOUNT_H2])
        translate([PLATE_X0 + h[0], OUTER_Y - WALL_S - 2, h[1]])
            rotate([-90, 0, 0])
                translate([0, 0, -0.05])
                    cylinder(d=M5_CS_D, h=M5_CS_H + 0.05, $fn=24);

    // ── Back wall: combined USB-A + microSD cable routing window ──
    // Right zone of main back wall; X = 97.7..126.5 mm; Z = 21..30 mm.
    translate([BKWALL_WIN_X0 - 0.05, OUTER_Y - WALL_S - 0.05, BKWALL_WIN_ZLO])
        cube([BKWALL_WIN_W + 0.1, WALL_S + 0.1, BKWALL_WIN_ZHI - BKWALL_WIN_ZLO]);

    // ── Back wall: second window (15×15 mm) — lower-left wiring access ──
    // Left edge 10 mm right of MOUNT_H2 centre; bottom at exterior floor (Z=0).
    translate([BKWALL_WIN2_X0 - 0.05, OUTER_Y - WALL_S - 0.05, BKWALL_WIN2_ZLO - 0.05])
        cube([BKWALL_WIN2_W + 0.1, WALL_S + 0.1, BKWALL_WIN2_ZHI - BKWALL_WIN2_ZLO + 0.1]);

    // ── Rear top edge rounding on side walls ──
    // R = distance from hinge axle centre to the (Y=OUTER_Y, Z=MAX_OUTER_Z) corner.
    // corner_cut = quadrant_cube − quadrant_cylinder (both on hinge axle).
    // Subtracting corner_cut rounds the corner with arc centred on the hinge axle.
    let(_dy = OUTER_Y - BHINGE_Y,
        _dz = MAX_OUTER_Z - BHINGE_WZ,
        _R  = sqrt(_dy*_dy + _dz*_dz)) {
        // Left wall
        difference() {
            translate([-0.05, BHINGE_Y, BHINGE_WZ])
                cube([WALL_S + 0.1, _dy + 1, _dz + 1]);
            translate([-0.05, BHINGE_Y, BHINGE_WZ])
                rotate([0, 90, 0])
                    cylinder(r=_R, h=WALL_S + 0.1, $fn=64);
        }
        // Right wall
        difference() {
            translate([OUTER_X - WALL_S - 0.05, BHINGE_Y, BHINGE_WZ])
                cube([WALL_S + 0.1, _dy + 1, _dz + 1]);
            translate([OUTER_X - WALL_S - 0.05, BHINGE_Y, BHINGE_WZ])
                rotate([0, 90, 0])
                    cylinder(r=_R, h=WALL_S + 0.1, $fn=64);
        }
    }

    // ── Rear top edge rounding on side walls ──
    // corner_cut = quadrant_cube − quadrant_cylinder, both centred at (OUTER_Y−r, MAX_OUTER_Z−r).
    // Subtracting corner_cut from the solid rounds the convex rear-top edge with radius r.
    // Left wall
    difference() {
        translate([-0.05, OUTER_Y - REAR_CORNER_R, MAX_OUTER_Z - REAR_CORNER_R])
            cube([WALL_S + 0.1, REAR_CORNER_R + 1, REAR_CORNER_R + 1]);
        translate([-0.05, OUTER_Y - REAR_CORNER_R, MAX_OUTER_Z - REAR_CORNER_R])
            rotate([0, 90, 0])
                cylinder(r=REAR_CORNER_R, h=WALL_S + 0.1, $fn=32);
    }
    // Right wall
    difference() {
        translate([OUTER_X - WALL_S - 0.05, OUTER_Y - REAR_CORNER_R, MAX_OUTER_Z - REAR_CORNER_R])
            cube([WALL_S + 0.1, REAR_CORNER_R + 1, REAR_CORNER_R + 1]);
        translate([OUTER_X - WALL_S - 0.05, OUTER_Y - REAR_CORNER_R, MAX_OUTER_Z - REAR_CORNER_R])
            rotate([0, 90, 0])
                cylinder(r=REAR_CORNER_R, h=WALL_S + 0.1, $fn=32);
    }

    // ── Pin-hinge through-holes in side walls ──
    translate([-0.05, BHINGE_Y, BHINGE_WZ])
        rotate([0, 90, 0])
            cylinder(r=BHINGE_R + BHINGE_CLR, h=WALL_S + 0.1, $fn=32);
    translate([OUTER_X - WALL_S - 0.05, BHINGE_Y, BHINGE_WZ])
        rotate([0, 90, 0])
            cylinder(r=BHINGE_R + BHINGE_CLR, h=WALL_S + 0.1, $fn=32);

    // M3 tap holes are already inside m3_boss() — no separate cut needed.

    // ── M2.5 tap holes in back plate (RPi rear mounting holes) ──
    // Same tilted-frame position as the former rpi_back_block boss tips.
    for (bx = BOSS_XS)
        translate([bx, BOSS_YS[1], BASE_OUTER_Z])
            rotate([TILT_ANGLE, 0, 0])
                translate([0, 0, _BH_C + BOSS_YS[1] * sin(TILT_ANGLE) - M25_BOSS_DEPTH])
                    cylinder(d=M25_CLEAR, h=M25_BOSS_DEPTH + 0.1, $fn=16);
}
