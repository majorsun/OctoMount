# Design Requirements

## REQ-001 — Hardware Compatibility

| ID | Requirement | Priority |
|---|---|---|
| REQ-001.1 | Enclosure must fit Raspberry Pi 4B (85 × 56 × 17 mm) with clearance | MUST |
| REQ-001.2 | Front face must accommodate MPI4008 LCD (143 × 134 mm panel area) | MUST |
| REQ-001.3 | Mount must attach to 2020 V-slot aluminum extrusion (Ender 3 Pro frame) | MUST |
| REQ-001.4 | USB-C power port on RPi must remain accessible | MUST |
| REQ-001.5 | USB-A ports (at least 1) must remain accessible for USB-B printer cable | MUST |
| REQ-001.6 | Micro HDMI port on RPi must be routed to the LCD internally | MUST |
| REQ-001.7 | MPI4008 GPIO 13×2 header connection to RPi must be accommodated | MUST |
| REQ-001.8 | MPI4008 backlight button must remain accessible | SHOULD |
| REQ-001.9 | MPI4008 3.5mm audio jack access is optional | NICE-TO-HAVE |

---

## REQ-002 — Structural & Mounting

| ID | Requirement | Priority |
|---|---|---|
| REQ-002.1 | Must mount securely to the Ender 3 Pro left vertical upright (2020 extrusion) | MUST |
| REQ-002.2 | Mount must withstand vibration during printing without loosening | MUST |
| REQ-002.3 | Fasteners must use standard M3 screws and M3 2020 T-slot nuts (no glue) | MUST |
| REQ-002.4 | LCD must face the user (front-facing when standing at the printer) | MUST |
| REQ-002.5 | Mount height should position LCD at a comfortable viewing angle (~elbow height) | SHOULD |
| REQ-002.6 | Enclosure must support the combined weight of RPi 4B + LCD without flex | MUST |

---

## REQ-003 — Thermal Management

| ID | Requirement | Priority |
|---|---|---|
| REQ-003.1 | Enclosure must include ventilation slots or openings for passive airflow | MUST |
| REQ-003.2 | Design must allow a 30mm or 40mm fan to be optionally mounted | SHOULD |
| REQ-003.3 | Heatsinks on RPi 4B CPU/RAM must have clearance inside the enclosure | MUST |
| REQ-003.4 | Enclosure must not trap heat near the Ender 3 Pro heated bed or hotend | MUST |

---

## REQ-004 — Printability

| ID | Requirement | Priority |
|---|---|---|
| REQ-004.1 | All parts must be printable on an Ender 3 Pro (235 × 235 × 250 mm build volume) | MUST |
| REQ-004.2 | No part should require supports on critical interface surfaces | SHOULD |
| REQ-004.3 | Minimum wall thickness: 2mm (3mm preferred for structural walls) | MUST |
| REQ-004.4 | Design in at least two parts: enclosure body + lid (or front + back) | MUST |
| REQ-004.5 | Recommended print material: PETG (heat resistant, durable) | SHOULD |

---

## REQ-005 — Assembly & Serviceability

| ID | Requirement | Priority |
|---|---|---|
| REQ-005.1 | RPi must be removable without tools or with only a screwdriver | SHOULD |
| REQ-005.2 | LCD must be replaceable independently of the enclosure body | SHOULD |
| REQ-005.3 | Assembly must be completable by a maker with basic tools | MUST |
| REQ-005.4 | Provide assembly documentation with the design files | SHOULD |

---

## REQ-006 — Aesthetics

| ID | Requirement | Priority |
|---|---|---|
| REQ-006.1 | Design should be clean and intentional, not purely functional | NICE-TO-HAVE |
| REQ-006.2 | Branding / logo emboss on exterior is optional | NICE-TO-HAVE |
| REQ-006.3 | Cable routing should be hidden where possible | SHOULD |

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

### Ender 3 Pro Frame
- Extrusion profile: 2020 V-slot aluminum
- T-slot width: 6mm
- Standard T-nut: M3, 6mm slot
