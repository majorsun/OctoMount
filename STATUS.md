# Project Status

**Last Updated:** 2026-03-02
**Current Phase:** Planning

---

## Phase Overview

| Phase | Name | Status |
|---|---|---|
| 1 | Planning & Requirements | In Progress |
| 2 | CAD Design | Not Started |
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
- [x] Draft assembly instructions skeleton (see docs/ASSEMBLY.md)
- [ ] Select CAD tool (FreeCAD / Fusion 360 / OpenSCAD)
- [ ] Sketch initial concept / layout
- [ ] Confirm mounting location on Ender 3 Pro frame
- [ ] Measure integrated fan size and orientation (MPI4008 kit)
- [ ] Measure buck converter PCB dimensions (physical unit)
- [ ] Measure stylus diameter (physical unit)
- [ ] Confirm SD extension cable length against routing path

---

## Phase 2 — CAD Design

- [ ] Model RPi 4B reference body
- [ ] Model MPI4008 LCD + fan reference body
- [ ] Design enclosure body (P1) — RPi bay, buck converter tray, cable channels
- [ ] Design LCD front bezel (P3) — display cutout, stylus clip slot
- [ ] Design 2020 extrusion bracket (P2) — tilted mount, T-slot clamp
- [ ] Design rear panel (P4) — ventilation openings sized for fan, dust filter seat
- [ ] Design buck converter tray (P5)
- [ ] Add openings: USB-A cable exit, RPi microSD access, full-size SD slot, USB-C
- [ ] Export STLs for prototype print

---

## Phase 3 — Prototype Print

- [ ] Print enclosure body
- [ ] Print LCD frame
- [ ] Print mounting bracket
- [ ] Assemble dry-fit (no hardware)

---

## Phase 4 — Fit & Function Testing

- [ ] Test RPi 4B seating and standoff alignment
- [ ] Test LCD fit and bezel clearance
- [ ] Test 2020 extrusion clamp fit, tilt angle, and stability
- [ ] Test port access (USB-C, USB-A, RPi microSD, full-size SD slot)
- [ ] Test USB cable routing to Ender 3 Pro front USB port
- [ ] Test SD extension cable reach and routing
- [ ] Test stylus clip retention and removal
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
- [ ] Publish all STL files to stl/
- [ ] Write OctoPrint + MPI4008 software setup guide
- [ ] Update PARTS.md with final confirmed part specs and quantities
- [ ] Tag v1.0 release on GitHub

---

## Issues & Blockers

| # | Description | Status |
|---|---|---|
| — | No issues yet | — |

---

## Notes

- MPI4008 stacks directly onto RPi GPIO — the combined module dimension (143 × 134 × 51 mm) drives the minimum enclosure footprint.
- Integrated fan sits in the sandwich gap between LCD and RPi — size and orientation TBD (measure before CAD).
- Ender 3 Pro left front vertical upright is the mount location; assembly tilted toward operator.
- Power: 24V PSU → LM2596 buck converter → 5V USB-C → RPi 4B. Verify output voltage before first power-on.
- PETG strongly recommended over PLA due to heat from the printer environment.
- Dust filter is permanently glued to ventilation openings — cleaned by vacuuming.
