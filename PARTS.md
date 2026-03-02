# Parts List / Bill of Materials

**Project:** OctoMount — RPi 4B + MPI4008 LCD enclosure for Ender 3 Pro
**Last Updated:** 2026-03-02

Legend: ✅ On hand / ordered &nbsp;|&nbsp; 🛒 Needs to be purchased &nbsp;|&nbsp; 🖨️ 3D printed

---

## 1. Core Electronics

| # | Item | Spec | Source | Status | Notes |
|---|---|---|---|---|---|
| 1 | Raspberry Pi 4B | 2GB / 4GB / 8GB | — | ✅ | Running OctoPi |
| 2 | MPI4008 LCD Kit | 4" HDMI, 800×480, resistive touch, w/ integrated fan | LCDwiki / Miuzei | ✅ | Includes GPIO stacking header and fan |
| 3 | Buck converter | LM2596 adjustable step-down w/ LED voltmeter | Temu (goods_id 601099525293943) | ✅ | Set output to 5V |
| 4 | SD card extension | microSD male → full-size SD female, panel-mount | AliExpress (item 2255801037535913) | ✅ | Verify cable length before routing |

---

## 2. Cables & Connectors

| # | Item | Spec | Source | Status | Notes |
|---|---|---|---|---|---|
| 5 | USB-A to micro-USB cable | Short, ~30 cm | Amazon / local | 🛒 | RPi USB-A → Ender 3 Pro front USB port |
| 6 | USB-C pigtail / breakout | USB-C male plug with bare wire ends, 5V/3A rated | Amazon / AliExpress | 🛒 | Buck converter 5V output → RPi USB-C power in |
| 7 | 24V tap wire | 22 AWG stranded, red + black, ~50 cm | Local electronics | 🛒 | PSU terminal → buck converter input |
| 8 | Wire ferrules or spade terminals | For PSU terminal connections | Local electronics | 🛒 | Crimped connection to PSU screw terminals |

---

## 3. Protection & Power Safety

| # | Item | Spec | Source | Status | Notes |
|---|---|---|---|---|---|
| 9 | Polyfuse (resettable fuse) | 24V, 1A hold / 2A trip, inline | DigiKey / Mouser | 🛒 | On 24V input line before buck converter |
| 10 | Heat shrink tubing | Assorted 2–6 mm | Local | 🛒 | Insulate all bare wire splices |

---

## 4. Fasteners & Hardware

| # | Item | Spec | Qty | Source | Status | Notes |
|---|---|---|---|---|---|---|
| 11 | M3 × 8mm socket head screws | DIN 912 | 8 | Local / Amazon | 🛒 | Enclosure assembly |
| 12 | M3 × 12mm socket head screws | DIN 912 | 4 | Local / Amazon | 🛒 | Bracket to extrusion |
| 13 | M3 × 16mm socket head screws | DIN 912 | 4 | Local / Amazon | 🛒 | Buck converter mount, misc |
| 14 | M3 T-slot nuts | 2020 V-slot, spring-loaded or hammer | 4 | Amazon / AliExpress | 🛒 | Frame mounting |
| 15 | M3 hex nuts | Standard | 8 | Local | 🛒 | General assembly |
| 16 | M2.5 × 6mm screws + nuts | — | 4+4 | Local / Amazon | 🛒 | RPi 4B PCB standoff mounting |
| 17 | M2.5 × 5mm brass standoffs (F-F) | — | 4 | Amazon / AliExpress | 🛒 | RPi PCB raised off enclosure floor |

---

## 5. Filtration & Finishing

| # | Item | Spec | Source | Status | Notes |
|---|---|---|---|---|---|
| 18 | Dust filter mesh | Fine nylon or foam sheet, ~100 × 100 mm | Amazon / AliExpress | 🛒 | Cut to fit ventilation openings; permanently glued in |
| 19 | Micro SD card | 16GB+ Class 10 / A1 | Amazon | 🛒 | RPi OS (OctoPi image) |
| 20 | Stylus pen | Resistive touch, ~105 mm × 8–9 mm | Included with MPI4008 kit or Amazon | ✅ / 🛒 | Check if included with LCD kit |

---

## 6. 3D Printed Parts

> STL files will be published in `/stl` once CAD is complete.

| # | Part | Material | Est. Print Time | Notes |
|---|---|---|---|---|
| P1 | Main enclosure body | PETG | TBD | Houses RPi+LCD assembly and buck converter |
| P2 | 2020 extrusion bracket | PETG | TBD | Clamps to left front vertical upright; angled for tilt |
| P3 | LCD front bezel / frame | PETG | TBD | Frames MPI4008 display; includes stylus clip slot on side |
| P4 | Rear panel / lid | PETG | TBD | Closes enclosure; ventilation openings with dust filter |
| P5 | Buck converter tray | PETG | TBD | Retention bracket inside enclosure for LM2596 module |

---

## Summary

| Category | Items | Estimated Cost |
|---|---|---|
| Core electronics | 4 items | Already ordered / on hand |
| Cables & connectors | 4 items | ~$10–15 |
| Protection & safety | 2 items | ~$5 |
| Fasteners | 7 items | ~$10–15 |
| Filtration & finishing | 3 items | ~$5–10 |
| 3D printed parts | 5 parts | Filament only (~$3–5) |

> Cost estimates are approximate. Verify prices at time of purchase.
