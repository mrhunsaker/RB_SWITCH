# RB_SWITCH RevD – sourcing notes (checked 2026-09-29)

Stock figures come from search snapshots of Digi-Key, LCSC and JLCPCB part pages, some undated. They are **not live**. Re-check at order time, especially the parts marked ⚠.

## Part selection

| Ref | Part (MPN) | JLCPCB / LCSC # | Digi-Key P/N | Alternate / note |
|---|---|---|---|---|
| U1 | ESP32-S3-MINI-1-N4R2 | C3013941 (Ext.) | 1965-ESP32-S3-MINI-1-N4R2CT-ND | ⚠ LCSC stock flipped between 0 and ~2k in snapshots. Fallback: ESP32-S3-MINI-1-N8, **C2913206** (same footprint/pinout, 8 MB flash, no PSRAM). |
| REG1 | TPS63001DRCR | C28060 (~5.7k at JLC) | 296-19643-1-ND | TPS63001DRCT = C2070693 / 296-32517-1-ND. JLC flags it as needing an assembly fixture. |
| U_CHG | MCP73831T-2ACI/OT | C424093 | MCP73831T-2ACI/OTCT-ND (~43.9k) | Don't swap option codes (2DCI, 2ATI…) without checking datasheet thresholds. |
| J_USB | USB4105-GF-A | C3020560 | 2073-USB4105-GF-ACT-ND | ⚠ JLC stock thin/volatile (snapshot: 8; another source ~1.1k; LCSC retail 0). Fallback **USB4105-GF-A-120 = C5184243** (1.2 mm shell stakes vs 0.95 mm; sticks out ~0.2 mm under a 1.0 mm PCB). Both carry JLC's "high difficulty" $0.03/pc fee. |
| J_BAT | S2B-PH-K-S(LF)(SN) | C173752 (Ext., THT) | 455-1719-ND | S2B-PH-K(LF)(SN) = C265016 is also listed; confirm drawing before substituting. |
| L1 | SRN4018-2R2M | C913207 | SRN4018-2R2MCT-ND | 2.2 µH, Isat 3.0 A, 4×4×1.8 mm. See flag 1. |
| D1 | KT-0603R (red) | C2286 (Basic) | Würth 150060RS75000 = 732-4978-1-ND | Red/green/yellow only. See flag 3. |
| R1 2k | 0603WAF2001T5E | C22975 (Basic) | Yageo RC0603FR-072KL | |
| R2 1k | 0603WAF1001T5E | C21190 (Basic) | Yageo RC0603FR-071KL | |
| R3,R4 5.1k | 0603WAF5101T5E | C23186 (Basic) | Yageo RC0603FR-075K1L | |
| R5,R6 10k | 0603WAF1002T5E | C25804 (Basic) | Yageo RC0603FR-0710KL | |
| R7,R8 100k | 0603WAF1003T5E | C25803 (Basic) | Yageo RC0603FR-07100KL | |
| C1,C3,C7 10 µF | CL10A106KP8NNNC (10 V X5R) | C19702 (Basic) | 1276-1192-1-ND | |
| C2 22 µF | CL10A226MQ8NRNC (6.3 V X5R) | C59461 | 1276-1193-1-ND | JLC-verified alternate: CL10A226MQ8NRNE = **C159801** (Ext.). |
| C4 1 µF | CL10A105KB8NNNC (50 V X5R) | C15849 (Basic) | 1276-1860-1-ND | |
| C5,C6,C8–C11 100 nF | CC0603KRX7R9BB104 | C14663 (Basic) | Yageo (same MPN) | |
| SW_RST, SW_BOOT | B3U-1000P | C231329 | SW1020CT-ND (~88k) | Alt JLC listing C271754; with-boss variant B3U-1000P-B = C231330 / SW1143CT-ND. |
| **SW1–SW3** | **B3F-1000** | **C93157** (Ext., THT) | **SW400-ND** (~27–40k) | ⚠ LCSC snapshot showed ~1.5k. Omron lists it "in production". |

Extended-part types on the JLC build: U1, REG1, U_CHG, J_USB, J_BAT, L1, C2, SW_RST/BOOT and SW1–3. Each type carries JLC's per-part loading fee.

## CPL changes vs. the templates

1. **Y is negated.** The gerbers run Y = 0 to −38 (verified: R3's pads are at Y −33.0 in `F_Cu.gtl`), but the templates used KiCad's raw positive Y. Uploaded as-is, every part would have been mirrored top-to-bottom.
2. **THT rows filled** (SW1–3, J_BAT) at body centre, not KiCad's pin-1 origin. JLC hand/wave-solders THT and does not use these rows, so delete them if the uploader complains.
3. **JLC rotations** include community corrections from JLCKicadTools' `cpl_rotations_db.csv`: SOT-23 (U_CHG) −90 → 270, B3U switches +90, JST-PH +180.
4. **PCBWay CPL keeps raw KiCad rotations.** I found no published PCBWay convention, so I left them uncorrected. Their engineers review placement.
5. **Not covered by any known correction, so verify orientation in the JLC/PCBWay preview:** U1, REG1 (VSON, pin 1), D1 (cathode = pad 1), J_USB.

## Flags found while reading the design files

1. **L1 mismatch.** The PCB footprint is `L_Bourns-SRN4018`, the schematic footprint is `..._SRN4026_4.0x4.0mm`, the PCBWay template said SRN4026-2R2M and the generic BOM said "SRN4018-2R2Y". I used **SRN4018-2R2M**, which matches the PCB. Confirm the enclosure height budget (1.8 mm vs 2.6 mm).
2. **C2 22 µF at 6.3 V** loses much of its capacitance at 3.3 V DC bias. C3 and C7 add to the rail, but check the TPS63001 datasheet's minimum output capacitance.
3. **Status LED** is fed from 3V3 through R2 = 1k, about 1.3 mA with a red LED. A blue or white LED would barely light. Worth a bench check that it stays dark on battery power alone (unverified: current could leak through the charger's STAT pin when VBUS is absent).
4. **Battery pack** (BT1 in the generic BOM) is still "TBD". Verify JST polarity and protection circuit before first power-up.
