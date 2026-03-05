// ============================================================
// OctoMount — p3_bezel.scad
// LCD front bezel + stylus clip.
//
// The bezel snaps onto the front face of the enclosure,
// framing the LCD active area and securing with 4× M3 screws
// that thread into the enclosure front-face bosses.
//
// Print orientation: face-down (display-opening facing build plate)
// for best surface quality on the visible front face.
//
// Coordinate origin: outer front-left-bottom corner of bezel.
//   X = left → right  (matches enclosure X)
//   Y = 0 → BEZEL_D   (depth, Y=0 is outer/visible face)
//   Z = bottom → top  (matches enclosure Z)
// ============================================================
include <params.scad>

// ── Local parameters ─────────────────────────────────────────
// Bezel outer dimensions match enclosure face.
BZ_X = OUTER_X;
BZ_Z = OUTER_Z;
BZ_D = BEZEL_D;   // total bezel depth (WALL + 2 mm overlap)

// The inner face of the bezel (Y = BZ_D) sits flush against
// the enclosure front face (Y = 0 of enclosure).
// A 1 mm lip around the perimeter ensures positive location.
LIP_H = 1.0;    // lip protrusion into enclosure front cavity
LIP_T = 1.5;    // lip wall thickness (all sides)

// Display opening with small margin around active area.
OPEN_X = LCD_ACT_X + 1.0;   // +0.5 mm each side
OPEN_Z = LCD_ACT_Z + 1.0;   // +0.5 mm each side

// Stylus clip (right side of bezel)
CLIP_D     = STYLUS_D - 0.3;  // interference slot width (snap fit)
CLIP_W     = STYLUS_D + 4.0;  // clip outer width
CLIP_L     = STYLUS_GRIP;     // clip length (Z direction, open both ends)
CLIP_WALL  = 2.5;             // clip body wall thickness

module bezel() {
    difference() {
        union() {
            // ── Main bezel frame ────────────────────────────────
            rbox([BZ_X, BZ_D, BZ_Z]);

            // ── Location lip (protrudes into enclosure front opening) ─
            // Thin ridge on the inner face perimeter that seats into
            // the front opening for positive registration.
            translate([LIP_T, BZ_D - 0.01, LIP_T])
                cube([BZ_X - 2*LIP_T, LIP_H + 0.01, BZ_Z - 2*LIP_T]);

            // ── Stylus clip (on right side, +X face) ────────────
            // Open-top channel; stylus slides in from the top (Z+).
            // Uses a C-channel profile printed integral with the bezel.
            translate([BZ_X - 0.01, (BZ_D - CLIP_W) / 2, (BZ_Z - CLIP_L) / 2])
                stylus_clip();
        }

        // ── Display cutout ──────────────────────────────────────
        // Centred on the bezel face.  The opening goes full depth.
        translate([
            (BZ_X - OPEN_X) / 2,
            -0.05,
            (BZ_Z - OPEN_Z) / 2
        ])
            cube([OPEN_X, BZ_D + 0.1, OPEN_Z]);

        // ── Remove lip material from display opening area ────────
        // (The lip cube above over-fills — clear out the centre.)
        translate([LIP_T, BZ_D - 0.01, LIP_T])
            translate([
                (BZ_X - OPEN_X) / 2 - LIP_T,
                -0.01,
                (BZ_Z - OPEN_Z) / 2 - LIP_T
            ])
                cube([OPEN_X + 2*LIP_T, LIP_H + 0.1, OPEN_Z + 2*LIP_T]);

        // ── 4× M3 countersunk through-holes at corners ──────────
        // Screws pass through bezel from front (Y=0) and thread into
        // the enclosure front-face bosses.
        for (bx = BOSS_XS) for (bz = BOSS_ZS)
            translate([bx, 0, bz])
                rotate([-90, 0, 0])
                    m3_thru(BZ_D);
    }
}

// ── Stylus clip (C-channel profile) ──────────────────────────
// Origin: left-front-bottom corner of the clip bounding box.
// The clip extends in +X from the bezel right face.
// The stylus slot is open at both Z ends (top & bottom).
module stylus_clip() {
    clip_total_w = CLIP_WALL * 2 + CLIP_D;  // full width in X
    difference() {
        // Outer body block
        cube([clip_total_w, CLIP_W, CLIP_L]);

        // Stylus slot: slightly narrower than stylus for snap fit
        translate([CLIP_WALL, (CLIP_W - CLIP_D)/2, -0.05])
            cube([CLIP_D, CLIP_D, CLIP_L + 0.1]);

        // Small entry chamfer at top to guide stylus in
        translate([CLIP_WALL - 0.5, (CLIP_W - CLIP_D)/2 - 0.5, CLIP_L - 3])
            cube([CLIP_D + 1.0, CLIP_D + 1.0, 3.5]);
    }
}

bezel();
