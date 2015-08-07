// :CATEGORY:Games
// :NAME:Go_Game
// :AUTHOR:Jonathan Shaftoe
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:357
// :NUM:484
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Now for the tiles to display textures, first GoTileScript
// :CODE:
// GoTileScript
// Jonathan Shaftoe
// A tile prim for displaying textures on the board to show where pieces are. Each tile is a squashed
// flattened cube, to create 3 square faces in a row, like XYText. Each face displays a texture which
// shows 4 game pieces. Using rotation and flipping, just 20 textures are required to display all
// 81 possible states of 4 squares on the board being either empty, black or white.
// The tile prims are made into a tile grid, in the same way as the sensors.
// Create a single prim, drop this script and the GoTileFaceScript in, then take the resulting
// GoTile object into your inventory and see GoTileGridScript

integer gGameSize; // size of game board, 9, 13 or 19
integer gIndex;  // which tile in the grid are we
float gSize;     // scaling factor

integer TILEWIDTH = 6;  // absolute values for making us the right shape
integer TILEHEIGHT = 2;

integer gRotated = 0; // are we one of the rotated tiles used down the edge to conserve prim count

integer gXPosBase;  // Our logical coordinates within the grid
integer gYPosBase;

integer gXPos;  // Our actual physical coordinates
integer gYPos;

float gSquareSize; // Size of an individual square on the board.

integer gFace0Modified = 0; // has one of the three faces been modified and need re-texturing
integer gFace1Modified = 0;
integer gFace2Modified = 0;

list gStates = []; // The state of this tile. Each face is a string in the list, each
                   // string is 4 characters of 0 - blank, 1 - black, 2 - white
list gStatesBackup = []; // backup copy of game state used for undoing changes during endgame
integer gGotBackup = 0;  // do we have a backup.
string  TRANSPARENT = "701917a8-d614-471f-13dd-5f4644e36e3c";

add_turn(integer face, integer x, integer y, string colour) {
    string current = llList2String(gStates, face);
//    llWhisper(0, "Got add turn, face: " + (string) face + " coords " + (string)x + ", " + (string)y + " and current state: " + current + ". Index is: " + (string)gIndex);
    string newstr;
    integer pos = (y * 2) + x;
    if (pos == 0) {
        newstr = colour + llGetSubString(current, 1, 3);
    } else if (pos == 3) {
        newstr = llGetSubString(current, 0, 2) + colour;
    } else {
        newstr = llGetSubString(current, 0, pos - 1) + colour + llGetSubString(current, pos + 1, 3);
    }
//    llWhisper(0, "New state is: " + newstr);
    gStates = llListInsertList(llDeleteSubList(gStates, face, face), [newstr], face);
}

show_face(integer face) {
    string statestr = llList2String(gStates, face);
    llMessageLinked(llGetLinkNumber(), 301, statestr, (string)(face + 10 * gRotated));
}

default {
    state_entry() {
        llSetPrimitiveParams([
            PRIM_TYPE, PRIM_TYPE_BOX, PRIM_HOLE_DEFAULT, <0, 1, 0>, 0.0, ZERO_VECTOR, <0.333333, 1, 0>, ZERO_VECTOR,
            PRIM_SIZE, <1.5, 0.5, 0.01>,
            PRIM_TEXTURE, ALL_SIDES, "5748decc-f629-461c-9a36-a35a221fe21f", <1, 1, 0>,  <0, 0, 0>, 0.0,
            PRIM_COLOR, ALL_SIDES, <1, 1, 1>, 1.0
        ]);
        llSetObjectName("GoTile");
        llSetTouchText("");
        llSetObjectDesc("Go Game board tile");
        llSitTarget(ZERO_VECTOR, ZERO_ROTATION);

    }

    on_rez(integer start_param) {
        gIndex = start_param;
//        llSetText((string)gIndex, <0, 0, 0>, 1.0);
        state ready;
    }

    changed(integer change) {
        if (change & CHANGED_LINK) 
            if (llGetLinkNumber() == 0) 
                llDie(); // so i die        
    }
}

state ready {
    link_message(integer sender, integer num, string str, key id) {
        if (num == 3) {
            list params = llParseString2List(str, [","], []);
            gGameSize = llList2Integer(params, 0);
            gSize = llList2Float(params, 3);
            
            integer vertical_strips = 0;
            integer xTiles = gGameSize / TILEWIDTH;
            integer yTiles = gGameSize / TILEHEIGHT;
            if (yTiles * TILEHEIGHT < gGameSize) {
                yTiles++;
            }
            if (xTiles * TILEWIDTH + 2 < gGameSize) {
                xTiles++;
            } else {
                vertical_strips = xTiles + 1;
            }
            integer extra_index = gIndex - (xTiles * yTiles);
            if (extra_index >= vertical_strips) {
                // hide us away, not needed
                llSetScale(<0.01, 0.01, 0.01>);
                llSetPos(<0, 0, -.01>);
                llSetText("", <0,0,0>, 1.0);
                gXPos = -10;
                gYPos = -10;
            } else {
                if (extra_index >= 0 && extra_index < vertical_strips) {
                    gXPosBase = xTiles;
                    gYPosBase = extra_index * (TILEWIDTH / TILEHEIGHT);
                    gRotated = 1;
                } else {
                    gXPosBase = (gIndex % xTiles);
                    gYPosBase = (gIndex / xTiles);
                }

                gXPos = gXPosBase * TILEWIDTH;
                gYPos = gYPosBase * TILEHEIGHT;
            
                gSquareSize = gSize / gGameSize;
                llSetTexture(TRANSPARENT, ALL_SIDES);
                llSetScale(<gSquareSize * TILEWIDTH, gSquareSize * TILEHEIGHT, 0.01>);
                if (gRotated == 1) {
                    llSetPos(<(gXPos + (TILEHEIGHT / 2.0)) * gSquareSize - gSize / 2, (gYPos + (TILEWIDTH /     2.0)) * gSquareSize - gSize / 2, 0.005 * gSize + .005>);
                    llSetLocalRot(llEuler2Rot(<0, 0, PI_BY_TWO>));
                } else {
                    llSetPos(<(gXPos + (TILEWIDTH / 2.0)) * gSquareSize - gSize / 2, (gYPos + (TILEHEIGHT / 2.0)) * gSquareSize - gSize / 2, 0.01 * gSize + .001>);
                }
                gStates = ["0000", "0000", "0000"];
            }
        } else if (num == 201) {
            list params = llParseString2List(str, [","], []);
            integer x;
            integer y;
            string colour;
            x = llList2Integer(params, 0);
            y = llList2Integer(params, 1);
            colour = llList2String(params, 2);
            if (x < gXPos || y < gYPos) {
                return;
            }
            integer face;
            integer facex;
            integer facey;
            if (gRotated == 0) {
                facey = y - gYPos;
                if (facey > 1) {
                    return;
                }
                face = (x - gXPos) / 2;
                facex = (x - gXPos) % 2;
            } else {
                facex = x - gXPos;
                if (facex > 1) {
                    return;
                }
                face = (y - gYPos) / 2;
                facey = (y - gYPos) % 2;
            }
            if (face > 2) {
                return;
            }
            // need to save states in case we have to undo the changes - needed when marking groups for endgame
            if (id == "1" && gGotBackup == 0) {
                gGotBackup = 1;
                gStatesBackup = gStates;
            }
            add_turn(face, facex, facey, colour);
            if (colour != "0") {
                show_face(face);
            } else {
                if (face == 0) {
                   gFace0Modified = 1;
                } else if (face == 1) {
                    gFace1Modified = 1;
                } else if (face == 2) {
                    gFace2Modified = 1;
                }
            }
        } else if (num == 202) {
            if (gFace0Modified == 1) {
                show_face(0);
                gFace0Modified = 0;
            }
            if (gFace1Modified == 1) {
                show_face(1);
                gFace1Modified = 0;
            }
            if (gFace2Modified == 1) {
                show_face(2);
                gFace2Modified = 0;
            }
        } else if (num == 15) {
            if (gGotBackup == 1) {
                gStates = gStatesBackup;
                gStatesBackup = [];
                gGotBackup = 0;
                show_face(0);
                show_face(1);
                show_face(2);
            }
        } else if (num == 203) {
            gGotBackup = 0;
            gStatesBackup = [];
        } else if (num == 999) {
            gGotBackup = 0;
            gStatesBackup = [];
            gStates = ["0000", "0000", "0000"];
            show_face(0);
            show_face(1);
            show_face(2); 
            gFace0Modified = 0;
            gFace1Modified = 0;
            gFace2Modified = 0;
        }
    }

    changed(integer change) {
        if (change & CHANGED_LINK) 
            if (llGetLinkNumber() == 0) 
                llDie(); // so i die        
    }
}
