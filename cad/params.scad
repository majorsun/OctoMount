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
WALL     = 3.0;   // nominal wall — clearances, hinge boss, cover geometry
WALL_S   = 2.0;   // structural side + back wall thickness (thinner than hinge boss)
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
RPI_T    = 18.0;   // GPIO-face → heatsink tip height — TBD (heatsink height not yet measured)
RPI_PCB_T =  1.2;  // bare PCB thickness (confirmed)

// Mounting holes (rotated 90° CW with PCB — DX↔DY swapped; OX, OY unchanged):
RPI_HOLE_DX  = 58.0;   // hole-to-hole in X (physical long-axis spacing, now in X)
RPI_HOLE_DY  = 49.0;   // hole-to-hole in Y (physical short-axis spacing, now in Y)
RPI_HOLE_OX  =  3.5;   // offset from RPi −X edge to nearest hole column
RPI_HOLE_OY  =  3.5;   // offset from RPi −Y edge to nearest hole row

// Port positions — all TBD: measure on physical RPi in final orientation.
// USB-A / ETH ports exit through LEFT wall (−X face).
//   _Y = distance of port centre along the RPi −X edge from the RPi −Y (front) edge.
//   _W = opening width in enclosure Y;  _H = opening height in Z;  _Z = bottom Z above base floor.
PORT_USBA_Y   = 28.0;   // USB-A 4-port stack centre: Y from RPi front edge  — TBD
PORT_USBA_W   = 32.0;   // USB-A combined opening width  (Y)                  — TBD
PORT_USBA_H   = 16.0;   // USB-A combined opening height (Z)                  — TBD
PORT_USBA_Z   =  9.0;   // USB-A opening bottom Z above base floor             — TBD
PORT_ETH_Y    =  9.0;   // Ethernet centre: Y from RPi front edge              — TBD
PORT_ETH_W    = 20.0;   // Ethernet opening width  (Y)                         — TBD
PORT_ETH_H    = 16.0;   // Ethernet opening height (Z)                         — TBD
PORT_ETH_Z    =  9.0;   // Ethernet opening bottom Z above base floor          — TBD
// USB-C / HDMI ports exit through RIGHT wall (+X face).
PORT_USBC_Y   = 36.0;   // USB-C centre: Y from RPi front edge  — TBD
PORT_USBC_W   = 11.0;   // USB-C opening width  (Y)
PORT_USBC_H   =  7.0;   // USB-C opening height (Z)

// ── Right-wall ventilation grill (round holes) ────────────────
// Round holes through the 1 mm right wall, over the buck converter zone.
// Hole centres are kept ≥ VENT_HOLE_R from every zone boundary so
// no hole overlaps the floor, wall top, or front/back wall edges.
VENT_Y0         = 15.0;   // hole centre Y min (world Y) — 15 mm clear of front wall
VENT_Y1         = 64.0;   // hole centre Y max (world Y) — 9 mm clear of back wall
VENT_Z0         =  1.0;   // zone bottom (world Z); centres start at VENT_Z0+VENT_HOLE_R
VENT_Z1         = 33.0;   // zone top   (world Z); centres end   at VENT_Z1-VENT_HOLE_R
VENT_HOLE_R     =  2.5;   // hole radius (5 mm diameter)
VENT_HOLE_PITCH =  6.0;   // centre-to-centre spacing in Y and Z (2 mm land between holes)

// ── MPI4008 4″ LCD ────────────────────────────────────────────
// The LCD plugs directly onto the RPi 40-pin GPIO header — their
// relative XY position is mechanically fixed and must be measured
// as a coupled assembly.  Offsets below are from RPi PCB centre.
LCD_PCB_X  = 100;    // LCD PCB width  (along enclosure X) — from manual diagram
LCD_PCB_SL = 60;   // LCD PCB depth along slope (enclosure Y) — from manual diagram
LCD_T      =  5.8;    // LCD module thickness (perp. to face) — measured
LCD_ACT_X  = 100;    // active area width  (confirmed)
LCD_ACT_SL = 60;    // active area height along slope (confirmed)
// GPIO flex cable connects RPi (rotated 90° CW) to LCD.
// LCD orientation: chip side faces RPi (screen faces outward through cover window).
// LCD coupling offsets must be re-derived from physical flex-cable assembly.  TBD.
LCD_OFS_X  = (LCD_PCB_X - RPI_X) / 2;  // = 6.8 mm — left edge of LCD PCB aligned with left edge of RPi PCB
LCD_OFS_Y  =  0.0;    // TBD — re-measure with RPi in rotated orientation

// ── LCD panel layer (the front display glass, slightly smaller than PCB) ─
// The module has two layers back-to-back:
//   back  layer (faces RPi): the PCB board  (LCD_PCB_X × LCD_PCB_SL)
//   front layer (faces out): the LCD panel  (slightly smaller, fits in cover window)
// Setbacks = how much each panel edge is inset from the corresponding PCB edge.
// All marked TBD — measure the physical module before printing.
LCD_PANEL_T    =  2.5;   // panel/glass thickness (perp. to face)   — TBD measure
LCD_SB_LEFT    =  0;   // setback: PCB -X edge → panel -X edge     — TBD measure
LCD_SB_RIGHT   =  0;   // setback: PCB +X edge → panel +X edge     — TBD measure
LCD_SB_FRONT   =  0;   // setback: PCB low-slope edge → panel edge  — TBD measure
LCD_SB_BACK    =  0;   // setback: PCB high-slope edge → panel edge — TBD measure

// Derived panel dimensions and centre offset from PCB centre
LCD_PANEL_X    = LCD_PCB_X  - LCD_SB_LEFT  - LCD_SB_RIGHT;    // panel width in X
LCD_PANEL_SL   = LCD_PCB_SL - LCD_SB_FRONT - LCD_SB_BACK;     // panel depth along slope
LCD_PANEL_OX   = (LCD_SB_LEFT  - LCD_SB_RIGHT)  / 2;  // panel centre X shift from PCB centre
LCD_PANEL_OSL  = (LCD_SB_FRONT - LCD_SB_BACK)   / 2;  // panel centre slope shift from PCB centre

// ── LCD viewable area (window opening in cover) ───────────────
// Setbacks from the panel edges to the viewable/active area edges.
// The cover window is cut to this size (+ LCD_FIT_CLR per side).
// All zero until measured from the physical unit.
LCD_VIEW_SB_LEFT  = 9;   // panel -X edge → viewable area -X edge  — TBD
LCD_VIEW_SB_RIGHT = 2;   // panel +X edge → viewable area +X edge  — TBD
LCD_VIEW_SB_FRONT = 2;   // panel low-slope edge → viewable edge    — TBD
LCD_VIEW_SB_BACK  = 2;   // panel high-slope edge → viewable edge   — TBD

LCD_VIEW_X   = LCD_PANEL_X   - LCD_VIEW_SB_LEFT  - LCD_VIEW_SB_RIGHT;
LCD_VIEW_SL  = LCD_PANEL_SL  - LCD_VIEW_SB_FRONT - LCD_VIEW_SB_BACK;
LCD_VIEW_OX  = LCD_PANEL_OX  + (LCD_VIEW_SB_LEFT  - LCD_VIEW_SB_RIGHT)  / 2;
LCD_VIEW_OSL = LCD_PANEL_OSL + (LCD_VIEW_SB_FRONT - LCD_VIEW_SB_BACK)   / 2;

LCD_WIN_SKIN = 0.5;  // cover thickness over the LCD setback area (step shoulder depth from outer face)

REAR_CORNER_R = 3.0;  // rear top edge rounding radius (Y=OUTER_Y, Z=MAX_OUTER_Z corner)

// ── LCD PCB corner brackets ───────────────────────────────────
LCD_BRACKET_T   = 1.5;   // bracket wall thickness
LCD_BRACKET_W   = 5.0;   // bracket arm length along each PCB edge
LCD_BRACKET_GAP = 0.3;   // clearance between bracket inner wall face and PCB edge


// ── Fan (in MPI4008 kit sandwich) ────────────────────────────
FAN_SIZE = 30.0;   // fan square side — TBD
FAN_T    =  7.0;   // fan thickness  — TBD

// ── Buck converter LM2596 ─────────────────────────────────────
BUCK_X   = 35.0;   // LM2596 PCB width in enclosure X  (measured)
BUCK_Y   = 56.0;   // LM2596 PCB depth in enclosure Y  (measured)
BUCK_Z   = 12.0;   // LM2596 PCB + component height    (measured)
BUCK_HOLE_X = 28.0;   // screw hole span in X (measured)
BUCK_HOLE_Y = 50.0;   // screw hole span in Y (measured)
BUCK_HOLE_D  =  3.5;  // screw hole diameter  (measured)

// ── Full-size SD slot (extension cable, left wall) ───────────
SD_W      = 30.4;  // slot opening width in Y (measured from SD holder)
SD_H      =  4.0;  // slot opening height in Z (measured from SD holder)
SD_POCKET = 34.0;  // card insertion depth in X (+X direction)
// Two M2 screw holes in base floor, flanking the SD slot centre.
SD_SCREW_D    = 2.0;   // screw hole diameter
SD_SCREW_SPAN = 34.1;  // centre-to-centre Y distance between the two holes
SD_SCREW_X    = 17.8;  // hole centre X from outside left wall surface
SD_BACK_CLR   = 3.0;   // back screw hole distance from inner back wall surface

// ── Cavity footprint (shared by base slab and cover) ─────────
// Left wall aligns with panel left edge (PLATE_X0 = 0). OUTER_X = 140 mm.
// Space right of RPi: INNER_X − (RPI_X0+RPI_X) = 134 − 87.8 = 46.2 mm — LM2596 fits flat.
INNER_X = 140.0 - 2*WALL;  // = 134 mm
// Y: Driven by RPi tilt geometry, not LCD PCB flat depth.
// After rotate([180+TILT_ANGLE,0,0]), RPi bare-bottom front edge reaches world_y:
//   = WALL + RPI_Y0 + RPI_Y/2*(1+cos θ) + STOFF_H*sin θ
// After rotate([180+TILT_ANGLE,0,0]), RPi bare-bottom front edge reaches world_y:
//   = WALL + RPI_Y0 + RPI_Y/2*(1+cos θ) + STOFF_H*sin θ
// RPI_Y0 = -10mm (maximally forward); INNER_Y unchanged — back clearance to rear boss rib increases.
INNER_Y = 67.0;                            // RPi tilt constraint (not LCD width)

// ── RPi + LCD assembly inside cover ──────────────────────────
// Assembly mounts perpendicular to inner angled face.
// Order from inner face outward: CLR_ABOVE_RPI → LCD screen → LCD PCB
//                                → RPi (GPIO top) → RPi PCB → standoff tips
CLR_ABOVE_RPI  = -LCD_PANEL_T;  // screen back face at cover inner face → panel sits in window slot
LCD_RPI_GAP    = 17.0;    // gap: LCD PCB bottom → RPi PCB GPIO face (measured)
STOFF_H        = CLR_ABOVE_RPI + LCD_T + LCD_RPI_GAP + RPI_PCB_T;  // = 21.5 mm (inner face → RPi chip face)
ASSEMBLY_DEPTH = STOFF_H;  // cover interior depth — TBD: extend by heatsink height once measured
_COVER_FZ_BASE = WALL + STOFF_H;  // base cover front height — feeds _BH_C so boss heights are independent of COVER_EXTRA
COVER_EXTRA    = 3.1;              // additional cover height: 0.5 base + 2.0 lift + 0.6 LCD clearance gap

// ── RPi position (centred in X, front-flush in Y) ─────────────
// RPi centred in X (LCD also centred → they share X centre), shifted right by RPI_X_SHIFT
RPI_X_SHIFT = 1.0;                                          // shift of RPi+LCD assembly (−2 mm vs original to keep same gap to right wall)
RPI_X0 = (LCD_PCB_X + 2*CLR - RPI_X) / 2 + RPI_X_SHIFT;  // = 8.8 mm
RPI_Y0 = CLR - 11.0;              // = -10mm: maximally forward; front boss at BOSS_YS[0]≈6.2mm (front edge +2.7mm); front wall extends by FRONT_EXT
FRONT_EXT = max(0, CLR - RPI_Y0); // = 11mm: front wall/floor/side-wall extension to give CLR clearance at RPi edge
RPI_GROOVE_DEPTH = 3.5;           // depth of floor groove to clear RPi front edge below BASE_OUTER_Z  — TBD

// ── Buck converter floor bosses ────────────────────────────────
// PCB lies flat (56 mm along Y, 35 mm along X). Right edge of PCB sits
// BUCK_WALL_GAP mm from right wall inner face.  Setbacks: 3 mm in Y, 3.5 mm in X.
BUCK_X0 = RPI_X0 + RPI_X + CLR;   // X of PCB left edge (≈ 93.8 mm) — TBD fit check
BUCK_Y0 = 5.0;                     // Y gap from inner front wall to PCB front edge (back edge 4 mm from inner back wall)
BUCK_WALL_GAP = 1.0;   // clearance from right wall inner face to PCB right edge
BUCK_FLOOR_H  = 4.0;   // boss height — PCB solder face at BASE_OUTER_Z + BUCK_FLOOR_H
// Boss X: right pair setback (BUCK_X - BUCK_HOLE_X)/2 from right PCB edge
BUCK_FLOOR_X2 = INNER_X + WALL - BUCK_WALL_GAP - (BUCK_X - BUCK_HOLE_X)/2;  // right pair (= OUTER_X − WALL − …)
BUCK_FLOOR_X1 = BUCK_FLOOR_X2 - BUCK_HOLE_X;                                  // left  pair
// Boss Y: setback (BUCK_Y - BUCK_HOLE_Y)/2 from front/back PCB edges
BUCK_FLOOR_Y1 = WALL + BUCK_Y0 + (BUCK_Y - BUCK_HOLE_Y)/2;  // front pair
BUCK_FLOOR_Y2 = BUCK_FLOOR_Y1 + BUCK_HOLE_Y;                 // back  pair

// ── Outer dimensions ──────────────────────────────────────────
OUTER_X      = INNER_X + 2*WALL;   // = 140 mm
OUTER_Y      = INNER_Y + 2*WALL;   // =  73 mm
BASE_OUTER_Z = 1.0;                // floor slab thickness
// SD slot Y centre: back screw hole sits SD_BACK_CLR from inner back wall.
SD_CY = OUTER_Y - WALL - SD_BACK_CLR - SD_SCREW_SPAN/2;

// ── Tilt & cover geometry ─────────────────────────────────────
// Plate is 125 mm wide (left-aligned).
// COVER_BACK_Z: full angled-slab back height (cover-local); determines tilt angle.
// The angled slab is trimmed at COVER_FLAT_Z; a horizontal cap closes the top.
COVER_BACK_Z  = 51.0;    // angled slab full back height (cover-local); determines tilt angle
                         // min: BKWALL_H = MAX_OUTER_Z − WALL/cos(θ) − 4 ≥ BKWALL_WIN_ZHI (37mm) → 51mm gives ≈1mm margin
COVER_FRONT_Z = _COVER_FZ_BASE + COVER_EXTRA; // front wall height (cover-local)
TILT_ANGLE    = atan((COVER_BACK_Z - COVER_FRONT_Z) / OUTER_Y);  // ≈ 19.6°
LCD_FIT_CLR   = 0.7;     // per-side clearance for LCD PCB window

// Flat top: horizontal cap as low as possible without clipping the LCD window back edge.
// _LCD_WIN_BACK_Y = world Y of the LCD window back edge (highest-Y window feature).
// COVER_FLAT_Z    = cover-local Z of the flat cap bottom face (= angled slab trim height).
// MAX_OUTER_Z     = enclosure ceiling = flat top outer face world Z.
_LCD_WIN_BACK_Y = WALL + RPI_Y0 + RPI_Y/2 + LCD_OFS_Y + LCD_PANEL_SL/2 + LCD_FIT_CLR;
COVER_FLAT_Z    = COVER_FRONT_Z + (_LCD_WIN_BACK_Y / OUTER_Y) * (COVER_BACK_Z - COVER_FRONT_Z);
MAX_OUTER_Z   = BASE_OUTER_Z + COVER_FLAT_Z;  // enclosure ceiling = flat top outer face (flush with angled slab at junction)

// Back wall height: shortened so the cover's inner face clears the flat top.
BKWALL_H = MAX_OUTER_Z - WALL / cos(TILT_ANGLE) - 4;

echo(str("Assembly depth (perp. to face): ", ASSEMBLY_DEPTH, " mm"));
echo(str("LCD tilt from horizontal: ", TILT_ANGLE, "°"));
echo(str("Flat top Z (cover-local): ", COVER_FLAT_Z, " mm   MAX_OUTER_Z: ", MAX_OUTER_Z, " mm"));
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

// ── Pin hinge ─────────────────────────────────────────────────
// Cover has two cylinder pins protruding outward from each side face.
// Base side walls have matching through-holes.
// The X-parallel axis through both pin centres is the hinge axle.
BHINGE_R     = 1.0;   // pin/hole radius
BHINGE_CLR   = 0.2;   // radial clearance between pin and hole
BHINGE_PIN_L = WALL_S; // pin protrusion length = wall thickness (flush with outer face)

BHINGE_Y  = OUTER_Y - WALL_S - BHINGE_R - BHINGE_CLR - 0.5;  // Y: hole edge 0.5 mm clear of back wall
// Hinge axle sits at the centre of the flat top slab (Z = COVER_FLAT_Z + WALL/2).
BHINGE_WZ = BASE_OUTER_Z + COVER_FLAT_Z - WALL / 2 - 1.5;  // 1.5 mm below flat slab centre for better material strength

// ── Back-wall cable pass-throughs ─────────────────────────────
// Window positions are anchored to the two M5 mounting screws (MOUNT_H1, MOUNT_H2).
// All horizontal offsets are measured in +X (rightward) from MOUNT_H2[0].
//
// Panel drawing (Ender3PanelDiagram.pdf, rotated to natural orientation):
//   Reference = right edge of full 153 mm panel.
//   MOUNT_H2 is at 123 mm from panel right  (= 153 − MOUNT_H2[0] = 153 − 30).
//   USB-A port:       18.5..34.5 mm from panel right  → 104.5..75.7 mm right of MOUNT_H2
//                     Z depth 0..6 mm from panel top  → Z = 24..30 mm
//   microSD ext port: 38.3..47.3 mm from panel right  → 84.7..75.7 mm right of MOUNT_H2
//                     Z depth 0..9 mm from panel top  → Z = 21..30 mm
//   Combined window:  18.5..47.3 mm from panel right  → 75.7..104.5 mm right of MOUNT_H2
//
// Z anchor: window top = PLATE_H = 40 mm (top edge of mounting plate).
//   Diagram right-side labels are DEPTH FROM TOP EDGE: 0→top, 6→USB depth, 9→SD depth, 10→MOUNT_H1, 30→MOUNT_H2.
//   Z = PLATE_H − depth  →  MOUNT_H1 at depth 10 = Z 30 ✓,  MOUNT_H2 at depth 30 = Z 10 ✓.
//   Ports sit just above MOUNT_H1: Z = PLATE_H−9 .. PLATE_H = 31..40 mm.
//
BKWALL_WIN_X0  = 55.0;   // window left  edge from left wall (mm)
BKWALL_WIN_W   = 35.0;   // window width (mm)
BKWALL_WIN_ZHI = PLATE_H - 3.0;  // = 37 mm  (lowered 3 mm from plate top)
BKWALL_WIN_ZLO = PLATE_H - 12.0; // = 28 mm  (9 mm window height)
echo(str("Cable window X=[", BKWALL_WIN_X0, " .. ", BKWALL_WIN_X0+BKWALL_WIN_W, "]  Z=[", BKWALL_WIN_ZLO, " .. ", BKWALL_WIN_ZHI, "]"));

// Second back-wall window: 15×15 mm, lower-left area.
// Left edge = 10 mm right of MOUNT_H2 countersink right edge (MOUNT_H2[0] + M5_CS_D/2 + 10).
// Bottom = exterior floor surface (Z = 0).
BKWALL_WIN2_X0  = MOUNT_H2[0] + 10.0;  // = 40 mm (10 mm right of MOUNT_H2 centre)
BKWALL_WIN2_W   = 15.0;
BKWALL_WIN2_ZLO = 0.0;
BKWALL_WIN2_ZHI = 15.0;

// ── RPi mounting boss positions on base (XY aligned with RPi M2.5 holes) ──
// The boss is rotate([TILT_ANGLE,0,0]) → its tip shifts -Y by h·sin(θ) relative to base.
// So boss BASE must be placed at a larger Y than the target hole world_y:
//
//   hole_world_y(dy) = _RY_C + (RPI_Y/2 − dy)·cos θ + STOFF_H·sin θ
//   boss base by     = (hole_world_y + _BH_C·sin θ) / cos²θ
//   boss height h    = _BH_C + by·sin θ
//   (derived from requiring boss tip Y = by − h·sin θ = hole_world_y)
//
// _BH_C = height constant: _COVER_FZ_BASE·cos θ − WALL − STOFF_H − RPI_PCB_T + RPI_Z_LIFT
// RPI_PCB_T subtracted so boss tips land on the PCB bare-bottom face (not the component-top face).
// RPI_Z_LIFT raises all boss tips (≈ RPI_Z_LIFT mm in world Z), keeping the PCB front edge
// above the base floor so no floor groove is needed.
// 180° flip → small-dy RPi holes land at large world_y (near enclosure back wall).
RPI_Z_LIFT = 4.0;   // raises boss tips above STOFF_H from cover inner face; net lift = RPI_Z_LIFT − RPI_PCB_T = 2.8 mm
_BH_C = _COVER_FZ_BASE * cos(TILT_ANGLE) - WALL - STOFF_H - RPI_PCB_T + RPI_Z_LIFT;  // uses _COVER_FZ_BASE so boss heights are unchanged by COVER_EXTRA
_RY_C = WALL + RPI_Y0 + RPI_Y/2;   // RPi Y-centre in enclosure

// RPi mirrored in X: offset from −X edge = RPI_X − RPI_HOLE_OX − RPI_HOLE_DX
BOSS_XS = [WALL + RPI_X0 + RPI_X - RPI_HOLE_OX - RPI_HOLE_DX,
           WALL + RPI_X0 + RPI_X - RPI_HOLE_OX];
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

// ── Stylus holder (flat top of cover) ─────────────────────────
STYLUS_D        =  5.0;   // stylus outer diameter (mm)
STYLUS_HOLDER_D =  8.0;   // groove diameter — half-cylinder (mm)
STYLUS_HOLDER_L = 100.0;  // groove length along X (mm)

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
