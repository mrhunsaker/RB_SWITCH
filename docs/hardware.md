---
layout: default
title: Hardware Reference
permalink: /hardware.html
---

# Hardware Reference

This page describes the current RevD/RevD2 hardware.

## User controls

| Reference | Function | MCU connection |
|---|---|---|
| SW1 | Left Arrow | `SW1_NET` → U1 pin 14 → GPIO10 |
| SW2 | Enter | `SW2_NET` → U1 pin 15 → GPIO11 |
| SW3 | Right Arrow | `SW3_NET` → U1 pin 16 → GPIO12 |

Each switch input has a 100 nF capacitor to ground.

## Main electronics

| Reference | Part | Function |
|---|---|---|
| U1 | ESP32-S3-MINI-1-N4R2 | BLE MCU |
| REG1 | TPS63001DRCR | 3.3 V buck-boost regulation |
| U_CHG | MCP73831T-2ACI/OT | Li-Po charging |
| J_USB | USB-C receptacle | Power / USB connection |
| J_BAT | JST-PH 2-pin | Battery connection |
| D1 | 0603 LED | Charge status |
| R7/R8 + C8 | Battery sense network | Battery voltage measurement |

## PCB module labeling

The schematic and BOM identify U1 as an **ESP32-S3-MINI-1-N4R2**. The PCB footprint uses the shared S2/S3 MINI-1 land pattern and may display **ESP32-S2-MINI-1** as its footprint value. The schematic/BOM designation is the production reference.

## Hardware not included

The current PCB does not include TTP223 touch controllers, proximity sensor hardware, NeoPixel/WS2812 hardware, or 3.5 mm mono-jack switch inputs.
