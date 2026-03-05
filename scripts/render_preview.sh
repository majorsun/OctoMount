#!/usr/bin/env bash
# render_preview.sh — Render OctoMount assembly to img/preview.png
#
# Usage: bash scripts/render_preview.sh
#
# Requires OpenSCAD installed at default Windows path, or on PATH.
# Re-run this script whenever the CAD design changes to update the preview.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCAD="$REPO_ROOT/cad/assembly.scad"
OUT="$REPO_ROOT/img/preview.png"

# Find OpenSCAD
if command -v openscad &>/dev/null; then
    OPENSCAD="openscad"
elif [[ -x "/c/Program Files/OpenSCAD/openscad.exe" ]]; then
    OPENSCAD="/c/Program Files/OpenSCAD/openscad.exe"
else
    echo "ERROR: OpenSCAD not found. Install from https://openscad.org/downloads.html"
    exit 1
fi

echo "Rendering $SCAD -> $OUT ..."

"$OPENSCAD" \
    --render \
    --camera=53,40,35,38,0,45,380 \
    --imgsize=1200,900 \
    --colorscheme=Tomorrow \
    -o "$OUT" \
    "$SCAD"

echo "Done: $OUT"
