// ============================================================
// OctoMount — p4_rear_panel.scad
// Rear panel: vent honeycomb + voltmeter window.
//
// The panel screws into the enclosure rear-face bosses via
// 4× M3 screws.  A 1.5 mm step lip around the perimeter
// seats into the rear opening for positive location.
//
// Print orientation: outside face down for surface quality.
//
// Coordinate origin: outer left-bottom corner of panel.
//   X = left → right  (= enclosure OUTER_X)
//   Y = 0 → WALL      (panel thickness, Y=0 = outer visible face)
//   Z = bottom → top  (= enclosure OUTER_Z)
// ============================================================
include <params.scad>

// ── Local parameters ─────────────────────────────────────────
PANEL_X  = OUTER_X;
PANEL_Z  = OUTER_Z;
PANEL_T  = WALL;       // panel plate thickness

LIP_STEP = 1.5;        // lip step height (seats into rear opening recess)
LIP_T    = 1.5;        // lip wall thickness

// Vent field: centred in Y (main cavity area, avoiding buck region)
// Buck cavity occupies approx Z = WALL to WALL+BUCK_W,
// so vent centred in the main cavity Z span.
VENT_CX  = PANEL_X / 2;
VENT_CZ  = WALL + INNER_Z / 2;    // vertically centred
VENT_W   = INNER_X - 4;           // vent field width  (2 mm margin each side)
VENT_H   = INNER_Z * 0.55;        // vent field height (~55% of inner height)

// Voltmeter window (small rectangle to see buck LED through panel)
// Positioned in the buck section area (lower Z).  TBD position.
VOLT_W   = 20.0;   // window width  — TBD
VOLT_H   =  8.0;   // window height — TBD
VOLT_CX  = PANEL_X / 2;
VOLT_CZ  = WALL + BUCK_W/2 + 2;   // approx over buck module (TBD)

module rear_panel() {
    difference() {
        union() {
            // ── Main panel plate ────────────────────────────────
            cube([PANEL_X, PANEL_T, PANEL_Z]);

            // ── Location lip ────────────────────────────────────
            // Protrudes +Y from inner face and seats into rear opening.
            translate([CLR + LIP_T, PANEL_T - 0.01, CLR + LIP_T])
                cube([
                    PANEL_X - 2*(CLR + LIP_T),
                    LIP_STEP + 0.01,
                    PANEL_Z - 2*(CLR + LIP_T)
                ]);
        }

        // ── Hex vent cutouts ────────────────────────────────────
        // Honeycomb grid centred at (VENT_CX, VENT_CZ).
        // Two interleaved rows (standard hex packing).
        vent_field(VENT_CX, VENT_CZ, VENT_W, VENT_H);

        // ── Voltmeter window ────────────────────────────────────
        translate([VOLT_CX - VOLT_W/2, -0.05, VOLT_CZ - VOLT_H/2])
            cube([VOLT_W, PANEL_T + 0.1, VOLT_H]);

        // ── 4× M3 countersunk through-holes at corners ──────────
        // Screws pass from outside (Y=0) and thread into enclosure bosses.
        for (bx = BOSS_XS) for (bz = BOSS_ZS)
            translate([bx, 0, bz])
                rotate([-90, 0, 0])
                    m3_thru(PANEL_T);
    }
}

// ── Hex vent field ────────────────────────────────────────────
// cx, cz = centre of vent field on the panel face
// fw, fh = total field width and height
module vent_field(cx, cz, fw, fh) {
    p   = HEX_PITCH;                    // centre-to-centre = (r + wall) * 2
    row_h = p * sin(60);                // row vertical pitch

    // Half-extents for iteration
    cols = ceil(fw / p / 2) + 1;
    rows = ceil(fh / row_h / 2) + 1;

    for (row = [-rows : rows])
    for (col = [-cols : cols]) {
        // Every other row is offset by half a pitch (hex packing)
        x_off = col * p + (abs(row) % 2 == 0 ? 0 : p/2);
        z_off = row * row_h;
        tx = cx + x_off;
        tz = cz + z_off;
        // Clip to field boundary
        if (tx >= cx - fw/2 + HEX_CIRC_R && tx <= cx + fw/2 - HEX_CIRC_R &&
            tz >= cz - fh/2 + HEX_CIRC_R && tz <= cz + fh/2 - HEX_CIRC_R)
            translate([tx, -0.05, tz])
                rotate([90, 0, 0])
                    hex_cell(HEX_CIRC_R, PANEL_T + 0.1);
    }
}

rear_panel();
