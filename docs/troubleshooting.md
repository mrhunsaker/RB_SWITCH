---
layout: default
title: Troubleshooting
permalink: /troubleshooting.html
---

# Troubleshooting

## The device does not appear in Bluetooth

1. Confirm the PCB is powered.
2. Disconnect/reconnect USB-C or power-cycle the battery supply.
3. Wait several seconds for BLE advertising to begin.
4. Search for **RB Switch**.
5. If it was previously paired, try disconnecting/reconnecting it from the host.
6. If necessary, remove/forget the old pairing and pair again.

## A button does nothing

First determine whether the failure is electrical or Bluetooth-related.

### Check Bluetooth

Confirm the host shows **RB Switch** as connected.

### Check the button

The expected mapping is:

- SW1 → Left Arrow
- SW2 → Enter
- SW3 → Right Arrow

Try all three buttons. If two work and one does not, the problem is likely isolated to that switch/input.

### Check serial diagnostics

Connect the PCB to a computer and open the Serial Monitor at 115200 baud. A button event should produce a line similar to:

```text
SW GPIO10 -> HID 0x50
```

The expected diagnostic codes are:

- GPIO10 / `0x50` = SW1 / Left Arrow
- GPIO11 / `0x28` = SW2 / Enter
- GPIO12 / `0x4F` = SW3 / Right Arrow

If the GPIO event is not logged, inspect the corresponding switch, solder joints, capacitor, trace, and ground connection.

If the event is logged but the host does not respond, investigate BLE pairing/HID behavior.

## The key repeats unexpectedly

The production firmware is edge-triggered and uses a 35 ms debounce interval. A held switch should not continuously generate events.

If repeated events occur, inspect:

- switch mechanical condition
- switch solder joints
- switch-input capacitor
- ground connection
- PCB contamination or damage

## USB works for power but uploading fails

Use a known data-capable USB-C cable.

If the ESP32-S3 does not enter download mode automatically, use `SW_BOOT` and `SW_RST` to manually enter the bootloader, then retry the upload.

## Charging LED behavior

D1 is the charger status indicator. It is controlled by the MCP73831 charger, not by the firmware.

If D1 behaves unexpectedly while charging, troubleshoot the charging circuit and battery independently of the BLE firmware.

## Battery concerns

The BOM leaves the exact purchased Li-Po battery SKU as an open item. Before connecting an unknown battery:

- verify connector polarity
- verify the nominal cell voltage
- verify the pack has appropriate protection
- verify the battery physically fits the enclosure
- verify the battery is suitable for the MCP73831 charging circuit

Do not assume a JST-PH connector guarantees compatible polarity.
