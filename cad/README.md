# OctoMount — CAD Files

All source models are written in **OpenSCAD** (parametric, text-based CAD).

## Install OpenSCAD

Download the latest stable release from <https://openscad.org/downloads.html>
(Windows / macOS / Linux — free, open source)

## File overview

| File | Description | Render to get… |
|---|---|---|
| `params.scad` | All dimensions + derived values + shared modules | *(not a standalone part)* |
| `assembly.scad` | All parts positioned together | Full assembly preview |
| `p1_enclosure.scad` | Main body shell | `OctoMount_enclosure.stl` |
| `p2_bracket.scad` | 2020 extrusion clamp + tilted arm | `OctoMount_bracket.stl` |
| `p3_bezel.scad` | LCD front bezel + stylus clip | `OctoMount_bezel.stl` |
| `p4_rear_panel.scad` | Rear panel with hex vent cutouts | `OctoMount_rear_panel.stl` |
| `p5_buck_tray.scad` | Buck converter retention tray | `OctoMount_buck_tray.stl` |

## How to render a part

1. Open the `.scad` file in OpenSCAD
2. Press **F5** for a fast preview, or **F6** for a full render
3. Check the **Console** tab at the bottom — no errors means the geometry is valid
4. Export: **File → Export → Export as STL…** → save to `../stl/`

## How to render the assembly

1. Open `assembly.scad`
2. Press **F5** (preview) — colour-coded parts help distinguish components
3. Set `EXPLODE = 1;` at the top of the file for an exploded view, then press F5 again

## Iterating on dimensions

All dimensions live in **`params.scad`**.
- Items marked `// TBD` must be confirmed against the physical hardware before printing
- Edit the relevant parameter value, save, and press F5 in OpenSCAD to see the change
- No other files need changing for pure dimension tweaks

## Which file to open for each change

| Change type | File to edit |
|---|---|
| Hardware dimensions, clearances | `params.scad` |
| New openings, port positions, cavity shape | `p1_enclosure.scad` |
| Bracket tilt angle, clamp depth, arm length | `p2_bracket.scad` |
| Bezel border width, stylus clip profile | `p3_bezel.scad` |
| Vent pattern size/density, voltmeter window | `p4_rear_panel.scad` |
| Buck tray inner dimensions, wire holes | `p5_buck_tray.scad` |

## Print settings (recommended)

- Material: **PETG** (heat resistant near printer, good layer adhesion)
- Layer height: 0.2 mm
- Walls: 3 perimeters
- Infill: 30 % gyroid
- Supports: only on bracket arm overhang if TILT > 45°

## TBD items (measure before final print)

See `params.scad` — every line marked `// TBD` needs physical measurement:

- LCD PCB outer dimensions (`LCD_PCB_X`, `LCD_PCB_Z`, `LCD_T`)
- RPi 4B total thickness with heatsinks (`RPI_T`)
- Fan size and thickness (`FAN_SIZE`, `FAN_T`)
- Buck converter PCB dimensions (`BUCK_L`, `BUCK_H`, `BUCK_W`)
- All port centre positions on RPi (`RPI_ETH_Z`, `RPI_USBC_Z`, etc.)
- Stylus diameter (`STYLUS_D`)
- SD extension slot opening size (`SD_SLOT_W`, `SD_SLOT_H`)
