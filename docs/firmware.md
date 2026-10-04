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
- NimBLE-Arduino, **version 2.x** (the sketch uses the 2.x callback signatures, so 1.x will not compile)

No touch-sensor, proximity-sensor, NeoPixel, or separate project-specific HID library is required.

## Board selection

For the production ESP32-S3 module, select:

**ESP32 Arduino → ESP32S3 Dev Module**

Use the board settings required by the exact production module.

The board has no separate USB-to-serial chip. USB-C connects directly to the ESP32-S3's native USB (D− on GPIO19, D+ on GPIO20), so firmware is uploaded and the Serial Monitor is read over that same connection. In the Arduino IDE **Tools** menu, set **USB CDC On Boot** to **Enabled** if you want `Serial` output to appear in the Serial Monitor.

## Uploading firmware

1. Connect the PCB with a data-capable USB-C cable.
2. Open `RB_SWITCH_firmware.ino`.
3. Select the ESP32-S3 board and set **USB CDC On Boot** to **Enabled**.
4. Select the correct serial port.
5. Click **Verify**.
6. Click **Upload**.
7. If necessary, enter the ESP32-S3 bootloader: hold BOOT, press and release RESET, then release BOOT.
8. Reset the board after upload.
9. Open the Serial Monitor at 115200 baud and confirm the startup banner appears.
10. Pair with a host and run the three-button test from [Setup & Pairing]({{ '/setup.html#4-test-the-three-buttons' | relative_url }}).

If the upload fails or no serial port appears, see [Troubleshooting]({{ '/troubleshooting.html#5-firmware-upload-and-serial-monitor' | relative_url }}).

## Serial diagnostics

Open the Serial Monitor at **115200 baud**. The firmware reports the three button mappings and logs button activity with its GPIO and HID usage ID. It also prints `BLE connected` and `BLE disconnected; restarting advertising`, and `Key ignored: BLE not connected` when a button is pressed with no host connected. The full expected output is in [Troubleshooting]({{ '/troubleshooting.html#what-the-serial-monitor-should-show' | relative_url }}).

## Hardware the firmware does not use

The board also has a battery-voltage divider on GPIO5 (VBAT ÷ 2) and a charge-status LED (D1) driven by the charger. The production firmware does not read GPIO5 and reports a fixed 100% battery level. See [Hardware]({{ '/hardware.html' | relative_url }}) for the full pin map.

## HID usage IDs

| Function | HID Usage ID |
|---|---:|
| Enter / Return | `0x28` |
| Right Arrow | `0x4F` |
| Left Arrow | `0x50` |

## Bluetooth behavior

- The advertised Bluetooth name is **RB Switch** (the same on every unit).
- The sketch advertises the standard HID service and presents a boot-compatible keyboard.
- Bonding is enabled with no passkey. Pairing data is stored in flash. To clear it, erase flash while uploading (see [Troubleshooting]({{ '/troubleshooting.html#clearing-the-rb-switchs-stored-pairings' | relative_url }})).
- After a disconnect, advertising restarts automatically.
- Transmit power is set to the maximum the sketch requests (`ESP_PWR_LVL_P9`).
- There is no sleep mode, so the device draws power continuously whenever it is powered.

## Modifying the firmware

For remapping keys, changing debounce timing, renaming the device, or other customization of `RB_SWITCH_firmware.ino`, see [Firmware Customization]({{ '/firmware-customization.html' | relative_url }}).
