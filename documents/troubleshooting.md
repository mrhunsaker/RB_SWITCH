---
layout: default
title: Troubleshooting
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

## Only two of three buttons do anything in Android Switch Access

This is expected behavior, not a fault. Android's Switch Access setup wizard only ever asks for **one or two** switches; a third switch (Previous) must be assigned separately under **Settings → Accessibility → Switch Access → Settings → Assign switches for scanning**. See [Android Switch Access](switch-access-android.md) for the full walkthrough. This does not affect iOS/iPadOS, Windows, macOS, Linux, or Chromebook, where all three buttons work through their normal setup flow.

## Switch Access doesn't appear on an Android device at all

Switch Access is distributed as a standalone app on the **Google Play Store**, separate from Android Accessibility Suite. Install or update it from the Play Store, then check **Settings → Accessibility** again. See [Android Switch Access](switch-access-android.md).

## Button repeats unexpectedly

The production firmware sends one key press/release when a button changes from released to pressed and uses 35 ms debounce. A held button should not repeat.

If it does, inspect the switch, solder joints, input capacitor, ground connection, and PCB for damage or contamination.

## USB powers the board but firmware upload fails

Use a known data-capable USB-C cable. If necessary, hold BOOT, press and release RESET, then release BOOT to enter the ESP32-S3 bootloader and retry.

## Serial Monitor shows nothing

The board uses the ESP32-S3's native USB rather than a USB-to-serial chip. In the Arduino IDE, set **Tools → USB CDC On Boot** to **Enabled**, re-upload, and reopen the Serial Monitor at 115200 baud.

## Charging LED

D1 is controlled by the MCP73831 charger, not the BLE firmware. It lights while the battery is charging from USB.

## Battery

Before connecting or replacing a battery:

- Verify connector polarity.
- Verify nominal cell voltage.
- Verify appropriate battery protection.
- Verify physical fit.
- Verify compatibility with the MCP73831 charging circuit.

A JST-PH connector alone does not guarantee compatible polarity.

## Technical support

For firmware or hardware issues, use the [Firmware](firmware.md) and [Hardware](hardware.md) pages and the production source files.
