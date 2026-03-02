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

- [ ] Design a box/enclosure that houses the RPi 4B
- [ ] Integrate a front-face mount for the MPI4008 LCD
- [ ] Mount to the Ender 3 Pro upright extrusion via 2020 T-slot bracket
- [ ] Provide ventilation for RPi cooling
- [ ] Route cables cleanly (HDMI, USB, power)
- [ ] Fully 3D-printable (no purchased hardware beyond M3 screws and T-nuts)

---

## Repository Structure

```
OctoMount/
├── README.md
├── REQUIREMENTS.md
├── STATUS.md
├── cad/                  # Source CAD files (FreeCAD / Fusion 360)
├── stl/                  # Export-ready STL files for printing
├── docs/                 # Photos, diagrams, assembly instructions
└── img/                  # Renders and reference images
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
