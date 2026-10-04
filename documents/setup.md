---
layout: default
title: Setup & Pairing
---

# Quick Setup & Classroom Use Guide

<!-- web-only -->
**[Download this guide for printing](https://github.com/mrhunsaker/RB_SWITCH/raw/main/RB_Switch_Paraprofessional_Setup_Guide.docx)**

For paraprofessionals and K–12 staff. This page is the same content as the printable guide, `RB_Switch_Paraprofessional_Setup_Guide.docx`. The printable guide is generated from this page (see [CONTRIBUTING](https://github.com/mrhunsaker/RB_SWITCH/blob/main/CONTRIBUTING.md)), so the two stay in sync.
<!-- /web-only -->

> **Before you begin: Android and iOS/iPadOS are different here.**
> The RB Switch has three buttons. On an iPad or iPhone, all three can be set up in one pass. On an Android phone or tablet, the built-in setup only walks you through two of the three buttons, and Switch Access itself must be installed from the Google Play Store first. Section 6 covers the Android steps in full, including the extra step for the third button. Read it even if you've set up switches on Android before.

## At a glance

| Button | Position | Sends | Suggested scanning action |
|---|---|---|---|
| SW1 | Left | Left Arrow | Previous item |
| SW2 | Center | Enter | Select |
| SW3 | Right | Right Arrow | Next item |

- **Bluetooth name:** RB Switch
- **Power:** USB-C or the installed battery. There is no power switch; the RB Switch is on whenever it has power.
- **Charging light (D1):** on while the battery charges from USB-C. It is not a button indicator.
- **If something is wrong:** go to Section 8, then Section 11.

## 1. What the RB Switch does

The RB Switch is a three-button Bluetooth accessibility switch. It connects to a tablet, phone, Chromebook, Mac, or Windows computer and acts like a standard Bluetooth keyboard. The three physical buttons send three different keyboard commands.

| Button | Sends | In a plain text field |
|---|---|---|
| SW1 (left) | Left Arrow | Cursor moves left |
| SW2 (center) | Enter | Enter/Return |
| SW3 (right) | Right Arrow | Cursor moves right |

The RB Switch does not need an app, and it does not need to be turned on. It starts advertising over Bluetooth as soon as it has power.

## 2. Before you start

- Have the student's device nearby (iPad, iPhone, Android device, Chromebook, Mac, or Windows PC).
- Make sure Bluetooth is turned on.
- Make sure the RB Switch has power. It can be powered by USB-C or its installed battery.
- Keep the RB Switch close to the device while pairing. About 1–3 feet is ideal.
- If the RB Switch has already been paired to another nearby device, that device may reconnect to it first. If needed, turn Bluetooth off on the other device or choose Forget on it.
- If the student's device is Android, install or update the Switch Access app from the Google Play Store before you start (see Section 6). This is a change from older Android versions, where the feature was bundled in automatically.

## 3. Connect the RB Switch by Bluetooth

Use the instructions for the student's device below. Look for **RB Switch** in the list of devices. The name is the same on every unit, so if several RB Switches are in the same room, pair one at a time with the others unplugged or out of range.

### iPad or iPhone

1. Open Settings.
2. Tap Bluetooth.
3. Make sure Bluetooth is On.
4. Look under Other Devices for RB Switch.
5. Tap RB Switch.
6. Wait until it shows as Connected.

### Android phone or tablet

1. Open Settings.
2. Open Bluetooth or Connected devices → Bluetooth. The exact wording varies by device.
3. Make sure Bluetooth is On.
4. Look for RB Switch in the available devices list.
5. Tap RB Switch and complete pairing if Android asks you to do so.
6. Confirm that RB Switch shows as connected.

### Windows PC

1. Open Settings.
2. Select Bluetooth & devices.
3. Turn Bluetooth On.
4. Select Add device → Bluetooth.
5. Select RB Switch.
6. Wait for Windows to finish connecting.

### Mac

1. Open System Settings.
2. Select Bluetooth.
3. Turn Bluetooth On.
4. Find RB Switch in the list of nearby devices.
5. Click Connect.

### Chromebook

1. Click the time in the lower-right corner.
2. Open Bluetooth.
3. Turn Bluetooth On.
4. Select RB Switch from the available devices.
5. Complete pairing if prompted.

## 4. Test the three buttons

Before configuring accessibility settings, test the RB Switch in a place where you can see normal keyboard input. For example, open a text field, a simple document, or another application that accepts keyboard commands.

- Press the left button (SW1). The cursor should move left.
- Press the center button (SW2). Enter/Return should be sent.
- Press the right button (SW3). The cursor should move right.

*Note: Do this test before turning on Switch Control or Switch Access. If a button doesn't work here, it won't start working once accessibility scanning is turned on. See Section 8.*

## 5. Set up Switch Control on iPad/iPhone

Use these steps when the student will operate an iPad or iPhone using Apple's Switch Control accessibility feature. Unlike Android, all three RB Switch buttons can be assigned here without any extra steps.

1. Open Settings.
2. Tap Accessibility.
3. Tap Switch Control.
4. Turn Switch Control On.
5. Tap Switches.
6. Tap Add New Switch.
7. Choose External.
8. When the device asks you to activate a switch, press the RB Switch button you want to assign.
9. Choose the action you want that button to perform.
10. Repeat Add New Switch for the other RB Switch buttons you want the student to use.

Suggested mapping: SW1 (Left Arrow) → Move to Previous Item, SW2 (Enter) → Select Item, SW3 (Right Arrow) → Move to Next Item. This uses all three buttons right away.

Full details: [iOS/iPadOS Switch Control](switch-control-ios.md).

## 6. Set up Switch Access on Android

> **Android limits the setup wizard to two switches. Here's how to add the third.**
> Google's Switch Access is now its own app on the Play Store, and its guided setup only ever asks for one or two switches, never three. To use the RB Switch's third button, you finish the two-switch wizard first, then add the third button afterward in a separate settings screen. Steps 1 and 9–10 below are the parts most generic instructions leave out.

1. Open the Google Play Store app and search for Switch Access. Install it, or tap Update if it's already installed. (If your device shows Switch Access under Accessibility without doing this, it may be an older, bundled version. Check the Play Store anyway.)
2. Open Settings.
3. Open Accessibility.
4. Find and tap Switch Access.
5. Turn Switch Access On, and tap Allow when asked to grant the accessibility permission.
6. When the setup wizard runs, choose Bluetooth switch as your switch type, then select RB Switch from the list.
7. The wizard will ask you to choose One switch or Two switch. Choose Two switch.
8. When prompted, press the button you want as Next (recommended: SW3 / right button), then the button you want as Select (recommended: SW2 / center button). Choose a scanning method and finish the wizard.
9. To add the third button (SW1 / left button), leave the wizard and go to: Settings → Accessibility → Switch Access → Settings → Assign switches for scanning → Previous.
10. Press SW1 when prompted, then tap Save.

If a student only needs two functions (scan and select), you can stop after step 8 and simply not use the third button on that device. Nothing else needs to change.

| RB Switch button | Sends | Recommended Switch Access action |
|---|---|---|
| SW1 (left) | Left Arrow | Previous |
| SW2 (center) | Enter | Select |
| SW3 (right) | Right Arrow | Next |

*Note: Android supports up to five assigned switches once you're past the wizard (Next, Select, Previous, and more, depending on scanning method), but the wizard itself only ever asks about one or two. Menu wording can vary by Android version and device manufacturer.*

Full details: [Android Switch Access](switch-access-android.md).

## 7. Using the RB Switch during the school day

- The RB Switch does not need a separate app for basic operation.
- Once paired, keep the student's device within normal Bluetooth range (about 30 feet in open air, less through walls and furniture).
- If the device stops responding, first check whether RB Switch still shows as connected in Bluetooth settings.
- If the RB Switch loses its connection, it starts advertising again by itself. The device usually reconnects without any action.
- A button press made while the RB Switch is not connected is not saved and is not sent later. Check the connection before assuming a button is broken.
- If the student moves between devices, make sure the switch is disconnected from the previous device before pairing it to the new one.
- The three buttons always use the same keyboard mapping: Left Arrow, Enter, Right Arrow. What that mapping *does* on screen depends on how Switch Control or Switch Access is configured on that specific device.
- The RB Switch has no power switch and no sleep mode. Recharge it regularly, and unplug the battery connector (trained staff only) if it will be stored for a long time.

## 8. Quick troubleshooting

Start with the table, then use the matching section below. The online [Troubleshooting](troubleshooting.md) page has more detail.

| What you see | Most likely cause | First thing to try |
|---|---|---|
| RB Switch is not in the Bluetooth list | No power, or already connected elsewhere | Check power; turn Bluetooth off on other nearby devices |
| It is listed but will not connect | Old saved pairing | Forget RB Switch on the device and pair again |
| Connected, but no button works | Connection dropped, or the host is not listening | Reconnect in Bluetooth settings; test in a text field |
| One button does nothing | Switch or solder joint problem | Note which button and report it |
| Only two buttons work on Android | Third switch not assigned yet | Section 6, steps 9–10 |
| Works in a text field but not in Switch Control/Access | Accessibility feature not set up | Re-add the switch (Sections 5–6) |
| Cursor or selection jumps twice | Host-side repeat settings or a worn switch | Check Switch Stabilization/Ignore Repeat; report if it continues |
| Light stays on or does not come on while plugged in | Normal in some cases; see Section 9 | Read Section 9 |

### RB Switch is not listed in Bluetooth

1. Make sure the RB Switch has power. If it runs from its battery, plug in USB-C for a few minutes in case the battery is flat.
2. Wait a few seconds and refresh the Bluetooth device list.
3. Move the RB Switch closer to the student's device.
4. Check whether it is already connected to another nearby device. Only one device can use the RB Switch at a time.
5. If an old RB Switch entry is saved but the device will not connect, choose Forget/Remove this device and pair it again.

### RB Switch is connected, but a button does nothing

- Press each of the three buttons. The expected mapping is SW1 = Left Arrow, SW2 = Enter, SW3 = Right Arrow.
- Check that RB Switch shows Connected in Bluetooth settings. A press made while it is disconnected is lost.
- If all three buttons fail, disconnect and reconnect RB Switch in Bluetooth settings.
- If only one button fails, note which button fails and report that information to the person responsible for equipment support.

### Only two of the three buttons do anything on an Android device

- This is expected unless you completed steps 9–10 in Section 6 (Assign switches for scanning → Previous).
- It is not a sign of a broken button. Check Section 6 before assuming a hardware problem.
- This does not happen on iPad/iPhone, Windows, Mac, or Chromebook.

### The switch works in a text box but not in the student's accessibility app

- Confirm the accessibility feature is turned on.
- Check that the physical button was added as an external switch in the accessibility settings.
- Re-add the switch if necessary and press the requested RB Switch button when the device asks for it.
- If the problem continues, record the device type, operating-system version if known, and which button/action is affected.

### The connection keeps dropping

- Move the RB Switch and the device closer together and away from other wireless equipment such as routers, microwaves, and several other Bluetooth devices.
- Check the battery. Charge it from USB-C for at least an hour and try again.
- Forget RB Switch on the device and pair it again.

### The student moved to a different device

- Disconnect or forget RB Switch on the old device if it keeps reconnecting there.
- Pair RB Switch with the new device.
- Run the three-button test.
- Reconfigure Switch Control or Switch Access on the new device if required.

More: [Troubleshooting](troubleshooting.md).

## 9. Charging and power

The PCB includes USB-C power and a single-cell Li-Po charging circuit. The charge-status light (D1) is a charging indicator. It is not an RGB status light and does not indicate which button was pressed or whether Bluetooth is connected.

- Use the USB-C connection supplied for the device.
- **Charging light on:** the battery is charging from USB-C.
- **Charging light off:** charging is complete, or USB-C is not connected.
- While the switch is plugged in and in use, the charger may take longer to finish and the light may stay on longer than expected. This is normal.
- If the switch is not powering on, try a known-good USB-C power source and cable. If it still does not respond, the battery may be flat or disconnected.
- The RB Switch has no power switch. It is on whenever the battery is connected or USB-C is plugged in.
- Do not open the enclosure or replace the battery unless you are trained and authorized to service the device.
- Do not assume a replacement battery has the correct connector polarity just because the connector fits.

## 10. Daily checklist

1. Check that the RB Switch shows Connected in Bluetooth settings.
2. Press each button once in a text field. Left, Enter, Right.
3. Check that Switch Control or Switch Access is turned on.
4. At the end of the day, plug the RB Switch in to charge.

## 11. Getting help

Before asking for support, write down:

- The device type (for example, iPad 9th generation) and its operating-system version if known.
- Which button or action is affected (SW1, SW2, SW3).
- Whether the problem happens in a plain text field as well as in Switch Control or Switch Access.
- Whether the charging light is on.
- What you have already tried.

Scan the QR code on the enclosure to return to the latest online instructions.

## 12. Technical support / reprogramming (not normally needed by paraprofessionals)

The current production sketch is `firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino`. The current GitHub project specifies the following Arduino setup:

- Install Arduino IDE.
- Install the ESP32 Arduino core by Espressif.
- Install the NimBLE-Arduino library, version 2.x.
- Select an ESP32-S3 target; the project documentation normally uses ESP32S3 Dev Module.
- In the Tools menu, set USB CDC On Boot to Enabled so the Serial Monitor works.
- Open the production .ino file, verify it, and upload it using a data-capable USB-C cable.
- If the board does not enter download mode automatically, hold BOOT, press and release RESET, then release BOOT.
- Use Serial Monitor at 115200 baud for diagnostics.

| Switch | GPIO | Keyboard key |
|---|---|---|
| SW1 | GPIO10 | Left Arrow |
| SW2 | GPIO11 | Enter |
| SW3 | GPIO12 | Right Arrow |

If a button mapping, debounce timing, or device name ever needs to change (for example, to better fit a specific student's Switch Access or Switch Control setup), see [Firmware Customization](firmware-customization.md) before asking a technician to make firmware changes.
