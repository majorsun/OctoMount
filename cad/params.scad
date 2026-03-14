// ============================================================
// OctoMount — params.scad  (2-piece redesign)
// All hardware dimensions, design parameters, derived values,
// and shared utility modules.
//
// RPi 4B orientation: FLAT
//   X = RPi short axis (56 mm) — left/right in enclosure
//   Y = RPi long  axis (85 mm) — front/back in enclosure
//   Z = RPi stack height       — up/down, total outer height ≤ 52 mm
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
M25_BOSS_DEPTH = 3.0;    // M2.5 blind hole depth (≤ STOFF_H)

M5_CLEAR  = 5.5;   // M5 clearance hole (4040 beam mount)
M5_CS_D   = 9.5;   // M5 flat-head countersink OD (matches 4040 spec)
M5_CS_H   = 2.0;   // M5 countersink depth

// ── Shell ─────────────────────────────────────────────────────
WALL     = 3.0;   // nominal wall thickness
CLR      = 1.0;   // per-side assembly clearance
CORNER_R = 3.0;   // outer corner rounding radius
$fa = 3;  $fs = 0.5;

// ── Raspberry Pi 4B (rotated 90° CW in enclosure — long axis along X) ──────
// Reference: Pi-4-Physical-size.jpg
//   USB-A Z=16.0mm, ETH Z=13.5mm, USB-C Z=6.0mm, microHDMI Z=3.0mm (all from PCB top)
// RPi long edge (85mm) aligned with LCD PCB long edge (98.6mm), both in enclosure X.
// 90° CW rotation viewed from LCD front face.
// GPIO flex cable required (direct GPIO plug-in not valid in this orientation).
// Ports after rotation:
//   USB-A / ETH  short edge → LEFT  wall (−X face)           — TBD verify
//   USB-C / HDMI short edge → RIGHT wall (+X face)           — TBD verify
//   GPIO long edge          → toward cover front (−Y face)   — internal, no wall exit
RPI_X    = 85.0;   // PCB long  axis → enclosure X (rotated 90° CW)
RPI_Y    = 56.0;   // PCB short axis → enclosure Y
RPI_T    = 22.0;   // GPIO-face → heatsink tip height — TBD (heatsink height not yet measured)
RPI_PCB_T =  1.2;  // bare PCB thickness (confirmed)

// Mounting holes (rotated 90° CW with PCB — DX↔DY swapped; OX, OY unchanged):
RPI_HOLE_DX  = 58.0;   // hole-to-hole in X (physical long-axis spacing, now in X)
RPI_HOLE_DY  = 49.0;   // hole-to-hole in Y (physical short-axis spacing, now in Y)
RPI_HOLE_OX  =  3.5;   // offset from RPi −X edge to nearest hole column
RPI_HOLE_OY  =  3.5;   // offset from RPi −Y edge to nearest hole row

// Port positions — TBD: re-measure with RPi in rotated orientation.
PORT_USBA_X   = 28.0;   // USB-A stack centre X from RPi −X edge — TBD
PORT_USBA_W   = 32.0;   // USB-A opening width (X)
PORT_USBA_H   = 16.0;   // USB-A opening height (Z)
PORT_USBC_X   = 36.0;   // USB-C centre X from RPi −X edge — TBD
PORT_USBC_W   = 11.0;   // USB-C opening width
PORT_USBC_H   =  7.0;   // USB-C opening height
PORT_ETH_X    =  9.0;   // Ethernet centre X from RPi −X edge — TBD
PORT_ETH_W    = 20.0;   // Ethernet opening width
PORT_ETH_H    = 16.0;   // Ethernet opening height

// ── MPI4008 4″ LCD ────────────────────────────────────────────
// The LCD plugs directly onto the RPi 40-pin GPIO header — their
// relative XY position is mechanically fixed and must be measured
// as a coupled assembly.  Offsets below are from RPi PCB centre.
LCD_PCB_X  = 98.6;    // LCD PCB width  (along enclosure X) — from manual diagram
LCD_PCB_SL = 58.08;   // LCD PCB depth along slope (enclosure Y) — from manual diagram
LCD_T      =  5.0;    // LCD module thickness (perp. to face) — TBD measure
LCD_ACT_X  = 87.7;    // active area width  (confirmed)
LCD_ACT_SL = 52.2;    // active area height along slope (confirmed)
// GPIO flex cable connects RPi (rotated 90° CW) to LCD.
// LCD orientation: chip side faces RPi (screen faces outward through cover window).
// LCD coupling offsets must be re-derived from physical flex-cable assembly.  TBD.
LCD_OFS_X  =  0.0;    // LCD centred on RPi in X (both centred in enclosure) — TBD confirm
LCD_OFS_Y  =  0.0;    // TBD — re-measure with RPi in rotated orientation

// ── LCD panel layer (the front display glass, slightly smaller than PCB) ─
// The module has two layers back-to-back:
//   back  layer (faces RPi): the PCB board  (LCD_PCB_X × LCD_PCB_SL)
//   front layer (faces out): the LCD panel  (slightly smaller, fits in cover window)
// Setbacks = how much each panel edge is inset from the corresponding PCB edge.
// All marked TBD — measure the physical module before printing.
LCD_PANEL_T    =  2.5;   // panel/glass thickness (perp. to face)   — TBD measure
LCD_SB_LEFT    =  3.5;   // setback: PCB -X edge → panel -X edge     — TBD measure
LCD_SB_RIGHT   =  3.5;   // setback: PCB +X edge → panel +X edge     — TBD measure
LCD_SB_FRONT   =  3.5;   // setback: PCB low-slope edge → panel edge  — TBD measure
LCD_SB_BACK    =  3.5;   // setback: PCB high-slope edge → panel edge — TBD measure

// Derived panel dimensions and centre offset from PCB centre
LCD_PANEL_X    = LCD_PCB_X  - LCD_SB_LEFT  - LCD_SB_RIGHT;    // panel width in X
LCD_PANEL_SL   = LCD_PCB_SL - LCD_SB_FRONT - LCD_SB_BACK;     // panel depth along slope
LCD_PANEL_OX   = (LCD_SB_LEFT  - LCD_SB_RIGHT)  / 2;  // panel centre X shift from PCB centre
LCD_PANEL_OSL  = (LCD_SB_FRONT - LCD_SB_BACK)   / 2;  // panel centre slope shift from PCB centre

// ── Fan (in MPI4008 kit sandwich) ────────────────────────────
FAN_SIZE = 30.0;   // fan square side — TBD
FAN_T    =  7.0;   // fan thickness  — TBD

// ── Buck converter LM2596 ─────────────────────────────────────
BUCK_X   = 21.0;   // LM2596 PCB width in enclosure X direction
BUCK_Y   = 43.0;   // LM2596 PCB depth in enclosure Y direction
BUCK_Z   = 17.0;   // LM2596 PCB + component height in Z (including potentiometer)

// ── Full-size SD slot (extension cable, left wall) ───────────
SD_W = 32.0;   // slot opening width in Y — TBD
SD_H =  8.0;   // slot opening height in Z — TBD
SD_POCKET = 34.0;  // card insertion depth in X (+X direction)

// ── Cavity footprint (shared by base slab and cover) ─────────
// Left wall aligns with panel left edge (PLATE_X0 = 0). OUTER_X = 145 mm (full panel width).
// Space right of RPi: INNER_X − (RPI_X0+RPI_X) = 139 − 92.8 = 46.2 mm — LM2596 fits flat.
INNER_X = 145.0 - 2*WALL;  // = 139 mm
// Y: Driven by RPi tilt geometry, not LCD PCB flat depth.
// After rotate([180+TILT_ANGLE,0,0]), RPi bare-bottom front edge reaches world_y:
//   = WALL + RPI_Y0 + RPI_Y/2*(1+cos θ) + STOFF_H*sin θ ≈ 65.2 mm  (θ≈19°)
// This exceeds LCD_PCB_SL + 2*CLR = 60.1 mm. Iterative solution: INNER_Y ≥ 63.3 mm
// for CLR clearance; 65.0 mm gives ~2.8 mm margin at the back inner wall.
INNER_Y = 65.0;                            // RPi tilt constraint (not LCD width)

// ── RPi + LCD assembly inside cover ──────────────────────────
// Assembly mounts perpendicular to inner angled face.
// Order from inner face outward: CLR_ABOVE_RPI → LCD screen → LCD PCB
//                                → RPi (GPIO top) → RPi PCB → standoff tips
CLR_ABOVE_RPI  = -LCD_PANEL_T;  // screen back face at cover inner face → panel sits in window slot
LCD_RPI_GAP    = 17.0;    // gap: LCD PCB bottom → RPi PCB GPIO face (measured)
STOFF_H        = CLR_ABOVE_RPI + LCD_T + LCD_RPI_GAP + RPI_PCB_T;  // = 20.7 mm (inner face → RPi chip face, confirmed)
ASSEMBLY_DEPTH = STOFF_H;  // cover interior depth — TBD: extend by heatsink height once measured

// ── RPi position (centred in X, front-flush in Y) ─────────────
// RPi centred in X (LCD also centred → they share X centre)
RPI_X0 = (LCD_PCB_X + 2*CLR - RPI_X) / 2;   // = 7.8 mm (fixed — keeps RPi position relative to left wall)
RPI_Y0 = CLR;                      // Y offset of RPi front edge from inner front wall

// ── Buck converter (in base wiring slab, beside RPi footprint) ─
BUCK_X0 = RPI_X0 + RPI_X + CLR;   // X start of buck  — TBD fit check
BUCK_Y0 = CLR;
// M3 mounting boss positions — derived from STL hole analysis.
// Orientation: rotate([0,0,90]) so long axis (50.9mm STL-X) runs in enclosure Y (along side wall).
// STL holes at approx (stl_x=4.0, stl_y=23.0) and (stl_x=36.0, stl_y=23.0).
// Mapping: world_x = -stl_y + (WALL+BUCK_X0+37.796),  world_y = stl_x + (WALL+BUCK_Y0+2.418)
BUCK_BOSS_H  = 3.0;   // M3 boss height above base floor (lifts PCB for airflow)
BUCK_BOSS_X  = WALL + BUCK_X0 + 37.796 - 23.0;   // ≈ 111.6 mm — same for both holes
BUCK_BOSS_Y1 = WALL + BUCK_Y0 +  2.418 +  4.0;   // ≈  10.4 mm — near-front hole
BUCK_BOSS_Y2 = WALL + BUCK_Y0 +  2.418 + 36.0;   // ≈  42.4 mm — near-back hole

// ── Outer dimensions ──────────────────────────────────────────
OUTER_X      = INNER_X + 2*WALL;   // = 145 mm
OUTER_Y      = INNER_Y + 2*WALL;   // =  93 mm
BASE_OUTER_Z = 4.0;                // thin floor slab — 4 mm is enough

// ── Tilt & cover geometry ─────────────────────────────────────
// Plate is 125 mm wide (left-aligned), height ceiling = 52 mm.
// Cover front wall must clear the full RPi + LCD assembly perpendicular to face.
MAX_OUTER_Z   = 52.0;    // clearance ceiling (narrower left-aligned plate)
COVER_FRONT_Z = WALL + ASSEMBLY_DEPTH;        // = 31 mm (clears RPi+LCD stack at front)
COVER_BACK_Z  = MAX_OUTER_Z - BASE_OUTER_Z;  // = 48 mm
TILT_ANGLE    = atan((COVER_BACK_Z - COVER_FRONT_Z) / OUTER_Y);  // ≈ 10.4°
LCD_FIT_CLR   = 0.5;     // per-side clearance for LCD PCB window

echo(str("Assembly depth (perp. to face): ", ASSEMBLY_DEPTH, " mm"));
echo(str("LCD tilt from horizontal: ", TILT_ANGLE, "°"));
echo(str("Total outer height (back corner): ", BASE_OUTER_Z + COVER_BACK_Z, " mm"));
echo(str("PLATE_X0 = ", PLATE_X0, " mm  OUTER_X = ", OUTER_X, " mm  INNER_X = ", INNER_X, " mm"));

// ── Mounting bracket (plate + arm shelf) ─────────────────────
PLATE_W   = 125.0;   // plate width  (20 mm narrower than control box; right side clear for bed screws)
PLATE_H   =  40.0;   // plate height (= 4040 cross-section)
PLATE_X0  = 0.0;   // left wall aligns with panel left edge (leftmost point of assembly)
ARM_L     =  15.0;   // cable gap: plate front → enclosure rear face
ARM_THICK =   8.0;   // arm shelf Z thickness

// M5 flat-head screws into 4040 beam end face
MOUNT_H1  = [10.0, 30.0];   // top-left hole  [X, Z-from-plate-bottom]
MOUNT_H2  = [30.0, 10.0];   // bottom-right hole

// ── Back-wall cable pass-throughs ─────────────────────────────
// Slots cut in the back wall to route cables from the Ender 3 control box
// interior into the OctoMount enclosure.
//
// Positions derived from "Sheetmetal enclosure bottom.pdf" (face view, 90° CW):
//
//   Face-view direct mapping verified by M5 holes:
//     X_offset from PLATE_X0 = old_x   (horizontal 0..30mm)
//     Z_OctoMount             = 153 − old_y
//     (10,123)→[X_off=10,Z=30]=MOUNT_H1 ✓   (30,143)→[X_off=30,Z=10]=MOUNT_H2 ✓
//
//   Applying 90° CW rotation to the diagram axes gives slot positions:
//     new_x (X_offset) = old_y
//     new_z            = 30 − old_x   (30 = max of the depth axis)
//
//   USB-A: old_y=18.5..34.5, old_x=0..6 → X_off=18.5..34.5, Z=24..30 mm
//   SD:    old_y=38.3..47.3, old_x=0..9 → X_off=38.3..47.3, Z=21..30 mm
//
// X_enclosure = PLATE_X0 + X_offset  (PLATE_X0 = 0 — left wall at panel left edge)
//
// USB-A cable slot — left zone of main back wall
BKWALL_USB_X0  = PLATE_X0 + 18.5;   // = 18.5 mm from enclosure left
BKWALL_USB_W   = 16.0;              //  = 16.0 mm  (34.5 − 18.5)
BKWALL_USB_ZLO = 24.0;             //  = 24.0 mm  (30 − 6)
BKWALL_USB_ZHI = 30.0;             //  = 30.0 mm  (30 − 0)
// microSD extension cable slot — left zone of main back wall
BKWALL_SD_X0   = PLATE_X0 + 38.3;   // = 38.3 mm from enclosure left
BKWALL_SD_W    =  9.0;              //  =  9.0 mm  (47.3 − 38.3)
BKWALL_SD_ZLO  = 21.0;             //  = 21.0 mm  (30 − 9)
BKWALL_SD_ZHI  = 30.0;             //  = 30.0 mm  (30 − 0)
echo(str("USB  slot X=[", BKWALL_USB_X0, " .. ", BKWALL_USB_X0+BKWALL_USB_W, "]  Z=[", BKWALL_USB_ZLO, " .. ", BKWALL_USB_ZHI, "]"));
echo(str("SD   slot X=[", BKWALL_SD_X0,  " .. ", BKWALL_SD_X0+BKWALL_SD_W,   "]  Z=[", BKWALL_SD_ZLO,  " .. ", BKWALL_SD_ZHI,  "]"));

// ── RPi mounting boss positions on base (XY aligned with RPi M2.5 holes) ──
// The boss is rotate([TILT_ANGLE,0,0]) → its tip shifts -Y by h·sin(θ) relative to base.
// So boss BASE must be placed at a larger Y than the target hole world_y:
//
//   hole_world_y(dy) = _RY_C + (RPI_Y/2 − dy)·cos θ + STOFF_H·sin θ
//   boss base by     = (hole_world_y + _BH_C·sin θ) / cos²θ
//   boss height h    = _BH_C + by·sin θ
//   (derived from requiring boss tip Y = by − h·sin θ = hole_world_y)
//
// _BH_C = height constant: COVER_FRONT_Z·cos θ − WALL − STOFF_H − RPI_PCB_T
// RPI_PCB_T subtracted so boss tips land on the PCB bare-bottom face (not the component-top face).
// 180° flip → small-dy RPi holes land at large world_y (near enclosure back wall).
_BH_C = COVER_FRONT_Z * cos(TILT_ANGLE) - WALL - STOFF_H - RPI_PCB_T;
_RY_C = WALL + RPI_Y0 + RPI_Y/2;   // RPi Y-centre in enclosure

BOSS_XS = [WALL + RPI_X0 + RPI_HOLE_OX,
           WALL + RPI_X0 + RPI_HOLE_OX + RPI_HOLE_DX];
// [0] = back holes  (dy = RPI_HOLE_OY + RPI_HOLE_DY, small world_y, short boss)
// [1] = front holes (dy = RPI_HOLE_OY,               large world_y, tall boss — base near back wall)
BOSS_YS = [(_RY_C + (RPI_Y/2 - RPI_HOLE_OY - RPI_HOLE_DY) * cos(TILT_ANGLE) + (STOFF_H + _BH_C) * sin(TILT_ANGLE)) / pow(cos(TILT_ANGLE), 2),
           (_RY_C + (RPI_Y/2 - RPI_HOLE_OY)               * cos(TILT_ANGLE) + (STOFF_H + _BH_C) * sin(TILT_ANGLE)) / pow(cos(TILT_ANGLE), 2)];
// Boss height: h(by) = _BH_C + by·sin θ  — computed in base.scad using _BH_C.
// Approx (θ≈14.6°): back boss ≈ 4.2 mm, front boss ≈ 17.0 mm.

echo(str("BOSS_XS = ", BOSS_XS, "  BOSS_YS = ", BOSS_YS));
echo(str("Boss tip world_Y: [0]=",
    BOSS_YS[0] - (_BH_C + BOSS_YS[0]*sin(TILT_ANGLE)) * sin(TILT_ANGLE),
    "  [1]=",
    BOSS_YS[1] - (_BH_C + BOSS_YS[1]*sin(TILT_ANGLE)) * sin(TILT_ANGLE)));

// ── Utility modules ───────────────────────────────────────────

// Rounded-corner box: X×Y footprint with CORNER_R on vertical edges.
module rbox(sz, r = CORNER_R) {
    hull()
        for (xi = [r, sz[0]-r], yi = [r, sz[1]-r])
            translate([xi, yi, 0])
                cylinder(r=r, h=sz[2], $fn=32);
}

// M2.5 standoff boss: solid cylinder, blind tapped hole on top.
// Hole depth clamped to min(h, M25_BOSS_DEPTH) so short bosses don't punch through base.
module rpi_boss(h = STOFF_H) {
    _hd = min(h, M25_BOSS_DEPTH);
    difference() {
        cylinder(r=M25_BOSS_R, h=h, $fn=32);
        translate([0, 0, h - _hd])
            cylinder(d=M25_CLEAR, h=_hd+0.1, $fn=16);
    }
}

// M2.5 back-wall block: cube-shaped support from back inner wall, top face parallel to RPi face.
// Built in the same tilted local frame as rpi_boss (rotate([TILT_ANGLE,0,0]) already applied).
//   Local +Y → world (0, cos θ, sin θ) → toward back wall.
//   Block spans local Y ∈ [−M25_BOSS_R,  DY/cosθ + WALL]
//              local Z ∈ [0, h]          (floor to RPi mounting plane)
//   M2.5 hole at local (0, 0, h) — same world position as equivalent floor boss tip.
// by = world Y of boss base (= BOSS_YS[1]);  h = boss height in tilted frame.
module rpi_back_block(h, by) {
    _extra = M25_BOSS_R;                                               // −Y overhang for hole clearance
    _D     = (OUTER_Y - WALL - by) / cos(TILT_ANGLE) + WALL + _extra; // total local-Y span
    _t     = max(WALL, M25_BOSS_DEPTH);                                // slab thickness (local Z)
    difference() {
        // Slab only at the top — space below (local Z < h−_t) is left open
        translate([-M25_BOSS_R, -_extra, h - _t])
            cube([2*M25_BOSS_R, _D, _t]);
        // M2.5 blind hole from top face (local Z = h, centred at XY = 0)
        translate([0, 0, h - _t])
            cylinder(d=M25_CLEAR, h=_t + 0.1, $fn=16);
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
