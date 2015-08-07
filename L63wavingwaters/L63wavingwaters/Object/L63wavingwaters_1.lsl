// :CATEGORY:Water Animation
// :NAME:L63wavingwaters
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:430
// :NUM:586
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L6.03-waving-waters.lsl
// :CODE:

// Copyright (c) 2008, Scripting Your World
// All rights reserved.
//
// Scripting Your World
// By Dana Moore, Michael Thome, and Dr. Karen Zita Haigh
// http://syw.fabulo.us
// http://www.amazon.com/Scripting-Your-World-Official-Second/dp/0470339837/
//
// You are permitted to use, share, and adapt this code under the 
// terms of the Creative Commons Public License described in full
// at http://creativecommons.org/licenses/by/3.0/legalcode.
// That means you must keep the credits, do nothing to damage our
// reputation, and do not suggest that we endorse you or your work.

// Listing 6.3: Waving Waters
vector gFullWest = <98.500, 188.700, 113.00>; // substitute your coordinates here
vector gFullEast = <99.325, 188.700, 113.00>; // substitute your own coordinates
vector gCurrentPos; // will vary between full west and full east
float gAdjuster;

move_on()
{
    if (gCurrentPos.x <= gFullWest.x){ gAdjuster = 0.01; }
    if (gCurrentPos.x >= gFullEast.x){ gAdjuster = -0.01; }
    gCurrentPos.x += gAdjuster;
    
    // uncomment this line only when you know that the gFullWest and gFullEast
    // are correct
    // llSetPos(gCurrentPos);
}

default
{
    state_entry() {
        gCurrentPos = gFullWest;
        llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES, 1, 1, 1.0, 1.0, 0.05);
        llSetTimerEvent(1.0);
    }
    timer() {
        move_on();
    }
}
// END //
