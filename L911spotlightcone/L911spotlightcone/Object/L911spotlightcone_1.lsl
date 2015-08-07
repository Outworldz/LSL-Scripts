// :CATEGORY:Spotlight
// :NAME:L911spotlightcone
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:437
// :NUM:593
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L9.11-spotlight-cone.lsl
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

// Listing 9.11: The Cone of Light
float TRANSPARENCY = 0.2;
default
{
    link_message(integer linknum, integer _n, string msg, key _id) {
        vector color = (vector)msg;
        llSetPrimitiveParams([PRIM_PHANTOM, TRUE,
                              PRIM_COLOR, ALL_SIDES, color, TRANSPARENCY]);
    }
}
// END //
