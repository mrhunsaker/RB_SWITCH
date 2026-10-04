---
layout: default
title: Hardware Reference
---

# Hardware Reference

This page describes the current RB Switch hardware as captured in the KiCad 10 schematic and PCB in `electrical/mechanical_switch/` (4-layer, 115 × 38 mm, last updated 2026-10-03).

The schematic and PCB were checked against each other: all 19 named nets and all 34 intentionally unused pins match pad-for-pad. See `electrical/mechanical_switch/VERIFICATION.md` for what was checked and what was not.

## User controls

| Reference | Function | Net | MCU connection |
|---|---|---|---|
| SW1 | Left Arrow | `/SW1_NET` | U1 pin 14 (IO10) → GPIO10 |
| SW2 | Enter | `/SW2_NET` | U1 pin 15 (IO11) → GPIO11 |
| SW3 | Right Arrow | `/SW3_NET` | U1 pin 16 (IO12) → GPIO12 |
| SW_RST1 | Reset | `/EN_NET` | U1 pin 45 (EN) |
| SW_BOOT1 | Boot / download mode | `/BOOT_NET` | U1 pin 4 (IO0) |

Each of SW1–SW3 connects its GPIO to ground when pressed, so the firmware uses `INPUT_PULLUP` and treats LOW as pressed. Each switch input has a 100 nF capacitor to ground (C9, C10, C11) for filtering. GPIO10–12 are not strapping pins, so a held button at boot does not change boot mode.

Reset and boot use 10 kΩ pull-ups (R5 on EN, R6 on IO0) to 3.3 V, with the switch pulling the line to ground. C12 (1 µF) from EN to ground forms an RC delay with R5 (about 10 ms), so the module stays in reset until the 3.3 V rail has settled. This is the same arrangement Espressif uses on its development boards.

## Main electronics

| Reference | Part | Function |
|---|---|---|
| U1 | ESP32-S3-MINI-1-N4R2 | BLE MCU |
| REG1 | TPS63001DRCR | 3.3 V buck-boost regulation |
| L1 | 2.2 µH, Bourns SRN4018 | Regulator inductor |
| U_CHG1 | MCP73831T-2ACI/OT | Li-Po charging |
| J_USB1 | GCT USB4105-GF-A USB-C receptacle | Power, charging and native USB |
| J_BAT1 | JST-PH 2-pin | Battery connection |
| D1 | 0603 red LED | Charge status |
| R7, R8, C8 | 100 kΩ / 100 kΩ / 100 nF | Battery-voltage sense network |
| R5, C12 | 10 kΩ / 1 µF | EN pull-up and reset-delay capacitor |

Reference designators `J_BAT1`, `J_USB1`, `SW_RST1`, `SW_BOOT1` and `U_CHG1` end in a digit so KiCad treats them as annotated. Older documents and BOMs may show them without the `1`.

## What each part connects to

**Power input and charging**

- **J_USB1:** VBUS pins (A4, A9, B4, B9) go to C4 and U_CHG1 pin 4. CC1 goes to R3 and CC2 goes to R4. D+ (A6, B6) goes to U1 pin 24 (IO20) and D− (A7, B7) goes to U1 pin 23 (IO19). All GND pins and the shield go to ground. The two SBU pins are unused.
- **R3, R4 (5.1 kΩ):** CC1 and CC2 to ground, so the port presents itself as a USB-C sink.
- **C4 (1 µF):** VBUS to ground.
- **U_CHG1 (MCP73831):** VBUS in, VBAT out to the battery rail, ground, PROG to R1, STAT to D1's cathode.
- **R1 (2 kΩ):** PROG to ground, setting about 500 mA charge current.
- **D1:** cathode to STAT, anode to R2.
- **R2 (1 kΩ):** D1's anode to 3.3 V.

**Battery and regulator**

- **J_BAT1:** pin 1 to the battery rail (VBAT), pin 2 to ground.
- **REG1 (TPS63001):** VIN, VINA and EN go to VBAT. PS/SYNC, PGND, GND and the thermal pad go to ground. L1 and L2 go to the two ends of inductor L1. VOUT and FB go to the 3.3 V rail (the TPS63001 is the fixed 3.3 V version).
- **L1:** between REG1's two switch pins.
- **C1 (10 µF):** VBAT to ground.
- **C2 (22 µF), C3 (10 µF):** 3.3 V rail to ground.

**Battery sensing**

- **R7 and R8 (100 kΩ each):** a divider from VBAT to ground. The midpoint also has C8 (100 nF) to ground and goes to U1 pin 9 (IO5).
- The production firmware does not read this input yet. It reports a fixed 100% battery level.

**Microcontroller**

- **U1:** 3.3 V on pin 3, ground on pins 1, 2, 42, 43 and 46–65 (including the exposed pad). Pins 4, 9, 14, 15, 16, 23, 24 and 45 are connected as described above. The other 32 pins are intentionally unused.
- **C5, C6 (100 nF), C7 (10 µF):** 3.3 V rail to ground, decoupling for U1.
- **C12 (1 µF):** EN (pin 45) to ground, the reset-delay capacitor described above.

## PCB summary

| Item | Value |
|---|---|
| Size / layers | 115 × 38 mm, 4 layers (F.Cu, In1 = GND plane, In2 = 3V3 plane, B.Cu) |
| Signal routing | 0.2 mm tracks; VBAT, L_A, L_B 0.25 mm; VBUS 0.3 mm |
| Vias | 0.5 mm pad / 0.3 mm drill |
| Fixed placement | SW1–SW3, the two M4 mounting holes (MH1, MH2) and J_USB1 |
| Antenna | The module's antenna end points toward the right edge of the board. That area has a copper keep-out on all layers, and the module's courtyard extends past the board edge. |

SW1, SW2 and SW3 sit at the same positions as in the original design (pad 1 at X = 101, 126, 151 mm; Y = 99 mm). The M4 holes are at (91, 84) and (179.5, 84). J_USB1 is at (84, 99) rotated −90°. All other parts were moved to give the tracks clearance.

MH1 and MH2 have no schematic symbol. Their footprints are marked "Not in schematic" so the parity check does not flag them.

The J_USB1 footprint has a built-in clearance of about 0.18–0.21 mm between its NPTH positioning holes and some pads. The project's minimum hole clearance is set to 0.15 mm for this reason.

## Library notes

- **U1 footprint:** the PCB uses `RF_Module:ESP32-S2-MINI-1`, the land pattern shared with the S3 module. The schematic symbol and BOM identify the part as an ESP32-S3-MINI-1-N4R2. Your KiCad library may report the S3 symbol as not found; this is a library naming issue and does not affect the board.
- **SW1–SW3 footprint:** `Button_Switch_THT:SW_TH_Tactile_Omron_B3F-100x`. Pads 1 are the pair on the top edge and connect to the switch net; pads 2 are the pair on the bottom edge and connect to ground.
- **L1 footprint:** `Inductor_SMD:L_Bourns-SRN4018`. Its pads (1.5 × 3.6 mm, 4.55 mm overall width) match the recommended layout in the Bourns SRN4018 datasheet. The SRN4018-2R2M is at most 1.88 mm tall, well under the enclosure's clearance above the board.
- **REG1 footprint:** `Package_SON:Texas_DRC0010J`, without thermal-via pads. Four GND vias sit in the exposed pad.

## Debugging a board

Measurement points, expected voltages and a symptom guide are in [Troubleshooting, Section 6](troubleshooting.md#6-board-level-checks-for-technicians).

## Before ordering a board

- The files in `electrical/mechanical_switch/gerbers/` and the PCB images in `electrical/mechanical_switch/diagrams/` were exported from an earlier layout. Run `create_gerber.ps1` to export fresh gerbers and renders before ordering.
- The CPL files in `bom/` were regenerated from the current PCB. Check U1, REG1, D1, J_USB1 and L1 orientation in the fab's placement preview, since no published rotation correction covers them.
- Verify battery polarity: J_BAT1 pin 1 is the positive terminal (VBAT).

## Hardware not included

The current PCB does not include TTP223 touch controllers, proximity sensor hardware, NeoPixel/WS2812 hardware, or 3.5 mm mono-jack switch inputs.
