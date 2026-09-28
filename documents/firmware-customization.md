---
layout: default
title: Firmware Customization
---

# Firmware Customization

This page is for anyone who needs to change what `RB_SWITCH_firmware.ino` actually does — remap a key, change debounce timing, rename the Bluetooth device, or adapt the firmware to a specific student's needs. If you only need to **install** the unmodified production firmware, see [Firmware](firmware.md) instead. If you need to set up switch **scanning software** on the receiving device, see [Setup & Pairing](setup.md).

This page assumes you have already installed the Arduino IDE, the ESP32 Arduino core, and the NimBLE-Arduino library, and that you can already open, verify, and upload the unmodified production sketch (see [Firmware](firmware.md)).

## Before you change anything

- Work from a copy. Duplicate `firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino` into a new sketch folder (Arduino requires the `.ino` file name to match its parent folder name) rather than editing the production file in place, unless you intend the change to become the new production behavior.
- Change one thing at a time, re-verify, re-upload, and re-test with the Serial Monitor before making a second change. The firmware is small and single-purpose; most bugs come from stacking several changes before testing any of them.
- Keep a copy of the original file. If you're using git, commit before you start editing so you can diff or revert.

## Map of the file

| Section | What it controls | Typically safe to change? |
|---|---|---|
| `SW1_PIN`, `SW2_PIN`, `SW3_PIN` constants | Which GPIO each switch reads | Yes, if you also update the wiring/schematic to match |
| `LEFT_ARROW`, `ENTER_KEY`, `RIGHT_ARROW` constants | Which HID key each switch sends | Yes — this is the most common customization |
| `DEBOUNCE_MS` constant | How long a signal must be stable before it counts as a press | Yes, in small increments |
| `SwitchState sw1/sw2/sw3` struct instances | Binds each pin to its key and debounce state | Yes, alongside the constants above |
| `sendKey()` | Builds and sends the BLE HID press/release report, including the 20 ms hold between them | Only with care — see [Changing the key-hold timing](#changing-the-key-hold-timing) |
| `setupBLE()` | Device name, advertised HID service, report descriptor, power level | Only the device name and power level are routine changes — see below |
| `updateSwitch()` | Debounce and edge-detection logic | Not recommended unless you understand the state machine; changing this can reintroduce switch bounce |
| `setup()` / `loop()` | Pin modes, startup logging, main loop | Safe to add serial logging; avoid adding blocking `delay()` calls inside `loop()` |

## Common customization: remapping a key

The three constants near the top of the file are the usual starting point:

```cpp
static constexpr uint8_t LEFT_ARROW  = 0x50;
static constexpr uint8_t ENTER_KEY   = 0x28;
static constexpr uint8_t RIGHT_ARROW = 0x4F;
```

These are USB HID Usage IDs, not ASCII characters. To remap a button, replace the constant with a different Usage ID and, if you want the name to keep making sense, rename the constant and the comments that reference it. A short reference of commonly useful codes:

| Key | HID Usage ID |
|---|---:|
| Enter / Return | `0x28` |
| Escape | `0x29` |
| Tab | `0x2B` |
| Space | `0x2C` |
| Right Arrow | `0x4F` |
| Left Arrow | `0x50` |
| Down Arrow | `0x51` |
| Up Arrow | `0x52` |
| A–Z | `0x04`–`0x1D` (A=0x04, B=0x05, … Z=0x1D) |
| 1–0 (top row) | `0x1E`–`0x27` |

For the full table, search for "USB HID Usage Tables" (Usage Page 0x07, Keyboard/Keypad) — the constants above are drawn directly from that specification, and the firmware's report descriptor already declares the full `0x00`–`0x73` range as valid, so most standard keys work without changing `setupBLE()`.

**Why you might do this:** the most common reason is adapting the RB Switch to a specific accessibility workflow rather than the default Left Arrow / Enter / Right Arrow text-navigation mapping. For example, some Switch Access or Switch Control configurations read more naturally if the "select" button sends **Space** instead of **Enter**, or if a two-switch Android configuration is simplified by making both remaining buttons send the *same* key (for example, both edge switches send Tab) so that either hand can trigger the same scanning action. If you do this, update `docs/use.md` and `docs/hardware.md` (or your local equivalents) so the documented button map stays accurate — see [Keeping documentation in sync](#keeping-documentation-in-sync).

## Changing debounce timing

```cpp
static constexpr uint32_t DEBOUNCE_MS = 35;
```

This is the minimum time a signal must stay stable before the firmware treats it as a real press. 35 ms is a reasonable default for the Omron B3F-series tactile switches used on the production PCB. If a student's motor pattern causes intermittent double-presses, increasing this value (try 50–75 ms in small steps) is a reasonable first troubleshooting step before assuming a hardware fault. If you increase it substantially (past roughly 100 ms), very fast intentional double-taps may start being merged into one press — test with the actual student, not just yourself.

## Changing the Bluetooth device name

```cpp
NimBLEDevice::init("RB Switch");
...
hid->setManufacturer("RB Switch");
...
advertisementData.setName("RB Switch");
```

All three of these should be changed together (for example, to distinguish two units in the same classroom, such as `"RB Switch 2"`). If you change the name, also update the physical label/sticker on the enclosure and the [QR Code](qr-code.md) destination if it references the device name, and re-pair any devices that had the old name saved.

## Changing the key-hold timing

```cpp
delay(20);
```

inside `sendKey()` controls how long the "key down" HID report is held before the "key up" report is sent. 20 ms is well within what any host OS expects for a single keypress. Shortening this is not recommended — some hosts debounce very short HID reports and may drop the keystroke entirely. If a receiving app seems to miss presses under load, try lengthening this value slightly (30–40 ms) before changing anything else.

## Adding a fourth input (advanced)

The production PCB and firmware are deliberately three-switch. If you are prototyping an expansion (for example, testing a 4th mechanical input on a breadboard before considering a hardware revision):

1. Pick an unused GPIO that is not one of GPIO10/11/12 and is not reserved for USB, flash, or strapping on the ESP32-S3-MINI-1-N4R2 module — check the module's datasheet before choosing.
2. Add a new `SwitchState` instance following the existing `sw1`/`sw2`/`sw3` pattern.
3. Add a matching `pinMode(..., INPUT_PULLUP)` call in `setup()`.
4. Add a matching `updateSwitch(...)` call in `loop()`.
5. Add the new HID Usage ID constant.

This is firmware-only prototyping guidance. It does **not** reflect the production hardware described in [Hardware](hardware.md), and a fourth input has no footprint on the current PCB. Do not describe a modified sketch as "the production firmware" in documentation, labels, or support conversations — see [Production scope](hardware.md) and the archived-firmware note in `firmware/BLE_ADAPTIVE_SWITCH_EXPANDED_SCAFFOLD/README.md` for why this distinction matters to this project.

## Verifying a change

After any edit:

1. **Verify** (checkmark icon) before uploading, to catch syntax errors early.
2. **Upload** over a data-capable USB-C cable.
3. Open **Serial Monitor** at 115200 baud. Confirm the startup banner still prints the mapping you expect.
4. Press each physical button and confirm the Serial Monitor logs `SW GPIOx -> HID 0xYY` for the GPIO/key pair you intended.
5. Pair with a real host device and repeat the plain-text-field test from [Setup & Pairing, Step 3](setup.md#3-test-the-buttons).
6. Only after that, re-test inside Switch Access or Switch Control if the change affects how the device should be scanned (see [Android Switch Access](switch-access-android.md) or [iOS/iPadOS Switch Control](switch-control-ios.md)).

## Keeping documentation in sync

If a firmware change alters the button mapping, debounce timing, or device name from what's documented, update all of the following so a future maintainer isn't misled by a stale table:

- `README.md`
- `docs/index.md` and `documents/index.md`
- `docs/use.md` and `documents/use.md`
- `docs/hardware.md` and `documents/hardware.md` (if the wiring itself changed)
- The firmware's own header comment and `Serial.println()` startup banner

See [CONTRIBUTING.md](https://github.com/mrhunsaker/RB_SWITCH/blob/main/CONTRIBUTING.md) in the repository root for the full documentation-sync expectation for pull requests.
