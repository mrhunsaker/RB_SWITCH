---
layout: default
title: Android Switch Access
---

# Android Switch Access with the RB Switch

This page is a deep dive into using the RB Switch's three buttons with Android's **Switch Access** feature. Read [Setup & Pairing](setup.md) first if you haven't paired the RB Switch yet.

## Why this page exists

The RB Switch has three physical buttons (SW1 = Left Arrow, SW2 = Enter, SW3 = Right Arrow). On **iOS/iPadOS**, all three can be assigned to distinct actions directly through the normal setup flow (see [iOS/iPadOS Switch Control](switch-control-ios.md)). On **Android**, the built-in setup wizard only ever asks you to choose between a **one-switch** or **two-switch** configuration — it does not offer a "three-switch" option. This is a real, current limitation of the guided Switch Access wizard, not a bug in the RB Switch.

The good news: Android **does** support more than two switches — up to **five** — but only through settings that sit outside the wizard. This page shows how to get there.

## 1. Install Switch Access from the Google Play Store

Switch Access is no longer only a hidden feature bundled inside Android Accessibility Suite. Google now distributes it as its **own standalone app** on the Play Store.

1. Open the **Google Play Store** app.
2. Search for **Switch Access**.
3. Install the app (or tap **Update** if it's already installed but out of date).
4. Open **Settings → Accessibility**. Switch Access should now appear under **Downloaded apps** (or simply under **Accessibility**, depending on your Android version and device manufacturer).

If you skip this step, you may still find an older, more limited version of Switch Access already on the device — but it can lag behind the Play Store version in features and bug fixes. Always check the Play Store first, especially on a device that hasn't been updated recently.

## 2. Understand the wizard's one-switch / two-switch choice

After you turn on Switch Access and grant it permission, the setup wizard walks you through:

1. Choosing a switch type — select **Bluetooth switch** for the RB Switch.
2. Selecting your device from the Bluetooth list and confirming pairing.
3. Choosing **One switch** or **Two switch**.
   - **One switch**: press the switch to start scanning; press it again to select the highlighted item (auto-scan).
   - **Two switch** (recommended starting point for the RB Switch): one switch moves ("Next"), the other selects ("Select").
4. Choosing a scanning method: **Linear scanning**, **Row-column scanning**, or **Group selection**.
5. Assigning the RB Switch buttons you want to the **Next** and **Select** roles when prompted.
6. A short practice screen, then **Finish**.

At no point does this wizard ask "do you have a third switch?" That question only exists in the advanced settings screen described next.

## 3. Add the third RB Switch button (Previous)

Once the wizard is finished, go back into the settings by hand:

1. **Settings → Accessibility → Switch Access → Settings.**
2. Confirm **Auto-scan** is off (it should be, if you chose Two switch).
3. Tap **Assign switches for scanning**.
4. You will see **Next** and **Select** already assigned from the wizard. Tap **Previous**.
5. Press the remaining RB Switch button (SW1 / Left Arrow, if you used the recommended mapping below) when prompted.
6. Tap **Save**.

You can assign **up to five total switches** this way — Next, Select, Previous, Group Selection colors, and Auto-scan Reverse are all valid targets, depending on which scanning method you picked in step 4 above. For the RB Switch's three physical buttons, **Next / Select / Previous** is the natural mapping.

### Recommended mapping

| RB Switch button | Sends | Recommended Switch Access action |
|---|---|---|
| SW1 | Left Arrow | **Previous** |
| SW2 | Enter | **Select** |
| SW3 | Right Arrow | **Next** |

This mirrors the button layout printed on the enclosure (left, center, right) and the arrow-key intuition students already have from the plain-keyboard test in [Setup & Pairing](setup.md).

If a student only needs two functions, it is entirely reasonable to stop after the wizard and leave SW1 unused on that device — nothing else needs to change, and the same RB Switch will still expose all three buttons normally to a computer, Chromebook, or iPad.

## 4. Choosing a scanning method

- **Linear scanning** moves through on-screen items one at a time (or one row at a time on a keyboard). This is the simplest method to explain to a new switch user.
- **Row-column scanning** scans by row first, then by item within the selected row. This is faster once a student is comfortable with two-step selection.
- **Group selection** requires two or more switches and divides the screen into color-coded groups; each press narrows down the selection. This method benefits the most from having a third switch assigned, since more switches mean fewer presses per selection.

Whichever method you choose, re-test all assigned buttons afterward (see [Setup & Pairing, Section 4](setup.md#4-test-the-three-buttons)).

## 5. Adjusting timing and feedback

From **Switch Access Settings**:

- **Speech, sound & vibration → Spoken feedback** reads highlighted items aloud, which can help a student who is still learning the scan pattern.
- Auto-scan timing (delay before the first item, delay between items) is adjustable if you are using the one-switch method.
- **Change Switch Access settings → [action]** lets you review or reassign any button to any action at any time, without re-running the whole wizard.

## 6. Android-specific troubleshooting

**Switch Access doesn't appear under Accessibility at all.**
Install or update the app from the Google Play Store (Step 1). On some devices it will not appear until the app has been opened at least once after installing.

**The wizard only lets me pick one or two switches, and I have three buttons.**
This is expected — see Step 3 above. The wizard is not the place to add a third switch; the **Assign switches for scanning** screen under Switch Access Settings is.

**I assigned Previous to SW1, but pressing it does nothing.**
Confirm you saved the assignment (Step 3, step 6) and that you are testing inside an app while Switch Access scanning is actually active (the screen should show a highlight box). Previous only affects the on-screen highlight; it does not undo an action that was already selected.

**Group Selection colors look confusing with three switches.**
Group Selection is most useful with three or more switches, but it does take practice. Consider starting a new student on Linear or Row-column scanning with just Next/Select, and introducing Previous or Group Selection later.

**A key on the RB Switch does something unexpected inside Switch Access, like opening a menu.**
Left Arrow, Enter, and Right Arrow are ordinary keyboard keys. If another keyboard shortcut on the device is bound to one of those keys outside of Switch Access, it can fire at the same time. Re-check the button assignment in **Assign switches for scanning**, and confirm no other keyboard-shortcut feature is intercepting the same key.

For hardware-level troubleshooting (a specific button not registering at all, on any platform), see [Troubleshooting](troubleshooting.md).
