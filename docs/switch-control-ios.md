---
layout: default
title: iOS/iPadOS Switch Control
permalink: /switch-control-ios.html
---

# iOS/iPadOS Switch Control with the RB Switch

This page is a deep dive into using the RB Switch's three buttons with Apple's **Switch Control** accessibility feature on iPhone and iPad. Read [Setup & Pairing]({{ '/setup.html' | relative_url }}) first if you haven't paired the RB Switch yet.

## How this differs from Android

Switch Control is built into iOS/iPadOS — there is no separate app to install from the App Store. More importantly for the RB Switch, **Switch Control does not force a choice between "one switch" and "two switch" the way Android's Switch Access wizard does.** Instead, you add switches one at a time, and each new switch is assigned to whichever action you pick from a full list. Because of this, all three RB Switch buttons can be given three distinct, independent actions from the very first setup pass, with no extra steps required beyond what's already in [Setup & Pairing]({{ '/setup.html' | relative_url }}). If you're coming from an Android Switch Access setup and wondering why there's no equivalent "advanced settings" step here — there isn't one needed. See [Android Switch Access]({{ '/switch-access-android.html' | relative_url }}) for the contrast.

## Turning on Switch Control

1. Pair **RB Switch** in **Settings → Bluetooth** (see [Setup & Pairing]({{ '/setup.html' | relative_url }})).
2. Open **Settings → Accessibility → Switch Control**.
3. Turn on **Switch Control**.

The first time it's enabled, iOS may briefly show an onboarding screen. You can dismiss it and configure switches directly.

## Adding all three RB Switch buttons

1. Open **Switches → Add New Switch → External**.
2. Press the RB Switch button you want to assign first (there's no required order).
3. When prompted, choose the action for that button. Common first choices:
   - **Select Item**
   - **Move to Next Item**
   - **Move to Previous Item**
4. Tap **Add New Switch** again and repeat for the second button.
5. Repeat once more for the third button.

### Recommended mapping

| RB Switch button | Sends | Recommended Switch Control action |
|---|---|---|
| SW1 | Left Arrow | **Move to Previous Item** |
| SW2 | Enter | **Select Item** |
| SW3 | Right Arrow | **Move to Next Item** |

This mirrors the left/center/right layout of the enclosure and the arrow-key intuition students already have from the plain-keyboard test in [Setup & Pairing]({{ '/setup.html' | relative_url }}), and it maps directly onto the equivalent Android recommendation, so a student who uses both an iPad and an Android device gets a consistent physical mapping even though the two operating systems configure it differently.

Switch Control offers many more actions than these three (Long Press, Tap, gestures, scrolling, opening Control Center, running a custom "Recipe," and more). Because assignment is per-switch and not limited to a fixed set of roles, you can give any RB Switch button any of these actions if the default mapping above doesn't fit a particular student.

## Choosing a scanning style

**Settings → Accessibility → Switch Control → Scanning Style** offers:

- **Auto Scanning** — the highlight moves on its own; press a switch to select. Works with as few as one assigned switch.
- **Manual Scanning** — you press one switch to move the highlight and another to select. This is the natural fit for the RB Switch's Left/Right + Enter mapping above.
- **Single Switch Step** — a single switch both moves and (after a pause) selects.

**Auto Scanning** and **Manual Scanning** both make use of a third switch if you've assigned **Move to Previous Item**, letting a student correct an overshoot without waiting for the scan to wrap back around.

## Adjusting timing and feedback

- **Settings → Accessibility → Switch Control → Auto Scanning Time** adjusts how long each item is highlighted before Auto Scanning moves on.
- **Switch Control → Switch Stabilization** and **Switch Control → Ignore Repeat** help filter out accidental double-presses, which can be useful if a student's motor control causes brief bounces (see also the firmware-level debounce described in [Firmware]({{ '/firmware.html' | relative_url }})).
- **Switch Control → Sound Effects** and **Speech** provide audio feedback as the highlight scans, which can help a student learn the pattern before relying on vision alone.

## iOS/iPadOS-specific troubleshooting

**A button is recognized as a keypress but Switch Control never highlights anything.**
Confirm Switch Control is actually turned on (Step 1) — the RB Switch will still send Left Arrow / Enter / Right Arrow to any app whether or not Switch Control is active, which can look like "it's connected but nothing happens" if you're testing inside an app that also responds to arrow keys.

**I want to reassign a button to a different action.**
Open **Switches**, tap the existing switch entry, and choose a new action. You do not need to remove and re-add it.

**Menu wording doesn't match this page.**
Apple periodically renames or relocates Switch Control menu items between iOS/iPadOS releases. The concepts above (Switches → Add New Switch → External, per-switch action assignment, scanning style) have been stable across recent releases even when exact wording shifts.

For hardware-level troubleshooting (a specific button not registering at all, on any platform), see [Troubleshooting]({{ '/troubleshooting.html' | relative_url }}).
