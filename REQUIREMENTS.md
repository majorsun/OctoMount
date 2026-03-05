# Design Requirements

**Last Updated:** 2026-03-04 (rev 2)
**Design:** 2-piece enclosure (Base + Cover) — see STATUS.md for design pivot history

---

## REQ-001 — Hardware Compatibility

| ID | Requirement | Priority |
|---|---|---|
| REQ-001.1 | Base must house Raspberry Pi 4B (85 × 56 × 17 mm) with clearance | MUST |
| REQ-001.2 | Cover must provide an angled LCD window for the MPI4008 display (active area ~87 × 52 mm) | MUST |
| REQ-001.3 | Base must bolt to the Ender 3 Pro 4040 control-box beam end face via 2× M5 flat-head screws | MUST |
| REQ-001.4 | USB-C power port on RPi must receive 5V from the internal LM2596 buck converter via a USB-C pigtail routed through the right-bottom corner | MUST |
| REQ-001.5 | A USB-A cable must exit through the back wall of the base to connect the RPi to the Ender 3 Pro mainboard USB port (routed internally through the control box) | MUST |
| REQ-001.6 | RPi microSD slot is not required to be accessible from outside (OctoPi OS is pre-flashed) | INFO |
| REQ-001.7 | Micro HDMI port on RPi must be routed to the LCD internally | MUST |
| REQ-001.8 | MPI4008 GPIO 13×2 header connection to RPi must be accommodated | MUST |
| REQ-001.9 | Enclosure must include a full-size SD card slot on the left wall, connected via microSD male → SD female extension cable (AliExpress item 2255801037535913) to the Ender 3 Pro control box microSD slot | MUST |
| REQ-001.10 | SD extension cable must reach from the Ender 3 Pro mainboard to the left-wall SD slot without tension — verify cable length before ordering | MUST |
| REQ-001.11 | MPI4008 backlight button access is optional | NICE-TO-HAVE |
| REQ-001.12 | MPI4008 3.5mm audio jack access is not required | OUT-OF-SCOPE |

---

## REQ-002 — Structural & Mounting

| ID | Requirement | Priority |
|---|---|---|
| REQ-002.1 | Base plate must bolt to the Ender 3 Pro 4040 control-box front beam end face using 2× M5 flat-head screws in the existing diagonal hole pattern (10,10) and (30,30) — 20 mm apart in X and Z | MUST |
| REQ-002.2 | The base plate covers the stock Ender 3 Pro control box front panel entirely | MUST |
| REQ-002.3 | Assembly must withstand vibration during printing without loosening | MUST |
| REQ-002.4 | No 2020 T-slot nuts or 2020 clamp hardware required | MUST |
| REQ-002.5 | Total enclosure height (Z, including all walls) must not exceed **48 mm** — hard clearance limit from the Ender 3 Pro bed assembly | MUST |
| REQ-002.6 | RPi 4B must be mounted flat (85 × 56 mm footprint in XY, PCB+heatsinks ~17–25 mm in Z) — standing on-edge is ruled out by the 48 mm height limit | MUST |
| REQ-002.7 | LCD tilt must be **maximised toward the operator**: back wall at the full 48 mm, front wall at the minimum height dictated by the flat RPi stack + clearance. Do not target a fixed angle — derive it from the geometry | MUST |
| REQ-002.8 | Side silhouette: right-trapezoid — back wall tall (48 mm), front wall short (minimum), angled top face spanning between them holding the LCD | MUST |
| REQ-002.9 | Assembly must support the combined weight of RPi 4B + LCD without flex | MUST |
| REQ-002.10 | Assembly must not protrude into the path of the printer bed (Y-axis travel) | MUST |
| REQ-002.11 | Assembly must not obstruct the X-axis gantry wheels or carriage movement | MUST |
| REQ-002.12 | Full-size SD card slot must be on the left wall and allow one-handed card insertion/removal | MUST |
| REQ-002.13 | Cover must attach to Base with M3 screws (no glue) and be removable for service | MUST |

---

## REQ-003 — Power

| ID | Requirement | Priority |
|---|---|---|
| REQ-003.1 | Assembly must draw power from the Ender 3 Pro PSU (24V DC) — no separate wall adapter | MUST |
| REQ-003.2 | Buck converter model: LM2596-based adjustable step-down (Temu goods_id 601099525293943) | MUST |
| REQ-003.3 | Buck converter must be set to output 5V DC for RPi 4B | MUST |
| REQ-003.4 | Buck converter output must supply at least 3A continuous | MUST |
| REQ-003.5 | Buck converter must be mounted inside the base body with adhesive thermal pad/heatsink (~14 × 14 mm aluminum) | MUST |
| REQ-003.6 | 5V output must connect to RPi via USB-C pigtail (not GPIO pins) | MUST |
| REQ-003.7 | USB-C power cable must enter the enclosure through the right-bottom corner, routed through the 4040 beam T-slot channel | MUST |
| REQ-003.8 | 24V tap must be taken from the PSU terminals or a safe splice point | MUST |
| REQ-003.9 | Wiring must include a fuse or polyfuse on the 24V input line | SHOULD |

---

## REQ-004 — Thermal Management

| ID | Requirement | Priority |
|---|---|---|
| REQ-004.1 | Enclosure must provide clearance for the integrated fan mounted between the LCD and RPi 4B modules | MUST |
| REQ-004.2 | Enclosure must have ventilation openings aligned with the fan's intake and exhaust paths | MUST |
| REQ-004.3 | Ventilation area must be sufficient to not back-pressure the integrated fan (open area ≥ fan blade swept area) | MUST |
| REQ-004.4 | Heatsinks on RPi 4B CPU/RAM must have clearance inside the enclosure | MUST |
| REQ-004.5 | Enclosure must not trap heat near the Ender 3 Pro heated bed or hotend | MUST |
| REQ-004.6 | Ventilation openings should incorporate a dust filter screen | SHOULD |

---

## REQ-005 — Printability

| ID | Requirement | Priority |
|---|---|---|
| REQ-005.1 | All parts must be printable on an Ender 3 Pro (235 × 235 × 250 mm build volume) | MUST |
| REQ-005.2 | Minimum wall thickness: 2 mm (3 mm preferred for structural walls) | MUST |
| REQ-005.3 | Design consists of exactly 2 printed parts: Base and Cover | MUST |
| REQ-005.4 | Parts should minimise required supports | SHOULD |
| REQ-005.5 | Recommended print material: PETG (heat resistant, durable) | SHOULD |

---

## REQ-006 — Assembly & Serviceability

| ID | Requirement | Priority |
|---|---|---|
| REQ-006.1 | RPi must be removable with only a screwdriver | SHOULD |
| REQ-006.2 | Cover must be removable independently for LCD or RPi service | MUST |
| REQ-006.3 | Assembly must be completable by a maker with basic tools | MUST |
| REQ-006.4 | Provide assembly documentation with the design files | SHOULD |

---

## REQ-007 — Aesthetics

| ID | Requirement | Priority |
|---|---|---|
| REQ-007.1 | Design should be clean and intentional, not purely functional | NICE-TO-HAVE |
| REQ-007.2 | Branding / logo emboss on exterior is optional | NICE-TO-HAVE |
| REQ-007.3 | Cable routing should be hidden where possible | SHOULD |

---

## Reference Dimensions

### Raspberry Pi 4B
- PCB: 85 × 56 mm
- Height with heatsinks: ~25 mm
- Mounting holes: 3.5 mm dia., 58 × 49 mm pattern (M2.5 standoffs)

### MPI4008 LCD Module
- Overall: 143 × 134 × 51 mm (including RPi when stacked)
- Active area: ~87 × 52 mm (4.0" diagonal)
- GPIO header: 13×2, standard 2.54 mm pitch
- Integrated fan: in the gap between LCD board and RPi — **measure fan size and orientation before CAD** (likely 30×30 mm or 40×40 mm)

### Ender 3 Pro 4040 Control-Box Beam
- Cross-section: 40 × 40 mm
- Front end face: 2× M5 threaded holes at (10,10) and (30,30) mm from corner
- Hole spacing: 20 mm in X, 20 mm in Z (diagonal 28.3 mm)
- Existing screws hold the stock control box front panel — replace with longer M5 flat-heads that pass through the OctoMount base plate + original plastic panel → into beam

### SD Card Extension (AliExpress item 2255801037535913)
- Type: microSD male plug → full-size SD card female socket, panel-mount
- Socket end: flush-mounted on left wall of base
- Lengths typically available: 15 cm / 48 cm — **measure routing path before ordering**
- Full-size SD socket panel cutout: ~32 × 3 mm slot — **verify against physical unit**

### Buck Converter (LM2596 + voltmeter, Temu goods_id 601099525293943)
- Input: 4–40V DC (Ender 3 Pro 24V PSU)
- Output: 1.25–37V DC adjustable — set to 5V for RPi 4B
- Max current: 3A
- PCB dimensions: ~48 × 23 × 14 mm — **measure physical unit before CAD**
- Heatsink: adhesive ~14 × 14 mm aluminum pad on LM2596 IC
