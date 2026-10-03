# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). This project does not currently follow strict semantic versioning for hardware/firmware releases; entries are grouped by date instead.

## [Unreleased]

### Hardware (2026-10-03)

- **Schematic rewritten with real wires.** Every connection is now drawn pin to pin, with power symbols for GND, 3V3, VBAT and VBUS and net labels on the 15 signal nets. Previously the file had only short stubs ending in labels.
- **PCB re-routed and re-placed.** All 19 named nets are routed on F.Cu/B.Cu with GND (In1) and 3V3 (In2) planes. SW1–SW3, the two M4 holes and J_USB stay at their original positions; the other parts were moved to give the tracks room.
- **USB D+ / D− corrected.** D+ (A6/B6) now goes to U1 pin 24 (IO20) and D− (A7/B7) to pin 23 (IO19). They were swapped.
- **REG1 FB (pin 10) now connected to the 3.3 V output.** It was floating.
- **REG1 footprint is now `Package_SON:Texas_DRC0010J`** (no thermal-via pads). Four GND vias sit in the exposed pad.
- **Schematic and PCB parity.** Net names, reference designators, values, descriptions, datasheets and footprint links match. `J_BAT`, `J_USB`, `SW_BOOT`, `SW_RST`, `U_CHG` are now `J_BAT1`, `J_USB1`, `SW_BOOT1`, `SW_RST1`, `U_CHG1`. The 34 unused pins have `unconnected-(...)` nets. MH1/MH2 are marked "Not in schematic".
- **SW1–SW3 footprint link** is now `Button_Switch_THT:SW_TH_Tactile_Omron_B3F-100x`. L1's schematic footprint now matches the PCB (`L_Bourns-SRN4018`).
- **Project rule:** minimum hole clearance lowered from 0.25 mm to 0.15 mm because of the J_USB1 footprint.
- `electrical/mechanical_switch/VERIFICATION.md` added. `net_table.json`, the layout and schematic previews, and the CPL/BOM workbooks in `bom/` were regenerated or updated for the new design.
- **Not yet regenerated:** `electrical/mechanical_switch/gerbers/` and the PCB images in `electrical/mechanical_switch/diagrams/` are from an earlier layout. Re-export with `create_gerber.ps1` before ordering.

### Documentation and firmware (2026-10-03)

- `docs/hardware.md` and `documents/hardware.md` rewritten: pin map, part-by-part connections, PCB summary, library notes and a pre-order checklist.
- `docs/firmware.md`, `docs/troubleshooting.md` and `docs/firmware-customization.md` (and their `documents/` copies) updated: native USB / **USB CDC On Boot** note, bootloader procedure, GPIO5 battery sense and other pins in use.
- `README.md` points to the verification report and the pre-order note.
- `firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino`: header comments now list every U1 connection on the board. **No behaviour change.**
- `bom/RB_SWITCH_RevD_SOURCING_NOTES.md` updated for the new designators, footprints and CPL.

### Added

- `docs/switch-access-android.md` and `documents/switch-access-android.md` — a dedicated walkthrough for Android Switch Access, covering the Google Play Store install step and how to assign a third (Previous) switch outside the guided setup wizard.
- `docs/switch-control-ios.md` and `documents/switch-control-ios.md` — a dedicated walkthrough for iOS/iPadOS Switch Control, for contrast with the Android flow.
- `docs/firmware-customization.md` and `documents/firmware-customization.md` — a guide to safely modifying `RB_SWITCH_firmware.ino` (key remapping, debounce timing, device naming, and a HID Usage ID reference table).
- `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `CODE_STYLE.md`, `LICENSE`.
- `.github/ISSUE_TEMPLATE/` (bug report, hardware issue, documentation issue, feature request) and `.github/PULL_REQUEST_TEMPLATE.md`.
- `.github/CODEOWNERS`.

### Changed

- `docs/setup.md` and `documents/setup.md` rewritten to clearly separate Android (Switch Access) and iOS/iPadOS (Switch Control) setup, including the Android-specific one-switch/two-switch wizard limitation and the Play Store install requirement.
- `docs/index.md`, `documents/index.md`, `docs/use.md`, `documents/use.md`, `docs/firmware.md`, `documents/firmware.md` updated with cross-links to the new pages.
- `docs/troubleshooting.md` and `documents/troubleshooting.md` gained entries for the Android two-switch wizard limitation and for Switch Access not appearing until installed from the Play Store.
- `README.md` updated to reference the new documentation pages and community files.

## 2026-09-27 — Production documentation baseline

This is the state of the project as of the initial GitHub Pages publication, prior to the documentation overhaul above.

### Added

- Production firmware: `firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino` — three-button BLE HID keyboard (Left Arrow / Enter / Right Arrow) on the RevD/RevD2 mechanical-switch PCB.
- Hardware sources for the RevD/RevD2 PCB (`electrical/`), enclosure (`mechanical/`), and bill of materials (`bom/`).
- GitHub Pages documentation (`docs/`) and a packaging-friendly mirror (`documents/`): Setup & Pairing, Switch Operation, Firmware, Hardware, Troubleshooting, and QR Code pages.
- `RB_Switch_Paraprofessional_Setup_Guide.docx`, a printable classroom quick-reference.
- GitHub Actions workflow (`.github/workflows/static.yml`) to build and publish `docs/` with Jekyll.

### Notes

- An earlier, 11-input adaptive-switch prototype (`firmware/BLE_ADAPTIVE_SWITCH_EXPANDED_SCAFFOLD/`) was marked archived; it is retained for historical reference only and is not part of the current production scope.
