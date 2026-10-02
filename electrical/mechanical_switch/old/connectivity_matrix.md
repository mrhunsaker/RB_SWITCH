What each component connects to

## Power input and charging

J_USB (USB-C): VBUS pins go to U_CHG pin 4 and C4. CC1 goes to R3, CC2 goes to R4. D+ and D− go to U1's USB pins. All GND pins and the shield go to ground. Both SBU pins are unused.
R3, R4 (5.1 kΩ): each runs from its CC line (CC1, CC2) to ground.
C4 (1 µF): VBUS to ground, the charger's input capacitor.
U_CHG (MCP73831): VBUS in, VBAT out to the battery rail, ground, PROG to R1, STAT to D1's cathode.
R1 (2 kΩ): PROG pin to ground, which sets the charge current.
D1 (LED): cathode to U_CHG STAT, anode to R2.
R2 (1 kΩ): between D1's anode and 3V3.

## Battery and regulator

J_BAT (JST-PH): pin 1 to the battery rail (VBAT), pin 2 to ground.
REG1 (TPS63001):
VIN, EN and VINA go to VBAT.
PS/SYNC, PGND and GND go to ground.
L1 and L2 go to the two ends of the inductor.
VOUT and FB go to 3V3.
L1 (2.2 µH): between REG1's two switch pins.
C1 (10 µF): VBAT to ground.
C2 (22 µF), C3 (10 µF): 3V3 to ground.

## Battery sensing

R7 (100 kΩ): VBAT to the sense node.
R8 (100 kΩ): sense node to ground.
C8 (100 nF): sense node to ground.
The sense node goes to U1 pin 9.

## Microcontroller and buttons

U1 (ESP32 module):
3V3 is on pin 3, and all the GND pads (including the large thermal pad) go to ground.
Pin 4 (IO0) goes to SW_BOOT and R6.
Pin 45 (EN) goes to SW_RST and R5.
Pin 9 is the battery sense node.
Pins 14, 15 and 16 go to SW1, SW2 and SW3.
Pins 23 and 24 are USB D− and D+.
Every other pin is unused.
R5, R6 (10 kΩ): pull-ups from EN and IO0 up to 3V3.
SW_RST: EN to ground. SW_BOOT: IO0 to ground.
C5, C6, C7 (100 nF, 100 nF, 10 µF): 3V3 to ground, U1 decoupling.
SW1, SW2, SW3: each switches its U1 pin to ground.
C9, C10, C11 (100 nF): each sits across its switch's U1 line to ground, for debounce.
