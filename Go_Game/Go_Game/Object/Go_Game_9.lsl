// :CATEGORY:Games
// :NAME:Go_Game
// :AUTHOR:Jonathan Shaftoe
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:357
// :NUM:488
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// And now for the GoGameMainScript, which does all the gluing together of all the other scripts, and handles players joining/leaving the game and the like.
// :CODE:
// GoGameMainScript
// Jonathan Shaftoe
// This is the main controlling script which sorts out rezzing all the objects and moving
// them around and sending messages to the other bits and pieces. It's big and it's messy.
// To use, create a single prim, drop into it a previously created GoButton, GoJoinButton,
// GoSensorGrid and GoTileGrid, then drop in the GoGaneLogicScript, then finally drop in this
// script. If you want the info button to give out a notecard, create one called Go Info and
// drop that into the inventory of the prim too (actually, it'll probably error if you don't
// do this, so.. )

// Channel used for listens, used for dialogs.
integer CHANNEL = 85483;
// Size of go board, 9, 13 or 19. This is just what it initialises to, can be changed
// during game setup
integer gGameSize = 9;

// Store the current listener, so we can remove it.
integer gListener;
// This is a general scaling multiplier, allowing you either to create a small dinky Go Board, or a
// large one. The maximum size that will work is 9.0, as beyond that linking of things fails. I've
// not experimented with the smallest workable size.
float SIZE = 3.0;

// Keys and names of the players playing each colour
key gBlackPlayer;
key gWhitePlayer;
string gBlackName;
string gWhiteName;
// Current player, whose turn it is.
key gPlayer;

// How many sensors we have, and the size of grid being used.
integer gXSensors;
integer gYSensors;

// Current scores
integer gBlackScore = 0;
integer gWhiteScore = 0;

// Used for counting rezzes, so we know when everything has been rezzedd
integer gCountRez;

// Whose turn it is, 0 is black, 1 is white.
integer gTurn = 0;

// How long since last turn (for reset)
string gLastTurnDate;
float gLastTurnTime;

// for the alpha part of coords, so we know what to call each square in messages. Note
// absence of I to avoid confusion with 1.
string COORDS = "ABCDEFGHJKLMNOPQRST";


set_player(integer turn, integer endgame, integer send_message) {
    vector colour;
    integer score = 0;
    string name;
    gTurn = turn;
    if (gTurn == 0) {
        gPlayer = gBlackPlayer;
        score = gBlackScore;
        colour = <0, 0, 0>;
        name = gBlackName;
    } else {
        gPlayer = gWhitePlayer;
        score = gWhiteScore;
        colour = <1, 1, 1>;
        name = gWhiteName;
    }
    llMessageLinked(LINK_ALL_CHILDREN, 0, "", gPlayer);
    if (endgame == 0) {
        llSetText(name + "'s turn (prisoners: " + (string)score + ").", colour, 1.0);
    } else if (endgame == 1) {
        llSetText(name + "'s turn to remove dead groups (prisoners: " + (string)score + ").", colour, 1.0);
        llInstantMessage(gPlayer, "Select opponent's dead groups then click done.");
    }
    if (send_message == 1) {
        llMessageLinked(LINK_ROOT, 103, (string)gTurn, (string)endgame);
    }
    gLastTurnDate = llGetDate();
    gLastTurnTime = llGetGMTclock();
}

set_size(integer size) {
    gGameSize = size;
    if (gGameSize == 9) {
        gXSensors = 3;
        gYSensors = 3;
        llSetTexture("a9878863-732f-09af-b908-09070ea9b213", 0);
    } else if (gGameSize == 13) {
        gXSensors = 4;
        gYSensors = 4;
        llSetTexture("a0973434-028b-3323-b572-8347095e6c3c", 0);
    } else if (gGameSize == 19) {
        gXSensors = 4;
        gYSensors = 5;
        llSetTexture("9575b5cf-72ec-14bf-e400-320f9008bbd9", 0);
    }
    llSetScale(<(gGameSize + 1.0) * SIZE / gGameSize, (gGameSize + 1.0) * SIZE / gGameSize, 0.01 * SIZE>);
    llMessageLinked(LINK_ALL_CHILDREN, 3, (string)gGameSize + "," + (string)gXSensors + "," + (string)gYSensors + "," + (string)SIZE, "");
    llMessageLinked(LINK_ROOT, 100, (string)gGameSize, (string)SIZE);
}

// State we start in, but don't stay in long. Need permission to link to do set-up.
default {
    state_entry() {
        llSetPrimitiveParams([
            PRIM_TYPE, PRIM_TYPE_BOX, PRIM_HOLE_DEFAULT, <0, 1, 0>, 0.0, 
                  ZERO_VECTOR, <1, 1, 0>, ZERO_VECTOR,
            PRIM_SIZE, <1 * SIZE, 1 * SIZE, 0.01 * SIZE>,
            PRIM_TEXTURE, ALL_SIDES, "5748decc-f629-461c-9a36-a35a221fe21f", <1, 1, 0>,  <0, 0, 0>, 0.0,
            PRIM_COLOR, ALL_SIDES, <0.8, 0.6, 0.5>, 1.0
        ]);
        llSetObjectName("Jonathan's Go Board");
        llSetObjectDesc("Jonathan's Go Board");
        llSitTarget(ZERO_VECTOR, ZERO_ROTATION);
        llRequestPermissions(llGetOwner(), PERMISSION_CHANGE_LINKS);
    }

    run_time_permissions(integer perms) {
        llBreakAllLinks();
        state initialising;
    }
}

// Initialisation state, rezzing all the buttons we need
state initialising {
    state_entry() {
        gCountRez = 7;
        llRezObject("GoButton", llGetPos() + <SIZE * (0.5 + 0.2), SIZE * .45, SIZE * .02>, ZERO_VECTOR, llGetRot(), 1);
        llRezObject("GoButton", llGetPos() + <SIZE * (0.5 + 0.2), SIZE * .25, SIZE * .02>, ZERO_VECTOR, llGetRot(), 2);
        llRezObject("GoButton", llGetPos() + <SIZE * (0.5 + 0.2), SIZE * -.25, SIZE * .02>, ZERO_VECTOR, llGetRot(), 4);
        llRezObject("GoButton", llGetPos() + <SIZE * (0.5 + 0.2), SIZE * -.45, SIZE * .02>, ZERO_VECTOR, llGetRot(), 3);
        llRezObject("GoButton", llGetPos() + <SIZE * (0.5 + 0.2), 0, SIZE * .02>, ZERO_VECTOR, llGetRot(), 5);
        llRezObject("GoJoinButton", llGetPos() + <0, SIZE * 0.5, 0.1 * SIZE>, ZERO_VECTOR, llGetRot(), 1);
        llRezObject("GoJoinButton", llGetPos() + <0, SIZE * -0.5, 0.1 * SIZE>, ZERO_VECTOR, llGetRot(), 2);
    }

    object_rez(key id) {
        llCreateLink(id, TRUE);
        gCountRez--;
        if (gCountRez == 0) {
            llMessageLinked(LINK_ALL_CHILDREN, 1, (string)SIZE, "");
            state setup_sensors;
        }
    }
}   

// Initialization state 2, seting up the sensor and tile grids.
state setup_sensors {
    state_entry() {
        gCountRez = 2;

        llRezObject("GoSensorGrid", llGetPos() + <0, 0, 0.005 * SIZE + .01>, ZERO_VECTOR, llGetRot(), 0);
        llRezObject("GoTileGrid", llGetPos() + <0, 0, 0.005 * SIZE + 0.1>, ZERO_VECTOR, llGetRot(), 0);
    }
    
    object_rez(key id) {
        llCreateLink(id, TRUE);
        gCountRez--;
        if (gCountRez == 0) {
            set_size(9);
            state awaiting_start;
        }
    }
}

// All initialised, waiting for players to join the game, plus can change game board size.

state awaiting_start {
    state_entry() {
        llSetTouchText("Game Size");
        llSetText("Go Game - awaiting players", <0, 0, 0>, 1.0);
    }

    state_exit() {
        llSetTimerEvent(0);
    }

    touch_start(integer num) {
        llDialog(llDetectedKey(0), "Set size of Go game board.\nCurrently set to: " + (string)gGameSize + "x" + (string)gGameSize, ["9x9", "13x13", "19x19"], CHANNEL);
        llListenRemove(gListener);
        gListener = llListen(CHANNEL, "", llDetectedKey(0), "");
        // Make sure we timeout the listen, in case they ignore the dialog
        llSetTimerEvent(60 * 2);  
    }

    listen(integer channel, string name, key id, string message) {
        if (message == "9x9") {
          set_size(9);
        } else if (message == "13x13") {
          set_size(13);
        } else if (message == "19x19") {
          set_size(19);
        }
        llWhisper(0, "Go board set to size: " + (string)gGameSize + "x" + (string)gGameSize); 
        llListenRemove(gListener);
        llSetTimerEvent(0);
    }

    timer() {
        llListenRemove(gListener);
        llSetTimerEvent(0);
    }
     
    link_message(integer sender, integer num, string str, key id) {
        if (num == 1) {
            gBlackPlayer = id;
            gBlackName = llKey2Name(id);
            llWhisper(0, gBlackName + " will play black.");
        } else if (num == 2) {
            gWhitePlayer = id;
            gWhiteName = llKey2Name(id);
            llWhisper(0, gWhiteName + " will play white.");
        } else if (num == 12) {
            llWhisper(0, llKey2Name(id) + " resets the Go board.");
            state resetting;
        } else if (num == 14) {
            llGiveInventory(id, "Go Info");
        }
        if (num == 1 || num == 2) {
            if (gBlackPlayer != "" && gWhitePlayer != "") {
                llWhisper(0, "Game started.");
                set_player(0, 0, 1);
                state playing;
            }
        }
    }
}

// Game has started, two players are playing.
state playing {
    state_entry() {
        llSetTouchText("Undo zoom");
    }
 
    touch_end(integer num) {
        if (llDetectedKey(0) == gPlayer) {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "", gPlayer);
        }
    }

    link_message(integer sender, integer num, string str, key id) {
        if (num == 101) {
            set_player((integer)str, (integer)((string)id), 0);
        } else if (num == 400) {
            integer turn = (integer)((string)id);
            integer score = (integer)str;
            if (turn == 0) {
                gBlackScore += score;
            } else {
                gWhiteScore += score;
            }
        } else if (num == 500) {
            integer x = (integer)str;
            integer y = (integer)((string)id);
            llPlaySound("a46a5924-5679-6483-233a-5b0b165ec477", 1.0);
            string player;
            if (gTurn == 0) {
                player = "Black";
            } else {
                player = "White";
            }
            string coord = llGetSubString(COORDS, x, x);
            llWhisper(0, player + " played at " + coord + ", " + (string)(y + 1));
        } else if (num == 102) {
            state endgame;
        } else if (num == 12) {
            string nowDate = llGetDate();
            float nowTime = llGetGMTclock();
            if (nowDate == gLastTurnDate && ((nowTime - gLastTurnTime) < 600)) {
                llInstantMessage(id, "You cannot reset the Go board, an active game is in progress. If you are playing and wanting to reset, resign first to end a game. If a game has been abandoned, then the board will be resettable if 10 minutes pass with no turn played.");
            } else {
                llDialog(id, "Are you sure you want to reset the board? The game in progress will be lost.", ["Reset", "Cancel"], CHANNEL);
                llListenRemove(gListener);
                gListener = llListen(CHANNEL, "", id, "");
                llSetTimerEvent(60 * 4);
            }
        } else if (num == 13) {
            if (id == gWhitePlayer || id == gBlackPlayer) {
                llDialog(id, "Are you sure you want to resign the game?", ["Resign", "Cancel"], CHANNEL);
                llListenRemove(gListener);
                gListener = llListen(CHANNEL, "", id, "");
                llSetTimerEvent(60 * 4);
            }
        } else if (num == 14) {
            llWhisper(0, "Game in progress between " + gBlackName + " (Black: current prisoners " + (string)gBlackScore + ") and " + gWhiteName + " (White, current prisoners: " + (string)gWhiteScore + ")");
            llGiveInventory(id, "Go Info");
        }
    }
    
    listen(integer channel, string name, key id, string message) {
        llListenRemove(gListener);
        llSetTimerEvent(0);
        if (message == "Resign") {
            string resignerName;
            string winnerName;
            if (id == gBlackPlayer) {
                resignerName = "Black";
                winnerName = "White";
            } else {
                resignerName = "White";
                winnerName = "Black";
            }
            llWhisper(0, resignerName + " has resigned. " + winnerName + " wins.");
            llSetText(resignerName + " resigns. " + winnerName + " wins.", <0, 0, 1>, 1.0);
            state gameover;
        } else if (message == "Reset") {
            llWhisper(0, name + " resets the Go board.");
            state resetting;
        }
    }
    
    timer() {
        llListenRemove(gListener);
        llSetTimerEvent(0);
    }
    
    state_exit() {
        llSetTimerEvent(0);
    }
}

// Two passes have occured, we're in endgame, players must mark oppositions dead groups (and then
// agree with what their opponent has marked as dead )

state endgame {
    state_entry() {
    }

    link_message(integer sender, integer num, string str, key id) {
        if (num == 11) {
            set_player(1 - gTurn, 2, 1);
            llDialog(gPlayer, "Are you happy with the groups your opponent has marked as dead?\nIf you dispute, play will resume.", ["It's fine", "Dispute"], CHANNEL);
            llListenRemove(gListener);
            gListener = llListen(CHANNEL, "", gPlayer, "");
            // Make sure we timeout the listen, in case they ignore the dialog
            llSetTimerEvent(60 * 4);  
        } else if (num == 105) {
            state scoring;
        } else if (num == 101) {
            set_player((integer)str, (integer)((string)id), 0);
        } else if (num == 12) {
            string nowDate = llGetDate();
            float nowTime = llGetGMTclock();
            if (nowDate == gLastTurnDate && ((nowTime - gLastTurnTime) < 600)) {
                llInstantMessage(id, "You cannot reset the Go board, an active game is in progress. If you are playing and wanting to reset, resign first to end a game. If a game has been abandoned, then the board will be resettable if 10 minutes pass with no turn played.");
            } else {
                llDialog(id, "Are you sure you want to reset the board? The game in progress will be lost.", ["Reset", "Cancel"], CHANNEL);
                llListenRemove(gListener);
                gListener = llListen(CHANNEL, "", id, "");
                llSetTimerEvent(60 * 4);
            }
        } else if (num == 14) {
            llWhisper(0, "Game in progress between " + gBlackName + " (Black: current prisoners " + (string)gBlackScore + ") and " + gWhiteName + " (White, current prisoners: " + (string)gWhiteScore + ") - players in endgame");
            llGiveInventory(id, "Go Info");
        }
    }

    listen(integer channel, string name, key id, string message) {
        llListenRemove(gListener);
        llSetTimerEvent(0);
        llMessageLinked(LINK_ROOT, 104, message, "");
        if (message == "Dispute") {
            state playing;
        } else if (message == "Reset") {
            llWhisper(0, name + " resets the Go board.");
            state resetting;
        }
    }
    
    touch_end(integer num) {
        if (llDetectedKey(0) == gPlayer) {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "", gPlayer);
        }
    }
    
    timer() {
        llListenRemove(gListener);
        llSetTimerEvent(0);
    }
    
    state_exit() {
        llSetTimerEvent(0);
    }
}

// End game finished, waiting for GoGameLogic to work out final score.
state scoring {
    state_entry() {
    }

    link_message(integer sender, integer num, string str, key id) {
        if (num == 106) {
            state gameover;
        } else if (num == 14) {
            llWhisper(0, "Game in progress between " + gBlackName + " (Black: current prisoners " + (string)gBlackScore + ") and " + gWhiteName + " (White, current prisoners: " + (string)gWhiteScore + ") - game scoring.");
            llGiveInventory(id, "Go Info");
        }
    }
}

// Game finished and final score displayed
state gameover {
    state_entry() {
    }
    link_message(integer sender, integer num, string str, key id) {
        if (num == 12) {
            state resetting;
        } else if (num == 14) {
            llGiveInventory(id, "Go Info");
        }    
    }
}

// Reset board ready to start new game.
state resetting {
    state_entry() {
        llMessageLinked(LINK_SET, 999, "", "");
        set_size(gGameSize);
        gBlackPlayer = "";
        gWhitePlayer = "";
        gBlackScore = 0;
        gWhiteScore = 0;
        state awaiting_start;
    }
}
