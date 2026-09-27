---
layout: default
title: RB Switch
---

# RB Switch

The **RB Switch** is a three-button Bluetooth Low Energy (BLE) accessibility switch interface. It presents itself to a computer, tablet, or phone as a standard Bluetooth keyboard.

## Switch functions

| Physical switch | MCU GPIO | HID key |
|---|---:|---|
| **SW1** | GPIO10 | **Left Arrow** |
| **SW2** | GPIO11 | **Enter** |
| **SW3** | GPIO12 | **Right Arrow** |

Pressing a switch sends one key press followed by one key release. Holding a switch does not generate repeated key events.

## Quick start

1. Power the RB Switch through USB-C or the installed Li-Po battery.
2. On the host device, open Bluetooth settings.
3. Pair with **RB Switch**.
4. Confirm the device appears as a Bluetooth keyboard.
5. Press SW1, SW2, and SW3 to verify the expected keys.
6. For accessibility software, configure the three inputs as external switches if required by the host platform.

## Hardware at a glance

- ESP32-S3 BLE-capable MCU module
- Three Omron B3F-series tactile switches
- USB-C power/programming connector
- Li-Po battery connector and charging circuit
- 3.3 V buck-boost regulation
- Battery-voltage sensing
- Charge-status LED

The firmware does **not** use touch sensors, proximity sensors, NeoPixels, mono-jack inputs, or other expansion hardware because those functions are not present in the RevD/RevD2 PCB/BOM.

See [Setup & Pairing](setup.md), [Switch Operation](use.md), [Firmware](firmware.md), and [Troubleshooting](troubleshooting.md).
