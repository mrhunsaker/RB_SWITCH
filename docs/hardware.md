---
layout: default
title: Hardware Reference
permalink: /hardware.html
---

# Hardware Reference

This page summarizes the current RevD/RevD2 hardware as reconciled from the BOM, schematic, PCB, and net table.

## User controls

| Reference | Function | MCU connection |
|---|---|---|
| SW1 | Left Arrow | `SW1_NET` → U1 pin 14 → GPIO10 |
| SW2 | Enter | `SW2_NET` → U1 pin 15 → GPIO11 |
| SW3 | Right Arrow | `SW3_NET` → U1 pin 16 → GPIO12 |

Each switch has a 100 nF capacitor from its signal node to ground.

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

## Important PCB naming note

The BOM and schematic identify U1 as an **ESP32-S3-MINI-1**. The PCB footprint's displayed value text contains `ESP32-S2-MINI-1`, but the project status and schematic identify this as the shared ESP32-S2/S3 MINI-1 land pattern rather than an instruction to populate an ESP32-S2.

Verify the actual purchased module against the BOM before production.

## Hardware not present

The current schematic/PCB does not contain:

- TTP223 touch controllers
- proximity sensor hardware
- NeoPixel/WS2812 hardware
- 3.5 mm mono-jack switch inputs

The production firmware consequently does not implement those functions.
