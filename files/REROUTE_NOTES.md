# RB_Switch re-route notes

Board: 4-layer, 115 x 38 mm (In1 = GND plane, In2 = V3V3 plane).

## What was wrong
The original file had 36 tracks, each a single straight line from pad to pad (some ~100 mm long, diagonal across the board). 22 pairs crossed on the same layer (real shorts), and 58 vias were stacked on pads with overlapping annuli. Several endpoints did not land on any pad (J_USB tracks started at x=81-86, the pads are at x=87.7).

## What changed in RB_Switch.kicad_pcb
- Removed all 36 tracks and 58 vias (signal-net vias, duplicate vias, and plane vias that violated clearance or sat inside through-hole pads).
- Kept 61 plane vias (GND / V3V3) that were clean.
- Added 235 track segments (17 signal nets) and 45 vias (signal layer hops + plane fan-outs for REG1 pin 1, REG1 GND pins 3/7/9 and the USB-C GND pins).
- Widened VBUS / VBAT / L_A / L_B to 0.3-0.5 mm where clearance allowed (0.2 mm at fine-pitch pads).
- Nothing else in the file was touched (footprints, zones, outline, rules).

## Checked here (custom script, NOT KiCad DRC)
0 copper-clearance errors (0.2 mm), 0 edge-clearance errors (0.5 mm), 0 hole-to-hole errors, all 17 signal nets fully connected.
The script uses rectangular pads and ignores silkscreen, mask, courtyards and zone fill, so KiCad's DRC is the authority.

## Needs your decision: "Antenna" rule area
The rule area (x 154.25-173.75, y 76.3-121.7, all copper layers; no tracks / vias / pads / copper pour / footprints) spans the full board height. It:
- contains D1, R2, R7, C9, C10, C11 and part of SW3, so KiCad will flag them;
- must be crossed by every net between the left-hand circuitry and the ESP32 (SW1/2/3, EN, USB D+/D-, VBAT_SENSE, BOOT), so a route that respects it does not exist;
- removes the GND and V3V3 plane copper there, leaving C9.2, C10.2, C11.2, SW3.2 (GND) and R2.2 (V3V3) without a plane connection.
I routed through it and did not edit it. Shrinking it to the real antenna end of U1 should clear all of the above.

## Other observations
- L1 sits ~30 mm from REG1; the switching-node traces (L_A / L_B) are long for a buck-boost.
- About 60 GND/V3V3 pads have vias directly in the pad. Unless plugged/filled, solder can wick through; tell PCBWay or move the vias.

## Next steps
1. Open the file in KiCad, press B to refill zones, run DRC (with parity check).
2. Decide the Antenna rule area.
3. Re-export with create_gerber.ps1 and upload.
