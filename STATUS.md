# Project Status

**Last Updated:** 2026-03-04
**Current Phase:** CAD Design (2-piece redesign)

---

## Design Pivot — 2026-03-04

The original 5-piece design (enclosure body + bezel + bracket arm + rear panel + buck tray) has been replaced with a **2-piece design**:

- **Base** — single printed part: mounting plate + arm shelf + enclosure walls + RPi standoff bosses + left-wall SD slot + internal buck converter mount
- **Cover** — angled lid with 45° front-top face; houses the LCD window; attaches to Base with 4× M3 screws

Key changes from original design:
- Mounting: M5 flat-head screws into 4040 beam end face (replaces 2020 T-slot clamp)
- LCD tilt: maximised — back wall at 48 mm (hard limit), front wall at minimum height above flat RPi stack; angle derived from geometry, not fixed at 45°
- USB-A: exits back wall to Ender 3 Pro mainboard (not top face)
- USB-C: enters right-bottom corner via 4040 T-slot channel
- Buck converter: inside base body with adhesive heatsink (no separate tray part)
- Removed: stylus clip, separate bezel (P3), rear panel (P4), buck tray (P5)

Old 5-piece OpenSCAD files remain in `cad/` as reference but are superseded.

---

## Phase Overview

| Phase | Name | Status |
|---|---|---|
| 1 | Planning & Requirements | Complete |
| 2 | CAD Design | In Progress |
| 3 | Prototype Print | Not Started |
| 4 | Fit & Function Testing | Not Started |
| 5 | Revision & Polish | Not Started |
| 6 | Documentation & Release | Not Started |

---

## Phase 1 — Planning & Requirements

- [x] Define hardware components (RPi 4B + MPI4008 + Ender 3 Pro)
- [x] Document design requirements (see REQUIREMENTS.md)
- [x] Gather hardware reference dimensions
- [x] Define bill of materials (see PARTS.md)
- [x] Select CAD tool → **OpenSCAD** (parametric, Claude-editable .scad files)
- [x] Confirm mounting location → 4040 control-box beam end face (2× M5 diagonal screws)
- [x] Confirm design architecture → 2-piece: Base + Cover
- [ ] Measure integrated fan size and orientation (MPI4008 kit)
- [ ] Measure buck converter PCB dimensions (physical unit)
- [ ] Confirm SD extension cable length against routing path

---

## Phase 2 — CAD Design

### Superseded (5-piece) — kept for reference only
- [x] p1_enclosure.scad — original enclosure body
- [x] p2_bracket.scad — original 2020 T-slot bracket arm
- [x] p3_bezel.scad — original LCD bezel with stylus clip
- [x] p4_rear_panel.scad — original rear panel with hex vents
- [x] p5_buck_tray.scad — original buck converter tray

### 2-Piece Redesign (active)
- [ ] Redesign Base in OpenSCAD: plate + arm shelf + walls + RPi bosses + SD slot + buck mount
- [ ] Redesign Cover in OpenSCAD: angled lid (45° face) + LCD window cutout + M3 attachment points
- [ ] Add openings: USB-A back wall, USB-C right-bottom corner, SD left wall
- [ ] Confirm all TBD dimensions against physical hardware before export
- [ ] Iterate port positions from first prototype print
- [ ] Export STLs for prototype print

---

## Phase 3 — Prototype Print

- [ ] Print Base
- [ ] Print Cover
- [ ] Dry-fit assembly (no hardware)

---

## Phase 4 — Fit & Function Testing

- [ ] Test RPi 4B seating and standoff alignment
- [ ] Test LCD fit and cover clearance
- [ ] Test M5 mounting to 4040 beam end face
- [ ] Test port access (SD left wall, USB-A back wall, USB-C right-bottom corner)
- [ ] Test USB cable routing from Ender 3 Pro mainboard through back wall
- [ ] Test SD extension cable reach and routing
- [ ] Test fan airflow through ventilation openings
- [ ] Test thermal performance under OctoPrint load
- [ ] Test vibration resistance during a print job
- [ ] Verify assembly clears printer bed Y-axis travel and X-axis gantry wheels

---

## Phase 5 — Revision & Polish

- [ ] Address any fit issues from Phase 4
- [ ] Final surface / aesthetic refinements
- [ ] Finalize print settings recommendation

---

## Phase 6 — Documentation & Release

- [ ] Finalize assembly guide (docs/ASSEMBLY.md) with photos and wiring diagram
- [ ] Add renders to img/
- [ ] Publish STL files to stl/
- [ ] Write OctoPrint + MPI4008 software setup guide
- [ ] Update PARTS.md with final confirmed part specs
- [ ] Tag v1.0 release on GitHub

---

## Issues & Blockers

| # | Description | Status |
|---|---|---|
| 1 | Fan size and orientation (MPI4008 kit) not yet measured — needed before enclosure depth is final | Open |
| 2 | Buck converter PCB dimensions not yet confirmed — needed before base cavity sizing | Open |
| 3 | SD extension cable length not yet verified against routing path | Open |
| 4 | M5 screw length depends on physical control box panel thickness — measure before ordering | Open |

---

## Notes

- MPI4008 stacks directly onto RPi GPIO — combined stack height drives enclosure internal Z.
- Integrated fan sits in the gap between LCD board and RPi — measure size and orientation before CAD.
- Power: 24V PSU → LM2596 buck converter (inside Base, adhesive heatsink) → 5V USB-C → RPi 4B.
- PETG strongly recommended over PLA due to heat from the printer environment.
