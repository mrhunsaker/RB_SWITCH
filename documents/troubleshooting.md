---
layout: default
title: Troubleshooting
---

# Troubleshooting

Use this page when the RB Switch does not behave as described in [Setup & Pairing](setup.md) and [Switch Operation](use.md). Sections 1–5 are for classroom staff. Sections 6–8 are for technicians who can program the board or open the enclosure.

## Start here

| Symptom | Most likely cause | Go to |
|---|---|---|
| RB Switch is not in the Bluetooth list | No power, flat battery, or connected to another device | [Section 1](#1-bluetooth-and-pairing) |
| Listed but will not connect, or pairs then drops | Stale pairing, range, or low battery | [Section 1](#1-bluetooth-and-pairing) |
| Connected, but a button does nothing | Connection lost, or a switch fault | [Section 2](#2-buttons) |
| One button works differently or not at all | Switch fault or host setting | [Section 2](#2-buttons) |
| Only two buttons work on Android | Third switch not assigned | [Section 3](#3-accessibility-features-ios-and-android) |
| Works in a text box, not in Switch Control/Access | Accessibility not set up | [Section 3](#3-accessibility-features-ios-and-android) |
| Will not power on, or battery drains quickly | Flat battery, cable, or no sleep mode | [Section 4](#4-power-charging-and-the-light) |
| Charging light behaves oddly | Normal charger behavior | [Section 4](#4-power-charging-and-the-light) |
| Firmware upload fails or no serial port | Cable or download mode | [Section 5](#5-firmware-upload-and-serial-monitor) |
| Board dead or a voltage is wrong | Hardware fault | [Section 6](#6-board-level-checks-for-technicians) |

## How the RB Switch behaves (so you know what is normal)

- It advertises as **RB Switch** as soon as it has power. The name is the same on every unit.
- There is **no power switch and no sleep mode**. It runs whenever USB-C or the battery is connected.
- It reports a fixed battery level of 100%. The host's battery indicator for the RB Switch does not change.
- A button press made while it is not connected is **dropped**. It is not sent later.
- Each press sends one key press and one key release about 20 ms later. Holding a button does not repeat the key.
- Inputs are debounced for 35 ms.
- After a disconnect, it starts advertising again automatically.
- The charge light (D1) belongs to the charger. The firmware does not control it.

## 1. Bluetooth and pairing

### RB Switch does not appear in Bluetooth

1. Confirm the RB Switch has power. Plug in USB-C for a few minutes in case the battery is flat.
2. Move it within about 3 feet of the device.
3. Turn Bluetooth off and on again on the device and refresh the list.
4. Check whether another device (a phone, tablet, or computer that was paired before) is already connected. A connected host stops the RB Switch from showing up elsewhere. Turn Bluetooth off on the other devices, or choose Forget on them.
5. If it was previously paired, remove/forget the old pairing and pair again.
6. Restart the RB Switch (technicians: press RESET, or disconnect and reconnect power).

### It is listed but will not connect, or connects and then drops

1. Forget RB Switch on the device and pair again.
2. Charge the battery from USB-C for at least an hour.
3. Move away from sources of interference such as routers, microwaves, USB 3 hubs, and many other Bluetooth devices.
4. Try a different host device. If it pairs with a different device, the problem is the first device's Bluetooth stack. Restart that device.
5. If it still fails, the RB Switch's stored pairing data may be out of step with the host. See [Clearing the RB Switch's stored pairings](#clearing-the-rb-switchs-stored-pairings).

### Clearing the RB Switch's stored pairings

The firmware enables bonding, so the RB Switch stores pairing information in flash memory. If a host forgot the RB Switch but the RB Switch still holds the old pairing (or the reverse), the two can refuse to reconnect.

1. Forget RB Switch on the host device.
2. In the Arduino IDE, set **Tools → Erase All Flash Before Sketch Upload** to **Enabled**.
3. Upload the production firmware again.
4. Set that option back to **Disabled** so later uploads do not erase settings.
5. Pair again from the host.

### Two RB Switches in one room

Both advertise as "RB Switch". Pair one at a time with the other unplugged or out of range. To tell units apart permanently, give each a different name in the firmware (see [Firmware Customization](firmware-customization.md)).

## 2. Buttons

### Connected, but a button does nothing

1. Confirm RB Switch shows **Connected** in Bluetooth settings. Presses made while disconnected are lost.
2. Press all three buttons in a plain text field.
   - SW1 → Left Arrow
   - SW2 → Enter
   - SW3 → Right Arrow
3. If all three fail, disconnect and reconnect, then try a different host.
4. If only one fails, the problem is probably that switch, its solder joints, or its trace. See [Section 7](#7-switch-input-checks).
5. If the buttons work in a text field but not in an accessibility feature, see [Section 3](#3-accessibility-features-ios-and-android).

### A button repeats, double-presses, or fires by itself

The firmware sends one press and one release when a button changes from released to pressed, with 35 ms debounce, so a held button should not repeat.

- Check the host first: iOS **Switch Stabilization** and **Ignore Repeat**, Android Switch Access timing, and any host "key repeat" setting.
- If a student's motor pattern causes extra presses, raise `DEBOUNCE_MS` in small steps (50–75 ms). See [Firmware Customization](firmware-customization.md).
- If it happens without anyone touching it, inspect the switch, solder joints, the 100 nF capacitor on that input, the ground connection, and the PCB for damage, flux, or moisture.

### The wrong key is sent

The mapping is fixed in the firmware: SW1 Left Arrow, SW2 Enter, SW3 Right Arrow. If a different key arrives, the unit may be running modified firmware. Re-upload the production firmware from `firmware/RB_SWITCH_firmware/`.

## 3. Accessibility features (iOS and Android)

### Works in a text field but not in Switch Control or Switch Access

- Confirm the feature is turned on.
- Confirm each RB Switch button was added as an external switch and assigned an action.
- Re-add the switch and press the requested RB Switch button when the device asks.
- Note: the RB Switch sends Left Arrow, Enter, and Right Arrow to any app, whether or not scanning is on. In an app that also responds to arrow keys, this can look like scanning works when it does not.

### Only two of three buttons do anything in Android Switch Access

This is expected, not a fault. Android's setup wizard only asks for one or two switches. Assign the third under **Settings → Accessibility → Switch Access → Settings → Assign switches for scanning**. See [Android Switch Access](switch-access-android.md).

### Switch Access does not appear on an Android device

Switch Access is a separate app on the **Google Play Store**. Install or update it, open it once, then check **Settings → Accessibility** again.

### A button opens a menu or does something unexpected

Left Arrow, Enter, and Right Arrow are ordinary keys. Another shortcut or app on the device may also react to them. Check the device's keyboard-shortcut settings and the switch assignments.

## 4. Power, charging, and the light

### The RB Switch will not power on

1. Plug in a known-good USB-C power source and data-capable cable for at least 30 minutes.
2. Try a different charger. Some USB-C to USB-C chargers only supply power if the device presents the correct resistors on its CC pins. This board has them (R3 and R4, 5.1 kΩ), so a charger that does not work with it may be faulty.
3. Check that the battery connector is seated and the battery is not damaged or swollen. If it is swollen, stop using it.
4. Technicians: continue with [Section 6](#6-board-level-checks-for-technicians).

### Charging light (D1)

D1 is controlled by the MCP73831 charger. It is not a status light for Bluetooth or buttons.

- **On:** the battery is charging from USB-C.
- **Off:** charging is complete, or USB-C is not connected.
- The charger and the RB Switch share the battery. While the RB Switch is plugged in and running, the charger may not reach its end-of-charge point as quickly, and the light may stay on longer than you expect. This is normal.

### The battery runs down quickly

The RB Switch has no sleep mode and no power switch. It uses power whenever it is connected to a battery. Recharge regularly. For long storage, trained staff can disconnect the battery connector. The firmware reports a fixed 100% battery level, so a host's battery reading cannot be used to judge charge.

### Battery safety

Before connecting or replacing a battery:

- Verify connector polarity. Pin 1 of the JST-PH connector (J_BAT1) is the positive terminal.
- Verify nominal cell voltage (single-cell Li-Po, 3.7 V nominal, 4.2 V full).
- Verify appropriate battery protection.
- Verify physical fit.
- Verify compatibility with the MCP73831 charging circuit (about 500 mA charge current).

A JST-PH connector alone does not guarantee compatible polarity. Stop using any battery that is hot, swollen, or damaged.

## 5. Firmware upload and Serial Monitor

### USB powers the board but firmware upload fails

1. Use a known data-capable USB-C cable. Many charge-only cables look identical.
2. Enter the ESP32-S3 bootloader: hold **BOOT**, press and release **RESET**, then release **BOOT**. Retry the upload.
3. In the Arduino IDE, confirm the board is **ESP32S3 Dev Module** and the correct port is selected.
4. Close any other program that has the serial port open (such as another Serial Monitor).
5. If the sketch does not compile, confirm you have the NimBLE-Arduino library, version 2.x. The sketch uses the 2.x callback signatures.

### No serial port appears

The board has no USB-to-serial chip. It uses the ESP32-S3's native USB.

1. Enter the bootloader as above. A port should appear while it is in download mode.
2. Try a different cable and a different USB port.
3. If a port still does not appear, check the USB lines in [Section 6](#6-board-level-checks-for-technicians).

### Serial Monitor shows nothing

In the Arduino IDE, set **Tools → USB CDC On Boot** to **Enabled**, re-upload, and reopen the Serial Monitor at **115200** baud. After a reset, the port may disappear and reappear, so reselect it if needed.

### What the Serial Monitor should show

At startup:

```
RB Switch firmware
SW1 GPIO10 -> Left Arrow
SW2 GPIO11 -> Enter
SW3 GPIO12 -> Right Arrow
BLE advertising as "RB Switch"
```

When a host connects: `BLE connected`. When one disconnects: `BLE disconnected; restarting advertising`. A button press prints `SW GPIOxx -> HID 0xYY`, or `Key ignored: BLE not connected` if no host is connected.

## 6. Board-level checks for technicians

Do these only with the battery disconnected unless the step says otherwise, and with ESD precautions. Use a multimeter. The PCB layout and net names are in [Hardware](hardware.md) and `electrical/mechanical_switch/`.

| Check | Where | Expected | If wrong |
|---|---|---|---|
| Battery voltage | J_BAT1 pin 1 (+) to pin 2 (−) | 3.0–4.2 V, pin 1 positive | Wrong polarity or flat/damaged cell |
| 3.3 V rail | C2 or C3, across the capacitor, battery connected | 3.3 V (±5%) | See below |
| VBUS from USB-C | C4, USB-C plugged in | About 5 V | Cable, charger, or J_USB1 solder joints |
| CC resistors | R3 (CC1) and R4 (CC2) to ground, power off | About 5.1 kΩ each | Without these, USB-C chargers may not supply power |
| Charge current set | R1 (PROG) to ground | 2 kΩ | Wrong value changes charge current |
| EN (reset) | U1 pin 45, or C12 | About 3.3 V idle, 0 V while RESET is pressed | Stuck low: SW_RST1 or C12 shorted. Stuck high: SW_RST1 open |
| IO0 (boot) | R6 / SW_BOOT1 net, U1 pin 4 | About 3.3 V idle, 0 V while BOOT is pressed | Stuck low forces download mode on every start |
| Battery sense | R7/R8 midpoint, battery connected | Half the battery voltage (for example 2.0 V at 4.0 V) | R7, R8, or C8 fault. The firmware does not read this input yet |
| USB data | J_USB1 D+ pads to U1 pin 24; D− pads to U1 pin 23 (continuity, power off) | Continuity | Open or shorted USB trace |

### 3.3 V rail is missing or wrong

1. With the battery connected, measure VBAT at C1. If it is near 0 V, the battery or connector is the problem.
2. If VBAT is good but 3.3 V is absent, measure resistance from the 3.3 V rail to ground with power off. Near 0 Ω means a shorted capacitor (C2, C3, C5, C6, C7, or C12) or a short at U1.
3. Check REG1 (TPS63001) for solder bridges, especially the exposed pad, and check L1 for a good joint on both pads.
4. REG1 enable is tied to VBAT, so it starts as soon as the battery is present.

### Board runs hot or resets under load

A hot battery, regulator, or charger is a fault. Disconnect the battery. Look for solder bridges near REG1, U_CHG1, and J_BAT1. Confirm the battery is a single-cell Li-Po rated for the load.

## 7. Switch input checks

Each of SW1, SW2, and SW3 connects its input to ground when pressed. Idle level is high, from the ESP32's internal pull-up.

1. With the board running, measure the input at the switch pad that is not ground. It should read about 3.3 V idle and about 0 V while pressed. Use a high-impedance meter, because the internal pull-up is weak.
2. With power off, check continuity across the switch contacts while pressing. It should close only when pressed.
3. No change when pressed: check the switch solder joints and the trace.
4. Reads 0 V all the time: look for a short across the 100 nF capacitor (C9, C10, or C11) on that input, or solder bridging at the switch.

| Switch | Net | U1 pin | GPIO |
|---|---|---|---|
| SW1 | `/SW1_NET` | 14 | GPIO10 |
| SW2 | `/SW2_NET` | 15 | GPIO11 |
| SW3 | `/SW3_NET` | 16 | GPIO12 |

## 8. When to ask for help

When you report a problem, include:

- The device type and operating-system version.
- Which button or action is affected.
- Whether it happens in a plain text field.
- Whether the charging light is on and whether the unit runs from USB or battery.
- The Serial Monitor output if you have it.
- What you have already tried.

For firmware or hardware issues, use the [Firmware](firmware.md) and [Hardware](hardware.md) pages and the source files. Use the repository's issue templates for bug and hardware reports.
