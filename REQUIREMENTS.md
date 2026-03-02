# Design Requirements

## REQ-001 — Hardware Compatibility

| ID | Requirement | Priority |
|---|---|---|
| REQ-001.1 | Enclosure must fit Raspberry Pi 4B (85 × 56 × 17 mm) with clearance | MUST |
| REQ-001.2 | Front face must accommodate MPI4008 LCD (143 × 134 mm panel area) | MUST |
| REQ-001.3 | Mount must attach to 2020 V-slot aluminum extrusion (Ender 3 Pro frame) | MUST |
| REQ-001.4 | USB-C power port on RPi must remain accessible | MUST |
| REQ-001.5 | Enclosure must have a cable exit opening sized for a USB-A plug to route from the RPi to the Ender 3 Pro front USB port | MUST |
| REQ-001.6 | USB cable from RPi to Ender 3 Pro must exit toward the front/bottom of the enclosure to align with the printer's front USB port | MUST |
| REQ-001.7 | RPi 4B microSD slot must be accessible from outside the enclosure without disassembly | MUST |
| REQ-001.8 | Micro HDMI port on RPi must be routed to the LCD internally | MUST |
| REQ-001.9 | MPI4008 GPIO 13×2 header connection to RPi must be accommodated | MUST |
| REQ-001.10 | MPI4008 backlight button must remain accessible | SHOULD |
| REQ-001.11 | MPI4008 3.5mm audio jack access is optional | NICE-TO-HAVE |
| REQ-001.12 | Enclosure must include a full-size SD card slot (female) connected via a microSD male → SD female extension cable (AliExpress item 2255801037535913) to the Ender 3 Pro's microSD slot | MUST |
| REQ-001.13 | SD extension cable must reach from the Ender 3 Pro motherboard SD slot to the enclosure without tension — cable length to be verified against routing path before ordering | MUST |
| REQ-001.14 | SD extension cable must be routed internally and strain-relieved at both ends | MUST |

---

## REQ-002 — Structural & Mounting

| ID | Requirement | Priority |
|---|---|---|
| REQ-002.1 | Must mount to the left front vertical upright of the Ender 3 Pro (2020 extrusion) | MUST |
| REQ-002.2 | Mount must withstand vibration during printing without loosening | MUST |
| REQ-002.3 | Fasteners must use standard M3 screws and M3 2020 T-slot nuts (no glue) | MUST |
| REQ-002.4 | LCD must face the user (front-facing when standing at the printer) | MUST |
| REQ-002.5 | Mount height should position LCD at a comfortable viewing angle (~elbow height) | SHOULD |
| REQ-002.6 | Enclosure must support the combined weight of RPi 4B + LCD without flex | MUST |
| REQ-002.7 | Assembly must be tilted toward the user for comfortable touchscreen operation | MUST |
| REQ-002.8 | Assembly must not protrude into the path of the printer bed (Y-axis travel) | MUST |
| REQ-002.9 | Assembly must not obstruct the X-axis gantry wheels or carriage movement | MUST |
| REQ-002.10 | Full-size SD card slot must be positioned on the left side of the enclosure | MUST |
| REQ-002.11 | SD card slot opening must allow card insertion/removal with one hand | MUST |
| REQ-002.12 | Enclosure must include a stylus clip or slot on the side of the LCD bezel for stylus storage | MUST |
| REQ-002.13 | Stylus clip/slot must retain the stylus securely during printing vibration without permanent fasteners | MUST |
| REQ-002.14 | Stylus clip/slot must allow one-handed removal and re-insertion of the stylus | SHOULD |

---

## REQ-003 — Power

| ID | Requirement | Priority |
|---|---|---|
| REQ-003.1 | Assembly must draw power from the Ender 3 Pro PSU (24V DC) — no separate wall adapter | MUST |
| REQ-003.2 | Buck converter model: LM2596-based adjustable step-down module with LED voltmeter (Temu goods_id 601099525293943) | MUST |
| REQ-003.3 | Buck converter input: 4–40V DC; must be set to output 5V DC for RPi 4B | MUST |
| REQ-003.4 | Buck converter output must supply at least 3A continuous (RPi 4B max draw ~3A) | MUST |
| REQ-003.5 | Enclosure must provide a dedicated bay or bracket for the buck converter module | MUST |
| REQ-003.6 | Buck converter voltmeter display must be visible or accessible for output voltage verification | SHOULD |
| REQ-003.7 | 24V tap must be taken from a dedicated terminal on the PSU or a safe splice point | MUST |
| REQ-003.8 | Wiring must include a fuse or polyfuse on the 24V input line | SHOULD |
| REQ-003.9 | 5V output must connect to RPi via USB-C connector (not GPIO pins) | MUST |

---

## REQ-004 — Thermal Management

> Note: The MPI4008 + RPi 4B kit includes a fan mounted between the two modules. The enclosure must accommodate active airflow from this integrated fan, not just passive ventilation.

| ID | Requirement | Priority |
|---|---|---|
| REQ-004.1 | Enclosure must provide clearance for the integrated fan mounted between the LCD and RPi 4B modules | MUST |
| REQ-004.2 | Enclosure must have ventilation openings aligned with the fan's intake and exhaust paths to allow unobstructed airflow | MUST |
| REQ-004.3 | Ventilation opening area must be sufficient to not back-pressure the integrated fan (total open area ≥ fan blade swept area) | MUST |
| REQ-004.4 | Heatsinks on RPi 4B CPU/RAM must have clearance inside the enclosure | MUST |
| REQ-004.5 | Enclosure must not trap heat near the Ender 3 Pro heated bed or hotend | MUST |
| REQ-004.6 | Ventilation openings should incorporate a dust filter screen to protect the RPi and fan from print debris | SHOULD |
| REQ-004.7 | Dust filter may be permanently integrated — cleaning by vacuuming through the vent is acceptable | MUST |
| REQ-004.8 | Dust filter mesh size should be fine enough to block 3D printing particulates while maintaining adequate airflow | SHOULD |

---

## REQ-005 — Printability

| ID | Requirement | Priority |
|---|---|---|
| REQ-005.1 | All parts must be printable on an Ender 3 Pro (235 × 235 × 250 mm build volume) | MUST |
| REQ-005.2 | No part should require supports on critical interface surfaces | SHOULD |
| REQ-005.3 | Minimum wall thickness: 2mm (3mm preferred for structural walls) | MUST |
| REQ-005.4 | Design in at least two parts: enclosure body + lid (or front + back) | MUST |
| REQ-005.5 | Recommended print material: PETG (heat resistant, durable) | SHOULD |

---

## REQ-006 — Assembly & Serviceability

| ID | Requirement | Priority |
|---|---|---|
| REQ-006.1 | RPi must be removable without tools or with only a screwdriver | SHOULD |
| REQ-006.2 | LCD must be replaceable independently of the enclosure body | SHOULD |
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
- Mounting holes: 3.5mm dia., 58 × 49mm pattern (M2.5 standoffs)

### MPI4008 LCD Module
- Overall: 143 × 134 × 51 mm (including RPi when stacked)
- Display active area: ~87 × 52 mm (4.0" diagonal)
- GPIO header: 13×2, standard 2.54mm pitch
- Integrated fan: mounted in the sandwich gap between LCD board and RPi 4B — **measure fan size and orientation before CAD** (likely 30×30mm or 40×40mm)

### Ender 3 Pro Frame
- Extrusion profile: 2020 V-slot aluminum
- T-slot width: 6mm
- Standard T-nut: M3, 6mm slot
- PSU output: 24V DC

### SD Card Extension (AliExpress item 2255801037535913)
- Type: microSD male plug → full-size SD card female socket, panel-mount
- Plug end: inserts into Ender 3 Pro motherboard microSD slot
- Socket end: full-size SD card female, flush-mounted on left side of enclosure
- Cable lengths typically available: 15 cm / 48 cm — **measure routing path and confirm length before CAD**
- Full-size SD socket panel cutout: ~32 × 3 mm slot (standard SD form factor — **verify against physical unit**)
- Ender 3 Pro microSD slot location: right side of mainboard, inside the electronics bay

### Stylus
- Intended for use with MPI4008 resistive touchscreen
- Typical resistive touch stylus dimensions: ~105 mm length, ~8–9 mm diameter — **measure actual stylus before CAD**
- Clip/slot to be integrated into the LCD bezel side wall

### Buck Converter (LM2596 + voltmeter, Temu goods_id 601099525293943)
- Input: 4–40V DC (will run on Ender 3 Pro 24V PSU)
- Output: 1.25–37V DC adjustable — set to 5V for RPi 4B
- Max output current: 3A
- PCB dimensions: ~48 × 23 × 14 mm (LM2596 with voltmeter standard footprint — **measure physical unit before CAD**)
