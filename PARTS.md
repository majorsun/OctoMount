# Parts List / Bill of Materials

**Project:** OctoMount — RPi 4B + MPI4008 LCD enclosure for Ender 3 Pro
**Last Updated:** 2026-03-04
**Design:** 2-piece (Base + Cover)

Legend: ✅ On hand / ordered &nbsp;|&nbsp; 🛒 Needs to be purchased &nbsp;|&nbsp; 🖨️ 3D printed

---

## 1. Core Electronics

| # | Item | Spec | Source | Status | Notes |
|---|---|---|---|---|---|
| 1 | Raspberry Pi 4B | 2GB / 4GB / 8GB | — | ✅ | Running OctoPi |
| 2 | MPI4008 LCD Kit | 4" HDMI, 800×480, resistive touch, w/ integrated fan | LCDwiki / Miuzei | ✅ | Includes GPIO stacking header and fan |
| 3 | Buck converter | LM2596 adjustable step-down w/ LED voltmeter | Temu (goods_id 601099525293943) | ✅ | Set output to 5V |
| 4 | SD card extension | microSD male → full-size SD female, panel-mount | AliExpress (item 2255801037535913) | ✅ | Verify cable length before routing |
| 5 | LM2596 adhesive heatsink | ~14 × 14 mm aluminum thermal pad, self-adhesive | AliExpress / Amazon | 🛒 | Sticks to LM2596 IC on buck converter PCB |

---

## 2. Cables & Connectors

| # | Item | Spec | Source | Status | Notes |
|---|---|---|---|---|---|
| 6 | USB-A extension / short cable | USB-A male → USB-A female or short patch, ~20–30 cm | Amazon / local | 🛒 | Routes from Ender 3 Pro control box mainboard USB → RPi USB-A through back wall |
| 7 | USB-C pigtail / breakout | USB-C male plug with bare wire ends, 5V/3A rated | Amazon / AliExpress | 🛒 | Buck converter 5V output → RPi USB-C power in |
| 8 | 24V tap wire | 22 AWG stranded, red + black, ~50 cm | Local electronics | 🛒 | PSU terminal → buck converter input |
| 9 | Wire ferrules or spade terminals | For PSU terminal connections | Local electronics | 🛒 | Crimped connection to PSU screw terminals |

---

## 3. Protection & Power Safety

| # | Item | Spec | Source | Status | Notes |
|---|---|---|---|---|---|
| 10 | Polyfuse (resettable fuse) | 24V, 1A hold / 2A trip, inline | DigiKey / Mouser | 🛒 | On 24V input line before buck converter |
| 11 | Heat shrink tubing | Assorted 2–6 mm | Local | 🛒 | Insulate all bare wire splices |

---

## 4. Fasteners & Hardware

| # | Item | Spec | Qty | Source | Status | Notes |
|---|---|---|---|---|---|---|
| 12 | M5 flat-head screws | M5 × 12 mm countersunk (measure actual panel thickness before ordering) | 2 | Local / Amazon | 🛒 | Attach base plate to 4040 beam end face, replacing original control-box screws |
| 13 | M2.5 × 8 mm screws | Socket head or countersunk | 4 | Local / Amazon | 🛒 | RPi 4B PCB standoff mounting |
| 14 | M2.5 brass standoffs (M-F) | M2.5, ~5 mm height | 4 | Amazon / AliExpress | 🛒 | Raise RPi PCB off base floor |
| 15 | M3 screws for cover | M3 × 8 mm socket head | 4 | Local / Amazon | 🛒 | Attach Cover to Base |
| 16 | M3 heat-set inserts (optional) | M3, standard press-fit | 4 | Amazon / AliExpress | 🛒 | Optional: for M3 cover attachment into Base bosses |

---

## 5. Filtration & Finishing

| # | Item | Spec | Source | Status | Notes |
|---|---|---|---|---|---|
| 17 | Dust filter mesh | Fine nylon or foam sheet, ~100 × 100 mm | Amazon / AliExpress | 🛒 | Cut to fit ventilation openings; permanently glued in |
| 18 | Micro SD card | 16GB+ Class 10 / A1 | Amazon | 🛒 | RPi OS (OctoPi image) |

---

## 6. 3D Printed Parts

> STL files will be published in `/stl` once CAD redesign is complete.

| # | Part | Material | Est. Print Time | Notes |
|---|---|---|---|---|
| P1 | Base | PETG | TBD | Mounting plate + arm shelf + enclosure walls + RPi bosses + SD slot + buck cavity |
| P2 | Cover | PETG | TBD | Angled lid with 45° front-top face; LCD window cutout; attaches to Base with 4× M3 screws |

---

## Summary

| Category | Items | Estimated Cost |
|---|---|---|
| Core electronics | 5 items | Mostly on hand; ~$3–5 for heatsink |
| Cables & connectors | 4 items | ~$10–15 |
| Protection & safety | 2 items | ~$5 |
| Fasteners | 5 items | ~$8–12 |
| Filtration & finishing | 2 items | ~$3–5 |
| 3D printed parts | 2 parts | Filament only (~$2–3) |

> Cost estimates are approximate. Verify prices at time of purchase.
