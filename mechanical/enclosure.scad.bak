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
 * BT Switch Enclosure - Mechanical Switch Variant
 *
 * OpenSCAD design for a 3D-printable enclosure for a Bluetooth switch device with mechanical buttons.
 * Features:
 * - Secure lid with three tabs (two on long sides with screw holes, one on short side with press-fit)
 * - M2 screw holes through long side tabs for optional mechanical fastening
 * - Press-fit vertical tab on the right side (opposite USB-C)
 * - Button bar openings for tactile switches
 * - USB-C charging access with funnel guide
 * - Battery compartment
 * - PCB mounting standoffs
 *
 * The lid attaches securely to the base using a combination of screw holes (long sides)
 * and press-fit (right side) to prevent accidental removal by students.
 */

$fn = 128;

// Box Dimensions
L = 127; W = 50.8; H = 24.0;   

WALL = 2.0; BOTTOM = 1.8; LID_T = 3.5;

// PCB Dimensions
PCB_L = 115; PCB_W = 38; PCB_T = 1.0;

// LiPo Battery Dimensions
BAT_L = 68; BAT_W = 38; BAT_H = 10.0; BAT_CLR = 0.8;

// Push Button Dimensions 
// Sized to fit the PCB's actual 25mm switch pitch with a 3mm visual gap between adjacent button caps 
BAR_L = 20; BAR_W = 16; BAR_H = 2.5;
OPEN_L = 17.5; OPEN_W = 12.5;
STEM_L = 15; STEM_W = 10; STEM_H = 3.0;
FLANGE_L = 22; FLANGE_W = 18; FLANGE_T = 1.2;
TRAVEL = 0.8;

// --- Long side tabs (top/bottom) ---
TAB_L = 10;         // Length (X for long sides)
TAB_W_LONG = 1.0;  // Width (Y for long sides, reduced to fit within wall)
TAB_HEIGHT = 4.0;  // Height (Z)

// Slot parameters for long side tabs
SLOT_L = TAB_L + 0.5;      // 8.5mm (X)
SLOT_W_LONG = TAB_W_LONG + 0.2;  // 1.2mm (Y, with 0.1mm clearance on each side)
SLOT_H = TAB_HEIGHT + 0.5; // 2.5mm (Z)

// Positions for long side tabs (0.5mm inward from cavity edge)
LONG_TAB_X = L / 2;
LONG_TAB_Y = [0.5, W - TAB_W_LONG - 0.5];  // [0.5, 49.3]

// --- Vertical tab (right side, opposite USB-C) ---
SHORT_TAB_X = L - WALL;  // x = 125 (right edge of lid)
SHORT_TAB_Y = 12.4;       // Centered at y=12.4 (below bar openings)

// Slot parameters for vertical tab
SHORT_SLOT_W = 1.0;       // 1.0mm (X, fits within wall)
SHORT_SLOT_L = TAB_L + 0.5; // 8.5mm (Y)
SHORT_SLOT_H = TAB_HEIGHT + 0.5; // 2.5mm (Z)

// ---- Single registration datum: where the PCB sits inside the case ----
// PCB centered in the case interior (123 x 46.8mm clear) -- WALL + half the slack.
PCB_OFFSET = [WALL + ((L-2*WALL)-PCB_L)/2, WALL + ((W-2*WALL)-PCB_W)/2];  // = [6, 6.4]

// ---- Real PCB-local coordinates (from build_mech_pcb.py) -- do not hand-edit
// without updating the PCB to match. ----
PCB_SWITCH_XY = [[22,19], [47,19], [72,19]];   // SW1, SW2, SW3 centers
PCB_M4_XY     = [[12,4], [103,4]];              // MH1, MH2 (front edge)
PCB_USB_XY    = [5,19];                          // J_USB origin (rot=180, nose -> PCB x=0)

function to_case(p) = [p[0]+PCB_OFFSET[0], p[1]+PCB_OFFSET[1]];

CASE_SWITCH_XY = [for (p = PCB_SWITCH_XY) to_case(p)];
CASE_M4_XY     = [for (p = PCB_M4_XY) to_case(p)];
CASE_USB_XY    = to_case(PCB_USB_XY);

BAR_X = [for (s = CASE_SWITCH_XY) s[0] - BAR_L/2];
BAR_Y = CASE_SWITCH_XY[0][1] - BAR_W/2;   // all three switches share the same Y

PCB_TOP_Z = BOTTOM + BAT_H + 1.2 + 2.0 + PCB_T;   // = 16.0, independent of H
LID_Z = H - LID_T;

SWITCH_H = 4.3;              // *** VERIFY vs datasheet ***
SWITCH_SAFE_TRAVEL = 0.5;    // *** VERIFY vs datasheet ***
CLEARANCE_AVAILABLE = LID_Z - PCB_TOP_Z;
NEEDED_CLEARANCE = SWITCH_H + SWITCH_SAFE_TRAVEL + 0.5;
LID_BOSS_H = max(0, NEEDED_CLEARANCE - CLEARANCE_AVAILABLE) + 0.5;

STOP_H = TRAVEL - SWITCH_SAFE_TRAVEL + 0.15;
STOP_D = 2.5;

// USB-C cutout: sized for a real plug + strain-relief boot (not just the bare
// connector), on the wall the connector actually faces (left, x=0).
USB_CUT_W = 12;    // along case Y
USB_CUT_H = 6.5;   // vertical (Z)
USB_CUT_Z = PCB_TOP_Z + 1.7;   // approx. USB-C mating-face center above PCB
USB_FUNNEL = 1.5;  // outer-face lead-in flare, each side

module rounded_box(x,y,z,r=4){
    hull(){
        translate([r,r,0]) cylinder(r=r,h=z);
        translate([x-r,r,0]) cylinder(r=r,h=z);
        translate([r,y-r,0]) cylinder(r=r,h=z);
        translate([x-r,y-r,0]) cylinder(r=r,h=z);
    }
}

module tab() {
    cube([TAB_L, TAB_W, TAB_HEIGHT]);
}

// A mounting post that is ALWAYS connected: solid from the case floor up to the
// PCB's underside, so it can never be a floating island.
module standoff(x, y, pilot_d=0, pilot_from_top=6){
    post_h = PCB_TOP_Z - PCB_T;   // floor(0) local -> PCB-bottom height
    translate([x,y,0]) difference(){
        cylinder(d=6.0, h=post_h);
        if (pilot_d > 0)
            translate([0,0,post_h-pilot_from_top])
                cylinder(d=pilot_d, h=pilot_from_top+0.1);
    }
}


// Four solid corner captures.  Each is tied into the case walls and floor, with
// an upward-open hex pocket for a standard M4 hex nut.  The lid screw passes
// through the lid into the captured nut.
LID_NUT_AF = 7.4;          // M4 nut pocket, across flats; standard nut is ~7.0mm
LID_NUT_H = 3.6;           // nut thickness + small print clearance
LID_NUT_Z = H-LID_T-LID_NUT_H;
LID_BOSS_X = 12;
LID_BOSS_Y = 12;
LID_SCREW_D = 4.3;         // M4 clearance
LID_RECESS_D = 8.5;        // accommodates typical M4 socket/button head
LID_RECESS_H = 1.4;        // shallow counterbore; preserves 2.1mm lid floor

LID_CORNER_XY = [
    [LID_BOSS_X/2,       LID_BOSS_Y/2],
    [L-LID_BOSS_X/2,     LID_BOSS_Y/2],
    [LID_BOSS_X/2,       W-LID_BOSS_Y/2],
    [L-LID_BOSS_X/2,     W-LID_BOSS_Y/2]
];

module base() {
    difference() {
        // Main base shape
        rounded_box(L, W, H - LID_T, 5);

        // Inner cavity
        translate([WALL, WALL, BOTTOM])
            rounded_box(L - 2 * WALL, W - 2 * WALL, H - LID_T - BOTTOM + 0.1, 3.5);

        // Battery cutout
        translate([L - BAT_L - 7, (W - BAT_W) / 2, BOTTOM - 0.01])
            cube([BAT_L, BAT_W, BAT_H + BAT_CLR]);

        // USB-C cutout (unchanged)
        translate([-0.1, CASE_USB_XY[1] - USB_CUT_W / 2, USB_CUT_Z - USB_CUT_H / 2])
            cube([WALL + 0.2, USB_CUT_W, USB_CUT_H]);
        hull() {
            translate([-0.1, CASE_USB_XY[1] - USB_CUT_W / 2, USB_CUT_Z - USB_CUT_H / 2])
                cube([0.1, USB_CUT_W, USB_CUT_H]);
            translate([-0.1, CASE_USB_XY[1] - USB_CUT_W / 2 - USB_FUNNEL,
                       USB_CUT_Z - USB_CUT_H / 2 - USB_FUNNEL])
                cube([0.1, USB_CUT_W + 2 * USB_FUNNEL, USB_CUT_H + 2 * USB_FUNNEL]);
        }

        // --- Add slots in the base (on the INSIDE half of the walls) ---
        // Long side slots (top/bottom)
        for (y = LONG_TAB_Y) {
            translate([LONG_TAB_X - SLOT_L / 2, y, H - LID_T - SLOT_H])
                cube([SLOT_L, SLOT_W_LONG, SLOT_H]);  // SLOT_W_LONG = 1.8mm
        }
        // Vertical slot (right side, opposite USB-C)
        translate([L - WALL, SHORT_TAB_Y - SHORT_SLOT_L / 2, H - LID_T - SHORT_SLOT_H])
            cube([SHORT_SLOT_W, SHORT_SLOT_L, SHORT_SLOT_H]);  // SHORT_SLOT_W = 1.0mm

      for (y = LONG_TAB_Y) {
       translate([LONG_TAB_X - SLOT_L / 2+4, y+30, H - LID_T - SLOT_H+1.5])rotate([90,0,0])color("yellow"){cylinder(55,.5,.5);}
       }
       
    }

    // Existing standoffs (unchanged)
    for (p = CASE_M4_XY)
        standoff(p[0], p[1], pilot_d = 3.4);
    standoff(WALL + 6, W - WALL - 6);
    standoff(L - WALL - 6, W - WALL - 6);
}

module lid() {
    difference() {
        // Main lid shape
        rounded_box(L, W, LID_T, 5);

        // Existing cutouts (bar openings, screw holes, etc.)
        for (x = BAR_X)
            translate([x, BAR_Y, -0.1])
                cube([OPEN_L, OPEN_W, LID_T + 0.2]);
        for (x = BAR_X)
            translate([x + (BAR_L - STEM_L) / 2 - 1, BAR_Y + (BAR_W - STEM_W) / 2 - 1, -0.1])
                cube([STEM_L + 2, STEM_W + 2, LID_BOSS_H + 0.1]);
    }

    // --- Add tabs as protrusions on the underside of the lid ---
    // Long side tabs (top/bottom)
    difference(){
    for (y = LONG_TAB_Y) {
        translate([LONG_TAB_X - TAB_L / 2, y, -TAB_HEIGHT])
            cube([TAB_L, TAB_W_LONG, TAB_HEIGHT]);  // TAB_W_LONG = 1.0mm
    }
    for (y = LONG_TAB_Y) {
     translate([LONG_TAB_X - SLOT_L / 2+4, y+30, H - LID_T - SLOT_H-19])rotate([90,0,0])color("yellow"){cylinder(55,.5,.5);}
       }
       }
    // Vertical tab (right side, opposite USB-C)
    translate([SHORT_TAB_X, SHORT_TAB_Y - TAB_L / 2, -TAB_HEIGHT])
        cube([WALL, TAB_L, TAB_HEIGHT]);  // WALL = 2.0mm
}


module bar(x=0, y=0){
    translate([x,y,H-LID_T+TRAVEL])
        rounded_box(BAR_L,BAR_W,BAR_H,3);
    translate([x+(BAR_L-STEM_L)/2,y+(BAR_W-STEM_W)/2,H-LID_T-STEM_H+TRAVEL])
        cube([STEM_L,STEM_W,STEM_H]);
    translate([x+(BAR_L-FLANGE_L)/2,y+(BAR_W-FLANGE_W)/2,
               H-LID_T-STEM_H-FLANGE_T+TRAVEL])
        rounded_box(FLANGE_L,FLANGE_W,FLANGE_T,2);
    translate([x+BAR_L/2+7, y+BAR_W/2, H-LID_T-STEM_H-FLANGE_T-STOP_H+TRAVEL])
        cylinder(d=STOP_D, h=STOP_H);
}

module assembly(){
    color("DarkGrey",alpha=1.0) base();
    color("Grey",alpha=1.0) translate([0,0,H-LID_T]) lid();
    for(i=[0:2])
        color(i==0?"blue":i==1?"green":"red")
            translate([0,0,2])bar(BAR_X[i],BAR_Y);
}

module exploded_assembly() {
    color("DarkGrey",alpha=1.0) base();
    color("Grey",alpha=1.0) translate([0,0,H-LID_T+15]) lid();
    for(i=[0:2])
        color(i==0?"blue":i==1?"green":"red")
            translate([0,0,2+5])bar(BAR_X[i],BAR_Y);
}

exploded_assembly();
translate([150,0,0])assembly();
//bar();
//lid();
//base();5