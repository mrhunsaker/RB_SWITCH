---
layout: default
title: Firmware
permalink: /firmware.html
---

# Firmware

## Production firmware

The production sketch is:

`firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino`

The sketch is self-contained and does not require a project-specific header file.

## Required software

For firmware maintenance, install:

- Arduino IDE
- ESP32 Arduino core by Espressif
- NimBLE-Arduino

No touch-sensor, proximity-sensor, NeoPixel, or separate project-specific HID library is required.

## Board selection

For the production ESP32-S3 module, select:

**ESP32 Arduino → ESP32S3 Dev Module**

Use the board settings required by the exact production module.

## Uploading firmware

1. Connect the PCB with a data-capable USB-C cable.
2. Open `RB_SWITCH_firmware.ino`.
3. Select the ESP32-S3 board.
4. Select the correct serial port.
5. Click **Verify**.
6. Click **Upload**.
7. If necessary, use BOOT and RESET to enter the ESP32-S3 bootloader.
8. Reset the board after upload.

## Serial diagnostics

Open the Serial Monitor at **115200 baud**. The firmware reports the three button mappings and logs button activity with its GPIO and HID usage ID.

## HID usage IDs

| Function | HID Usage ID |
|---|---:|
| Enter / Return | `0x28` |
| Right Arrow | `0x4F` |
| Left Arrow | `0x50` |

## Bluetooth name

The advertised Bluetooth name is **RB Switch**.

## Modifying the firmware

For remapping keys, changing debounce timing, renaming the device, or other customization of `RB_SWITCH_firmware.ino`, see [Firmware Customization]({{ '/firmware-customization.html' | relative_url }}).
