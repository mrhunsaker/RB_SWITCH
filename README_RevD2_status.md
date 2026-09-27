# RB Switch — Production Hardware and Firmware

## Production mapping

- SW1 / GPIO10 → Left Arrow
- SW2 / GPIO11 → Enter
- SW3 / GPIO12 → Right Arrow

## Production firmware

`firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino` is the production firmware.

It provides three mechanical switch inputs using BLE HID keyboard reports. Each activation sends one key press followed by one key release. A held button does not repeat.

The production firmware does not implement touch sensors, proximity sensors, NeoPixels, mono-jack inputs, or legacy F-key mappings.

## Hardware status

The current PCB is the RevD/RevD2 three-switch design.

D1 is the MCP73831 charger-status LED. It is not a programmable RGB LED.

The BOM and schematic identify U1 as ESP32-S3-MINI-1-N4R2. The PCB footprint uses the shared S2/S3 MINI-1 land pattern and may display ESP32-S2-MINI-1 as its footprint value.

## Source of truth

For current behavior, use the production firmware, schematic, PCB, BOM, and net table in this repository. The documentation in `docs/` and `documents/` describes that production design.