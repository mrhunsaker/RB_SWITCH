# Security Policy

RB Switch is a Bluetooth Low Energy (BLE) HID keyboard device built for classroom and personal accessibility use. This policy covers reporting security issues in the firmware, hardware design, or documentation, and describes the security properties of the device as shipped so users and IT staff can make informed deployment decisions.

## Supported versions

Only the current production firmware (`firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino`) and the current hardware revision documented in `docs/hardware.md` are supported. The archived scaffold under `firmware/BLE_ADAPTIVE_SWITCH_EXPANDED_SCAFFOLD/` is historical reference only and will not receive security fixes.

## Reporting a vulnerability

Please **do not open a public GitHub issue** for a suspected security vulnerability.

Instead, use GitHub's private vulnerability reporting for this repository (**Security → Advisories → Report a vulnerability**) if available, or contact the maintainer directly through the contact information on their GitHub profile ([@mrhunsaker](https://github.com/mrhunsaker)). Please include:

- A description of the issue and its potential impact.
- Steps to reproduce, including firmware version/commit and hardware revision if relevant.
- Whether the issue is in firmware, hardware design, documentation guidance, or the build/release process.

You should expect an initial response acknowledging the report. Because this is a small, community-maintained project rather than a commercial product with a dedicated security team, response and fix timelines will depend on maintainer availability — please be patient, and feel free to follow up if you haven't heard back after a reasonable interval.

## Known security properties of the device (please read before deploying)

Being transparent about these properties is more useful to deployers than treating them as a secret, since they affect how and where the device should be used.

### BLE pairing

The production firmware calls NimBLE's security setup with **bonding enabled, no MITM (man-in-the-middle) protection, and no LE Secure Connections**. In practice this means:

- The device uses "Just Works" BLE pairing. It does not use a PIN, passkey, or out-of-band confirmation step.
- Any nearby BLE-capable device can initiate pairing with the RB Switch while it is advertising and not already bonded to a host.
- Once bonded, the RB Switch will reconnect to its bonded host(s) and re-advertise if disconnected.

**What this means in practice:** the RB Switch is appropriate for its intended use case — a single physical switch device paired to a single student's device in a supervised classroom or home setting — but it should not be treated as a device with strong resistance to a nearby attacker deliberately trying to intercept or hijack the pairing process. It has no more (and no less) BLE authentication strength than most consumer BLE accessory keyboards and switches.

### HID keystroke content

As a BLE HID keyboard, the RB Switch only ever sends the three fixed keystrokes described in `docs/use.md` (or whatever keys a locally modified firmware sends — see `docs/firmware-customization.md`). It has no microphone, camera, storage, or network stack beyond BLE, and cannot exfiltrate any data from the host device; it can only send keystrokes to whatever host it is currently bonded/connected to.

### Firmware provenance

Only flash firmware you have built from a trusted copy of this repository (or your own audited fork). Because uploading firmware requires physical USB-C access to the board, the main supply-chain risk is a modified `.ino` file distributed outside this repository, not remote exploitation. If you distribute pre-built devices (for example, to a school district), keep a record of which firmware commit/version was flashed to which device, consistent with the recommendation in `CONTRIBUTING.md`.

### Physical and battery safety

This is a hardware device with a Li-Po battery and charging circuit (MCP73831). Before connecting or replacing a battery:

- Verify connector polarity — a JST-PH connector fitting is not proof of correct polarity.
- Verify nominal cell voltage and that the cell has appropriate protection circuitry.
- Do not open the enclosure or replace the battery unless trained and authorized to do so.

See `docs/troubleshooting.md` for the full battery-safety checklist. Report any physical defect (damaged battery, exposed wiring, cracked enclosure) as you would any other hardware safety issue at your site, in addition to (or instead of, if it's not a design flaw) reporting it here.

## Disclosure

Given this project's small scale, we do not currently operate a formal embargo/disclosure timeline. If a reported issue has broad impact, the maintainer will coordinate a reasonable disclosure timeline with the reporter before any public write-up, and will credit reporters who wish to be credited once a fix is available.
