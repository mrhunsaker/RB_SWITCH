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

The documentation covers:

- [Setup & Pairing](docs/setup.md)
- [Switch Operation](docs/use.md)
- [Firmware](docs/firmware.md)
- [Hardware](docs/hardware.md)
- [Troubleshooting](docs/troubleshooting.md)
- [QR Code](docs/qr-code.md)

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
