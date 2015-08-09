// :CATEGORY:Games
// :NAME:Go_Game
// :AUTHOR:Jonathan Shaftoe
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:357
// :NUM:481
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Next up, GoJoinButtonScript
// :CODE:
// GoJoinButtonScript
// Jonathan Shaftoe
// A simple button used for players to join the Go game, and also to start the game.
// Gets disabled and hidden once game is in progress.
// Drop into a simple prim, call it GoJoinButton, then store in your inventory for later.

integer gColour; // what colour are we, 1 - black, 2 - white
float gSize;     // scaling constant
string gPlayAs;  // Play as Black or Play as White
vector gPlayAsCol; // Actual colour, black or white.

set_size() {
    llSetScale(<0.2 * gSize, 0.2 * gSize, 0.1 * gSize>);
}

default {
    state_entry() {
        llSetPrimitiveParams([
            PRIM_TYPE, PRIM_TYPE_SPHERE, PRIM_HOLE_DEFAULT, <0, 0.5, 0>, 0.0, ZERO_VECTOR, <0, 1, 0>,
            PRIM_SIZE, <0.4, 0.4, 0.1>,
            PRIM_TEXTURE, ALL_SIDES, "5748decc-f629-461c-9a36-a35a221fe21f", <1, 1, 0>,  <0, 0, 0>, 0.0,
            PRIM_COLOR, ALL_SIDES, <0.5, 0.5, 0.5>, 1.0
        ]);
        llSetTouchText("Join Game");
        llSetObjectDesc("Go Game Join Button.");
        llSetObjectName("GoJoinButton");
        llSitTarget(ZERO_VECTOR, ZERO_ROTATION);
    }

    on_rez(integer start_param) {
        if (start_param > 0) {
            gColour = start_param;
            if (gColour == 1) { 
                llSetColor(<0, 0, 0>, ALL_SIDES);
                gPlayAs = "Play as Black";
                gPlayAsCol = <0, 0, 0>;
            } else if (gColour == 2) {
                llSetColor(<1, 1, 1>, ALL_SIDES);
                gPlayAs = "Play as White";
                gPlayAsCol = <1, 1, 1>;
            }
        }
    }

    link_message(integer sender, integer num, string str, key id) {
        if (num == 1) {
            gSize = (float)str;
            set_size();
            state enabled;
        }
    }
    
    changed(integer change) {
        if (change & CHANGED_LINK) 
            if (llGetLinkNumber() == 0) 
                llDie(); // so i die        
    }
}

state enabled {
    state_entry() {
        llSetAlpha(1.0, ALL_SIDES);
        llSetText(gPlayAs, gPlayAsCol, 1.0);
        set_size();
    }
     
    touch_start(integer num) {
        llMessageLinked(LINK_ROOT, gColour, "", llDetectedKey(0));
        state disabled;
    }
    
    changed(integer change) {
        if (change & CHANGED_LINK) 
            if (llGetLinkNumber() == 0) 
                llDie(); // so i die        
    }
}

state disabled {
    state_entry() {
        llSetAlpha(0.0, ALL_SIDES);
        llSetScale(<0.01, 0.01, 0.01>);
        llSetText("", <0, 0, 0>, 1.0);
    }
    
    link_message(integer sender, integer num, string str, key id) {
        if (num == 999) {
            state enabled;
        }
    }
    
    changed(integer change) {
        if (change & CHANGED_LINK) 
            if (llGetLinkNumber() == 0) 
                llDie(); // so i die        
    }
}
