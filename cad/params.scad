// ============================================================
// OctoMount — params.scad
// All hardware dimensions, design parameters, derived values,
// and shared utility modules.
//
// Items marked "TBD" must be confirmed against physical hardware
// before a final print. All dimensions in millimetres.
// ============================================================

// ── Fastener dimensions ──────────────────────────────────────
M3_CLEAR      = 3.4;   // M3 clearance hole diameter
M3_TAP        = 2.5;   // M3 tap/thread hole diameter (PETG self-tap)
M3_CS_D       = 6.0;   // M3 countersink outer diameter
M3_CS_H       = 2.0;   // M3 countersink depth
M3_BOSS_R     = 4.0;   // M3 boss outer radius
M3_BOSS_DEPTH = 6.0;   // M3 blind tapped-hole depth in boss

M25_CLEAR     = 2.7;   // M2.5 clearance hole (RPi mounting holes)
M25_BOSS_R    = 3.5;   // M2.5 boss outer radius
M25_BOSS_DEPTH= 5.0;   // M2.5 blind hole depth

// ── Raspberry Pi 4B ──────────────────────────────────────────
// Enclosure orientation after 90° rotation (display faces operator):
//   X = left-right (RPi PCB length),  Z = up-down (RPi PCB width)
//   Y = front-back (RPi PCB thickness + heatsinks, toward LCD)
//
//   GPIO long edge  → BOTTOM of enclosure (-Z edge)
//   USB-A long edge → TOP    of enclosure (+Z edge)
//   USB-C / HDMI short edge → RIGHT side (+X)
//   Ethernet short edge     → LEFT side  (-X)

RPI_L    = 85.0;   // PCB length (along X in enclosure)
RPI_W    = 56.0;   // PCB width  (along Z in enclosure)
RPI_PCB_T = 1.6;   // bare PCB thickness
RPI_T    = 17.0;   // total RPi depth including heatsinks (along Y) — TBD

// RPi mounting hole pattern (M2.5): 58 × 49 mm, offset from edges
RPI_HOLE_X  = 58.0;   // hole spacing in X
RPI_HOLE_Z  = 49.0;   // hole spacing in Z
RPI_HOLE_OX =  3.5;   // X offset from RPi left edge to nearest column
RPI_HOLE_OZ =  3.5;   // Z offset from RPi bottom (GPIO) edge to nearest row

// Port positions on RPi — ALL TBD, measured from RPi PCB edges
// (will be refined in first print iteration)
RPI_ETH_Z    = 28.0;   // Ethernet centre Z from RPi GPIO-edge (left wall)
RPI_ETH_Y    =  7.0;   // Ethernet centre Y offset from RPi rear face (TBD)
RPI_USBC_Z   = 38.0;   // USB-C centre Z from RPi GPIO-edge (right wall, TBD)
RPI_USBC_Y   =  5.0;   // USB-C centre Y offset from RPi right-edge face (TBD)
RPI_HDMI0_Z  = 26.0;   // micro-HDMI 0 centre Z (right wall, TBD)
RPI_HDMI1_Z  = 14.0;   // micro-HDMI 1 centre Z (right wall, TBD)
RPI_HMDI_Y   =  8.0;   // HDMI centre Y from right-edge face (TBD)
RPI_SD_Z     =  2.0;   // microSD slot centre Z from GPIO-edge (right wall, TBD)
RPI_USBA_Z   = 48.0;   // USB-A stack centre Z from GPIO-edge (top face, TBD)

// Port opening sizes — TBD, oversized initially for clearance
PORT_ETH_W   = 20.0;   PORT_ETH_H  = 15.0;  // Ethernet
PORT_USBC_W  = 11.0;   PORT_USBC_H =  7.0;  // USB-C
PORT_HDMI_W  = 11.0;   PORT_HDMI_H =  7.0;  // micro-HDMI
PORT_SD_W    =  4.5;   PORT_SD_H   = 14.0;  // microSD
PORT_USBA_W  = 32.0;   PORT_USBA_H = 16.0;  // USB-A top exit slot

// ── MPI4008 4″ LCD (LCDwiki Display-C) ───────────────────────
LCD_PCB_X  = 98.0;   // LCD PCB width  (X in enclosure) — TBD
LCD_PCB_Z  = 60.0;   // LCD PCB height (Z in enclosure) — TBD
LCD_T      =  5.0;   // LCD module thickness glass-to-PCB (Y)  — TBD
LCD_ACT_X  = 87.7;   // active display area width  (confirmed)
LCD_ACT_Z  = 52.2;   // active display area height (confirmed)
LCD_BEZEL_X = (LCD_PCB_X - LCD_ACT_X) / 2;  // border each side in X
LCD_BEZEL_Z = (LCD_PCB_Z - LCD_ACT_Z) / 2;  // border each side in Z

// ── Fan (integrated in MPI4008 sandwich gap) ─────────────────
FAN_SIZE = 30.0;   // fan square side — TBD (measure physical unit)
FAN_T    =  7.0;   // fan body thickness — TBD
FAN_GAP  = 12.0;   // total Y space reserved between LCD and RPi for fan

// ── Buck converter LM2596 ─────────────────────────────────────
BUCK_L   = 50.0;   // PCB length (X in enclosure) — TBD
BUCK_H   = 27.0;   // PCB depth  (Y in tray, front-to-back) — TBD
BUCK_W   = 16.0;   // PCB + component height (Z in tray) — TBD

// ── Stylus ────────────────────────────────────────────────────
STYLUS_D    =  9.0;   // stylus outer diameter — TBD
STYLUS_GRIP = 40.0;   // clip engagement length — TBD

// ── Full-size SD slot (extension cable) ──────────────────────
SD_SLOT_W = 32.0;   // slot opening width — TBD
SD_SLOT_H =  4.5;   // slot opening height — TBD

// ── Design parameters ─────────────────────────────────────────
WALL     = 3.0;   // shell wall thickness
CLR      = 1.0;   // per-side assembly clearance
CORNER_R = 3.0;   // outer shell corner rounding radius
TILT     = 15;    // bracket arm tilt toward operator (degrees)
$fn      = 0;     // set per-call below; 0 = use $fa/$fs defaults
$fa      = 3;
$fs      = 0.5;

// ── Internal Z clearances ─────────────────────────────────────
RPI_FLOOR_CLR = 5.0;    // clearance below RPi GPIO edge (inner floor to PCB)
RPI_TOP_CLR   = 14.0;   // clearance above RPi USB-A edge (PCB to inner ceiling)

// ── Derived inner cavity dimensions ───────────────────────────
INNER_X = LCD_PCB_X + 2*CLR;              // = 100 mm  (LCD drives width)
INNER_Z = RPI_W + RPI_FLOOR_CLR + RPI_TOP_CLR;  // =  75 mm

// ── RPi XZ position within inner cavity ──────────────────────
// RPi is pushed to the LEFT inner wall so Ethernet (left short edge)
// is accessible through the left shell wall.
RPI_X0 = CLR;           // 1 mm from inner left face
RPI_Z0 = RPI_FLOOR_CLR; // 5 mm above inner floor (GPIO edge at bottom)

// ── LCD XZ position within inner cavity ──────────────────────
LCD_X0 = (INNER_X - LCD_PCB_X) / 2;   // = 1 mm from inner left face
LCD_Z0 = (INNER_Z - LCD_PCB_Z) / 2;   // = 7.5 mm above inner floor

// ── Y section layout (absolute from outer front face) ─────────
//
//  Y=0              outer front face
//  Y=WALL           inner front face / start of LCD pocket
//  Y=_LCD_Y1        rear of LCD pocket
//  Y=_FAN_Y1        rear of fan gap = front face of RPi
//  Y=_RPI_Y1        rear face of RPi (heatsink side)
//  Y=_DIV_FACE      front face of internal divider wall
//  Y=_DIV_FACE+WALL rear face of divider wall = front of buck cavity
//  Y=_BUCK_Y1       rear of buck cavity
//  Y=OUTER_Y        outer rear face

_LCD_Y1    = WALL + LCD_T + CLR;
_FAN_Y1    = _LCD_Y1 + FAN_GAP;
_RPI_Y1    = _FAN_Y1 + RPI_T;
_DIV_FACE  = _RPI_Y1 + CLR;          // front face of divider wall
_BUCK_Y0   = _DIV_FACE + WALL;       // front of buck cavity (= divider rear)
_BUCK_Y1   = _BUCK_Y0 + BUCK_H + 2*CLR;
OUTER_Y    = _BUCK_Y1 + WALL;        // total outer enclosure depth

// Expose named Y references for part files
FRONT_Y  = WALL;           // Y of inner front face
DIV_Y    = _DIV_FACE;      // Y of divider front face
BUCK_Y   = _BUCK_Y0;       // Y start of buck cavity
REAR_Y   = _BUCK_Y1;       // Y end of buck cavity (start of rear wall)
RPI_Y0   = _FAN_Y1;        // Y of RPi front face (heatsink faces front)

// ── Derived outer box dimensions ──────────────────────────────
OUTER_X = INNER_X + 2*WALL;   // = 106 mm
OUTER_Z = INNER_Z + 2*WALL;   // =  81 mm  ← EXCEEDS LIMIT (see below)

// ── Hard height limit ─────────────────────────────────────────
// The Ender 3 Pro bed assembly allows at most 48 mm of vertical
// clearance at the mount location.  OUTER_Z must not exceed this.
// The 2-piece redesign must mount the RPi FLAT (85×56 mm footprint
// in XY, PCB thickness ~17 mm in Z) to achieve OUTER_Z ≤ 48 mm.
// The current 5-piece layout (RPi on-edge, OUTER_Z = 81 mm) is
// superseded.  This assert will pass once params are updated for
// the 2-piece redesign.
MAX_OUTER_Z = 48.0;
assert(OUTER_Z <= MAX_OUTER_Z,
    str("OUTER_Z ", OUTER_Z, " mm exceeds bed clearance limit of ",
        MAX_OUTER_Z, " mm — RPi must be mounted flat in the 2-piece redesign"));

// ── Standoff dimensions ───────────────────────────────────────
STOFF_OD = 6.0;   // standoff outer diameter
STOFF_H  = RPI_T - 2*CLR;  // standoff height = RPi depth minus clearance

// ── Bezel ─────────────────────────────────────────────────────
BEZEL_D      = WALL + 2.0;   // total bezel depth (overlaps front face)
BEZEL_BORDER = 8.0;          // border frame width around display cutout

// ── Rear-panel hex vent ───────────────────────────────────────
HEX_CIRC_R = 3.5;   // hex cell circumradius
HEX_WALL   = 1.5;   // hex cell wall thickness
HEX_PITCH  = (HEX_CIRC_R + HEX_WALL) * 2;  // centre-to-centre spacing

// ── Mounting bracket (front-plate + arm shelf) ────────────────
// The plate bolts to the Ender 3 Pro control box front panel via
// 2× M5 flat-head screws (diagonal) into the 4040 beam end face.
// The arm shelf extends horizontally under the full enclosure depth.
//
// Total forward depth from control box face:
//   WALL (plate) + ARM_L (cable gap) + OUTER_Y (enclosure) ≈ 95 mm

PLATE_W    = 145.0;  // plate width  (matches control box front panel)
PLATE_H    =  40.0;  // plate height (= 4040 beam cross-section, 40 mm)

// M5 fasteners: 2× flat-head screws, diagonal into 4040 end face
M5_CLEAR   =   5.5;  // M5 clearance hole diameter
M5_CS_D    =   9.5;  // M5 countersink outer diameter (matches 4040 beam spec)
M5_CS_H    =   2.0;  // M5 countersink depth (flat-head sits flush in WALL)

// Hole positions [X, Z-from-plate-bottom] — top-left and bottom-right
// corners of the 4040 beam end face (40×40 mm zone at plate left edge)
MOUNT_H1   = [10.0, 30.0];   // top-left:     X=10, Z=PLATE_H-10 = 30
MOUNT_H2   = [30.0, 10.0];   // bottom-right: X=30, Z=10

// SD card slot on arm left face (microSD extension from control box)
// Card inserts from left (+X); card width 24 mm in Y, thickness in Z.
CTRL_SD_W  = 26.0;   // slot opening width  (card width + clearance, Y dir) — TBD
CTRL_SD_H  =  3.5;   // slot opening height (card thickness + clearance, Z dir) — TBD
SD_POCKET  = 34.0;   // slot pocket depth into arm (+X direction)

// Arm shelf dimensions
ARM_L      = 15.0;   // cable-gap: plate front face → enclosure rear face
ARM_W      = OUTER_X;  // arm width = enclosure width (left-aligned, = 106 mm)
ARM_THICK  =  8.0;   // arm shelf thickness (Z)

// ── Boss screw corner positions (shared by enclosure + bezel + rear panel) ──
// 4 corner bosses at these absolute (X, Z) positions on front/rear faces
BOSS_XS = [CORNER_R + M3_BOSS_R + 1, OUTER_X - CORNER_R - M3_BOSS_R - 1];
BOSS_ZS = [CORNER_R + M3_BOSS_R + 1, OUTER_Z - CORNER_R - M3_BOSS_R - 1];

// ── Utility modules ───────────────────────────────────────────

// Rounded-vertical-edge box: X×Y footprint with CORNER_R rounding,
// straight vertical edges, flat top and bottom.
// sz = [x, y, z],  r = corner radius
module rbox(sz, r = CORNER_R) {
    hull() {
        for (xi = [r, sz[0] - r])
        for (yi = [r, sz[1] - r])
            translate([xi, yi, 0])
                cylinder(r = r, h = sz[2], $fn = 32);
    }
}

// M2.5 standoff boss: solid cylinder with blind tapped hole at TOP.
// h = total height,  hole_d = tap diameter.
// Hole opens at Z=h (top).  Mount with hole facing the screw entry side.
module rpi_boss(h = STOFF_H, hole_d = M25_CLEAR) {
    difference() {
        cylinder(r = M25_BOSS_R, h = h, $fn = 32);
        translate([0, 0, h - M25_BOSS_DEPTH])
            cylinder(d = hole_d, h = M25_BOSS_DEPTH + 0.1, $fn = 16);
    }
}

// M3 boss: solid cylinder with blind tapped hole at TOP.
// h = total height.  Hole opens at Z=h.
module boss(h, hole_d = M3_TAP) {
    difference() {
        cylinder(r = M3_BOSS_R, h = h, $fn = 32);
        translate([0, 0, h - M3_BOSS_DEPTH])
            cylinder(d = hole_d, h = M3_BOSS_DEPTH + 0.1, $fn = 16);
    }
}

// M3 through-hole with countersink on the Z=0 face (use inside difference()).
// depth = material thickness the hole passes through.
module m3_thru(depth = WALL) {
    translate([0, 0, -0.05]) {
        cylinder(d = M3_CLEAR, h = depth + 0.1, $fn = 16);
        cylinder(d = M3_CS_D,  h = M3_CS_H + 0.05, $fn = 32);
    }
}

// Single regular hexagon (flat-to-flat = HEX_CIRC_R * sqrt(3)) for vent pattern.
module hex_cell(r = HEX_CIRC_R, depth = WALL + 0.2) {
    cylinder(r = r, h = depth, $fn = 6);
}
