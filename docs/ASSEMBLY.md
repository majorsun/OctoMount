# Assembly Instructions

**Project:** OctoMount — RPi 4B + MPI4008 LCD enclosure for Ender 3 Pro
**Last Updated:** 2026-03-02
**Status:** Draft — pending CAD completion

> Diagrams and photos will be added to `/img` once the enclosure design is finalized.

---

## Enclosure Overview

```
  ┌─────────────────────────────────────────┐
  │           LCD BEZEL (front)             │
  │  ┌───────────────────────────────────┐  │
  │  │       MPI4008 4" Display          │  │
  │  │        (800 × 480, IPS)           │  │
  │  └───────────────────────────────────┘  │
  │                            [stylus slot]│
  └───────────────┬─────────────────────────┘
                  │  tilt bracket
  ┌───────────────┴─────────────────────────┐
  │           ENCLOSURE BODY                │
  │                                         │
  │  ┌──────────┐   fan (integrated)        │
  │  │ RPi 4B   │◄──────────────────────┐  │
  │  │  (PCB)   │                        │  │
  │  └──────────┘   ┌──────────────┐     │  │
  │                  │ Buck conv.   │     │  │
  │  [microSD slot]  │ LM2596+disp │     │  │
  │                  └──────────────┘     │  │
  │ LEFT SIDE:                            │  │
  │  [full-size SD slot]  [USB-A exit]    │  │
  │                                        │  │
  └───────────────┬────────────────[vents]─┘
                  │
  ┌───────────────┴──────┐
  │  2020 BRACKET        │  ← clamps to left front
  │  (tilted mount)      │    vertical extrusion
  └──────────────────────┘
```

---

## Part Identification

| Label | Part | Printed File |
|---|---|---|
| A | Main enclosure body | `P1_enclosure_body.stl` |
| B | 2020 extrusion bracket | `P2_bracket.stl` |
| C | LCD front bezel | `P3_lcd_bezel.stl` |
| D | Rear panel / lid | `P4_rear_panel.stl` |
| E | Buck converter tray | `P5_buck_tray.stl` |

---

## Tools Required

- Phillips / flathead screwdriver
- 2.5 mm hex key (M3 socket screws)
- 2 mm hex key (M2.5 screws)
- Wire strippers
- Crimping tool (for ferrules / spade terminals)
- Multimeter (to verify buck converter output voltage before connecting RPi)
- Soldering iron (optional, for USB-C pigtail)

---

## Step 1 — Print All Parts

1. Print parts P1–P5 in PETG.
2. Recommended settings:
   - Layer height: 0.2 mm
   - Infill: 30% (gyroid or grid)
   - Wall loops: 3
   - Supports: where required (primarily P2 bracket underside)
3. Post-process: remove supports, test-fit all parts dry before assembly.

---

## Step 2 — Prepare the Buck Converter

1. Slide the LM2596 module into tray **E** (P5).
2. Connect the 24V tap wires (red/black, 22 AWG) to the input terminals.
3. **Before connecting the RPi**, power on from the Ender 3 Pro PSU and use a multimeter to verify output is set to exactly **5.0–5.1V**. Adjust the trimmer pot as needed.
4. Power off before proceeding.

---

## Step 3 — Install the RPi 4B

1. Install M2.5 brass standoffs (×4) into the enclosure body floor (part **A**).
2. Set the RPi 4B onto the standoffs, USB ports facing the cable exit side.
3. Secure with M2.5 × 6 mm screws (×4).
4. Connect the USB-C pigtail (5V from buck converter) to the RPi USB-C power port.

---

## Step 4 — Mount the MPI4008 LCD

1. Align the MPI4008 GPIO header with the RPi 4B GPIO pins.
2. Press down firmly and evenly until fully seated — the integrated fan will sit in the gap between the two boards.
3. Confirm the micro HDMI cable (included with MPI4008 kit) is connected from the LCD board to the RPi micro HDMI port.

---

## Step 5 — Route the SD Extension Cable

1. Route the microSD end of the AliExpress extension cable (item 2255801037535913) through the internal channel in the enclosure body.
2. Insert the microSD plug into the Ender 3 Pro motherboard SD slot.
3. Seat the full-size SD female socket into the left-side panel cutout of the enclosure.
4. Ensure the cable has no sharp bends and is strain-relieved at both ends using the integrated cable clips in part **A**.

---

## Step 6 — Install Dust Filter

1. Cut dust filter mesh to match the ventilation opening(s) on the rear panel **D**.
2. Apply a thin bead of super glue or epoxy around the ventilation opening perimeter (inside face).
3. Press the mesh into place and hold until cured.
4. To clean: vacuum the exterior vent surface periodically.

---

## Step 7 — Install the LCD Bezel

1. Align the LCD bezel **C** over the front of the enclosure body **A**.
2. Confirm the display is fully visible through the bezel opening.
3. Secure bezel to enclosure with M3 × 8 mm screws.
4. Insert stylus into the clip slot on the side of the bezel.

---

## Step 8 — Close the Rear Panel

1. Route all internal wiring clear of the rear panel seating surface.
2. Press rear panel **D** (with dust filter installed) onto the enclosure body.
3. Secure with M3 × 8 mm screws.

---

## Step 9 — Mount to Ender 3 Pro Frame

1. Slide M3 T-slot nuts into the 2020 left front vertical extrusion.
2. Position the bracket **B** at the desired height (~elbow height when standing).
3. Align the enclosure tilt angle toward the operator.
4. Tighten M3 × 12 mm screws through the bracket into the T-slot nuts.
5. Verify the assembly does not protrude into the printer bed Y-axis travel path or obstruct X-axis gantry wheels.

---

## Step 10 — Connect USB to Printer

1. Plug the USB-A end of the USB cable into the RPi 4B USB-A port.
2. Route the cable through the enclosure exit opening.
3. Plug the micro-USB end into the Ender 3 Pro front USB port.

---

## Step 11 — Power On & Verify

1. Power on the Ender 3 Pro.
2. Confirm the buck converter LED voltmeter reads 5.0–5.1V.
3. Confirm the RPi 4B boots and the MPI4008 LCD displays the OctoPi interface.
4. Confirm touch input works on the LCD.
5. Test SD card insertion/removal from the full-size slot on the left side.

---

## Wiring Diagram

> To be added — see `/img/wiring_diagram.png` (pending)

---

## Troubleshooting

| Symptom | Likely Cause | Fix |
|---|---|---|
| RPi doesn't boot | Buck converter output not at 5V | Re-check and adjust trimmer pot |
| LCD no display | Micro HDMI not seated / driver not installed | Reseat cable; install MPI4008 driver |
| Touch not working | GPIO header not fully seated | Remove and re-seat LCD module |
| SD slot not reading | Extension cable bent or damaged | Inspect cable routing |
| Overheating | Fan not running / vents blocked | Check fan wiring; clear obstructions |
