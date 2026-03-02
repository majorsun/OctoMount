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
- [ ] Select CAD tool (FreeCAD / Fusion 360 / OpenSCAD)
- [ ] Sketch initial concept / layout
- [ ] Confirm mounting location on Ender 3 Pro frame

---

## Phase 2 — CAD Design

- [ ] Model RPi 4B reference body
- [ ] Model MPI4008 LCD reference body
- [ ] Design enclosure body
- [ ] Design LCD front bezel / frame
- [ ] Design 2020 extrusion bracket / clamp
- [ ] Design lid or rear panel
- [ ] Integrate ventilation features
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
- [ ] Test 2020 extrusion clamp fit and stability
- [ ] Test port access (USB-C, USB-A, micro HDMI)
- [ ] Test thermal performance under OctoPrint load
- [ ] Test vibration resistance during a print job

---

## Phase 5 — Revision & Polish

- [ ] Address any fit issues from Phase 4
- [ ] Final surface / aesthetic refinements
- [ ] Finalize print settings recommendation

---

## Phase 6 — Documentation & Release

- [ ] Write assembly guide
- [ ] Add photos / renders to docs/
- [ ] Publish STLs
- [ ] Write OctoPrint + MPI4008 software setup guide
- [ ] Tag v1.0 release on GitHub

---

## Issues & Blockers

| # | Description | Status |
|---|---|---|
| — | No issues yet | — |

---

## Notes

- MPI4008 stacks directly onto RPi GPIO — the combined module dimension (143 × 134 × 51 mm) drives the minimum enclosure footprint.
- Ender 3 Pro left vertical upright is the preferred mount location for operator-facing access.
- PETG strongly recommended over PLA due to heat from the printer environment.
