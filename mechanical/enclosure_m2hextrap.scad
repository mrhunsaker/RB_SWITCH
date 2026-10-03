/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * RB Switch Enclosure - Mechanical Switch Variant
 *
 * OpenSCAD design for a 3D-printable enclosure for a Bluetooth switch device with mechanical buttons.
 *
 * Features:
 * - Secure lid with three internal retention tabs
 * - Two long-side tabs
 * - One short-side press-fit tab
 * - M2/M4 screw/nut geometry retained
 * - Button bar openings for tactile switches
 * - USB-C charging access with funnel guide
 * - Battery compartment
 * - PCB mounting standoffs
 *
 * IMPORTANT:
 * The lid retention tabs are positioned against the INSIDE of the
 * base walls. The corresponding slots in the base are cut through
 * the wall thickness so the lid tabs can enter the slots when the
 * lid is installed.
 *
 * LONG-SIDE TAB SCREW HOLES:
 * The long-side lid tabs now have a horizontal M2 clearance hole on
 * the same axis as the cylinder cutout in the base walls, so a single
 * M2 screw can pass through the wall and the installed tab. The axis
 * is defined once (TAB_SCREW_*) and shared by base and lid so the
 * holes always line up.
 *
 * LID NUT TRAPS:
 * Each long-side tab carries a hex nut trap on its cavity side,
 * fused into the lid underside. Press an M2 nut into the trap (with
 * the lid off), then tighten the M2 screw from outside the case to
 * clamp the wall and tab together.
 *
 * SHORT-SIDE LAYOUT (updated):
 * The USB-C cutout is now on the LEFT short side (x = 0).
 * The short-side press-fit tab and its base slot are now on the
 * RIGHT short side (x = L), opposite the USB-C cutout.
 */

// ---------------------------------------------------------------------
// VARIABLES
// ---------------------------------------------------------------------
//smooth round edges
$fn = 128;

// M2 screw radius
M2 = 1;

// Box Dimensions
L = 127;
W = 50.8;
H = 24.0;
WALL = 2.0;
BOTTOM = 1.8;
LID_T = 3.5;

// PCB Dimensions
PCB_L = 115;
PCB_W = 38;
PCB_T = 1.0;

// LiPo Battery Dimensions
BAT_L = 68;
BAT_W = 38;
BAT_H = 10.0;
BAT_CLR = 0.8;

// Push Button Dimensions
// Sized to fit the PCB's actual 25mm switch pitch with a 3mm visual gap
// between adjacent button caps.
BAR_L = 20;
BAR_W = 16;
BAR_H = 2.5;

OPEN_L = 17.5;
OPEN_W = 12.5;

STEM_L = 15;
STEM_W = 10;
STEM_H = 3.0;

FLANGE_L = 22;
FLANGE_W = 18;
FLANGE_T = 1.2;

// Top cap is the only portion that passes through the lid opening.
// 0.2 mm clearance is provided on each side.
TOP_L = OPEN_L - 0.4;
TOP_W = OPEN_W - 0.4;
TOP_R = 2.0;

TRAVEL = 0.8;

// ---------------------------------------------------------------------
// LID RETENTION TABS
// ---------------------------------------------------------------------

// The tabs are deliberately positioned on the INSIDE of the base walls.

// Long-side tabs:
//
//   y = WALL
//   y = W - WALL - TAB_W_LONG
//
// This places each tab immediately against the inside face of its
// corresponding 2 mm wall.

// The short/right-side tab is positioned on the inside face of the
// right-hand wall, opposite the USB-C cutout (which is now on the
// left-hand wall).

TAB_L = 10;
TAB_W_LONG = 1.0;
TAB_HEIGHT = 4.0;

// X position of the long-side tabs
LONG_TAB_X = L / 2;

// Y positions of the long-side tabs.
// These are now INSIDE the enclosure walls.
LONG_TAB_Y = [
    WALL,
    W - WALL - TAB_W_LONG
];

// Slot parameters for long-side tabs
SLOT_L = TAB_L + 0.5;
SLOT_W_LONG = TAB_W_LONG + 0.2;
SLOT_H = TAB_HEIGHT + 0.5;

// Vertical tab on right side, opposite USB-C
SHORT_TAB_X = L - WALL;
SHORT_TAB_Y = 12.4;

// Slot parameters for vertical tab
// 0.2 mm vertical clearance provides a snug printable fit.
SHORT_SLOT_W = 1.0;
SHORT_SLOT_L = TAB_L + 0.5;
SHORT_SLOT_H = TAB_HEIGHT + 0.2;

// ---------------------------------------------------------------------
// M2 SCREW HOLE THROUGH LONG-SIDE TABS
// ---------------------------------------------------------------------

// Axis of the horizontal M2 clearance hole that passes through the
// long-side base walls and the installed long-side lid tabs.
// These values are shared by the base cutout and the lid tab cutout
// so the two holes are always concentric.

// X position of the screw axis
TAB_SCREW_X = LONG_TAB_X - SLOT_L / 2 + 5;

// Z position of the screw axis in BASE coordinates
TAB_SCREW_Z = H - LID_T - SLOT_H + 2.25;

// Z position of the screw axis in LID-LOCAL coordinates
// (the lid is placed at z = H - LID_T in the assembly)
TAB_SCREW_Z_LID = TAB_SCREW_Z - (H - LID_T);

// 2.4 mm clearance hole for an M2 screw
TAB_SCREW_R = M2 + 0.2;

// ---------------------------------------------------------------------
// M2 NUT TRAP (LID SIDE)
// ---------------------------------------------------------------------

// Standard M2 hex nut.
M2_NUT_AF = 4.0; // width across flats
M2_NUT_T = 1.6;  // thickness

// Hex pocket: 0.1 mm press fit so the nut stays seated in the lid
// until the screw engages. The pocket opens toward the enclosure
// cavity; the tab's inner face is the nut seat.
NUT_POCKET_AF = M2_NUT_AF - 0.1;
NUT_POCKET_R = NUT_POCKET_AF / sqrt(3); // hex circumradius
NUT_POCKET_T = M2_NUT_T + 0.15;         // slight extra depth

// Material around the hex pocket
NUT_WALL = 1.5;

// Lid underside overlap so tab-side parts fuse with the lid body
TAB_JOIN = 0.3;

// ---------------------------------------------------------------------
// PCB REGISTRATION DATUM
// ---------------------------------------------------------------------

// PCB centered in the case interior.
// 123 x 46.8 mm clear.
//
// WALL + half the slack.
PCB_OFFSET = [
    WALL + ((L - 2 * WALL) - PCB_L) / 2,
    WALL + ((W - 2 * WALL) - PCB_W) / 2
]; // = [6, 6.4]

// Real PCB-local coordinates (from build_mech_pcb.py)
// Do not hand-edit without updating the PCB to match.
PCB_SWITCH_XY = [
    [22, 19],
    [47, 19],
    [72, 19]
]; // SW1, SW2, SW3

PCB_M4_XY = [
    [12, 4],
    [103, 4]
]; // MH1, MH2 (front edge)

PCB_USB_XY = [5, 19]; // J_USB origin (rot=180, nose -> PCB x=0)

// Font for all Text CutOuts
FONT = "Atkinson Hyperlegible Next";

function to_case(p) = [
    p[0] + PCB_OFFSET[0],
    p[1] + PCB_OFFSET[1]
];

CASE_SWITCH_XY = [
    for (p = PCB_SWITCH_XY)
        to_case(p)
];

CASE_M4_XY = [
    for (p = PCB_M4_XY)
        to_case(p)
];

CASE_USB_XY = to_case(PCB_USB_XY);

BAR_X = [
    for (s = CASE_SWITCH_XY)
        s[0] - BAR_L / 2
];

BAR_Y = CASE_SWITCH_XY[0][1] - BAR_W / 2;

// ---------------------------------------------------------------------
// Z DIMENSIONS
// ---------------------------------------------------------------------

PCB_TOP_Z =
    BOTTOM +
    BAT_H +
    1.2 +
    2.0 +
    PCB_T; // = 16.0

LID_Z = H - LID_T;

SWITCH_H = 4.3; // B3F-1000
SWITCH_SAFE_TRAVEL = 0.5; // B3F-1000

CLEARANCE_AVAILABLE = LID_Z - PCB_TOP_Z;

NEEDED_CLEARANCE =
    SWITCH_H +
    SWITCH_SAFE_TRAVEL +
    0.5;

LID_BOSS_H =
    max(
        0,
        NEEDED_CLEARANCE - CLEARANCE_AVAILABLE
    ) + 0.5;

STOP_H =
    TRAVEL -
    SWITCH_SAFE_TRAVEL +
    0.15;

STOP_D = 2.5;

// ---------------------------------------------------------------------
// USB-C CUTOUT
// ---------------------------------------------------------------------

// Sized for a real plug + strain-relief boot
// on the wall the connector actually faces (left, x=0).

USB_CUT_W = 12;
USB_CUT_H = 6.5;

USB_CUT_Z =
    PCB_TOP_Z +
    1.7;

USB_FUNNEL = 1.5;

// ---------------------------------------------------------------------
// ENCLOSURE GEOMETRY
// ---------------------------------------------------------------------

module rounded_box(x, y, z, r = 4) {
    hull() {
        translate([r, r, 0])
        cylinder(r = r, h = z);

        translate([x - r, r, 0])
        cylinder(r = r, h = z);

        translate([r, y - r, 0])
        cylinder(r = r, h = z);

        translate([x - r, y - r, 0])
        cylinder(r = r, h = z);
    }
}

// Generic tab module.
module tab() {
    cube([
        TAB_L,
        TAB_W,
        TAB_HEIGHT
    ]);
}

// ---------------------------------------------------------------------
// PCB STANDOFF
// ---------------------------------------------------------------------

// A mounting post that is ALWAYS connected:
// solid from the case floor up to the PCB's underside,
// so it can never be a floating island.

module standoff(
    x,
    y,
    pilot_d = 3,
    pilot_from_top = 6
) {
    post_h = PCB_TOP_Z - PCB_T;

    translate([x, y, 0])
    difference() {
        color("DarkGrey")
        cylinder(
            d = 6.0,
            h = post_h
        );

        if (pilot_d > 0) {
            translate([
                0,
                0,
                post_h - pilot_from_top
            ])
            color("yellow")
            cylinder(
                d = pilot_d,
                h = pilot_from_top + 0.1
            );
        }
    }
}

// ---------------------------------------------------------------------
// LID NUT / SCREW CAPTURE GEOMETRY
// ---------------------------------------------------------------------

// Four solid corner captures.
// Each is tied into the case walls and floor, with an upward-open
// hex pocket for a standard M4 hex nut.
//
// The lid screw passes through the lid into the captured nut.

LID_NUT_AF = 7.4;
LID_NUT_H = 3.6;

LID_NUT_Z =
    H -
    LID_T -
    LID_NUT_H;

LID_BOSS_X = 12;
LID_BOSS_Y = 12;

LID_SCREW_D = 4;
LID_RECESS_D = 8.5;
LID_RECESS_H = 1.4;

LID_CORNER_XY = [
    [
        LID_BOSS_X / 2,
        LID_BOSS_Y / 2
    ],

    [
        L - LID_BOSS_X / 2,
        LID_BOSS_Y / 2
    ],

    [
        LID_BOSS_X / 2,
        W - LID_BOSS_Y / 2
    ],

    [
        L - LID_BOSS_X / 2,
        W - LID_BOSS_Y / 2
    ]
];

// ---------------------------------------------------------------------
// SHARED LID TAB MODULES
// ---------------------------------------------------------------------

// Long-side retention tabs with the M2 clearance hole that matches
// the horizontal cylinder cutout in the base walls.
//
// Each tab is a SOLID part of the lid. The tab overlaps the
// underside of the lid by TAB_JOIN so F5/F6 render produces one
// connected solid instead of a floating/coplanar part.
module long_side_tabs() {
    difference() {
        for (y = LONG_TAB_Y) {
            translate([
                LONG_TAB_X - TAB_L / 2,
                y,
                -TAB_HEIGHT
            ])
            color("LightGrey")
            cube([
                TAB_L,
                TAB_W_LONG,
                TAB_HEIGHT + TAB_JOIN
            ]);
        }

        // M2 clearance hole on the same axis as the base wall
        // cutout (TAB_SCREW_*), so the screw passes through the
        // wall and the installed tab as one continuous bore.
        translate([
            TAB_SCREW_X,
            W + 5,
            TAB_SCREW_Z_LID
        ])
        rotate([90, 0, 0])
        cylinder(
            W + 10,
            TAB_SCREW_R,
            TAB_SCREW_R
        );
    }

    // Nut traps: a press-fit M2 nut in each trap lets the screw
    // clamp the base wall and the installed tab together from
    // outside the case.
    for (y = LONG_TAB_Y) {
        tab_nut_trap(y);
    }
}

// Nut trap housing for one long-side tab. The housing hangs from
// the lid underside on the cavity side of the tab and is fused into
// both the lid body and the tab.
//
// Insert the nut with the lid off: it slides along the screw axis
// from the cavity side until it seats against the tab's inner face.
// The hex pocket keeps the nut from spinning while the M2 screw is
// tightened from outside the case; the pocket opens sideways
// (horizontally), so gravity never pulls the nut out.
module tab_nut_trap(tab_y) {
    near = tab_y < W / 2;

    // y of the tab's cavity-facing face
    face = near ? tab_y + TAB_W_LONG : tab_y;

    // +1: pocket extends toward +y (near wall)
    // -1: pocket extends toward -y (far wall)
    dir = near ? 1 : -1;

    block_w = 2 * (NUT_POCKET_R + NUT_WALL);
    z_bot = TAB_SCREW_Z_LID - (NUT_POCKET_R + NUT_WALL);

    difference() {
        // Housing block. Starts exactly at the tab's inner face
        // (which forms the nut seat) and overlaps the lid underside
        // by TAB_JOIN so it prints as one solid part.
        translate([
            TAB_SCREW_X - block_w / 2,
            near ? face : face - NUT_POCKET_T,
            z_bot
        ])
        color("LightGrey")
        cube([
            block_w,
            NUT_POCKET_T,
            TAB_JOIN - z_bot
        ]);

        // Hex pocket along the screw axis. Overshoots the opening
        // by 0.3 mm; the tab closes the far end.
        // Flats land top/bottom (AF vertical) so the nut fits the
        // tab height.
        translate([
            TAB_SCREW_X,
            face,
            TAB_SCREW_Z_LID
        ])
        rotate([dir == 1 ? -90 : 90, 0, 0])
        cylinder(
            h = NUT_POCKET_T + 0.3,
            r = NUT_POCKET_R,
            $fn = 6
        );
    }
}

// Right-side press-fit tab.
// The tab's outside face is flush with the base's outside face
// (X = L). It extends through the full 2 mm wall and 1 mm into
// the enclosure cavity so the base slot positively captures the tab.
module short_side_tab() {
    translate([
        SHORT_TAB_X - 1,
        SHORT_TAB_Y - TAB_L / 2,
        -TAB_HEIGHT
    ])
    color("LightGrey")
    cube([
        WALL + 1,
        TAB_L,
        TAB_HEIGHT + 0.3
    ]);
}

// ---------------------------------------------------------------------
// ENCLOSURE BASE
// ---------------------------------------------------------------------

module base() {
    difference() {
        // -------------------------------------------------------------
        // Main base shape
        // -------------------------------------------------------------

        color("DarkGrey")
        rounded_box(
            L,
            W,
            H - LID_T,
            5
        );

        // -------------------------------------------------------------
        // Side Branding
        // -------------------------------------------------------------

        translate([5, 1, 14])
        rotate([90, 0, 0])
        linear_extrude(
            h = 5,
            center = false
        )
        text(
            "RB Switch",
            size = 5,
            font = FONT
        );

        // -------------------------------------------------------------
        // Inner cavity
        // -------------------------------------------------------------

        translate([
            WALL,
            WALL,
            BOTTOM
        ])
        color("DarkGrey")
        rounded_box(
            L - 2 * WALL,
            W - 2 * WALL,
            H - LID_T - BOTTOM + 0.1,
            3.5
        );

        // -------------------------------------------------------------
        // Battery cutout
        // -------------------------------------------------------------

        translate([
            L - BAT_L - 7,
            (W - BAT_W) / 2,
            BOTTOM - 0.01
        ])
        color("DarkGrey")
        cube([
            BAT_L,
            BAT_W,
            BAT_H + BAT_CLR
        ]);

        // -------------------------------------------------------------
        // USB-C cutout (LEFT short side, x = 0)
        // -------------------------------------------------------------

        translate([
            -0.1,
            CASE_USB_XY[1] - USB_CUT_W / 2,
            USB_CUT_Z - USB_CUT_H / 2
        ])
        color("DarkGrey")
        cube([
            WALL + 0.2,
            USB_CUT_W,
            USB_CUT_H
        ]);

        // USB-C funnel
        hull() {
            translate([
                0,
                CASE_USB_XY[1] - USB_CUT_W / 2,
                USB_CUT_Z - USB_CUT_H / 2
            ])
            color("DarkGrey")
            cube([
                0.1,
                USB_CUT_W,
                USB_CUT_H
            ]);

            translate([
                0,
                CASE_USB_XY[1] -
                USB_CUT_W / 2 -
                USB_FUNNEL,

                USB_CUT_Z -
                USB_CUT_H / 2 -
                USB_FUNNEL
            ])
            color("DarkGrey")
            cube([
                0.1,
                USB_CUT_W + 2 * USB_FUNNEL,
                USB_CUT_H + 2 * USB_FUNNEL
            ]);
        }

        // -------------------------------------------------------------
        // INSIDE-FACING LONG-SIDE LID SLOTS
        // -------------------------------------------------------------

        // The slots now cut through the wall thickness.

        // This allows the tabs on the underside of the lid to enter
        // the wall from the inside when the lid is installed.

        for (y = LONG_TAB_Y) {
            translate([
                LONG_TAB_X - SLOT_L / 2,
                y + (TAB_W_LONG - SLOT_W_LONG) / 2,
                H - LID_T - SLOT_H
            ])
            color("DarkGrey")
            cube([
                SLOT_L,
                WALL + 0.4,
                SLOT_H
            ]);
        }

        // -------------------------------------------------------------
        // INSIDE-FACING RIGHT-SIDE LID SLOT
        // -------------------------------------------------------------

        // Mirrored to the right-hand wall (x = L), opposite the
        // USB-C cutout. Spans the full 2 mm wall plus clearance so
        // the lid's right-side tab is positively captured.

        translate([
            L - 2 * WALL - 0.3,
            SHORT_TAB_Y - SHORT_SLOT_L / 2,
            H - LID_T - SHORT_SLOT_H
        ])
        color("DarkGrey")
        cube([
            2 * WALL + 0.4,
            SHORT_SLOT_L,
            SHORT_SLOT_H
        ]);

        // -------------------------------------------------------------
        // M2 CLEARANCE HOLE THROUGH LONG-SIDE WALLS
        // -------------------------------------------------------------

        // Horizontal bore on the TAB_SCREW_* axis. With the lid
        // installed, the long-side tabs fill these wall slots and
        // this bore continues through the tab, capturing an M2 screw.

        for (y = LONG_TAB_Y) {
            translate([
                TAB_SCREW_X,
                y + 30,
                TAB_SCREW_Z
            ])
            rotate([90, 0, 0])
            color("DarkGrey")
            cylinder(
                55,
                TAB_SCREW_R,
                TAB_SCREW_R
            );
        }
    }

    // -----------------------------------------------------------------
    // PCB STANDOFFS
    // -----------------------------------------------------------------

    for (p = CASE_M4_XY) {
        standoff(
            p[0],
            p[1],
            pilot_d = 3
        );
    }

    color("DarkGrey")
    standoff(
        WALL + 6,
        W - WALL - 6
    );

    color("DarkGrey")
    standoff(
        L - WALL - 6,
        W - WALL - 6
    );
}

// ---------------------------------------------------------------------
// LID VARIATIONS
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Default Lid - 3 Button Openings
// ---------------------------------------------------------------------

module lid() {
    difference() {
        // Main lid shape
        color("LightGrey")
        rounded_box(
            L,
            W,
            LID_T,
            5
        );

        // -------------------------------------------------------------
        // Button openings
        // -------------------------------------------------------------

        for (x = BAR_X) {
            translate([
                x,
                BAR_Y,
                -0.1
            ])
            color("LightGrey")
            cube([
                OPEN_L,
                OPEN_W,
                LID_T + 0.2
            ]);
        }

        // -------------------------------------------------------------
        // Stem clearances
        // -------------------------------------------------------------

        for (x = BAR_X) {
            translate([
                x + (BAR_L - STEM_L) / 2 - 1,
                BAR_Y + (BAR_W - STEM_W) / 2 - 1,
                -0.1
            ])
            color("LightGrey")
            cube([
                STEM_L + 2,
                STEM_W + 2,
                LID_BOSS_H + 0.1
            ]);
        }

        // -------------------------------------------------------------
        // Lid text
        // -------------------------------------------------------------

        translate([95, 20, 3])
        color("LightGrey")
        cube([
            25,
            25,
            1
        ]);

        translate([75, 5, 3])
        linear_extrude(
            h = 5,
            center = false
        )
        color("LightGrey")
        text(
            "Three Switch",
            size = 5,
            font = FONT
        );
    }

    // -----------------------------------------------------------------
    // INSIDE-FACING LONG-SIDE TABS (with M2 screw clearance hole)
    // -----------------------------------------------------------------

    long_side_tabs();

    // -----------------------------------------------------------------
    // INSIDE-FACING RIGHT-SIDE TAB
    // -----------------------------------------------------------------

    short_side_tab();
}

// ---------------------------------------------------------------------
// Lid with Only 1 Opening for a Button
// ---------------------------------------------------------------------

module lid_oneswitch() {
    difference() {
        color("LightGrey")
        rounded_box(
            L,
            W,
            LID_T,
            5
        );

        // Center switch only
        x = BAR_X[1];

        translate([
            x,
            BAR_Y,
            -0.1
        ])
        color("LightGrey")
        cube([
            OPEN_L,
            OPEN_W,
            LID_T + 0.2
        ]);

        translate([
            x + (BAR_L - STEM_L) / 2 - 1,
            BAR_Y + (BAR_W - STEM_W) / 2 - 1,
            -0.1
        ])
        color("LightGrey")
        cube([
            STEM_L + 2,
            STEM_W + 2,
            LID_BOSS_H + 0.1
        ]);

        // Lid text block
        translate([95, 20, 3])
        cube([
            25,
            25,
            1
        ]);

        translate([80, 5, 3])
        linear_extrude(
            h = 5,
            center = false
        )
        color("LightGrey")
        text(
            "One Switch",
            size = 5,
            font = FONT
        );
    }

    // -----------------------------------------------------------------
    // INSIDE-FACING LONG-SIDE TABS (with M2 screw clearance hole)
    // -----------------------------------------------------------------

    long_side_tabs();

    // -----------------------------------------------------------------
    // INSIDE-FACING RIGHT-SIDE TAB
    // -----------------------------------------------------------------

    short_side_tab();
}

// ---------------------------------------------------------------------
// Lid with Only 2 Openings for Buttons
// ---------------------------------------------------------------------

module lid_twoswitch() {
    difference() {
        color("LightGrey")
        rounded_box(
            L,
            W,
            LID_T,
            5
        );

        // Left and right switches only
        for (i = [0, 2]) {
            x = BAR_X[i];

            translate([
                x,
                BAR_Y,
                -0.1
            ])
            color("LightGrey")
            cube([
                OPEN_L,
                OPEN_W,
                LID_T + 0.2
            ]);

            translate([
                x + (BAR_L - STEM_L) / 2 - 1,
                BAR_Y + (BAR_W - STEM_W) / 2 - 1,
                -0.1
            ])
            color("LightGrey")
            cube([
                STEM_L + 2,
                STEM_W + 2,
                LID_BOSS_H + 0.1
            ]);
        }

        // Lid text block
        translate([95, 20, 3])
        cube([
            25,
            25,
            1
        ]);

        translate([80, 5, 3])
        linear_extrude(
            h = 5,
            center = false
        )
        color("LightGrey")
        text(
            "Two Switch",
            size = 5,
            font = FONT
        );
    }

    // -----------------------------------------------------------------
    // INSIDE-FACING LONG-SIDE TABS (with M2 screw clearance hole)
    // -----------------------------------------------------------------

    long_side_tabs();

    // -----------------------------------------------------------------
    // INSIDE-FACING RIGHT-SIDE TAB
    // -----------------------------------------------------------------

    short_side_tab();
}

// ---------------------------------------------------------------------
// Finger Trap / Tactile Well Parameters
// ---------------------------------------------------------------------

DIVIDER_W = 4;
DIVIDER_H = 8;
DIVIDER_R = 2;
DIVIDER_OVERHANG = 5;

// ---------------------------------------------------------------------
// Tactile Divider Rail
// ---------------------------------------------------------------------

module finger_divider(x, y) {
    divider_len =
        OPEN_W +
        (2 * DIVIDER_OVERHANG);

    union() {
        // Vertical wall
        translate([
            x - DIVIDER_W / 2 + 1.1,
            y - DIVIDER_OVERHANG,
            LID_T
        ])
        color("LightGrey")
        cube([
            DIVIDER_W,
            divider_len,
            DIVIDER_H - DIVIDER_R
        ]);

        // Rounded top
        translate([
            x + 1.1,
            y + OPEN_W / 2,
            LID_T + DIVIDER_H - DIVIDER_R
        ])
        rotate([90, 0, 0])
        color("LightGrey")
        cylinder(
            r = DIVIDER_R,
            h = divider_len,
            center = true
        );
    }
}

// ---------------------------------------------------------------------
// Lid with Tactile Finger Wells
// ---------------------------------------------------------------------

module lid_fingertrap() {
    union() {
        difference() {
            color("LightGrey")
            rounded_box(
                L,
                W,
                LID_T,
                5
            );

            // ---------------------------------------------------------
            // All three switch openings
            // ---------------------------------------------------------

            for (x = BAR_X) {
                translate([
                    x,
                    BAR_Y,
                    -0.1
                ])
                color("LightGrey")
                cube([
                    OPEN_L,
                    OPEN_W,
                    LID_T + 0.2
                ]);
            }

            // ---------------------------------------------------------
            // Stem clearances
            // ---------------------------------------------------------

            for (x = BAR_X) {
                translate([
                    x + (BAR_L - STEM_L) / 2 - 1,
                    BAR_Y + (BAR_W - STEM_W) / 2 - 1,
                    -0.1
                ])
                color("LightGrey")
                cube([
                    STEM_L + 2,
                    STEM_W + 2,
                    LID_BOSS_H + 0.1
                ]);
            }

            // ---------------------------------------------------------
            // Lid text block
            // ---------------------------------------------------------

            translate([95, 20, 3])
            color("LightGrey")
            cube([
                25,
                25,
                1
            ]);

            translate([75, 5, 3])
            linear_extrude(
                h = 5,
                center = false
            )
            color("LightGrey")
            text(
                "Finger Trap",
                size = 5,
                font = FONT
            );
        }

        // -------------------------------------------------------------
        // Outer Divider Switch 1
        // -------------------------------------------------------------

        color("LightGrey")
        finger_divider(
            (BAR_X[0] - 50 + OPEN_L + BAR_X[1]) / 2,
            BAR_Y + 1
        );

        // -------------------------------------------------------------
        // Outer Divider Switch 3
        // -------------------------------------------------------------

        color("LightGrey")
        finger_divider(
            (BAR_X[2] + 50 + OPEN_L + BAR_X[1]) / 2,
            BAR_Y + 1
        );

        // -------------------------------------------------------------
        // Divider between switch 1 and switch 2
        // -------------------------------------------------------------

        color("LightGrey")
        finger_divider(
            (BAR_X[0] + OPEN_L + BAR_X[1]) / 2,
            BAR_Y + 1
        );

        // -------------------------------------------------------------
        // Divider between switch 2 and switch 3
        // -------------------------------------------------------------

        color("LightGrey")
        finger_divider(
            (BAR_X[1] + OPEN_L + BAR_X[2]) / 2,
            BAR_Y + 1
        );
    }

    // -----------------------------------------------------------------
    // INSIDE-FACING LONG-SIDE TABS (with M2 screw clearance hole)
    // -----------------------------------------------------------------

    long_side_tabs();

    // -----------------------------------------------------------------
    // INSIDE-FACING RIGHT-SIDE TAB
    // -----------------------------------------------------------------

    short_side_tab();
}

// ---------------------------------------------------------------------
// BUTTONS TO PRESS
// ---------------------------------------------------------------------

module bar(x = 0, y = 0) {
    // Common centerline for the entire button stack.
    // x/y identify the BAR envelope; every functional part is centered
    // on that same point so the button presses straight down.

    cx = x + BAR_L / 2;
    cy = y + BAR_W / 2;

    // -------------------------------------------------------------
    // Top cap
    // Only this part passes through the lid opening.
    // -------------------------------------------------------------

    translate([
        cx - TOP_L / 2,
        cy - TOP_W / 2,
        H - LID_T + TRAVEL
    ])
    rounded_box(
        TOP_L,
        TOP_W,
        BAR_H,
        TOP_R
    );

    // -------------------------------------------------------------
    // Stem
    // -------------------------------------------------------------

    translate([
        cx - STEM_L / 2,
        cy - STEM_W / 2,
        H - LID_T - STEM_H + TRAVEL
    ])
    cube([
        STEM_L,
        STEM_W,
        STEM_H
    ]);

    // -------------------------------------------------------------
    // Flange
    // -------------------------------------------------------------

    translate([
        cx - FLANGE_L / 2,
        cy - FLANGE_W / 2,
        H - LID_T - STEM_H - FLANGE_T + TRAVEL
    ])
    rounded_box(
        FLANGE_L,
        FLANGE_W,
        FLANGE_T,
        2
    );

    // -------------------------------------------------------------
    // Travel stop
    // -------------------------------------------------------------

    translate([
        cx,
        cy,
        H - LID_T - STEM_H - FLANGE_T - STOP_H + TRAVEL
    ])
    cylinder(
        d = STOP_D,
        h = STOP_H
    );
}

// ---------------------------------------------------------------------
// ASSEMBLIES
// ---------------------------------------------------------------------

module assembly() {
    color("DarkGrey", alpha = 1.0)
    base();

    color("LightGrey", alpha = 1.0)
    translate([
        0,
        0,
        H - LID_T
    ])
    lid();

    for (i = [0: 2]) {
        color(
            i == 0 ? "blue" :
            i == 1 ? "green" :
            "red"
        )
        translate([
            -1,
            -1,
            2
        ])
        bar(
            BAR_X[i],
            BAR_Y
        );
    }
}

module assembly_oneswitch() {
    color("DarkGrey", alpha = 1.0)
    base();

    color("LightGrey", alpha = 1.0)
    translate([
        0,
        0,
        H - LID_T
    ])
    lid_oneswitch();

    for (i = [1]) {
        color(
            i == 0 ? "blue" :
            i == 1 ? "green" :
            "red"
        )
        translate([
            -1,
            -1,
            2
        ])
        bar(
            BAR_X[i],
            BAR_Y
        );
    }
}

module assembly_twoswitch() {
    color("DarkGrey", alpha = 1.0)
    base();

    color("LightGrey", alpha = 1.0)
    translate([
        0,
        0,
        H - LID_T
    ])
    lid_twoswitch();

    for (i = [0, 2]) {
        color(
            i == 0 ? "blue" :
            i == 1 ? "green" :
            "red"
        )
        translate([
            -1,
            -1,
            2
        ])
        bar(
            BAR_X[i],
            BAR_Y
        );
    }
}

module assembly_fingertrap() {
    color("DarkGrey", alpha = 1.0)
    base();

    color("LightGrey", alpha = 1.0)
    translate([
        0,
        0,
        H - LID_T
    ])
    lid_fingertrap();

    for (i = [0: 2]) {
        color(
            i == 0 ? "blue" :
            i == 1 ? "green" :
            "red"
        )
        translate([
            -1,
            -1,
            2
        ])
        bar(
            BAR_X[i],
            BAR_Y
        );
    }
}

// ---------------------------------------------------------------------
// EXPLODED ASSEMBLIES
// ---------------------------------------------------------------------

module exploded_assembly() {
    color("DarkGrey", alpha = 1.0)
    base();

    color("LightGrey", alpha = 1.0)
    translate([
        0,
        0,
        H - LID_T + 15
    ])
    lid();

    for (i = [0: 2]) {
        color(
            i == 0 ? "blue" :
            i == 1 ? "green" :
            "red"
        )
        translate([
            -1,
            -1,
            2 + 5
        ])
        bar(
            BAR_X[i],
            BAR_Y
        );
    }
}

module exploded_assembly_oneswitch() {
    color("DarkGrey", alpha = 1.0)
    base();

    color("LightGrey", alpha = 1.0)
    translate([
        0,
        0,
        H - LID_T + 15
    ])
    lid_oneswitch();

    for (i = [1]) {
        color(
            i == 0 ? "blue" :
            i == 1 ? "green" :
            "red"
        )
        translate([
            -1,
            -1,
            2 + 5
        ])
        bar(
            BAR_X[i],
            BAR_Y
        );
    }
}

module exploded_assembly_twoswitch() {
    color("DarkGrey", alpha = 1.0)
    base();

    color("LightGrey", alpha = 1.0)
    translate([
        0,
        0,
        H - LID_T + 15
    ])
    lid_twoswitch();

    for (i = [0: 2: 2]) {
        color(
            i == 0 ? "blue" :
            i == 1 ? "green" :
            "red"
        )
        translate([
            -1,
            -1,
            2 + 5
        ])
        bar(
            BAR_X[i],
            BAR_Y
        );
    }
}

module exploded_assembly_fingertrap() {
    color("DarkGrey", alpha = 1.0)
    base();

    color("LightGrey", alpha = 1.0)
    translate([
        0,
        0,
        H - LID_T + 15
    ])
    lid_fingertrap();

    for (i = [0: 2]) {
        color(
            i == 0 ? "blue" :
            i == 1 ? "green" :
            "red"
        )
        translate([
            -1,
            -1,
            2 + 5
        ])
        bar(
            BAR_X[i],
            BAR_Y
        );
    }
}

// ---------------------------------------------------------------------
// VISUALIZATIONS
// ---------------------------------------------------------------------

// Exploded Assembly
module all_exploded_assemblies() {
    translate([0, 0, 0])
    exploded_assembly();

    translate([150, 75, 0])
    exploded_assembly_oneswitch();

    translate([150, 0, 0])
    exploded_assembly_twoswitch();

    translate([0, 75, 0])
    exploded_assembly_fingertrap();
}

// Assembly
module all_assemblies() {
    translate([0, 0, 0])
    assembly();

    translate([150, 75, 0])
    assembly_oneswitch();

    translate([150, 0, 0])
    assembly_twoswitch();

    translate([0, 75, 0])
    assembly_fingertrap();
}

// Uncomment one of these for full enclosure visualization:
//all_assemblies();
//all_exploded_assemblies();

// ---------------------------------------------------------------------
// INDIVIDUAL ITEMS FOR EXPORT AND CONSTRUCTION
// ---------------------------------------------------------------------
module printbar() {
    for (i = [0: 2]) {
        color(
            i == 0 ? "blue" :
            i == 1 ? "green" :
            "red"
        )
        translate([
            0,
            0,
            -17
        ])
        bar(
            BAR_X[i],
            BAR_Y
        );
    }
}
// Uncomment the desired item for export:
//printbar();
//base();
lid();
// lid_oneswitch();
// lid_twoswitch();
// lid_fingertrap();