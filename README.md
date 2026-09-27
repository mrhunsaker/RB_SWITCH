# RB Switch

Three-button BLE accessibility switch based on the RevD/RevD2 mechanical-switch PCB.

## Production firmware

`firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino`

| Switch | GPIO | BLE HID key |
|---|---:|---|
| SW1 | GPIO10 | Left Arrow |
| SW2 | GPIO11 | Enter |
| SW3 | GPIO12 | Right Arrow |

The production firmware intentionally contains no code for TTP223 touch sensors, proximity sensors, NeoPixels, mono-jack inputs, or legacy F-key mappings.

## Documentation

The GitHub Pages source is in `docs/`.

A duplicate documentation source set is in `documents/` for packaging/authoring workflows.

## Hardware source

- BOM: `bom/BT_Switch_Mechanical_BOM.xlsx`
- Schematic: `electrical/mechanical_switch/BT_Switch_Mechanical_RevD.kicad_sch`
- PCB: `electrical/mechanical_switch/BT_Switch_Mechanical_RevD.kicad_pcb`
- Net table: `electrical/mechanical_switch/net_table.json`
- Gerbers: `electrical/mechanical_switch/gerbers/`
- Mechanical source: `mechanical/enclosure_mechanical_RevD2.scad`

## GitHub Pages

Enable GitHub Pages for the repository using the `docs/` directory as the publishing source. Once the repository URL is known, create a QR code pointing to the published home page. See `docs/qr-code.md`.
