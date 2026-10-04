---
layout: default
title: RB Switch
---

# RB Switch

The **RB Switch** is a three-button Bluetooth Low Energy (BLE) accessibility switch. It presents itself to a computer, tablet, or phone as a standard Bluetooth keyboard, so it works with Switch Control (iOS/iPadOS), Switch Access (Android), and any app that accepts keyboard input.

## Button functions

| Physical switch | MCU GPIO | Keyboard key |
|---|---:|---|
| **SW1** (left) | GPIO10 | **Left Arrow** |
| **SW2** (center) | GPIO11 | **Enter** |
| **SW3** (right) | GPIO12 | **Right Arrow** |

Each button press sends one key press followed by one key release. Holding a button does not repeat the key.

## Quick start

1. Power the RB Switch using USB-C or the installed single-cell Li-Po battery. There is no power switch; it is on whenever it has power.
2. Open Bluetooth settings on the device you want to use.
3. Select **RB Switch**.
4. Complete pairing if prompted.
5. Test SW1, SW2, and SW3 in a text field.
6. If using Switch Control (iOS/iPadOS) or Switch Access (Android), add the buttons as external switches. **Android and iOS/iPadOS handle a 3-button switch differently**. See [Setup & Pairing](setup.md) before you configure scanning.

Something not working? Go to [Troubleshooting](troubleshooting.md).

## Which page do I need?

| I am… | Start with |
|---|---|
| A paraprofessional or teacher setting up a student's device | [Setup & Pairing](setup.md) (a printable version is available on that page) |
| Setting up an iPad or iPhone | [iOS/iPadOS Switch Control](switch-control-ios.md) |
| Setting up an Android phone or tablet | [Android Switch Access](switch-access-android.md) |
| Looking for how the buttons behave | [Switch Operation](use.md) |
| Fixing a problem | [Troubleshooting](troubleshooting.md) |
| Programming the board | [Firmware](firmware.md) and [Firmware Customization](firmware-customization.md) |
| Building, repairing, or ordering boards | [Hardware](hardware.md) |
| Printing the enclosure label | [QR Code](qr-code.md) |

## Current hardware

The current board uses an ESP32-S3-MINI-1-N4R2, three Omron B3F-series tactile switches, USB-C, a Li-Po battery connection and charger, a 3.3 V buck-boost regulator, battery-voltage sensing, and a charger-status LED.

The production design has three mechanical switch inputs. Touch sensors, proximity sensors, NeoPixel/RGB indicators, mono-jack inputs, and legacy F-key mappings are not part of the production design.

## Documentation

- [Setup & Pairing](setup.md)
- [Android Switch Access](switch-access-android.md)
- [iOS/iPadOS Switch Control](switch-control-ios.md)
- [Switch Operation](use.md)
- [Firmware](firmware.md)
- [Firmware Customization](firmware-customization.md)
- [Hardware](hardware.md)
- [Troubleshooting](troubleshooting.md)
- [QR Code](qr-code.md)
