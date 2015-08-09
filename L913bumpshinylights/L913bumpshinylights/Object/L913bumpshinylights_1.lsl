// :CATEGORY:Spotlight
// :NAME:L913bumpshinylights
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:439
// :NUM:595
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L9.13-bump-shiny-lights.lsl
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

// Listing 9.13: Texture-Changing Object
default
{
    state_entry() {
        vector currPos = llGetPos();
        llRezObject("Spinning Lights", currPos, ZERO_VECTOR, ZERO_ROTATION, 1);
        llSetTimerEvent(1);
    }
    timer() {
        integer bumpTexture = (integer)(llFrand(17));
        llSetPrimitiveParams([PRIM_BUMP_SHINY,ALL_SIDES,
                 PRIM_SHINY_NONE, bumpTexture]);
    }
}
// END //
