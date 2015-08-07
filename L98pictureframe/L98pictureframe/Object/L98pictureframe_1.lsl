// :CATEGORY:Picture Frame
// :NAME:L98pictureframe
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:449
// :NUM:605
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L9.08-picture-frame.lsl
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

// Listing 9.8: The Frame (Root Prim)
float HOLLOW_SIZE = 0.75;

integer gNumTextures;
list gTextures;
integer gCurrentTexture;
integer gWhichFrame;

initFrame()
{
    float hollow = HOLLOW_SIZE;
    vector cut = <0,1.0,0>;
    vector twist = <0,0,0>;
    vector taper_b = <0.85,0.85,0>;  // a basic cube would be <1,1,0>
    vector topshear = <0.0,0.0,0>;
    llSetPrimitiveParams( [PRIM_TYPE, PRIM_TYPE_BOX, PRIM_HOLE_DEFAULT, 
                             cut, hollow, twist, taper_b, topshear] );
}

default
{
    state_entry() {
        initFrame();
        gWhichFrame = 0;
        gNumTextures = llGetInventoryNumber( INVENTORY_TEXTURE );
        gCurrentTexture = 0;
        llSetTimerEvent(10);
    }
    on_rez(integer _n) {
        llResetScript();
    }
    timer() {
        string name = llGetInventoryName( INVENTORY_TEXTURE, gCurrentTexture );
        key id = llGetInventoryKey( name );
        vector size = llGetScale()*HOLLOW_SIZE;
        llMessageLinked(LINK_ALL_OTHERS, gWhichFrame, (string)size, id);
        gWhichFrame = !gWhichFrame;
        gCurrentTexture++;
        if (gCurrentTexture == gNumTextures) {
            gCurrentTexture = 0;
        }
    }
}
// END //
