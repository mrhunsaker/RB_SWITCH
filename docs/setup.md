---
layout: default
title: Setup & Pairing
permalink: /setup.html
---

# Setup & Pairing

## 1. Power

The RB Switch can be powered from USB-C and is designed around a single-cell Li-Po battery connected to `J_BAT`.

The PCB includes:

- USB-C input
- MCP73831 Li-Po charger
- TPS63001 3.3 V regulator
- Charge-status LED

Do not connect a battery with an unverified connector polarity. The BOM identifies the battery SKU as an open item, so verify the actual battery's polarity and protection circuitry before first power-up.

## 2. Pair over Bluetooth

The firmware advertises as:

**RB Switch**

On the host device:

1. Open Bluetooth settings.
2. Turn Bluetooth on.
3. Find **RB Switch** in available devices.
4. Select it and complete pairing if prompted.
5. Confirm it is connected.

The RB Switch uses standard BLE HID keyboard behavior; no companion application is required for basic keyboard operation.

## 3. Verify the three buttons

Open a text field or another application that accepts keyboard input.

- Press **SW1** → the cursor should move **left**.
- Press **SW2** → **Enter/Return** should be generated.
- Press **SW3** → the cursor should move **right**.

Each press is debounced in firmware and produces one press/release event.

## iPad / iPhone

For Apple Switch Control:

1. Pair **RB Switch** in **Settings → Bluetooth**.
2. Open **Settings → Accessibility → Switch Control**.
3. Enable Switch Control.
4. Use **Switches → Add New Switch → External**.
5. Activate the desired RB Switch button when prompted.
6. Assign the required Switch Control action.
7. Repeat for the other buttons.

The exact menu wording can vary by iOS/iPadOS release.

## Android

For Android Switch Access:

1. Pair **RB Switch** under Bluetooth settings.
2. Open **Settings → Accessibility → Switch Access**.
3. Enable Switch Access.
4. Add an external switch.
5. Activate the desired RB Switch button when prompted.
6. Assign the required action.

Menu names vary by Android manufacturer and version.

## macOS / Windows / Linux

Pair **RB Switch** as a Bluetooth keyboard. The three buttons then behave as ordinary keyboard keys:

- SW1 = Left Arrow
- SW2 = Enter
- SW3 = Right Arrow
