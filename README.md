# RB Switch

The RB Switch is a three-button Bluetooth Low Energy (BLE) accessibility switch. It presents itself to a computer, tablet, or phone as a standard Bluetooth keyboard.

## Production firmware

The production firmware is:

`firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino`

### Button mapping

| Switch | GPIO | Keyboard key |
|---|---:|---|
| SW1 | GPIO10 | Left Arrow |
| SW2 | GPIO11 | Enter |
| SW3 | GPIO12 | Right Arrow |

Each button press produces one key press followed by one key release. Holding a button does not repeat the key.

## Getting started

For normal setup and classroom use, start with [Setup & Pairing](docs/setup.md).

**Important for Android users:** Android's Switch Access is a separate app you install/update from the Google Play Store, and its setup wizard only offers a one-switch or two-switch configuration — it does not offer a third switch by default. Using the RB Switch's third button on Android requires one extra step beyond the wizard. This is different from iOS/iPadOS, where all three buttons can be assigned directly in the normal setup flow. See [Android Switch Access](docs/switch-access-android.md) and [iOS/iPadOS Switch Control](docs/switch-control-ios.md) for the full explanation before you configure a device.

The documentation covers:

- [Setup & Pairing](docs/setup.md)
- [Android Switch Access](docs/switch-access-android.md)
- [iOS/iPadOS Switch Control](docs/switch-control-ios.md)
- [Switch Operation](docs/use.md)
- [Firmware](docs/firmware.md)
- [Firmware Customization](docs/firmware-customization.md)
- [Hardware](docs/hardware.md)
- [Troubleshooting](docs/troubleshooting.md)
- [QR Code](docs/qr-code.md)

A printable classroom quick-reference is also available: `RB_Switch_Paraprofessional_Setup_Guide.docx`.

## Hardware

The current board uses:

- ESP32-S3-MINI-1-N4R2
- Three Omron B3F-series tactile switches
- USB-C power/programming connection
- Single-cell Li-Po battery connection and charger
- TPS63001 3.3 V buck-boost regulator
- Battery-voltage sensing
- MCP73831 charge-status LED

Hardware source files are in `electrical/`, `bom/`, and `mechanical/`.

## Production scope

The production design has three mechanical switch inputs only. It does not implement touch sensors, proximity sensors, NeoPixel/RGB indicators, mono-jack inputs, or the earlier F-key input mapping.

The charge-status LED (D1) is controlled by the battery charger and is not a programmable RGB LED.

## Documentation source

`docs/` is the published GitHub Pages source.

`documents/` contains the same documentation in a packaging-friendly directory. Keep the two documentation sets synchronized when documentation changes.

## GitHub Pages and enclosure QR code

Publish `docs/` with GitHub Pages. The enclosure QR code should point to the published documentation home page. See [QR Code](docs/qr-code.md).

## Contributing

Contributions to firmware, hardware, and documentation are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for project structure, how to propose a change, and pull request expectations, and [CODE_STYLE.md](CODE_STYLE.md) for formatting and naming conventions. Please review [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before participating.

## Security

To report a suspected security or safety issue, see [SECURITY.md](SECURITY.md) rather than opening a public issue.

## Changelog

See [CHANGES.md](CHANGES.md) for a history of notable changes.

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for the full text, including a note on hardware-specific licensing alternatives.

