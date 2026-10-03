#!/usr/bin/env bash

set -e

KiCad="flatpak run --command=kicad-cli org.kicad.KiCad"
Board="electrical/mechanical_switch/RB_Switch.kicad_pcb"
Gerbers="electrical/mechanical_switch/gerbers"

# Remove old production files
rm -rf "$Gerbers"

# Create fresh output directory
mkdir -p "$Gerbers"

# Export Gerbers
$KiCad pcb export gerbers \
    --output "$Gerbers" \
    --layers "F.Cu,In1.Cu,In2.Cu,B.Cu,F.Mask,B.Mask,F.SilkS,B.SilkS,Edge.Cuts" \
    "$Board"

# Export drill files
$KiCad pcb export drill \
    --output "$Gerbers" \
    --excellon-separate-th \
    "$Board"

# Show generated files
echo
echo "Generated production files:"
echo

find "$Gerbers" -maxdepth 1 -type f -printf '%f %s bytes\n'

# Render 3D view
$KiCad pcb render \
    --output "RB_Switch_3D.png" \
    --width 2400 \
    --height 1600 \
    --side top \
    --quality high \
    --preset follow_pcb_editor \
    "$Board"

# Render top view
$KiCad pcb render \
    --output "RB_Switch_TOP.png" \
    --width 2400 \
    --height 1600 \
    --side top \
    --quality high \
    --preset follow_pcb_editor \
    "$Board"

# Render bottom view
$KiCad pcb render \
    --output "RB_Switch_BOTTOM.png" \
    --width 2400 \
    --height 1600 \
    --side bottom \
    --quality high \
    --preset follow_pcb_editor \
    "$Board"
