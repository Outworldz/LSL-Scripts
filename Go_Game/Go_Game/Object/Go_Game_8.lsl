// :CATEGORY:Games
// :NAME:Go_Game
// :AUTHOR:Jonathan Shaftoe
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:357
// :NUM:487
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// You should now have a GoButton, a GoJoinButton, a GoSensorGrid and a GoTileGrid. Create a prim, drop an instance of each of those objects into its inventory, then finally put in the following two scripts which contain the main game logic, and you should have yourself a working Go board.// // First off is the GoGameLogicScript which contains most of the actual game logic for handling captures and the like.
// :CODE:
// GoGameLogicScript
// Jonathan Shaftoe
// Contains most of the game logic code for the Go game. It's big and it's nasty. It uses recursion
// to do group capture detection, so can be slow.
// For usage, see GoGameMainScript

integer gGameSize = 9; // size of the game board, can be 9, 13 or 19

integer gBlackScore; // current scores (captured stones)
integer gWhiteScore;

integer gDeadWhite; // count of dead stones in endgame
integer gDeadBlack;

string gGameStatePrev; // Previous game state, used to check for Ko
string gGameState; // Game state - string representing the current state of the game board.
string gCurrentGame; // Another copy of the game state, used to store current state when working out
                    // captures.

list gGroup = []; // list of indexes of stones in (possibly captured) group.
integer gGroupLiberties; // How many liberties the currently being checked group has
integer gLibertyX; // coordinates of found liberty. We only care if there are no liberties, one liberty
integer gLibertyY; // or more than one (number if more than one doesn't matter), so we store the first
                   // found liberty here, then subsequently found liberties we check if they're the same
                   // as this one, and if not then we know we have more than one.
integer gSearchColour; // Are we looking for black or white stones

integer gTurn; // Whose turn is it, black or white
integer gLastWasPass;  // So we know if we get two passes in a row
integer gTurnPreEndgame;  // For turn handling during endgame

integer gGotAtari; // If we've found at least one group with only one liberty left after a stone
                   // is played, then we have an atari

list gToDelete; // list of indexes of stones to be removed due to capture (can be more than one group)

integer gGroupType; // type of group check being done, to avoid having to pass it through recursive calls.
// 0 - suicide check, 1 - normal turn check, 2 - endgame dead group marking, 3 - endgame scoring.
float gSize=4.0; // global scale factor.

set_player(integer turn, integer endgame, integer send_message) {
    gTurn = turn;
    if (send_message == 1) {
        llMessageLinked(LINK_ROOT, 101, (string)gTurn, (key)((string)endgame));
    }
}

integer get_board_state(integer x, integer y) {
    integer index = x + 1 + ((y + 1) * (gGameSize + 2));
    string num = llGetSubString(gGameState, index, index);
    return (integer)num;
}

set_board_state(integer x, integer y, integer newstate) {
    integer index = x + 1 + ((y + 1) * (gGameSize + 2));
    string before = llGetSubString(gGameState, 0, index - 1);
    string after = llGetSubString(gGameState, index + 1, llStringLength(gGameState) - 1);
    gGameState = before + (string)newstate + after;
}

// Sets gameboard size and initialises gameState. Note 3s used around edge to make
// group detection easier (no boundary conditions, 3 is neither 1 (black) or 2 (white))
set_size(integer size) {
    gGameSize = size;
    if (gGameSize == 9) {
        gGameState = "33333333333" +
                     "30000000003" +
                     "30000000003" +
                     "30000000003" +
                     "30000000003" +
                     "30000000003" +
                     "30000000003" +
                     "30000000003" +
                     "30000000003" +
                     "30000000003" +
                     "33333333333"; 
    } else if (gGameSize == 13) {
        gGameState = "333333333333333" + 
                     "300000000000003" +
                     "300000000000003" +
                     "300000000000003" +
                     "300000000000003" +
                     "300000000000003" +
                     "300000000000003" +
                     "300000000000003" +
                     "300000000000003" +
                     "300000000000003" +
                     "300000000000003" +
                     "300000000000003" +
                     "300000000000003" +
                     "300000000000003" +
                     "333333333333333";
    } else if (gGameSize == 19) {
        gGameState = "333333333333333333333" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "300000000000000000003" +
                     "333333333333333333333";
    }
}

// functions below for doing recursive group detection. This is NOT efficient.
// on a 19x19 board, you can run out of script execution stack space if there are big
// groups. Could be improved.

recurse_check_util(integer x, integer y, integer dir) {
    integer neighbour = get_board_state(x, y);
    if (neighbour == gSearchColour) {
        recurse_check(x, y, dir);
    } else if (neighbour == 0 && gGroupType != 2) {
        if (x != gLibertyX || y != gLibertyY) {
            gLibertyX = x;
            gLibertyY = y;
            gGroupLiberties++;
        }
    } else if ((neighbour == 2 || neighbour == 1) && gGroupType == 3) {
        if (gGroupLiberties != neighbour) {
            gGroupLiberties += neighbour;
        }
    }
}

recurse_check(integer x, integer y, integer dir) {
    if (gGroupType == 1 && gGroupLiberties >= 2) {
        return;
    }
    if (gGroupType == 0 && gGroupLiberties == 1) {
        return;
    }
    if (llListFindList(gGroup, [x + (y * gGameSize)]) != -1) {
        return;
    }
    gGroup = gGroup + [x + (y * gGameSize)];
    if (dir != 0) {
        recurse_check_util(x - 1, y, 1);
    }
    if (dir != 1) {
        recurse_check_util(x + 1, y, 0);
    }
    if (dir != 2) {
        recurse_check_util(x, y - 1, 3);
    }
    if (dir != 3) {
        recurse_check_util(x, y + 1, 2);
    }
}

integer check_captures(integer x, integer y, integer dir, integer type) {
    integer groupSize = 0;
    gGroup = [];
    gGroupLiberties = 0;
    gLibertyX = -1;
    gLibertyY = -1;
    gGroupType = type;
    recurse_check(x, y, dir);

// if type == 0 then we're checking for a suicide play.
    if (type == 3 || gGroupLiberties == 0) {
        groupSize = llGetListLength(gGroup);
    }
    if (type == 1) { // finding captured groups in normal gameplay
        if (gGroupLiberties == 1) {
            gGotAtari = 1;
        } else if (gGroupLiberties == 0) {
            integer i = 0;
            while (i < groupSize) {
                integer index = llList2Integer(gGroup, i);
                integer remx = index % gGameSize;
                integer remy = index / gGameSize;
                set_board_state(remx, remy, 0);
                i++;
            }
            gToDelete = gToDelete + gGroup;
        }
    } else if (type == 2) {  // marking dead groups in endgame 
        integer i = 0;
        while (i < groupSize) {
            integer index = llList2Integer(gGroup, i);
            integer remx = index % gGameSize;
            integer remy = index / gGameSize;
            set_board_state(remx, remy, 0);
            i++;
            gToDelete = gToDelete + gGroup;
        }        
    } else if (type == 3) { // counting territory space in endgame - gGroupLiberties used to store colour of neighbouring stones to work out territory owner. If both colours are found then they're added so result will be 3 (or more)
        integer i = 0;
        while (i < groupSize) {
            integer index = llList2Integer(gGroup, i);
            integer remx = index % gGameSize;
            integer remy = index / gGameSize;
            set_board_state(remx, remy, 3);
            i++;
        }
        if (gGroupLiberties == 1) {
            gBlackScore += groupSize;
        } else if (gGroupLiberties == 2) {
            gWhiteScore += groupSize;
        }        
    }
    
    return groupSize;
}

default {
    state_entry() {
        gBlackScore = 0;
        gWhiteScore = 0;
        gTurn = 0;
        gLastWasPass = FALSE;
        state playing;
    }
}

// Normal state during game play.
state playing {
    state_entry() {
    }

    link_message(integer sender, integer num, string str, key id) {
        if (num == 100) {
            set_size((integer)str);
            gSize = (float)((string)id);
        } else if (num == 4) {
            list params = llParseString2List(str, [","], []);
            integer x = llList2Integer(params, 0);
            integer y = llList2Integer(params, 1);
            if (get_board_state(x, y) != 0) {
                llWhisper(0, "Cannot play there, already occupied.");
                llMessageLinked(LINK_ALL_CHILDREN, 21, "", "");
            } else {
                gCurrentGame = gGameState;
                set_board_state(x, y, gTurn + 1);
                gSearchColour = (1 - gTurn) + 1;
                integer scorechange = 0;
                gGotAtari = 0;
                gToDelete = [];
                if (get_board_state(x + 1, y) == gSearchColour) {
                    scorechange += check_captures(x + 1, y, 0, 1);
                }
                if (get_board_state(x - 1, y) == gSearchColour) {
                    scorechange += check_captures(x - 1, y, 1, 1);
                }
                if (get_board_state(x, y + 1) == gSearchColour) {
                    scorechange += check_captures(x, y + 1, 2, 1);
                }
                if (get_board_state(x, y - 1) == gSearchColour) {
                    scorechange += check_captures(x, y - 1, 3, 1);
                }
                if (scorechange > 0 && gGameState == gGameStatePrev) {
                    llWhisper(0, "Cannot play there due to ko");
                    gGameState = gCurrentGame;
                    llMessageLinked(LINK_ALL_CHILDREN, 21, "", "");
                    return;
                }
                if (scorechange == 0) {
                    gSearchColour = gTurn + 1;
                    integer checkSuicide = check_captures(x, y, -1, 0);
                    if (checkSuicide > 0) {
                        llWhisper(0, "Cannot play there, suicide play.");
                        gGameState = gCurrentGame;
                        llMessageLinked(LINK_ALL_CHILDREN, 21, "", "");
                        return;
                    }
                }
                llMessageLinked(LINK_ROOT, 500, (string)x, (string)y);
                if (gGotAtari == 1) {
                    if (gTurn == 0) {
                        llWhisper(0, "Black says 'atari'");
                    } else {
                        llWhisper(0, "White says 'atari'");
                    }
                }
                gGameStatePrev = gCurrentGame;
                if (scorechange > 0) {
                    // let's actually do the removing now
                    integer i = 0;
                    integer delete_index;
                    integer remx;
                    integer remy;
                    while (i < scorechange) {
                        delete_index = llList2Integer(gToDelete, i);
                        remx = delete_index % gGameSize;
                        remy = delete_index / gGameSize;
                        llMessageLinked(LINK_ALL_CHILDREN, 201, (string)remx + "," + (string)remy + ",0", "");
                        i++;
                    }
                    llMessageLinked(LINK_ALL_CHILDREN, 202, "", "");
                    string piece;
                    if (scorechange == 1) {
                        piece = "piece";
                    } else {
                        piece = "pieces";
                    }
                    if (gTurn == 0) {
                        gBlackScore += scorechange;
                        llWhisper(0, "Black captured " + (string)scorechange + " " + piece);
                    } else {
                        gWhiteScore += scorechange;
                        llWhisper(0, "White captured " + (string)scorechange + " " + piece);
                    }
                    llMessageLinked(LINK_ROOT, 400, (string)scorechange, (string)gTurn);
                }                
                gLastWasPass = FALSE;
                set_player(1 - gTurn, 0, 1);
                llMessageLinked(LINK_ALL_CHILDREN, 201, (string)x + "," + (string)y + "," + (string)(2 - gTurn), "");
            }
        } else if (num == 10) {
            if (gTurn == 0) {
                llWhisper(0, "Black passes");
            } else {
                llWhisper(0, "White passes");
            }
            gTurn = 1 - gTurn;
            gGameStatePrev = gGameState;
            if (gLastWasPass == TRUE) {
                llWhisper(0, "Consecutive passes, entering endgame.");
                state endgame;
            }
            gLastWasPass = TRUE;
            set_player(gTurn, 0, 1);
        } else if (num == 999) {
            state default;
        }
    }
}

// State during endgame, when players must mark any dead groups belonging to the other player.

state endgame {
    state_entry() {
        llMessageLinked(LINK_ROOT, 102, "", "");
        gLastWasPass = FALSE;
        gTurnPreEndgame = gTurn;
        gCurrentGame = gGameState;
        gDeadBlack = 0;
        gDeadWhite = 0;
        set_player(gTurn, 1, 1);
    }
    
    link_message(integer sender, integer num, string str, key id) {
        if (num == 103) {
            set_player((integer)str, (integer)((string)id), 0);
        } else if (num == 4) {
            list params = llParseString2List(str, [","], []);
            integer x = llList2Integer(params, 0);
            integer y = llList2Integer(params, 1);
            if (get_board_state(x, y) != (1 - gTurn) + 1) {
                llWhisper(0, "Invalid selection. Select your opponent's groups which are dead.");
                llMessageLinked(LINK_ALL_CHILDREN, 21, "", "");
            } else {
                gSearchColour = (1 - gTurn) + 1;
                gToDelete = [];
                integer scorechange = check_captures(x, y, -1, 2);
                integer i = 0;
                integer delete_index;
                integer remx;
                integer remy;
                while (i < scorechange) {
                    delete_index = llList2Integer(gToDelete, i);
                    remx = delete_index % gGameSize;
                    remy = delete_index / gGameSize;
                    llMessageLinked(LINK_ALL_CHILDREN, 201, (string)remx + "," + (string)remy + ",0", "1");
                    i++;
                }
                llMessageLinked(LINK_ALL_CHILDREN, 202, "", "");
                if (gSearchColour == 1) {
                    gDeadBlack += scorechange;
                } else {
                    gDeadWhite += scorechange;
                }
                set_player(gTurn, 1, 1);
            }
        } else if (num == 104) {
            if (str == "It's fine") {
                llMessageLinked(LINK_ALL_CHILDREN, 203, "", "");
                if (gTurn == gTurnPreEndgame) {
                    state scoring;
                } else {
                    set_player(gTurn, 1, 1);
                }
            } else if (str == "Dispute") {
                llWhisper(0, "Dead groups disputed, resuming play.");
                gTurn = gTurnPreEndgame;
                set_player(gTurn, 0, 1);
                gGameState = gCurrentGame;
                llMessageLinked(LINK_ALL_CHILDREN, 15, "", "");
                state playing;
            }
        } else if (num == 999) {
            state default;
        }
    }
}

// Actually working out the final score. 

state scoring {
    state_entry() {
        llMessageLinked(LINK_SET, 105, "", "");
        llWhisper(0, "Calculating final scores. Please be patient ...\nWarning - large open areas on a large board can cause this to error due to lack of memory.");
        llSetText("Calculating final scores ...", <0, 0, 1>, 1.0);
        integer x;
        integer y;
        gSearchColour = 0;
        for (x = 0; x < gGameSize; x++) {
            for (y = 0; y < gGameSize; y++) {
                if (get_board_state(x, y) == 0) {
                    check_captures(x, y, -1, 3);
                }
            }
        }
        gBlackScore += gDeadWhite;
        gWhiteScore += gDeadBlack;
        llWhisper(0, "Final score, black: " + (string)gBlackScore + "  and white: " + (string)gWhiteScore);
        llSetText("Final score, black: " + (string)gBlackScore + "  and white: " + (string)gWhiteScore, <0, 0, 1>, 1.0);
        llMessageLinked(LINK_ROOT, 106, "", "");
    }
    
    link_message(integer sender, integer num, string str, key id) {
        if (num == 999) {
            state default;
        }
    }
}
