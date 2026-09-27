---
layout: default
title: Setup & Pairing
---

# Setup & Pairing

This guide covers normal setup and classroom use. A programmed RB Switch does not require Arduino or programming software for everyday use.

## 1. Power the RB Switch

The RB Switch can operate from USB-C power or an installed single-cell Li-Po battery.

The board contains a USB-C connection, MCP73831 charger, TPS63001 regulator, and charger-status LED.

If installing or replacing a battery, verify its polarity, nominal voltage, protection, and connector before connecting it.

## 2. Pair with Bluetooth

1. Open Bluetooth settings on the device you want to use.
2. Turn Bluetooth on.
3. Find **RB Switch**.
4. Select **RB Switch**.
5. Wait until it shows as connected.

The RB Switch uses standard BLE keyboard behavior. No companion application is required for basic keyboard operation.

## 3. Test the buttons

Open a text field or another application that accepts keyboard input.

- **SW1** moves the cursor left.
- **SW2** sends Enter/Return.
- **SW3** moves the cursor right.

One press produces one key action. Holding a button does not repeat.

## iPad or iPhone

1. Pair **RB Switch** in **Settings → Bluetooth**.
2. Open **Settings → Accessibility → Switch Control**.
3. Turn on **Switch Control**.
4. Open **Switches → Add New Switch → External**.
5. Press the RB Switch button to assign.
6. Choose the desired Switch Control action.
7. Repeat for the other buttons.

Menu wording can vary by iOS/iPadOS release.

## Android

1. Pair **RB Switch** in Bluetooth settings.
2. Open **Settings → Accessibility → Switch Access**.
3. Turn on **Switch Access**.
4. Add an external switch.
5. Press the RB Switch button when prompted.
6. Assign the desired action.
7. Repeat for the other buttons.

Menu wording can vary by Android version and manufacturer.

## Windows, macOS, Linux, and Chromebook

Pair **RB Switch** as a Bluetooth keyboard. The buttons produce Left Arrow, Enter, and Right Arrow as shown in the button map.
