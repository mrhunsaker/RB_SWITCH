---
layout: default
title: RB Switch
---

# RB Switch

The **RB Switch** is a three-button Bluetooth Low Energy (BLE) accessibility switch. It presents itself to a computer, tablet, or phone as a standard Bluetooth keyboard.

## Button functions

| Physical switch | MCU GPIO | Keyboard key |
|---|---:|---|
| **SW1** | GPIO10 | **Left Arrow** |
| **SW2** | GPIO11 | **Enter** |
| **SW3** | GPIO12 | **Right Arrow** |

Each button press sends one key press followed by one key release. Holding a button does not repeat the key.

## Quick start

1. Power the RB Switch using USB-C or the installed single-cell Li-Po battery.
2. Open Bluetooth settings on the device you want to use.
3. Select **RB Switch**.
4. Complete pairing if prompted.
5. Test SW1, SW2, and SW3.
6. If using Switch Control or Switch Access, add the buttons as external switches.

## Current hardware

The current board uses an ESP32-S3-MINI-1-N4R2, three Omron B3F-series tactile switches, USB-C, a Li-Po battery connection and charger, a 3.3 V buck-boost regulator, battery-voltage sensing, and a charger-status LED.

The production design has three mechanical switch inputs. Touch sensors, proximity sensors, NeoPixel/RGB indicators, mono-jack inputs, and legacy F-key mappings are not part of the production design.

## Documentation

- [Setup & Pairing]({{ '/setup.html' | relative_url }})
- [Switch Operation]({{ '/use.html' | relative_url }})
- [Firmware]({{ '/firmware.html' | relative_url }})
- [Hardware]({{ '/hardware.html' | relative_url }})
- [Troubleshooting]({{ '/troubleshooting.html' | relative_url }})
- [QR Code]({{ '/qr-code.html' | relative_url }})
