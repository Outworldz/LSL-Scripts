// :CATEGORY:Fireworks
// :NAME:L93fireworkscannon
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:443
// :NUM:599
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L9.03-fireworks-cannon.lsl
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

// Listing 9.3: Fireworks Cannon
default
{
    touch_start(integer total_number) {
        vector rootRot = llRot2Euler(llGetRootRotation());
        vector mod = <llFrand(-0.2), llFrand(0.2), 0> + <0, -0.1, 0>;
        rotation rot = llEuler2Rot( rootRot + mod );
        
        integer n = llGetInventoryNumber( INVENTORY_OBJECT );
        integer choice = llFloor( llFrand(n) );
        string name = llGetInventoryName(INVENTORY_OBJECT,choice);
        llRezObject(name, llGetPos(), <0,0,15>*rot, ZERO_ROTATION, 12);
    }
}
// END //
