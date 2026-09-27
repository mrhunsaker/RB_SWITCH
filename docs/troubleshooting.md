---
layout: default
title: Troubleshooting
permalink: /troubleshooting.html
---

# Troubleshooting

## RB Switch does not appear in Bluetooth

1. Confirm the RB Switch is powered.
2. Power-cycle the RB Switch.
3. Wait several seconds.
4. Search for **RB Switch** again.
5. If it was previously paired, remove/forget the old pairing and pair again.

## RB Switch is connected but a button does nothing

Test all three buttons:

- SW1 → Left Arrow
- SW2 → Enter
- SW3 → Right Arrow

If only one button fails, the problem may be isolated to that switch or input circuit.

If the buttons work in a normal text field but not in an accessibility feature, check the host's Switch Control or Switch Access configuration.

## Button repeats unexpectedly

The production firmware sends one key press/release when a button changes from released to pressed and uses 35 ms debounce. A held button should not repeat.

If it does, inspect the switch, solder joints, input capacitor, ground connection, and PCB for damage or contamination.

## USB powers the board but firmware upload fails

Use a known data-capable USB-C cable. If necessary, use BOOT and RESET to enter the ESP32-S3 bootloader and retry.

## Charging LED

D1 is controlled by the MCP73831 charger, not the BLE firmware.

## Battery

Before connecting or replacing a battery:

- Verify connector polarity.
- Verify nominal cell voltage.
- Verify appropriate battery protection.
- Verify physical fit.
- Verify compatibility with the MCP73831 charging circuit.

A JST-PH connector alone does not guarantee compatible polarity.

## Technical support

For firmware or hardware issues, use the [Firmware](firmware.html) and [Hardware](hardware.html) pages and the production source files.
