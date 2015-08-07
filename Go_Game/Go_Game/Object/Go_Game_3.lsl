// :CATEGORY:Games
// :NAME:Go_Game
// :AUTHOR:Jonathan Shaftoe
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:357
// :NUM:482
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// That's the simple stuff done. Now things get more complicated, you need to create two grids, one of 'tiles' (prim textures to display the pieces on the board), and one of 'sensors' (to detect clicks when specifying where you want to play).// // First off sensors, here's the GoSensorScript
// :CODE:
// GoSensorScript
// Jonathan Shaftoe
// Script for each individual Go Sensor, used to detect mouse clicks to allow the player to select
// where they want to play. Uses a two click mechanism to reduce prim usage, a grid of these sensors
// moves over the board. For example, using a 19x19 board, 20 sensors in a 4x5 grid are used to allow
// the player to select the square they want to play in. To start with, the 4x5 grid covers the
// whole board, each sensor covering 20 squares. When one is clicked on, the sensors rearrange to
// just be over the 20 squares that were under the sensor clicked, then allowing the player to
// select an individual square. It's hard to explain, but when you see it working it'll be much
// more sense.
// Create a single prim, call it GoSensor, then drop this script in. Then see GoSensorGridScript.

integer gIndex;  // which sensor in the grid am I
float gSize;     // global scaling factor

integer gXSensors; // how many sensors across in grid to cover board
integer gYSensors; // how many sensors up/down in grid to cover board

integer gXSquares; // how many squares on the board across covered by a sensor
integer gYSquares; // how many squares on the board up/down covered by a sensor

integer gGameSize; // size of game board, will be 9, 13 or 19

integer gXPosBase; // x coordinate of sensor in grid
integer gYPosBase; // y coordinate of sensor in grid

integer gXPos;  // x position of sensor in grid 
integer gYPos;  // y position of sensor in grid

integer gZoomPosX; // x coordinate when zoomed in (after first click by player)
integer gZoomPosY; // y coordinate when zoomed in

float gSquareSize; // Size of an individual square on the board.

key gPlayer;  // player whose turn it currently is.

hide() {
    llSetScale(<0.01, 0.01, 0.01>);
    llSetPos(<0, 0, - 0.01>);
}

default {
    state_entry() {
        llSetPrimitiveParams([
            PRIM_TYPE, PRIM_TYPE_BOX, PRIM_HOLE_DEFAULT, <0, 1, 0>, 0.0, ZERO_VECTOR, <1, 1, 0>, ZERO_VECTOR,
            PRIM_SIZE, <0.5, 0.5, 0.5>,
            PRIM_TEXTURE, ALL_SIDES, "5748decc-f629-461c-9a36-a35a221fe21f", <1, 1, 0>,  <0, 0, 0>, 0.0,
            PRIM_COLOR, ALL_SIDES, <0, 0, 1>, 0.25
        ]);
        llSetObjectName("GoSensor");
        llSetTouchText("Play here");
        llSetObjectDesc("Go Game sensor - click once to select region to play in, then again for exact position.");
        llSitTarget(ZERO_VECTOR, ZERO_ROTATION);
    }

    on_rez(integer start_param) {
        gIndex = start_param;
        state ready;
    }

    changed(integer change) {
        if (change & CHANGED_LINK) 
            if (llGetLinkNumber() == 0) 
                llDie(); // so i die        
    }
}

// Do setup, hide sensor and wait for message
state ready {
    state_entry() {
    }
    
    link_message(integer sender, integer num, string str, key id) {
        if (num == 3) {
            hide();
            list params = llParseString2List(str, [","], []);
            gGameSize = llList2Integer(params, 0);
            gXSensors = llList2Integer(params, 1);
            gYSensors = llList2Integer(params, 2);
            gSize = llList2Float(params, 3);
            
            gXSquares = llCeil((float)gGameSize / gXSensors);
            gYSquares = llCeil((float)gGameSize / gYSensors);
            
            gXPosBase = (gIndex % gXSensors);
            gYPosBase = (gIndex / gXSensors);
            
            if ((gXPosBase + gYPosBase) % 2 == 0) { // Alternating colours for checkerboard effect
                llSetColor(<1, 0, 0>, ALL_SIDES);
            } else {
                llSetColor(<0, 1, 0>, ALL_SIDES);
            }

            gXPos = gXPosBase * gXSquares;
            gYPos = gYPosBase * gYSquares;
            
            if (gGameSize - gXPos < gXSquares) {
                gXSquares = gGameSize - gXPos;
            }
            if (gGameSize - gYPos < gYSquares) {
                gYSquares = gGameSize - gYPos;
            }
            gSquareSize = gSize / gGameSize;
        } else if (num == 0) {
            gPlayer = id;
            state zoom1;
        }
    }

    changed(integer change) {
        if (change & CHANGED_LINK) 
            if (llGetLinkNumber() == 0) 
                llDie(); // so i die        
    }
}


// Move to first position, sensor grid covering whole board, wait for player click
state zoom1 {
    state_entry() {
        if (gXPosBase >= gXSensors || gYPosBase >= gYSensors) {
            hide();
        } else {
            float width = gSquareSize * gXSquares;
            float height = gSquareSize * gYSquares;
            llSetScale(<width, height, 0.01 * gSize>);
            llSetPos(<(gXPos + (gXSquares / 2.0)) * gSquareSize - gSize / 2 , (gYPos + (gYSquares / 2.0)) * gSquareSize - gSize / 2, 0.02 * gSize + .02>);
        }
    }
    
    touch_start(integer num) {
        if (llDetectedKey(0) == gPlayer) {
            llMessageLinked(LINK_ALL_CHILDREN, 5, (string)gXPos + "," + (string)gYPos, "");
        } else {
//            llWhisper(0, "It's not your turn, " + llKey2Name(llDetectedKey(0)));
        }
    }
    
    link_message(integer sender, integer num, string str, key id) {
        if (num == 5) {
            list params = llParseString2List(str, [","], []);
            gZoomPosX = llList2Integer(params, 0);
            gZoomPosY = llList2Integer(params, 1);
            state zoom2;
        }
        else if (num == 0) {
            gPlayer = id;
        } else if (num == 105 || num == 999) {
            hide();
            state ready;
        }   
    }

    changed(integer change) {
        if (change & CHANGED_LINK) 
            if (llGetLinkNumber() == 0) 
                llDie(); // so i die        
    }
}

// move to zoomed in grid, each sensor covering one square on the board, wait for click.
state zoom2 {
    state_entry() {
        if (gXPosBase >= gXSensors || gYPosBase >= gYSensors || gZoomPosX + gYPosBase >= gGameSize || gZoomPosY + gXPosBase >= gGameSize) {
            hide();
        } else {
            llSetScale(<gSquareSize, gSquareSize, 0.01 * gSize>);
            llSetPos(<(gZoomPosX + gYPosBase + 0.5) * gSquareSize - gSize / 2, (gZoomPosY + gXPosBase + 0.5) * gSquareSize - gSize / 2, 0.02 * gSize + .02>);
        }
    }
    
    touch_start(integer num) {
        if (gZoomPosX + gYPosBase < gGameSize && gZoomPosY + gXPosBase < gGameSize) {
            if (llDetectedKey(0) == gPlayer) {
                llMessageLinked(LINK_ALL_CHILDREN, 20, "", "");
                integer x = gZoomPosX + gYPosBase;
                integer y = gZoomPosY + gXPosBase;
                llMessageLinked(LINK_ROOT, 4, (string)x + "," + (string)y, "");

                state waiting;
            } else {
//                llWhisper(0, "It's not your turn, " + llKey2Name(llDetectedKey(0)));
            }
        }
    }
    
    link_message(integer sender, integer num, string str, key id) {
        if (num == 0) {
            gPlayer = id;
            state zoom1;
        } else if (num == 20) {
            state waiting;
        } else if (num == 105 || num == 999) {
            hide();
            state ready;
        }
    }
    
    changed(integer change) {
        if (change & CHANGED_LINK) 
            if (llGetLinkNumber() == 0) 
                llDie(); // so i die        
    }
}

// Move has been attempted, disable clicks and wait to see what to do next.
state waiting {
    link_message(integer sender, integer num, string str, key id) {
        if (num == 0) {
            gPlayer = id;
            state zoom1;
        } else if (num == 21) {
            state zoom2;
        } else if (num == 105 || num == 999) {
            hide();
            state ready;
        }
    }   

    changed(integer change) {
        if (change & CHANGED_LINK) 
            if (llGetLinkNumber() == 0) 
                llDie(); // so i die        
    } 
}
