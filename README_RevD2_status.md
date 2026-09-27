# RB Switch — firmware/hardware reconciliation

## Current production mapping

- SW1 / GPIO10 → Left Arrow
- SW2 / GPIO11 → Enter
- SW3 / GPIO12 → Right Arrow

The mapping is taken from `electrical/mechanical_switch/net_table.json` and the RevD schematic.

## Firmware scope

`firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino` is the production firmware.

Removed from the prior scaffold:

- TTP223 touch input support
- proximity/I2C sensor support
- NeoPixel support
- five-switch legacy input map
- F1–F13 legacy key mapping
- `types_expanded.h` dependency
- unused `HIDKeyboardTypes.h` dependency

The PCB does contain D1, but D1 is the MCP73831 charger status LED, not a firmware-controlled RGB LED.

## Hardware/BOM note

The BOM and schematic specify an ESP32-S3-MINI-1-N4R2. The PCB footprint value text says `ESP32-S2-MINI-1`, consistent with the project's use of the shared S2/S3 MINI-1 land pattern. Confirm the actual MCU module being populated before production.
