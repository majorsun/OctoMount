// ============================================================
// OctoMount — params.scad  (2-piece redesign)
// All hardware dimensions, design parameters, derived values,
// and shared utility modules.
//
// RPi 4B orientation: FLAT
//   X = RPi short axis (56 mm) — left/right in enclosure
//   Y = RPi long  axis (85 mm) — front/back in enclosure
//   Z = RPi stack height       — up/down, constrained to ≤ 48 mm total
//
//   USB-A / Ethernet short edge → BACK  wall (+Y face)
//   USB-C / HDMI    short edge → FRONT wall (-Y face, internal pigtails)
//   GPIO long edge             → LEFT  wall (-X face)
//
// Items marked "TBD" must be measured before a final print.
// All dimensions in millimetres.
// ============================================================

// ── Fasteners ────────────────────────────────────────────────
M3_CLEAR       = 3.4;    // M3 clearance hole diameter
M3_TAP         = 2.5;    // M3 tap diameter (PETG self-tap)
M3_CS_D        = 6.0;    // M3 flat-head countersink outer diameter
M3_CS_H        = 2.0;    // M3 countersink depth
M3_BOSS_R      = 4.0;    // M3 boss outer radius
M3_BOSS_DEPTH  = 6.0;    // M3 blind tapped-hole depth

M25_CLEAR      = 2.7;    // M2.5 clearance hole (RPi mounting)
M25_BOSS_R     = 3.5;    // M2.5 boss outer radius
M25_BOSS_DEPTH = 5.0;    // M2.5 blind hole depth

M5_CLEAR  = 5.5;   // M5 clearance hole (4040 beam mount)
M5_CS_D   = 9.5;   // M5 flat-head countersink OD (matches 4040 spec)
M5_CS_H   = 2.0;   // M5 countersink depth

// ── Shell ─────────────────────────────────────────────────────
WALL     = 3.0;   // nominal wall thickness
CLR      = 1.0;   // per-side assembly clearance
CORNER_R = 3.0;   // outer corner rounding radius
$fa = 3;  $fs = 0.5;

// ── Raspberry Pi 4B (flat orientation) ───────────────────────
RPI_X    = 56.0;   // PCB short axis → enclosure X
RPI_Y    = 85.0;   // PCB long  axis → enclosure Y
RPI_T    = 22.0;   // PCB + heatsinks height → enclosure Z  — TBD (measure)
RPI_PCB_T =  1.6;  // bare PCB thickness

// Mounting holes: 49 mm spacing in X, 58 mm spacing in Y
// (short-axis spacing in X, long-axis spacing in Y)
RPI_HOLE_DX  = 49.0;   // hole-to-hole in X
RPI_HOLE_DY  = 58.0;   // hole-to-hole in Y
RPI_HOLE_OX  =  3.5;   // offset from RPi -X edge to nearest hole column
RPI_HOLE_OY  =  3.5;   // offset from RPi -Y edge (front) to nearest hole row

// Port positions on RPi (from RPi -Y edge = front edge of PCB) — TBD
// USB-A stack exits through back wall; USB-C/HDMI exit front via pigtails.
PORT_USBA_X   = 28.0;   // USB-A stack centre X from RPi -X edge — TBD
PORT_USBA_W   = 32.0;   // USB-A opening width (X)
PORT_USBA_H   = 16.0;   // USB-A opening height (Z)
PORT_USBC_X   = 36.0;   // USB-C centre X from RPi -X edge — TBD
PORT_USBC_W   = 11.0;   // USB-C opening width
PORT_USBC_H   =  7.0;   // USB-C opening height
PORT_ETH_X    =  9.0;   // Ethernet centre X from RPi -X edge — TBD
PORT_ETH_W    = 20.0;   // Ethernet opening width
PORT_ETH_H    = 16.0;   // Ethernet opening height

// ── MPI4008 4″ LCD ────────────────────────────────────────────
LCD_PCB_X  = 98.0;    // LCD PCB width  (along enclosure X) — TBD
LCD_PCB_SL = 60.0;    // LCD PCB height along the angled face slope — TBD
LCD_T      =  5.0;    // LCD module thickness (perpendicular to face) — TBD
LCD_ACT_X  = 87.7;    // active area width  (confirmed)
LCD_ACT_SL = 52.2;    // active area height along slope (confirmed)

// ── Fan (in MPI4008 kit sandwich) ────────────────────────────
FAN_SIZE = 30.0;   // fan square side — TBD
FAN_T    =  7.0;   // fan thickness  — TBD

// ── Buck converter LM2596 ─────────────────────────────────────
BUCK_X   = 23.0;   // PCB width in enclosure X direction — TBD
BUCK_Y   = 48.0;   // PCB depth in enclosure Y direction — TBD
BUCK_Z   = 14.0;   // PCB + component height in Z        — TBD

// ── Full-size SD slot (extension cable, left wall) ───────────
SD_W = 32.0;   // slot opening width in Y — TBD
SD_H =  4.5;   // slot opening height in Z — TBD
SD_POCKET = 34.0;  // card insertion depth in X (+X direction)

// ── Base inner cavity ─────────────────────────────────────────
// X: LCD PCB (98) is wider than RPi (56) → LCD drives INNER_X
INNER_X = LCD_PCB_X + 2*CLR;              // = 100 mm
// Y: RPi long axis (85) + front/rear clearance
INNER_Y = RPI_Y + 2*CLR;                  // = 87 mm
// Z: standoff height + RPi stack + clearance above
STOFF_H       = 5.0;     // RPi standoff height
CLR_ABOVE_RPI = 2.0;     // clearance above RPi heatsinks
BASE_INNER_Z  = STOFF_H + RPI_T + CLR_ABOVE_RPI;  // = 29 mm (TBD)

// ── RPi position within inner cavity ─────────────────────────
// RPi centred in X (LCD also centred → they share X centre)
RPI_X0 = (INNER_X - RPI_X) / 2;   // X offset of RPi -X edge from inner wall
RPI_Y0 = CLR;                      // Y offset of RPi front edge from inner front wall
// Standoff base sits on floor; RPi PCB at Z = STOFF_H

// ── Buck position within inner cavity ────────────────────────
// Buck beside RPi in X: RPi ends at RPI_X0+RPI_X; buck starts after CLR
BUCK_X0 = RPI_X0 + RPI_X + CLR;   // X start of buck (≈ 24 mm from inner wall)
BUCK_Y0 = CLR;                     // flush front with RPi (same Y zone)
// Buck sits on floor: BUCK_Z0 = 0 (relative to inner floor)
// Verify: BUCK_X0 + BUCK_X ≤ INNER_X
// = (100-56)/2 + 56 + 1 + 23 = 22+56+1+23 = 102 mm > 100 mm  ← tight, TBD

// ── Outer base dimensions ─────────────────────────────────────
OUTER_X      = INNER_X + 2*WALL;         // = 106 mm
OUTER_Y      = INNER_Y + 2*WALL;         // =  93 mm
BASE_OUTER_Z = WALL + BASE_INNER_Z;      // =  32 mm (open top, no lid wall)

// ── Height limit & cover geometry ────────────────────────────
MAX_OUTER_Z    = 48.0;    // hard clearance limit from bed assembly
COVER_BACK_Z   = MAX_OUTER_Z - BASE_OUTER_Z;  // = 16 mm
COVER_FRONT_Z  = WALL;                         // =  3 mm (front lip of cover)
// Tilt angle of LCD face from horizontal:
//   atan((COVER_BACK_Z - COVER_FRONT_Z) / OUTER_Y)
//   = atan(13 / 93) ≈ 7.9°  (LCD faces mostly upward, tilted toward operator)
echo(str("LCD tilt from horizontal: ",
         atan((COVER_BACK_Z - COVER_FRONT_Z) / OUTER_Y), "°"));

// ── Mounting bracket (plate + arm shelf) ─────────────────────
PLATE_W   = 145.0;   // plate width  (matches control box front panel)
PLATE_H   =  40.0;   // plate height (= 4040 cross-section)
ARM_L     =  15.0;   // cable gap: plate front → enclosure rear face
ARM_THICK =   8.0;   // arm shelf Z thickness

// M5 flat-head screws into 4040 beam end face
MOUNT_H1  = [10.0, 30.0];   // top-left hole  [X, Z-from-plate-bottom]
MOUNT_H2  = [30.0, 10.0];   // bottom-right hole

// ── Cover attachment bosses (4 corners of base top face) ──────
// Bosses sit on the base top rim, screws come down from inside cover.
BOSS_XS = [CORNER_R + M3_BOSS_R + 1,  OUTER_X - CORNER_R - M3_BOSS_R - 1];
BOSS_YS = [CORNER_R + M3_BOSS_R + 1,  OUTER_Y - CORNER_R - M3_BOSS_R - 1];
BOSS_H  = 6.0;   // boss height above base top rim

// ── Utility modules ───────────────────────────────────────────

// Rounded-corner box: X×Y footprint with CORNER_R on vertical edges.
module rbox(sz, r = CORNER_R) {
    hull()
        for (xi = [r, sz[0]-r], yi = [r, sz[1]-r])
            translate([xi, yi, 0])
                cylinder(r=r, h=sz[2], $fn=32);
}

// M2.5 standoff boss: solid cylinder, blind tapped hole on top.
module rpi_boss(h = STOFF_H) {
    difference() {
        cylinder(r=M25_BOSS_R, h=h, $fn=32);
        translate([0, 0, h - M25_BOSS_DEPTH])
            cylinder(d=M25_CLEAR, h=M25_BOSS_DEPTH+0.1, $fn=16);
    }
}

// M3 boss: solid cylinder, blind tapped hole on top.
module m3_boss(h) {
    difference() {
        cylinder(r=M3_BOSS_R, h=h, $fn=32);
        translate([0, 0, h - M3_BOSS_DEPTH])
            cylinder(d=M3_TAP, h=M3_BOSS_DEPTH+0.1, $fn=16);
    }
}

// M3 countersunk through-hole (use inside difference()).
module m3_thru(depth = WALL) {
    translate([0,0,-0.05]) {
        cylinder(d=M3_CLEAR, h=depth+0.1, $fn=16);
        cylinder(d=M3_CS_D,  h=M3_CS_H+0.05, $fn=32);
    }
}

// M5 countersunk through-hole for bracket plate.
module m5_thru(depth = WALL) {
    translate([0,0,-0.05]) {
        cylinder(d=M5_CLEAR, h=depth+0.1, $fn=16);
        cylinder(d=M5_CS_D,  h=M5_CS_H+0.05, $fn=32);
    }
}
