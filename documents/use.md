---
layout: default
title: Switch Operation
---

# Switch Operation

## Button map

| Button | Keyboard action |
|---|---|
| SW1 | Left Arrow |
| SW2 | Enter |
| SW3 | Right Arrow |

This mapping is fixed in the production firmware.

## Button behavior

When a button is pressed, the firmware:

1. Reads the switch.
2. Debounces the input for 35 ms.
3. Detects the transition from released to pressed.
4. Sends the corresponding BLE HID key press.
5. Sends the corresponding BLE HID key release.

A held button does not continuously repeat the key.

## Electrical input behavior

The switches connect their GPIO inputs to ground when pressed.

| Signal | GPIO | Input mode | Active state |
|---|---:|---|---|
| SW1_NET | 10 | `INPUT_PULLUP` | LOW |
| SW2_NET | 11 | `INPUT_PULLUP` | LOW |
| SW3_NET | 12 | `INPUT_PULLUP` | LOW |

Each switch input has a 100 nF capacitor for hardware filtering.

## Charge-status LED

D1 is the charge-status LED controlled by the MCP73831 charger. It is not a programmable RGB LED.

## Production scope

The current production design contains only the three mechanical switch inputs above. It does not contain or implement touch sensors, proximity sensors, NeoPixel/WS2812 RGB control, mono-jack inputs, eleven-input operation, or F1–F13 legacy mappings.
