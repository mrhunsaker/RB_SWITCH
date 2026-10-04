---
layout: default
title: Switch Operation
---

# Switch Operation

## Button map

| Button | Keyboard action |
|---|---|
| SW1 (left) | Left Arrow |
| SW2 (center) | Enter |
| SW3 (right) | Right Arrow |

This mapping is fixed in the production firmware.

## Button behavior

When a button is pressed, the firmware:

1. Reads the switch.
2. Debounces the input for 35 ms.
3. Detects the transition from released to pressed.
4. Sends the corresponding BLE HID key press.
5. Sends the corresponding BLE HID key release about 20 ms later.

A held button does not continuously repeat the key. Releasing a button sends nothing.

## Connection behavior

- The RB Switch advertises as **RB Switch** as soon as it has power. The name is the same on every unit.
- While no host is connected, button presses are ignored. They are not stored or sent later.
- If the connection drops, the RB Switch starts advertising again automatically, and a paired host normally reconnects on its own.
- One host uses the RB Switch at a time. To move it to another device, disconnect it from the first device (or turn that device's Bluetooth off), then connect from the new one.
- Pairing is stored in the RB Switch (bonding). No passkey is needed.

## Power

- The RB Switch runs from USB-C or its single-cell Li-Po battery.
- It has no power switch and no sleep mode. It is on whenever it has power.
- It reports a fixed 100% battery level to the host, so the host's battery indicator does not show the real charge.

## Electrical input behavior

The switches connect their GPIO inputs to ground when pressed.

| Signal | GPIO | Input mode | Active state |
|---|---:|---|---|
| SW1_NET | 10 | `INPUT_PULLUP` | LOW |
| SW2_NET | 11 | `INPUT_PULLUP` | LOW |
| SW3_NET | 12 | `INPUT_PULLUP` | LOW |

Each switch input has a 100 nF capacitor for hardware filtering.

## Charge-status LED

D1 is the charge-status LED controlled by the MCP73831 charger. It is on while the battery charges from USB-C and off when charging is complete or USB-C is not connected. It is not a programmable RGB LED, and it does not show button presses or the Bluetooth connection. See [Troubleshooting](troubleshooting.md#4-power-charging-and-the-light).

## Using these buttons with accessibility scanning

The three buttons above are ordinary keyboard keys. How a host device turns them into scanning actions (Next/Previous/Select and similar) is configured on the host, not the RB Switch. **Android and iOS/iPadOS configure this differently**. See [Setup & Pairing](setup.md), [Android Switch Access](switch-access-android.md), and [iOS/iPadOS Switch Control](switch-control-ios.md).

## Production scope

The current production design contains only the three mechanical switch inputs above. It does not contain or implement touch sensors, proximity sensors, NeoPixel/WS2812 RGB control, mono-jack inputs, eleven-input operation, or F1–F13 legacy mappings.

If something is not working, see [Troubleshooting](troubleshooting.md).
