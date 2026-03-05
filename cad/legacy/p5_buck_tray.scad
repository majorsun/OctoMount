// ============================================================
// OctoMount — p5_buck_tray.scad
// LM2596 buck converter retention tray.
//
// The tray slides into the buck cavity and is screwed to the
// enclosure floor with 4× M3 screws.  The module is held by
// 2× M3 screws through the tray side walls (or snap tabs —
// snap version TBD after physical fit check).
//
// Print orientation: open face up (tray floor on build plate).
//
// Coordinate origin: outer left-front-bottom corner of tray.
//   X = left → right  (along BUCK_L)
//   Y = front → rear  (along BUCK_H)
//   Z = bottom → top  (along BUCK_W height)
// ============================================================
include <params.scad>

// ── Local parameters ─────────────────────────────────────────
TRAY_ID_X = BUCK_L + 2*CLR;   // inner length
TRAY_ID_Y = BUCK_H + 2*CLR;   // inner depth
TRAY_ID_Z = BUCK_W + CLR;     // inner height (open top)

TRAY_OD_X = TRAY_ID_X + 2*WALL;
TRAY_OD_Y = TRAY_ID_Y + 2*WALL;
TRAY_OD_Z = TRAY_ID_Z + WALL;  // floor + 3 walls + open top

// Mounting flange at bottom
FLANGE_T  = 3.0;    // flange thickness (same as WALL)
FLANGE_W  = 4.0;    // flange overhang each side

// Wire pass-through holes on short ends (for 24V in + 5V out wires)
WIRE_HOLE_D = 8.0;

// M3 side-wall clamp holes (hold module in tray — TBD if snap instead)
SIDE_HOLE_Z = TRAY_OD_Z / 2;  // mid-height
SIDE_HOLE_Y = TRAY_OD_Y / 2;  // mid-depth

// Flange M3 hole positions (corners of tray footprint)
FLG_OX = WALL + FLANGE_W / 2;
FLG_OY = WALL + FLANGE_W / 2;

module buck_tray() {
    difference() {
        union() {
            // ── Tray body (open-top channel) ─────────────────────
            cube([TRAY_OD_X, TRAY_OD_Y, TRAY_OD_Z]);

            // ── Mounting flanges (around base perimeter) ──────────
            translate([-FLANGE_W, -FLANGE_W, 0])
                cube([
                    TRAY_OD_X + 2*FLANGE_W,
                    TRAY_OD_Y + 2*FLANGE_W,
                    FLANGE_T
                ]);
        }

        // ── Inner channel cavity (open at top) ───────────────────
        translate([WALL, WALL, WALL])
            cube([TRAY_ID_X, TRAY_ID_Y, TRAY_ID_Z + 0.1]);

        // ── Wire pass-through: front short end ────────────────────
        translate([-0.05, TRAY_OD_Y/2, TRAY_OD_Z/2])
            rotate([0, 90, 0])
                cylinder(d = WIRE_HOLE_D, h = WALL + 0.1, $fn = 16);

        // ── Wire pass-through: rear short end ─────────────────────
        translate([TRAY_OD_X - WALL - 0.05, TRAY_OD_Y/2, TRAY_OD_Z/2])
            rotate([0, 90, 0])
                cylinder(d = WIRE_HOLE_D, h = WALL + 0.1, $fn = 16);

        // ── Side-wall M3 clamp holes (2× through Y walls) ─────────
        // Screws or nut+bolt clamp module into tray from both sides.
        // Front Y wall
        translate([TRAY_OD_X/2, -0.05, SIDE_HOLE_Z])
            rotate([-90, 0, 0])
                cylinder(d = M3_CLEAR, h = WALL + 0.1, $fn = 16);
        // Rear Y wall
        translate([TRAY_OD_X/2, TRAY_OD_Y - WALL - 0.05, SIDE_HOLE_Z])
            rotate([-90, 0, 0])
                cylinder(d = M3_CLEAR, h = WALL + 0.1, $fn = 16);

        // ── Flange M3 through-holes (mount tray to enclosure floor) ─
        for (fx = [FLG_OX, TRAY_OD_X + FLANGE_W - FLG_OX])
        for (fy = [FLG_OY, TRAY_OD_Y + FLANGE_W - FLG_OY])
            translate([fx - FLANGE_W, fy - FLANGE_W, -0.05])
                m3_thru(FLANGE_T);
    }
}

buck_tray();
