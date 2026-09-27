---
layout: default
title: Firmware
permalink: /firmware.html
---

# Firmware

## Production firmware

The firmware file is:

`firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino`

The Arduino sketch is intentionally self-contained. There is no project-specific header file.

## Required software

Install:

- **Arduino IDE**
- **ESP32 Arduino core** by Espressif
- **NimBLE-Arduino**

The firmware does not require:

- Adafruit NeoPixel
- proximity-sensor libraries
- TTP223 libraries
- separate HID keyboard libraries

`Arduino.h` and the ESP32 BLE/HID support are provided by the Arduino/ESP32 environment.

## Arduino board selection

Select an ESP32-S3 target appropriate to the module used by the project. For a standard Arduino IDE installation this is normally:

**ESP32 Arduino → ESP32S3 Dev Module**

Use the board configuration appropriate to the exact module and flash/PSRAM configuration in your production process.

## Upload procedure

1. Connect the PCB to the computer with a data-capable USB-C cable.
2. Open `RB_SWITCH_firmware.ino`.
3. Select the ESP32-S3 board.
4. Select the USB serial port.
5. Click **Verify**.
6. Click **Upload**.
7. If the board does not enter download mode automatically, use the PCB's `SW_BOOT` and `SW_RST` controls according to the ESP32-S3 upload procedure.
8. After upload, reset the board.

## Serial diagnostics

Open the Serial Monitor at **115200 baud**.

Startup identifies the firmware and the three mappings:

```text
RB Switch firmware
SW1 GPIO10 -> Left Arrow
SW2 GPIO11 -> Enter
SW3 GPIO12 -> Right Arrow
```

When connected, button activity is logged with the GPIO and HID usage ID.

## Firmware key codes

The firmware uses standard USB HID Usage IDs:

| Function | HID Usage ID |
|---|---:|
| Enter / Return | `0x28` |
| Right Arrow | `0x4F` |
| Left Arrow | `0x50` |

The physical mapping is SW1 → Left Arrow, SW2 → Enter, SW3 → Right Arrow.

## Changing the Bluetooth name

The advertised name is defined in the firmware as:

`RB Switch`

If the name is changed, update both the device initialization name and advertisement name so the host sees a consistent device name.
