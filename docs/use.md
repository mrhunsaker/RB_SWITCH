---
layout: default
title: Switch Operation
permalink: /use.html
---

# Switch Operation

## Button map

| Button | Action |
|---|---|
| SW1 | Left Arrow |
| SW2 | Enter |
| SW3 | Right Arrow |

The mapping is fixed in the production firmware.

## What happens when a button is pressed?

The firmware:

1. Reads the physical switch.
2. Debounces the input for 35 ms.
3. Detects the transition from released to pressed.
4. Sends the corresponding BLE HID key press.
5. Sends the corresponding BLE HID key release.

A held button does not continuously repeat the key.

## Electrical behavior

The three switches are wired between their GPIO input and ground.

| Signal | GPIO | Firmware mode | Active state |
|---|---:|---|---|
| SW1_NET | 10 | `INPUT_PULLUP` | LOW |
| SW2_NET | 11 | `INPUT_PULLUP` | LOW |
| SW3_NET | 12 | `INPUT_PULLUP` | LOW |

The PCB also places a 100 nF capacitor on each switch input for hardware filtering.

## Charge-status LED

The PCB contains **D1**, a charge-status LED driven by the MCP73831 charger. It is not a programmable RGB indicator.

The firmware therefore contains no NeoPixel or RGB LED code.

## What is intentionally absent

The production firmware contains no code for:

- TTP223 capacitive touch sensors
- APDS9930 / APDS9960 proximity sensing
- VCNL4040
- VL53L0X
- I²C sensor polling
- NeoPixel / WS2812 control
- 3.5 mm mono-jack switch inputs
- five-switch or eleven-input legacy mappings
- F1–F13 legacy key mappings

These belonged to earlier concepts/scaffolds and are not part of the current three-switch PCB implementation.
