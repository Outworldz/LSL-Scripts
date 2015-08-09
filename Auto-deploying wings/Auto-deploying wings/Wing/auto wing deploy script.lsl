// :CATEGORY:Wings
// :NAME:Auto-deploying wings
// :AUTHOR:Dana Moore
// :CREATED:2014-01-20 18:13:24
// :EDITED:2014-01-20 18:13:24
// :ID:1013
// :NUM:1567
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Autodeploying Wings
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

// Autodeploying Wings
// The trick to making wings autodepoly is to link two wings to a third, invisible box.
// Set a Path Cut Begin to 0.625 and Path Cut End to 0.875 to cut each wing in half.
// This script goes into the 3rd, invisible prim.  Link the prims so that the invisible prim is the root, or last prim clicked.


vector WINGLG = <0.75,3.0, 0.01>;  // flying size
vector WINGSM = <0.2, 0.8, 0.01>;  // not flying size
float  TIMER_INTERVAL = 1.0;

integer gExtended = FALSE;
key gMyAvatar = NULL_KEY;

integer isFlying() {
    return AGENT_FLYING == (llGetAgentInfo(gMyAvatar) & AGENT_FLYING);
}

checkWings() {
    if (isFlying()) {
        if (!gExtended) {
            gExtended = TRUE;
            setWings(WINGLG);
        }
    } else { // not flying
        if (gExtended) {
            gExtended = FALSE;
            setWings(WINGSM);
        }
    }
}

setWings(vector scale) {
    llSetLinkPrimitiveParams(LINK_ALL_OTHERS, [PRIM_SIZE, scale]);
}

default {
    on_rez(integer p) {
        llResetScript();
    }
    state_entry() {
        gMyAvatar = llGetOwner();
        gExtended = FALSE;
        checkWings();
        llSetTimerEvent(TIMER_INTERVAL);
    }
    timer() {
        checkWings();
    }
}
