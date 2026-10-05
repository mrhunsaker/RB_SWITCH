# RB Switch

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
![GitHub top language](https://img.shields.io/github/languages/top/mrhunsaker/RB_SWITCH)
[![Documentation](https://img.shields.io/badge/docs-RB_SWITCH-blue)](https://mrhunsaker.github.io/RB_SWITCH/)
[![Last commit](https://img.shields.io/github/last-commit/mrhunsaker/RB_SWITCH)](https://github.com/mrhunsaker/RB_SWITCH/commits/main)
![GitHub Release](https://img.shields.io/github/v/release/mrhunsaker/RB_SWITCH)
[![Contributors](https://img.shields.io/github/contributors/mrhunsaker/RB_SWITCH)](https://github.com/mrhunsaker/RB_SWITCH/graphs/contributors)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

The RB Switch is a three-button Bluetooth Low Energy (BLE) accessibility switch. It presents itself to a computer, tablet, or phone as a standard Bluetooth keyboard, so it works with Switch Control (iOS/iPadOS), Switch Access (Android), and any app that accepts keyboard input.

## At a glance

| | |
|---|---|
| **Buttons** | SW1 Left Arrow, SW2 Enter, SW3 Right Arrow |
| **Bluetooth name** | RB Switch |
| **Microcontroller** | ESP32-S3-MINI-1-N4R2 |
| **Power** | USB-C or a single-cell Li-Po battery. No power switch and no sleep mode. |
| **Charging** | MCP73831, about 500 mA. D1 lights while charging. |
| **Regulator** | TPS63001 3.3 V buck-boost |
| **PCB** | KiCad 10, 4 layers, 115 × 38 mm |
| **Firmware** | Arduino sketch using NimBLE-Arduino 2.x |

## Quick start

1. Power the switch from USB-C or its battery.
2. Pair **RB Switch** in the device's Bluetooth settings.
3. Press each button in a text field: Left, Enter, Right.
4. Set up Switch Control (iOS/iPadOS) or Switch Access (Android) from the guides below.

**Important for Android users:** Android's Switch Access is a separate app you install/update from the Google Play Store, and its setup wizard only offers a one-switch or two-switch configuration. It does not offer a third switch by default. Using the RB Switch's third button on Android requires one extra step beyond the wizard. This is different from iOS/iPadOS, where all three buttons can be assigned directly in the normal setup flow. See [Android Switch Access](docs/switch-access-android.md) and [iOS/iPadOS Switch Control](docs/switch-control-ios.md) before you configure a device.

## Production firmware

The production firmware is:

`firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino`

### Button mapping

| Switch | GPIO   | Keyboard key |
| ------ | ------:| ------------ |
| SW1    | GPIO10 | Left Arrow   |
| SW2    | GPIO11 | Enter        |
| SW3    | GPIO12 | Right Arrow  |

Each button press produces one key press followed by one key release. Holding a button does not repeat the key. A press made while no host is connected is ignored.

### Building the firmware

1. Install the Arduino IDE, the **ESP32 Arduino core** by Espressif, and **NimBLE-Arduino 2.x**.
2. Select **ESP32S3 Dev Module** and set **USB CDC On Boot** to **Enabled**.
3. Open the `.ino` file, click **Verify**, then **Upload** over a data-capable USB-C cable. If the upload does not start, hold BOOT, tap RESET, release BOOT.
4. Open the Serial Monitor at 115200 baud.

See [Firmware](docs/firmware.md) for details.

## Documentation

| For | Read |
|---|---|
| Classroom staff setting up a device | [Setup & Pairing](docs/setup.md) |
| iPad and iPhone | [iOS/iPadOS Switch Control](docs/switch-control-ios.md) |
| Android phones and tablets | [Android Switch Access](docs/switch-access-android.md) |
| How the buttons behave | [Switch Operation](docs/use.md) |
| Something is not working | [Troubleshooting](docs/troubleshooting.md) |
| Evaluating a student for switch access and teaching switch skills | [Switch Evaluation Package](docs/evaluation-package.md) |
| Programming the board | [Firmware](docs/firmware.md), [Firmware Customization](docs/firmware-customization.md) |
| Hardware reference | [Hardware](docs/hardware.md) |
| Enclosure label | [QR Code](docs/qr-code.md) |

Published documentation: <https://mrhunsaker.github.io/RB_SWITCH/>

Two printable Word documents are also available. Both are generated from the matching page in `docs/`.

| Download | Source page | Use |
|---|---|---|
| [`RB_Switch_Paraprofessional_Setup_Guide.docx`](RB_Switch_Paraprofessional_Setup_Guide.docx) | `docs/setup.md` | Classroom quick-reference for pairing, setup and troubleshooting |
| [`RB_Switch_Evaluation_Package.docx`](RB_Switch_Evaluation_Package.docx) | `docs/evaluation-package.md` | Fill-in package for evaluating, teaching and documenting adaptive switch access (checklists, five-stage data sheets, graphing sheet, summary report, IEP goal bank) |

## Troubleshooting at a glance

| Symptom | First thing to try |
|---|---|
| Not in the Bluetooth list | Check power; turn Bluetooth off on other nearby devices that were paired before |
| Listed but will not connect | Forget RB Switch on the device and pair again |
| Connected, but no button works | Check it still shows Connected; a press made while disconnected is lost |
| Only two buttons work on Android | Assign the third switch under Assign switches for scanning |
| Will not power on | Charge from USB-C for 30 minutes with a known-good cable |
| Upload fails or no serial port | Hold BOOT, tap RESET, release BOOT; use a data cable |

The full guide, including board-level checks for technicians, is in [Troubleshooting](docs/troubleshooting.md).

## Hardware

The current board uses:

- ESP32-S3-MINI-1-N4R2
- Three Omron B3F-series tactile switches
- USB-C power/programming connection (native USB, no USB-to-serial chip)
- Single-cell Li-Po battery connection and MCP73831 charger
- TPS63001 3.3 V buck-boost regulator
- Battery-voltage sensing (not yet used by the firmware)
- MCP73831 charge-status LED
- Reset and boot buttons, with a 10 kΩ pull-up and 1 µF capacitor on the reset line

Hardware source files are in `electrical/`, `bom/`, and `mechanical/`.

| Path | Contents |
|---|---|
| `electrical/mechanical_switch/RB_Switch.kicad_sch`, `.kicad_pcb` | Current KiCad 10 schematic and 4-layer PCB. The schematic is fully wired and its netlist matches the PCB. |
| `electrical/mechanical_switch/VERIFICATION.md` | How the board was checked against the firmware, and what was not checked |
| `electrical/mechanical_switch/net_table.json` | Net-by-net list of pads |
| `bom/` | BOMs and placement files for JLCPCB and PCBWay, plus sourcing notes |
| `mechanical/` | Enclosure (OpenSCAD) |
| `docs/hardware.md` | Pin map and a part-by-part description of the connections |

> **Before ordering boards:** the files in `electrical/mechanical_switch/gerbers/` and the PCB images in `electrical/mechanical_switch/diagrams/` come from an earlier layout. Re-export them with `create_gerber.ps1` and check the CPL orientation of U1, REG1, D1, J_USB1, and L1 in the fab's preview.

## Production scope

The production design has three mechanical switch inputs only. It does not implement touch sensors, proximity sensors, NeoPixel/RGB indicators, mono-jack inputs, or the earlier F-key input mapping.

The charge-status LED (D1) is controlled by the battery charger and is not a programmable RGB LED.

## Repository layout

| Path | Contents |
|---|---|
| `firmware/RB_SWITCH_firmware/` | Production sketch |
| `firmware/BLE_ADAPTIVE_SWITCH_EXPANDED_SCAFFOLD/` | Archived earlier firmware, not production |
| `electrical/` | KiCad project, gerbers, diagrams, verification notes |
| `bom/` | BOM, placement and sourcing files |
| `mechanical/` | Enclosure and storage box models |
| `docs/` | GitHub Pages source |
| `documents/` | Packaging-friendly copy of `docs/` |
| `tools/` | Scripts that keep `documents/` and the printable Word documents in sync with `docs/` |
| `RB_Switch_Paraprofessional_Setup_Guide.docx` | Printable classroom guide |
| `RB_Switch_Evaluation_Package.docx` | Printable switch evaluation package |
| `CHANGES.md` | Changelog |

## Documentation source

`docs/` is the published GitHub Pages source.

`documents/` contains the same documentation in a packaging-friendly directory. Keep the two documentation sets synchronized when documentation changes.

After editing `docs/`, run:

```
python3 tools/sync_documents.py
node tools/build_docx.js
```

The first script rewrites `documents/` from `docs/`. The second rebuilds both Word documents (`RB_Switch_Paraprofessional_Setup_Guide.docx` from `docs/setup.md` and `RB_Switch_Evaluation_Package.docx` from `docs/evaluation-package.md`). It needs Node.js and the `docx` package (`npm install docx`). Pass `setup` or `evaluation` to build just one. See [tools/README.md](tools/README.md).

## GitHub Pages and enclosure QR code

Publish `docs/` with GitHub Pages. The enclosure QR code should point to the published documentation home page. See [QR Code](docs/qr-code.md).

## Contributing

Contributions to firmware, hardware, and documentation are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for project structure, how to propose a change, and pull request expectations, and [CODE_STYLE.md](CODE_STYLE.md) for formatting and naming conventions. Please review [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before participating.

## Security

To report a suspected security or safety issue, see [SECURITY.md](SECURITY.md) rather than opening a public issue.

## Changelog

See [CHANGES.md](CHANGES.md) for a history of notable changes.

## License

This project is licensed under the APACHE 2.0 License— see [LICENSE](LICENSE) for the full text, including a note on hardware-specific licensing alternatives.
