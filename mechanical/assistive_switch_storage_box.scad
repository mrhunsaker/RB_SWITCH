/*
 * RB Switch - Parts Storage Box
 *
 * Separate organizer for the assistive-switch enclosure parts.
 *
 * Storage layout:
 *   1. Main bay: one base() with lid_fingertrap() fitted on top.
 *      The bay height is sized from the maximum height of that assembly.
 *   2. Bar bay: room for 3 spare bar() parts.
 *   3. Four individual lid bays: lid(), lid_oneswitch(), lid_twoswitch(),
 *      and lid_fingertrap().
 *
 * This file intentionally does not modify the enclosure geometry.  The
 * dimensions below are derived from the supplied enclosure modules.
 */

$fn = 96;

// ---------------------------------------------------------------------
// Source enclosure dimensions
// ---------------------------------------------------------------------
L = 127;
W = 50.8;
H = 24.0;
LID_T = 3.5;

// Button geometry: the flange is the largest XY feature of bar().
BAR_L = 20;
BAR_W = 16;
BAR_H = 2.5;
FLANGE_L = 22;
FLANGE_W = 18;
FLANGE_T = 1.2;

// Finger-trap lid geometry.
DIVIDER_H = 8;

// ---------------------------------------------------------------------
// Storage clearances
// ---------------------------------------------------------------------
CLEAR_X = 3.0;       // clearance around 127 mm enclosure/lid length
CLEAR_Y = 3.0;       // clearance around 50.8 mm enclosure/lid width
WALL = 3.0;          // organizer wall/divider thickness
BOTTOM = 3.0;        // organizer floor thickness
TOP_CLEAR = 4.0;     // clearance above tallest stored assembly
LID_SLOT = 16.0;      // each lid gets its own 5 mm slot
BAR_CLEAR = 3.0;     // clearance around spare bars

// ---------------------------------------------------------------------
// Derived storage dimensions
// ---------------------------------------------------------------------
// Base() physical height is H-LID_T = 20.5 mm.
// Lid_fingertrap() is 3.5 mm thick with an 8 mm divider above it.
// Therefore the maximum stored assembly height is 20.5+3.5+8 = 32 mm.
BASE_ASSEMBLY_H = (H - LID_T) + LID_T + DIVIDER_H;

MAIN_X = L + 2*CLEAR_X;
MAIN_Y = W + 2*CLEAR_Y;

// Three bars are stored side-by-side in their own compartment.
// 22 x 18 is used because the flange is the largest bar footprint.
BAR_PITCH_X = FLANGE_L + BAR_CLEAR;
BAR_BAY_X = 3*FLANGE_L + 4*BAR_CLEAR;
BAR_BAY_Y = FLANGE_W + 2*BAR_CLEAR;

// Four lids are stored in four independent vertical slots.
LID_BAY_X = L + 2*CLEAR_X;
LID_BAY_Y = LID_SLOT;
LID_RACK_Y = 4*LID_SLOT + 5*WALL;

// Overall organizer arrangement:
//   [ MAIN BASE BAY ][ BAR BAY ]
//   [       4 INDIVIDUAL LID SLOTS       ]
OUTER_X = max(MAIN_X + WALL + BAR_BAY_X + 2*WALL, LID_BAY_X + 2*WALL);
OUTER_Y = MAIN_Y + WALL + LID_RACK_Y + 2*WALL;
OUTER_Z = BASE_ASSEMBLY_H + TOP_CLEAR;

// ---------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------
module rounded_box(x,y,z,r=4) {
    hull() {
        translate([r,r,0]) cylinder(r=r,h=z);
        translate([x-r,r,0]) cylinder(r=r,h=z);
        translate([r,y-r,0]) cylinder(r=r,h=z);
        translate([x-r,y-r,0]) cylinder(r=r,h=z);
    }
}

// A compartment represented as a solid divider footprint.
module divider(x,y,sx,sy,h=OUTER_Z) {
    translate([x,y,0]) cube([sx,sy,h]);
}

// ---------------------------------------------------------------------
// Organizer body
// ---------------------------------------------------------------------
module storage_box() {
    difference() {
        // Solid outer shell.
        rounded_box(OUTER_X, OUTER_Y, OUTER_Z, 5);

        // Main base + finger-trap assembly bay.
        translate([WALL, WALL, BOTTOM])
            cube([MAIN_X, MAIN_Y, OUTER_Z-BOTTOM+0.1]);

        // Three-bar bay.
        translate([WALL + MAIN_X + WALL, WALL, BOTTOM])
            cube([BAR_BAY_X, BAR_BAY_Y, OUTER_Z-BOTTOM+0.1]);

        // Four individual lid slots.
        // They run the full lid length, giving each lid its own location.
        for (i=[0:3]) {
            y0 = WALL + MAIN_Y + WALL + i*(LID_SLOT+WALL);
            translate([WALL, y0, BOTTOM])
                cube([LID_BAY_X, LID_SLOT, OUTER_Z-BOTTOM+0.1]);
        }
    

    // Raised labels for the storage areas.
    // Main bay label
    translate([WALL+140, WALL+45, OUTER_Z-1.2])
        linear_extrude(height=1.2)
            text("BASE", size=5, font="Atkinson Hyperlegible Next");

    // Bar bay label
    translate([WALL+MAIN_X+WALL+50, WALL+25, OUTER_Z-1.2])
        linear_extrude(height=1.2)
            text("3 BARS", size=5, font="Atkinson Hyperlegible Next");

    // Individual lid labels on the rack divider areas.
    lid_names = ["3 SWITCH", "1 SWITCH", "2 SWITCH", "FINGER TRAP"];
    for (i=[0:3]) {
        y0 = WALL + MAIN_Y + WALL + i*(LID_SLOT+WALL);
        translate([WALL+140, y0+6, OUTER_Z-1.2])
            linear_extrude(height=1.2)
                text(lid_names[i], size=5, font="Atkinson Hyperlegible Next");
    }
    }
}

module lid_for_storage_box() {
    // -------------------------------------------------------------
    // Lid fit parameters
    // -------------------------------------------------------------
    LID_CLEAR_XY = 0.75;   // clearance per side; 2 mm total
    LID_CLEAR_Z  = 1.0;   // clearance above storage box
    LID_WALL     = 2.0;   // lid wall thickness
    LID_BOTTOM   = 2.0;   // closed end / top thickness
    LID_RADIUS   = 5.0;

    // -------------------------------------------------------------
    // Outer lid dimensions
    // -------------------------------------------------------------
    // The lid is slightly larger than the storage box in XY.
    LID_OUTER_X = OUTER_X + 2*LID_CLEAR_XY + 2*LID_WALL;
    LID_OUTER_Y = OUTER_Y + 2*LID_CLEAR_XY + 2*LID_WALL;

    // Internal cavity is large enough to slip over the entire box.
    LID_INNER_X = OUTER_X + 2*LID_CLEAR_XY;
    LID_INNER_Y = OUTER_Y + 2*LID_CLEAR_XY;

    // The cavity needs to extend 1 mm beyond the top of the box.
    LID_INNER_Z = OUTER_Z + LID_CLEAR_Z;

    // Overall lid height = cavity depth + top thickness.
    LID_OUTER_Z = LID_INNER_Z + LID_BOTTOM;

    difference() {
        // Solid lid
            rounded_box(
                LID_OUTER_X,
                LID_OUTER_Y,
                LID_OUTER_Z,
                LID_RADIUS
            );

        // Internal cavity.
        //
        // Starting at z=0 means the bottom of the lid is open.
        // The cavity extends 1 mm above the storage box, providing
        // vertical clearance instead of colliding with its top.
        translate([
            LID_WALL,
            LID_WALL,
            -0.01
        ])
                 rounded_box(
                    LID_INNER_X,
                    LID_INNER_Y,
                    LID_INNER_Z + 0.01,
                    LID_RADIUS
                );
        translate([5,125,LID_OUTER_Z+LID_CLEAR_Z-2])linear_extrude(height=1.2)
                text("RB SWITCH", size=20, font="Atkinson Hyperlegible Next");
    }
}

// ---------------------------------------------------------------------
// Optional storage contents for visual verification
// ---------------------------------------------------------------------
// These are deliberately simple envelope representations.  The actual
// enclosure modules can be brought into a separate scene if desired.

module stored_bar_envelope() {
    rounded_box(FLANGE_L, FLANGE_W, FLANGE_T, 2);
}

module stored_lid_envelope() {
    rounded_box(L, W, LID_T, 5);
}

// Maximum-height envelope for base() + lid_fingertrap().
module stored_base_fingertrap_envelope() {
    rounded_box(L, W, BASE_ASSEMBLY_H, 5);
}

// ---------------------------------------------------------------------
// Main output
// ---------------------------------------------------------------------
translate([0,155,0])storage_box();
//lid_for_storage_box();