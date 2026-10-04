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
| EN (pin 45) has a 10 k pull-up to 3.3 V, a 1 µF capacitor to ground (C12, about 10 ms RC delay) and the RESET switch to ground | Pass |
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
| 19 named nets: every pad on each net is identical in schematic and PCB (includes C12) | Pass |
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
| L1 pads (1.5 × 3.6 mm, 4.55 mm overall) match the Bourns SRN4018 recommended layout and the stock KiCad footprint | Pass |
| L1 height: SRN4018-2R2M is 1.88 mm max; the enclosure allows for the 4.3 mm switches plus travel | Pass |
| Routed lengths: USB D− 85.2 mm, D+ 84.0 mm | Full-speed USB tolerates this |

## 5. Things this verification did not cover

- **Gerbers and diagrams:** `gerbers/` and the PCB images in `diagrams/` come from an earlier layout. Re-export with `create_gerber.ps1` before ordering.
- **Firmware:** the pin map was checked against the board, but the sketch was not compiled or run here.
- **No hardware testing.** Nothing here was measured on a built board.
- **Design notes, not errors:**
  - REG1 PS/SYNC is grounded, so power-save mode is enabled.
  - The battery charger and load share VBAT with no power-path IC. While USB is plugged in and the switch is running, the load current can keep the charger from reaching its termination current, so D1 may stay lit and the cell may sit at 4.2 V. Acceptable for a classroom device that is charged between uses; a power-path part would be a redesign.
  - VBAT and the L_A/L_B switching tracks are 0.25 mm wide. At the expected load (a few hundred mA peak) the drop and heating are negligible. Widening to 0.4 mm is optional.
  - The battery-sense divider draws about 21 µA continuously.
