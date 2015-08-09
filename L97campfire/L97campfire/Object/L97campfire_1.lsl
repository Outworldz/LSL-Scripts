// :CATEGORY:Fire
// :NAME:L97campfire
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:448
// :NUM:604
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L9.07-campfire.lsl
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

// Listing 9.7 Animating a Campfire
key fireTexture = "150a5721-e27a-36f4-bf91-4d8d5ad781f7";
default {
    state_entry() {
        llSetAlpha(0,ALL_SIDES);
        llSetAlpha(1,1);
        llSetAlpha(1,3);
        llSetTexture(fireTexture, ALL_SIDES);
        llSetTextureAnim(ANIM_ON | LOOP, // mode
                         ALL_SIDES,      // side
                         4, 4,           // x_frames, y_frames
                         0, 0,           // start, length frame
                         4);             // frame rate
    }
    on_rez( integer _n ) {
        llResetScript();
    }
}
// END //
