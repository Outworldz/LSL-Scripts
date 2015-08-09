// :CATEGORY:Land
// :NAME:L64pooldigger
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:431
// :NUM:587
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L6.04-pool-digger.lsl
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

// Listing 6.4: Terraforming Pool Digger
integer OB_CHANNEL = -654321; // or use a random value

integer gRadius = 4;  // how far to scan around starting point
integer gBrush = 0;   // brush size 0=2m, 1=4m, 2=8m: see wiki
integer gDig = TRUE;  // should we dig on the next touch?

scan(vector center, integer operation) {
    float step = llPow(2.0, (float) gBrush);
    float x;
    for (x = -gRadius; x <= gRadius; x += step) {
        float y;
        for (y = -gRadius; y <= gRadius; y += step) {
             vector p = <center.x + x, center.y + y, center.z>;
             float dist = llVecDist(p, center);
             if (dist <= gRadius) {
                 llSetPos(p);
                 integer z;
                 integer c = (integer) (((float) gRadius - dist) / 2);
                 for (z = 0; z <= c; z++) {
                    llModifyLand(operation, gBrush);
                 }
            }
        }
    }
}

default
{
    touch_start(integer total_number) {
        vector home = llGetPos();
        if (gDig) {
            scan(home, LAND_LOWER);
        } else {
            llSay(OB_CHANNEL, "die");
            scan(home, LAND_RAISE);
        }
        llSetPos(home);
        
        if (gDig) {
            llRezObject("Pool", <home.x, home.y, home.z - 1.0>,
                                <0,0,0>, ZERO_ROTATION, OB_CHANNEL);
            llSay(OB_CHANNEL, "size=" + (string)(2 * (gRadius + 1)));
        } 
        gDig = !gDig;
    }
}
// END //
