// :CATEGORY:Games
// :NAME:Go_Game
// :AUTHOR:Jonathan Shaftoe
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:357
// :NUM:480
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is my first (and perhaps only) large scale LSL project. I don't have time to do anything more with it, so I'm going to release it into the wild for others to use, adapt, play with as the like. I only ask that noone sells the original as posted here, as that would be a bit greedy.// // So, what is it? A fully functional Go board, which allows two players to play a game of Go and score up at the end. It uses various tricks, such as XYText style textures for the pieces on the board, and a squidgy double-click square selector device thing to keep the number of prims required to a minimum.// // There are several components and scripts, so it's all a bit complex to put together, and it's not as well commented as perhaps it should be, but I'll do my best to write some useful instructions.// 
// The board looks very basic. My talents do not lie in making things look pretty. All textures are linked to ones I've created. It would be trivial to put together some nicer textures and change the relevent keys. The code does the basic setting up of size/shape/colour of all parts of the game.
// 
// A large number of link messages are used to glue all the various bits and pieces together. I didn't document this as well as I should, and it's all a bit random as things which grow whilst coded tend to be. For my own benefit I eventually put together a little file documenting very briefly each message, so I'll include that here too.
// 
// As to the rules of the game of Go, there are plenty of websites out there that can explain it better than I can. However, I will say this, it is an extremely interesting and deep game that you can enjoy quickly, but study for years and not come close to mastering.
// 
// First up, GoButtonScript
// :CODE:
// GoButtonScript
// Jonathan Shaftoe
// A simple button used on the Go board, can be one of Pass, Done, Info, Resign or Reset
// Drop into a basic prim, call it GoButton, then store in your inventory for later.

key gPlayer; // Current player whose turn it is.
float gSize; // scaling constant.
integer gType; // which type of button we are. 1 - pass, 2 - done, 3 - reset, 4 - resign, 5 - info

set_size(string str) {
    gSize = (float)str;
    llSetScale(<0.2 * gSize, 0.1 * gSize, 0.01 * gSize>);
}

default {
    state_entry() {
        llSetPrimitiveParams([
            PRIM_TYPE, PRIM_TYPE_BOX, PRIM_HOLE_DEFAULT, <0, 1, 0>, 0.0, ZERO_VECTOR, <1, 1, 0>, ZERO_VECTOR,
            PRIM_SIZE, <0.2, 0.1, 0.01>,
            PRIM_TEXTURE, ALL_SIDES, "5748decc-f629-461c-9a36-a35a221fe21f", <1, 1, 0>,  <0, 0, 0>, 0.0,
            PRIM_COLOR, ALL_SIDES, <0.8, 0.6, 0.5>, 1.0
        ]);
        llSitTarget(ZERO_VECTOR, ZERO_ROTATION);
        llSetObjectName("GoButton");
    }

    on_rez(integer start_param) {
        if (start_param > 0) {
            gType = start_param;
            if (gType == 1) {
                llSetTouchText("Pass");
//                llSetText("Pass", <0, 0, 0>, 1.0);
                llSetObjectDesc("Go Game Pass Button.");
                llSetTexture("f8919345-d4ab-613f-c594-5cdafcf6f8a1", 0);
            } else if (gType == 2) {
                llSetTouchText("Done");
//                llSetText("Done", <0, 0, 0>, 1.0);
                llSetObjectDesc("Go Game Done Button.");
                llSetTexture("9db6cc17-c2bc-04e9-bc5e-659e0b20d82f", 0);
            } else if (gType == 3) {
                llSetTouchText("Reset");
//                llSetText("Reset", <0, 0, 0>, 1.0);
                llSetObjectDesc("Go Game Reset Button");
                llSetTexture("619570be-ce9c-11ff-3f8b-9ebab0f3c759", 0);
            } else if (gType == 4) {
                llSetTouchText("Resign");
//                llSetText("Resign", <0, 0, 0>, 1.0);
                llSetObjectDesc("Go Game Resign Button");
                llSetTexture("5ad73a1c-060c-3fba-5662-584ddfcdc115", 0);
            } else if (gType == 5) {
                llSetTouchText("Info");
//                llSetText("Info", <0, 0, 0>, 1.0);
                llSetObjectDesc("Go Game Info Button");
                llSetTexture("d0b9c9de-a289-01df-734a-10a8201841ad", 0);
            }
        }
    }

    changed(integer change) {
        if (change & CHANGED_LINK) 
            if (llGetLinkNumber() == 0) 
                llDie(); // so i die        
    }

    touch_start(integer num) {
        if (gType == 1) {
            if (llDetectedKey(0) == gPlayer) {
                llMessageLinked(LINK_ROOT, 10, "", "");
            }
        } else if (gType == 2) {
            if (llDetectedKey(0) == gPlayer) {
                llMessageLinked(LINK_ROOT, 11, "", "");
            }
        } else if (gType == 3) {
            llMessageLinked(LINK_ROOT, 12, "", llDetectedKey(0));
        } else if (gType == 4) {
            llMessageLinked(LINK_ROOT, 13, "", llDetectedKey(0));
        } else if (gType == 5) {
            llMessageLinked(LINK_ROOT, 14, "", llDetectedKey(0));
        }
    }
    
    link_message(integer sender, integer num, string str, key id) {
        if (num == 1) {
            set_size(str);
        } else if (num == 0) {
            gPlayer = id;
        }
    }
}
