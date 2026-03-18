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
        cube([OUTER_X, WALL, BKWALL_H]);               // back wall, shortened by cover slab thickness
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

    // Back-boss connecting plate + ribs.
    // Plate: same tilted frame as rpi_back_block, spans full X range of both bosses.
    // Ribs: world-space vertical fins from base floor to plate bottom.
    //   Rib 1 — between M5 holes (MOUNT_H1[0]=10, MOUNT_H2[0]=30), 3.75 mm clear of each.
    //   Rib 2 — right of BKWALL_WIN2 right edge (X=BKWALL_WIN2_X0+BKWALL_WIN2_W), WALL clear.
    let(_by = BOSS_YS[1],
        _hb = _BH_C + BOSS_YS[1] * sin(TILT_ANGLE),
        _ts = max(WALL, M25_BOSS_DEPTH),
        _D  = (OUTER_Y - WALL - BOSS_YS[1]) / cos(TILT_ANGLE) + WALL + M25_BOSS_R,
        _x0 = BOSS_XS[0] - M25_BOSS_R,
        _x1 = BOSS_XS[1] + M25_BOSS_R,
        _pz = BASE_OUTER_Z + (_hb - _ts) * cos(TILT_ANGLE)) {  // plate bottom world Z

        translate([_x0, _by, BASE_OUTER_Z])
            rotate([TILT_ANGLE, 0, 0])
                translate([0, -M25_BOSS_R, _hb - _ts])
                    cube([_x1 - _x0, _D, _ts]);

        translate([(MOUNT_H1[0] + MOUNT_H2[0]) / 2 - WALL/2, _by, 0])
            cube([WALL, OUTER_Y - WALL - _by, _pz]);

        translate([BKWALL_WIN2_X0 + BKWALL_WIN2_W + WALL, _by, 0])
            cube([WALL, OUTER_Y - WALL - _by, _pz]);
    }

    // Buck converter M3 floor bosses — 4-post pattern, vertical from base slab.
    // PCB rests on boss tops; screw from above through PCB into tapped boss.
    for (bx = [BUCK_FLOOR_X1, BUCK_FLOOR_X2], by = [BUCK_FLOOR_Y1, BUCK_FLOOR_Y2])
        translate([bx, by, BASE_OUTER_Z])
            m3_boss(BUCK_FLOOR_H);

    // LCD PCB corner brackets (floating — support to be added later).
    _lcd_pcb_brackets();
}

// ── LCD PCB corner brackets ───────────────────────────────────
// L-shaped brackets at all four corners of the LCD PCB board.
// Same transform chain as the LCD ghost in assembly.scad.
// Bracket walls sit on the OUTSIDE of each PCB edge and run along it.
// Height spans the PCB layer (CLR_ABOVE_RPI+LCD_PANEL_T .. CLR_ABOVE_RPI+LCD_T).
//
// Canonical bracket is for the (+X, +Y) corner (inside corner at origin);
// mirror([1,0,0]) and mirror([0,1,0]) adapt it to the other three corners.
module _lcd_corner_bracket() {
    _t = LCD_BRACKET_T;
    _w = LCD_BRACKET_W;
    _h = LCD_T - LCD_PANEL_T;   // PCB layer thickness
    _g = LCD_BRACKET_GAP;       // clearance from bracket wall inner face to PCB edge
    // Wall along X edge — shifted outward by gap from PCB +Y edge
    translate([-_w, _g, 0]) cube([_w + _t, _t, _h]);
    // Wall along Y edge — shifted outward by gap from PCB +X edge
    translate([_g, -_w, 0]) cube([_t, _w, _h]);
    // Floor ledge — extended to reach under both shifted walls
    translate([-_w, -_w, _h]) cube([_w + _t + _g, _w + _t + _g, _t]);
}

module _lcd_pcb_brackets() {
    _lx  = WALL + RPI_X0 + RPI_X/2 + LCD_OFS_X;
    _ly  = WALL + RPI_Y0 + RPI_Y/2 + LCD_OFS_Y;
    _wz  = WALL / cos(TILT_ANGLE);
    _lfz = COVER_FRONT_Z - _wz + _ly * tan(TILT_ANGLE);  // inner face Z at LCD Y
    _t   = LCD_BRACKET_T;

    translate([0, 0, BASE_OUTER_Z]) {
        translate([_lx, _ly, _lfz])
            rotate([180 + TILT_ANGLE, 0, 0]) {
                // Corner brackets
                for (sx = [-1, 1], sy = [-1, 1])
                    translate([sx * LCD_PCB_X/2,
                               sy * LCD_PCB_SL/2,
                               CLR_ABOVE_RPI + LCD_PANEL_T])
                        mirror([sx < 0 ? 1 : 0, 0, 0])
                        mirror([0, sy < 0 ? 1 : 0, 0])
                            _lcd_corner_bracket();

                // Left rail — floor ledge from left wall to PCB left edge,
                // Y spans outer face of −Y wall to outer face of +Y wall.
                let(_bx0 = WALL - _lx, _bw = _lx - WALL - LCD_PCB_X/2,
                    _h = LCD_T - LCD_PANEL_T) {
                    translate([_bx0, -LCD_PCB_SL/2 - _t, CLR_ABOVE_RPI + LCD_T])
                        cube([_bw, LCD_PCB_SL + 2*_t, _t]);
                    // Two triangular ribs — right-triangle profile in XZ plane,
                    // tall at left wall, tapering to zero at PCB edge.
                    let(_sin_t = sin(TILT_ANGLE), _cos_t = cos(TILT_ANGLE),
                        _z_top = CLR_ABOVE_RPI + LCD_T + _t)
                        for (ry = [-LCD_PCB_SL/6, LCD_PCB_SL/6])
                            let(_z_floor = (_lfz - ry * _sin_t) / _cos_t)
                            hull() {
                                // Tall face at left wall
                                translate([_bx0, ry - _t/2, _z_top])
                                    cube([0.01, _t, _z_floor - _z_top]);
                                // Zero-height edge at PCB left edge
                                translate([-LCD_PCB_X/2 - 0.01, ry - _t/2, _z_top])
                                    cube([0.01, _t, 0.01]);
                            }
                }

                // Right rail — joins right two floor ledges along Y
                translate([LCD_PCB_X/2, -LCD_PCB_SL/2,
                           CLR_ABOVE_RPI + LCD_T])
                    cube([_t, LCD_PCB_SL, _t]);

                // Front-right floor ledge extension — connects bracket to moved front post.
                // Spans from new post inner face (local X) to PCB right ledge outer edge.
                let(_w = LCD_BRACKET_W,
                    _px_new = OUTER_X - WALL - BUCK_WALL_GAP - BUCK_X - CLR - (_w + _t))
                    translate([_px_new - _lx, LCD_PCB_SL/2 - _w, CLR_ABOVE_RPI + LCD_T])
                        cube([LCD_PCB_X/2 + _t - (_px_new - _lx), _w + _t, _t]);

            }

        // Front right post — moved left to clear RPi right edge and buck converter.
        // Post right edge = buck left edge − CLR; post left edge clears RPi right edge.
        let(_sin_t = sin(TILT_ANGLE), _cos_t = cos(TILT_ANGLE),
            _zc    = CLR_ABOVE_RPI + LCD_T,
            _w     = LCD_BRACKET_W,
            _px_new = OUTER_X - WALL - BUCK_WALL_GAP - BUCK_X - CLR - (_w + _t),
            _wy    = _ly - LCD_PCB_SL/2 * _cos_t + _zc * _sin_t,
            _wz    = _lfz - LCD_PCB_SL/2 * _sin_t - _zc * _cos_t,
            _ty    = _wy - _t)
            translate([_px_new, _ty, 0])
                cube([_w + _t, _w + _t, _wz]);

        // Back-wall bridge — replaces removed back right post.
        // Horizontal beam from outer face of back-right bracket corner to inner back wall.
        // Z: above cable window (BKWALL_WIN_ZHI) to top of back wall (BKWALL_H).
        let(_cos_t = cos(TILT_ANGLE), _sin_t = sin(TILT_ANGLE),
            _w      = LCD_BRACKET_W,
            _zc     = CLR_ABOVE_RPI + LCD_T,
            _yl_out = -(LCD_PCB_SL/2 + _t),                      // outer local Y of back-right bracket
            _bry    = _ly - _yl_out * _cos_t + _zc * _sin_t,     // world Y of bracket outer face
            _brx    = _lx + LCD_PCB_X/2 - _w)                    // inner X (= old back post inner X)
            translate([_brx, _bry, BKWALL_WIN_ZHI])
                cube([_w + _t, OUTER_Y - WALL - _bry, BKWALL_H - BKWALL_WIN_ZHI]);
    }
}

// ── Subtractive cuts ──────────────────────────────────────────
module _base_cuts() {
    // ── Right wall: USB-C power entry (PORT_USBC_H tall notch) ───
    // 24V power cable enters from 4040 T-slot channel → buck on floor.
    _usbc_yz = OUTER_Y - 2*WALL;
    translate([OUTER_X - 0.05, _usbc_yz - PORT_USBC_W/2, -0.05])
        cube([WALL + 0.1, PORT_USBC_W, PORT_USBC_H + 0.1]);

    // ── Left wall: SD slot notch (bottom flush with inside floor) ────────────────────
    _sd_cy = SD_CY;
    translate([-0.05, _sd_cy - SD_W/2, BASE_OUTER_Z])
        cube([WALL + 0.1, SD_W, SD_H + 0.1]);

    // ── Base floor: two M2 screw holes for SD card holder ─────────────────────────
    // Evenly flanking slot centre at Y = _sd_cy ± SD_SCREW_SPAN/2; X = SD_SCREW_X.
    for (sy = [_sd_cy - SD_SCREW_SPAN/2, _sd_cy + SD_SCREW_SPAN/2])
        translate([SD_SCREW_X, sy, -0.05])
            cylinder(d=SD_SCREW_D, h=BASE_OUTER_Z + 0.1, $fn=16);

    // ── M5 countersunk holes through back wall / mounting plate ──
    // Counterbore opens on the INSIDE face (Y = OUTER_Y − WALL); screw head recessed from inside.
    for (h = [MOUNT_H1, MOUNT_H2])
        translate([PLATE_X0 + h[0], OUTER_Y - WALL, h[1]])
            rotate([-90, 0, 0])
                m5_thru(WALL);

    // ── Back wall: combined USB-A + microSD cable routing window ──
    // Right zone of main back wall; X = 97.7..126.5 mm; Z = 21..30 mm.
    translate([BKWALL_WIN_X0 - 0.05, OUTER_Y - WALL - 0.05, BKWALL_WIN_ZLO])
        cube([BKWALL_WIN_W + 0.1, WALL + 0.1, BKWALL_WIN_ZHI - BKWALL_WIN_ZLO]);

    // ── Back wall: second window (15×15 mm) — lower-left wiring access ──
    // Left edge 10 mm right of MOUNT_H2 centre; bottom at exterior floor (Z=0).
    translate([BKWALL_WIN2_X0 - 0.05, OUTER_Y - WALL - 0.05, BKWALL_WIN2_ZLO - 0.05])
        cube([BKWALL_WIN2_W + 0.1, WALL + 0.1, BKWALL_WIN2_ZHI - BKWALL_WIN2_ZLO + 0.1]);

    // ── Ball-hinge sockets (hemisphere bowls in inner faces of side walls) ──
    // Centre at the inner face — matches the cover ball centre exactly.
    // Socket radius = BHINGE_R + BHINGE_CLR (slight clearance for rotation).
    // The sphere subtraction carves a hemisphere bowl; the half extending into
    // the enclosure interior is in air and has no effect.
    translate([WALL,          BHINGE_Y, BHINGE_WZ])
        sphere(r = BHINGE_R + BHINGE_CLR, $fn=32);
    translate([OUTER_X-WALL,  BHINGE_Y, BHINGE_WZ])
        sphere(r = BHINGE_R + BHINGE_CLR, $fn=32);

    // M3 tap holes are already inside m3_boss() — no separate cut needed.
}
