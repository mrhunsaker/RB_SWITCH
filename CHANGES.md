# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). This project does not currently follow strict semantic versioning for hardware/firmware releases; entries are grouped by date instead.

## [Unreleased]

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
