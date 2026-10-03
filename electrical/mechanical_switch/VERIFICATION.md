# RB Switch PCB verification

Date: 2026-10-03. Files checked: `RB_Switch.kicad_sch`, `RB_Switch.kicad_pcb`, `net_table.json` in this folder, against `firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino`.

These checks were run with scripts that read the KiCad files directly. KiCad itself was **not** run for this verification, so KiCad's own ERC and DRC remain the authority. The most recent KiCad reports supplied for this design showed no clearance, short, or unconnected-pin errors; the remaining messages were library and field-parity items that have since been addressed.

## 1. Does the board work as a three-button BLE keyboard?

| Check | Result |
|---|---|
| SW1 net goes to U1 pin 14 (IO10); firmware reads GPIO10 | Pass |
| SW2 net goes to U1 pin 15 (IO11); firmware reads GPIO11 | Pass |
| SW3 net goes to U1 pin 16 (IO12); firmware reads GPIO12 | Pass |
| Each switch's other side goes to ground, so a press pulls the input LOW (matches `INPUT_PULLUP`, active LOW) | Pass |
| Switch footprint: the two pads on the top edge form the switch net and the two pads on the bottom edge are ground, so the switch contacts sit between the net and ground (not shorted at rest). Assumes the standard B3F arrangement where the two pads on each edge are one terminal. | Pass |
| GPIO10–12 are not strapping pins (strapping pins are GPIO0, 3, 45, 46) | Pass |
| 100 nF filter capacitor (C9–C11) from each switch net to ground | Pass |
| USB D+ goes to U1 pin 24 (IO20) and D− to pin 23 (IO19), both from the USB-C pads | Pass |
| EN (pin 45) has a 10 k pull-up to 3.3 V and the RESET switch to ground | Pass |
| IO0 (pin 4) has a 10 k pull-up to 3.3 V and the BOOT switch to ground | Pass |
| U1 3.3 V on pin 3; ground on pins 1, 2, 42, 43 and 46–65 | Pass |

## 2. Power

| Check | Result |
|---|---|
| USB-C CC1 and CC2 each have a 5.1 k pull-down | Pass |
| VBUS from all four USB-C VBUS pads goes to the charger input (U_CHG1 pin 4) and C4 | Pass |
| MCP73831 pin map: 1 STAT, 2 VSS, 3 VBAT, 4 VDD, 5 PROG, matches the schematic | Pass |
| PROG resistor R1 = 2 kΩ gives about 500 mA charge current | Pass |
| Battery connector pin 1 = VBAT, pin 2 = ground | Pass (confirm the actual pack's polarity) |
| TPS63001: VIN, VINA and EN on VBAT; FB tied to VOUT (fixed 3.3 V version); inductor between L1 and L2; PGND and GND grounded | Pass |
| Regulator output 3.3 V feeds only the 3.3 V rail (U1, pull-ups, LED, decoupling) | Pass |
| Battery sense: VBAT ÷ 2 (4.2 V → 2.1 V) into IO5; within the ADC range | Pass |

## 3. Schematic ↔ PCB parity

| Check | Result |
|---|---|
| 19 named nets: every pad on each net is identical in schematic and PCB | Pass |
| 34 intentionally unused pins have `unconnected-(...)` nets on both sides | Pass |
| Reference designators and Value fields identical | Pass |
| Footprint links identical | Pass |
| Mounting holes MH1 and MH2 (no symbol) marked "Not in schematic" | Pass |

## 4. PCB copper

| Check | Result |
|---|---|
| Every net is a single connected piece of copper once tracks, vias, THT pads and the filled GND (In1) and 3V3 (In2) planes are included | Pass (0 open nets) |
| Copper-to-copper clearance ≥ 0.2 mm, board-edge clearance ≥ 0.5 mm, hole-to-hole, courtyards | Pass (scripted check) |
| SW1–SW3, M4 holes and J_USB1 keep their original positions | Pass |
| J_USB1 NPTH-hole-to-pad clearance (0.18–0.21 mm) is below the usual 0.25 mm | Known: built into the GCT footprint; the project's minimum hole clearance is 0.15 mm |
| Routed lengths: USB D− 85.2 mm, D+ 84.0 mm | Full-speed USB tolerates this |

## 5. Things this verification did not cover

- **Gerbers and diagrams:** `gerbers/` and the PCB images in `diagrams/` come from an earlier layout. Re-export with `create_gerber.ps1` before ordering.
- **Firmware:** the pin map was checked against the board, but the sketch was not compiled or run here.
- **No hardware testing.** Nothing here was measured on a built board.
- **L1 footprint:** the PCB footprint's pad positions differ from the stock KiCad `L_Bourns-SRN4018` footprint. Compare with the Bourns datasheet before fabrication.
- **Design notes, not errors:**
  - EN has no RC delay; the ESP32-S3 hardware guide suggests one for clean power-up.
  - REG1 PS/SYNC is grounded, so power-save mode is enabled.
  - The battery charger and load share VBAT with no power-path IC, so charging while running is allowed but the charge termination can be affected.
  - VBAT and the L_A/L_B switching tracks are 0.25 mm wide; they are short but could be widened.
  - The battery-sense divider draws about 21 µA continuously.
