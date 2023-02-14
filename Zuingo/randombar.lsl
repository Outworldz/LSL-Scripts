list lSides = [3, 7, 4, 6, 1];
list lOffsets = [
        <-0.375, 0.45, 0.0>,
        <-0.450, 0.45, 0.0>,
        <-1.112, 0.45, 0.0>,
        <-0.457, 0.45, 0.0>,
        <-0.530, 0.45, 0.0>
        ];

list lNumbers = [];

integer totalRounds;
integer roundTime;
integer currentRound;
integer gameEnd = FALSE;

integer bChanging = FALSE;

key player;


ssSetSides() {
    bChanging = TRUE;
    ssReset();
    integer n = 0;
    while(n < 5) {
        integer random = (integer)llFrand(18);
        float x; float y;
        vector offset = (vector)llList2String(lOffsets, n);
        
        if (random < 17) {
            if (random < 15) { //numbers
                random += n * 15;
            } else { //if (random >= 15) -> joker
                random = 76;
            }
            x = (random % 10) / 10.0 + offset.x;
            y = offset.y - (random / 10) / 10.0;
            if (x < -1.0) x += 1.0;
            llOffsetTexture(x, y, llList2Integer(lSides, n));
        } else { //pharao/mummy
            integer rand = (integer)llFrand(10) + 4;
            integer status = 0;
            integer j = 0;
            
            if (rand % 2 == 0) rand = (integer)llFrand(10) + 4;
            
            while (j < rand) {
                status = !status;
                random = 77 + status;
                x = (random % 10) / 10.0 + offset.x;
                y = offset.y - (random / 10) / 10.0;
                if (x < -1.0) x += 1.0;
                llOffsetTexture(x, y, llList2Integer(lSides, n));
                ++j;
            }
            llSetColor(<0.25, 0.25, 0.25>, llList2Integer(lSides, n));
            if (random == 77) {
                llMessageLinked(LINK_ALL_OTHERS, -1, "mummy", NULL_KEY);
            } else {
                llMessageLinked(LINK_ALL_OTHERS, -1, "pharao", NULL_KEY);
            }
        }
        lNumbers += (string)random;
        ++n;
    }
    bChanging = FALSE;
}

ssReset() {
    lNumbers = [];
    llSetColor(<1.0, 1.0, 1.0>, ALL_SIDES);
    llOffsetTexture(-0.375, 0.650, 3);
    llOffsetTexture(-0.350, 0.650, 7);
    llOffsetTexture(-0.912, 0.650, 4);
    llOffsetTexture(-0.157, 0.650, 6);
    llOffsetTexture(-0.130, 0.650, 1);
}

default {
    on_rez(integer p) {
        llResetScript();
    }
    state_entry() {
        llMessageLinked(LINK_SET, -1, "gameOver", NULL_KEY);
        llSetText("", <1,1,1>, 0.0);
        ssReset();
    }
    link_message(integer sender, integer num, string msg, key id) {
        list data = llParseString2List(msg, (list)"~~", []);
        string cmd = llList2String(data, 0);
        string value = llList2String(data, 1);
        integer find;
        if (num == -1 && msg == "setTexture") llSetTexture(id, ALL_SIDES);
        if (cmd == "fieldTouched") {
            if ((find = llListFindList(lNumbers, (list)value)) != -1
                || llList2Integer(lNumbers, (integer)value / 15) == 76) {
                llMessageLinked(LINK_ALL_OTHERS, num, "useNumber", NULL_KEY);
                llSetColor(<0.25, 0.25, 0.25>, llList2Integer(lSides, (integer)value / 15));
                lNumbers = [] + llListReplaceList(lNumbers, (list)"-1", (integer)value / 15, (integer)value / 15);
            }
        } else if (num == -1 && msg == "startGame") {
            gameEnd = FALSE;
            player = id;
            currentRound = 0;
            llSetTimerEvent(0.1);
        } else if (msg == "totalRounds") {
            totalRounds = num;
        } else if (msg == "roundTime") {
            roundTime = num;
        } else if (msg == "stopGame") {
            gameEnd = TRUE;
            llSetTimerEvent(0.0);
            llMessageLinked(LINK_ALL_OTHERS, 20, "currentround", NULL_KEY);
            //llSetText("Game Over!\nTouch to Select Price Menu!", <1.0, 1.0, 1.0>, 1.0);
            llMessageLinked(LINK_SET, -1, "gameOver", NULL_KEY);
            ssReset();
        }
    }
    touch_start(integer n) {  // When Random Bar (Next Round Button) is Touched
        if (bChanging) return; // If it is currently changing, return and wait till it changes
        if (llDetectedKey(0) == player) { // If the playing user clicks the bar
            llSetTimerEvent(0.0); // Clear Round Timer
            if (++currentRound <= totalRounds) { // If we are still not at round end
                llMessageLinked(LINK_ALL_OTHERS, currentRound, "currentround", NULL_KEY);
                //llSetText("Round " + (string)currentRound + " of " + (string)totalRounds, <1.0, 1.0, 1.0>, 1.0);
                ssSetSides();
                llSetTimerEvent(roundTime); // Re-Instantiate Round Timer
            } else { // Else If we are done all rounds.
                llSetText("", <1.0, 1.0, 1.0>, 1.0);
                gameEnd = TRUE;
                llMessageLinked(LINK_SET, -1, "gameOver", NULL_KEY); //Send gameOver Message
                ssReset();
            }
        }
    }
    
    timer() {
        llSetTimerEvent(0.0);
        if (++currentRound <= totalRounds) {
            llMessageLinked(LINK_ALL_OTHERS, currentRound, "currentround", NULL_KEY);
            //llSetText("Round " + (string)currentRound + " of " + (string)totalRounds, <1.0, 1.0, 1.0>, 1.0);
            ssSetSides();
            llSetTimerEvent(roundTime);
        } else {
            gameEnd = TRUE;
            llMessageLinked(LINK_SET, -1, "gameOver", NULL_KEY);
            ssReset();
        }
    }
}