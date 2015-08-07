// :CATEGORY:Spotlight
// :NAME:L91spotlightcontroller
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:441
// :NUM:597
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L9.10-spotlight-controller.lsl
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

// Listing 9.10: Color-Changing Spotlight Controller (in the Bulb)
float TIMER_INTERVAL = 3.0;
float INTENSITY = 1.0;  // range 0.0 to 1.0
float RADIUS = 0.2;     // up to 20m
float FALLOFF   = 0.01; // range 0.01 (slow) to 2.0 (fast)
default
{
    state_entry() {
        llSetTimerEvent( TIMER_INTERVAL );
    }
    timer() {
        float r = llFrand(1.0);
        float g = llFrand(1.0);
        float b = llFrand(1.0);
        vector color = <r,g,b>; 
        llSetPrimitiveParams([
            PRIM_POINT_LIGHT, TRUE, color, INTENSITY, RADIUS, FALLOFF,
            PRIM_FULLBRIGHT, ALL_SIDES, TRUE,
            PRIM_COLOR, ALL_SIDES, color, 0.75 ]);
        llMessageLinked( LINK_SET, 0, (string)color, NULL_KEY ); 
    }
}
// END //
