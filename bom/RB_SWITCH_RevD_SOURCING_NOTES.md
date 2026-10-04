# RB_SWITCH RevD – sourcing notes (checked 2026-09-29; BOM/CPL notes updated 2026-10-03)

Stock figures come from search snapshots of Digi-Key, LCSC and JLCPCB part pages, some undated. They are **not live**. Re-check at order time, especially the parts marked ⚠.

## Part selection

| Ref | Part (MPN) | JLCPCB / LCSC # | Digi-Key P/N | Alternate / note |
|---|---|---|---|---|
| U1 | ESP32-S3-MINI-1-N4R2 | C3013941 (Ext.) | 1965-ESP32-S3-MINI-1-N4R2CT-ND | ⚠ LCSC stock flipped between 0 and ~2k in snapshots. Fallback: ESP32-S3-MINI-1-N8, **C2913206** (same footprint/pinout, 8 MB flash, no PSRAM). |
| REG1 | TPS63001DRCR | C28060 (~5.7k at JLC) | 296-19643-1-ND | TPS63001DRCT = C2070693 / 296-32517-1-ND. JLC flags it as needing an assembly fixture. |
| U_CHG1 | MCP73831T-2ACI/OT | C424093 | MCP73831T-2ACI/OTCT-ND (~43.9k) | Don't swap option codes (2DCI, 2ATI…) without checking datasheet thresholds. |
| J_USB1 | USB4105-GF-A | C3020560 | 2073-USB4105-GF-ACT-ND | ⚠ JLC stock thin/volatile (snapshot: 8; another source ~1.1k; LCSC retail 0). Fallback **USB4105-GF-A-120 = C5184243** (1.2 mm shell stakes vs 0.95 mm; sticks out ~0.2 mm under a 1.0 mm PCB). Both carry JLC's "high difficulty" $0.03/pc fee. |
| J_BAT1 | S2B-PH-K-S(LF)(SN) | C173752 (Ext., THT) | 455-1719-ND | S2B-PH-K(LF)(SN) = C265016 is also listed; confirm drawing before substituting. |
| L1 | SRN4018-2R2M | C913207 | SRN4018-2R2MCT-ND | 2.2 µH, Isat 3.0 A, 4×4 mm, 1.88 mm max height. See flag 1. |
| D1 | KT-0603R (red) | C2286 (Basic) | Würth 150060RS75000 = 732-4978-1-ND | Red/green/yellow only. See flag 3. |
| R1 2k | 0603WAF2001T5E | C22975 (Basic) | Yageo RC0603FR-072KL | |
| R2 1k | 0603WAF1001T5E | C21190 (Basic) | Yageo RC0603FR-071KL | |
| R3,R4 5.1k | 0603WAF5101T5E | C23186 (Basic) | Yageo RC0603FR-075K1L | |
| R5,R6 10k | 0603WAF1002T5E | C25804 (Basic) | Yageo RC0603FR-0710KL | |
| R7,R8 100k | 0603WAF1003T5E | C25803 (Basic) | Yageo RC0603FR-07100KL | |
| C1,C3,C7 10 µF | CL10A106KP8NNNC (10 V X5R) | C19702 (Basic) | 1276-1192-1-ND | |
| C2 22 µF | CL10A226MQ8NRNC (6.3 V X5R) | C59461 | 1276-1193-1-ND | JLC-verified alternate: CL10A226MQ8NRNE = **C159801** (Ext.). |
| C4, C12 1 µF | CL10A105KB8NNNC (50 V X5R) | C15849 (Basic) | 1276-1860-1-ND | C4 is the charger VBUS input cap. C12 (added 2026-10-03) is the EN-to-ground reset-delay cap. |
| C5,C6,C8–C11 100 nF | CC0603KRX7R9BB104 | C14663 (Basic) | Yageo (same MPN) | |
| SW_RST1, SW_BOOT1 | B3U-1000P | C231329 | SW1020CT-ND (~88k) | Alt JLC listing C271754; with-boss variant B3U-1000P-B = C231330 / SW1143CT-ND. |
| **SW1–SW3** | **B3F-1000** | **C93157** (Ext., THT) | **SW400-ND** (~27–40k) | ⚠ LCSC snapshot showed ~1.5k. Omron lists it "in production". |

Extended-part types on the JLC build: U1, REG1, U_CHG1, J_USB1, J_BAT1, L1, C2, SW_RST1/BOOT1 and SW1–3. Each type carries JLC's per-part loading fee.

## CPL changes vs. the templates

The CPL files were regenerated on 2026-10-03 from the current `RB_Switch.kicad_pcb`. All parts except U_CHG1, REG1, D1 and R2 moved, and U1 is now rotated 270° (it was 90°).

1. **Coordinates are relative to the board's top-left corner (X 79, Y 80 in KiCad), with Y negated.** This is the same convention as the earlier CPL. The gerbers run Y = 0 to −38, and the templates used KiCad's raw positive Y, which would mirror every part top-to-bottom.
2. **THT rows (SW1–3, J_BAT1) use the body centre**, not KiCad's pin-1 origin. JLC hand/wave-solders THT and does not use these rows, so delete them if the uploader complains.
3. **JLC rotations** keep the earlier corrections: U_CHG1 +270, SW_RST1/SW_BOOT1 +90, J_BAT1 +180 on top of KiCad's rotation.
4. **PCBWay CPL uses raw KiCad rotations**, except J_USB1, which keeps the 180° value from the earlier file.
5. **Verify orientation in the JLC/PCBWay preview** for U1, REG1 (VSON, pin 1), D1 (cathode = pad 1), J_USB1 and L1. No published correction covers them. In particular U1 and J_USB1 were re-rotated or re-derived and have not been checked against a fab preview.
6. **Re-export gerbers first.** The gerbers in `electrical/mechanical_switch/gerbers/` are from an earlier layout and will not match this CPL.

## Flags found while reading the design files

1. **L1 (resolved 2026-10-03).** The schematic and PCB now both use `L_Bourns-SRN4018`, and the BOMs list **SRN4018-2R2M**. The PCB land pattern matches the Bourns recommended layout (pads 1.5 × 3.6 mm, 4.55 mm overall). Height is 1.88 mm max for the 2R2M, well inside the enclosure's clearance.
2. **C2 22 µF at 6.3 V** loses much of its capacitance at 3.3 V DC bias. C3 and C7 add to the rail, but check the TPS63001 datasheet's minimum output capacitance.
3. **Status LED** is fed from 3V3 through R2 = 1k, about 1.3 mA with a red LED. A blue or white LED would barely light. Worth a bench check that it stays dark on battery power alone (unverified: current could leak through the charger's STAT pin when VBUS is absent).
4. **Battery pack** (BT1 in the generic BOM) is still "TBD". Verify JST polarity and protection circuit before first power-up.
