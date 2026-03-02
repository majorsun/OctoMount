# OctoMount

A 3D-printable mounting enclosure that attaches a **Raspberry Pi 4B** with **MPI4008 4" LCD touchscreen** to an **Ender 3 Pro** 3D printer frame.

Designed for use with [OctoPrint](https://octoprint.org/) — giving you a compact, integrated control panel mounted directly on your printer.

---

## Hardware

| Component | Model | Notes |
|---|---|---|
| Single Board Computer | Raspberry Pi 4B | 2GB/4GB/8GB variants |
| Display | MPI4008 (LCDwiki 4" HDMI Display-C) | 800×480 IPS, resistive touch |
| Printer | Creality Ender 3 Pro | 2020 V-slot aluminum extrusion frame |

### MPI4008 Display Specs

- **Size:** 4.0 inch IPS
- **Resolution:** 800 × 480
- **Touch:** 4-wire resistive
- **Interface:** HDMI (video) + 13×2 GPIO header (power + touch)
- **Module dimensions:** 143 × 134 × 51 mm

### Raspberry Pi 4B Specs

- **Dimensions:** 85 × 56 × 17 mm
- **Ports used:** HDMI micro (to LCD), USB-A (printer connection), USB-C (power)

---

## Project Goals

- [ ] Design a 3D-printable enclosure housing the RPi 4B + MPI4008 LCD + buck converter
- [ ] Mount to the Ender 3 Pro left front vertical extrusion, tilted toward the operator
- [ ] Power from the Ender 3 Pro 24V PSU via LM2596 buck converter (→ 5V for RPi)
- [ ] Expose full-size SD slot (extended from Ender 3 Pro microSD) on left side
- [ ] Expose RPi microSD slot and USB-A port for printer USB cable
- [ ] Include stylus clip/slot on LCD bezel side
- [ ] Integrated fan ventilation with permanent dust filter mesh

---

## Deliverables

| File | Description | Status |
|---|---|---|
| `PARTS.md` | Full bill of materials — parts to buy + 3D printed parts list | ✅ Draft |
| `stl/` | 3D print files for all enclosure parts (5 parts) | 🔄 Pending CAD |
| `docs/ASSEMBLY.md` | Enclosure diagram + step-by-step assembly instructions | ✅ Draft |
| `img/wiring_diagram.png` | Wiring diagram (PSU → buck converter → RPi) | 🔄 Pending |
| `img/renders/` | CAD renders of final enclosure | 🔄 Pending CAD |

---

## 3D Printed Parts

| Part | Description |
|---|---|
| P1 | Main enclosure body |
| P2 | 2020 extrusion bracket (tilted) |
| P3 | LCD front bezel (with stylus clip) |
| P4 | Rear panel / lid (with filtered vents) |
| P5 | Buck converter tray |

---

## Repository Structure

```
OctoMount/
├── README.md
├── REQUIREMENTS.md        # Full design requirements
├── STATUS.md              # Project phase tracker
├── PARTS.md               # Bill of materials
├── cad/                   # Source CAD files (FreeCAD / Fusion 360)
├── stl/                   # Export-ready STL files for printing
│   ├── P1_enclosure_body.stl
│   ├── P2_bracket.stl
│   ├── P3_lcd_bezel.stl
│   ├── P4_rear_panel.stl
│   └── P5_buck_tray.stl
├── docs/
│   └── ASSEMBLY.md        # Enclosure diagram + assembly instructions
└── img/                   # Renders, wiring diagram, photos
```

---

## Software

This mount is designed for use with:
- [OctoPrint](https://octoprint.org/) — web-based 3D printer control
- [OctoPi](https://github.com/guysoft/OctoPi) — Raspberry Pi OS image with OctoPrint pre-installed
- [LCD driver (goodtft)](https://github.com/goodtft/LCD-show) — MPI4008 display driver

---

## Printing Notes

> Print settings and recommended materials will be added as the design is finalized.

- Material: PETG recommended (heat resistance near printer)
- Layer height: 0.2mm
- Infill: 30%+
- Supports: Required for overhangs

---

## License

[MIT](LICENSE) — free to use, modify, and share.
