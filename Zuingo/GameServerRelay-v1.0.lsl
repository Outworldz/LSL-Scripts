float requestTime = 60.0;

list values;
list names;
list scores;
list prizes;
list rounds;
list multipliers;

integer status;

// Key of Game Server
key GameServer = "5b8c8de4-e142-4905-a28f-d4d00607d3e9"; // UUID of Game Server Prim in Server Cabinet
key GameDBServer = "b9dbc6a4-2ac3-4313-9a7f-7bd1e11edf78"; // UUID of Game Database Server in Cabinet
key GameEventDBServer = "dbfa0843-7f7f-4ced-83f6-33223ae57639"; // UUID of Game Event Logger Database Server
key SecurityKey = "3d7b1a28-f547-4d10-8924-7a2b771739f4"; // Security Key for Secure Communication. Currently my UUID
integer ServerComChannel = -13546788; // Game Server Communication Channel
integer EventDBServerComChannel = -260046; // Game Event Database Server Communication Channel
integer ComHandle;
string EMPTY = "";
string RequestFlag = "";
string NextPot = "";
integer DebugMode = FALSE;
integer Playing = FALSE;
integer bGame = TRUE;
string AskForKeys = "TheKeyIs(Mq=h/c2)";
string DiagMode;

default {
    state_entry() {
        llSleep(10.0);
        llSetText("Relay Loading...", <1,1,1>, 1.0);
        llListenRemove(ComHandle);
        llSleep(0.1);
        ComHandle = llListen(ServerComChannel, EMPTY, EMPTY, EMPTY);
        requestTime = 300.0 - llFrand(200.00); // How often does the Server Relay Call GS for Updates
        if(DebugMode){
            llOwnerSay("Request Time: "+(string)requestTime);
        }
        llSleep(1.0);
        llRegionSay(ServerComChannel, AskForKeys);
    }
    timer() {
        llSetTimerEvent(requestTime);
        ComHandle = llListen(ServerComChannel, EMPTY, EMPTY, EMPTY);
        if (status = !status) {
                // Get HighScores from Server
            RequestFlag = "HighScores";
            if(DebugMode){
                llOwnerSay("Requesting High Scores...");
            }
            llRegionSayTo(GameServer, ServerComChannel, "GetHighScores");
        } else {
            RequestFlag = "PotTimer";
            if(DebugMode){
                llOwnerSay("Requesting JackPot Timer...");
            }
            llRegionSayTo(GameServer, ServerComChannel, "GetPotTimeOut");
        }
    }
    
    run_time_permissions(integer p) {
        if (p & PERMISSION_DEBIT){
           llSetTimerEvent(0.01);
        }else{
            llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        }
    }
    
    listen(integer chan, string sender, key id, string msg){ // Listen for REsponses from REquests to Server for HighScores and Pot Timeouts
        list Inputs = llParseString2List(msg, "||", "");
        if(llList2Key(Inputs, 0)!=SecurityKey && llList2Key(Inputs, 0)!=AskForKeys){ // If Security Key was Not Included as For Key in String Return
            list SendList = [SecurityKey, "INSERT", id, "Un-Authorized Access Attempt!", "Machine ID: "+llGetObjectDesc(), msg];
            string SendString = llDumpList2String(SendList, "||");
            llRegionSayTo(GameEventDBServer, EventDBServerComChannel, SendString);
            if(DebugMode){
                llOwnerSay("Security Invalid for Listen Event!");
            }
            llListenRemove(ComHandle);
            return;
        }else if(llList2Key(Inputs, 0)==AskForKeys){
            return;
        }
        if(llList2String(llParseString2List(msg, "||", ""), 1)==AskForKeys){
            list NewKeys = llParseString2List(msg, "||", "");
            GameServer = llList2Key(NewKeys, 2);
            GameDBServer = llList2Key(NewKeys, 3);
            GameEventDBServer = llList2Key(NewKeys, 4);
            DiagMode = llList2String(NewKeys, 17);
            if(DebugMode){
                llOwnerSay("Server Key Update Complete!");
            }
            llListenRemove(ComHandle);
            llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
            return;
        }
        if(chan==ServerComChannel){ // Coming in on Current Channel
            if(RequestFlag=="HighScores"){ // If REquest we are expecting is HighScores
                RequestFlag = "";
                scores = [] + llList2List(Inputs, 1, 10);
                values = [] + llList2List(Inputs, 11, 20);
                prizes = [] + llList2List(Inputs, 21, 30);
                multipliers = [] + llList2List(Inputs, 31, 40);
                if(!Playing && bGame){
                    llSetText("Game Ready!\nClick MENU to select Price!", <1.0,1.0,1.0>, 1.0);
                }
                if(DebugMode){
                    llOwnerSay("High Scores Obtained!");
                }
                llListenRemove(ComHandle);
            }else if(RequestFlag=="PotTimer"){
                RequestFlag = "";
                if(DebugMode){
                    llOwnerSay("Pot Timer Obtained!");
                }
                NextPot = llList2String(llParseString2List(msg, "||", []), 1); // Set Next Time in IOT that Pot will be given out.
                llListenRemove(ComHandle);
            }
        }
    }
    
        // Receive and Process Link Messages
    link_message(integer sender, integer num, string message, key id) {
        if(message=="stopGame"){
            bGame = FALSE;
            llSetTimerEvent(0);
            return;
        }else if(message=="OFF"){
            bGame = FALSE;
            llSetTimerEvent(0);
            return;
        }
        if(message=="debugON"){
            DebugMode = TRUE;
            llOwnerSay("Debug Mode: TRUE");
        }else if(message=="debugOFF"){
            DebugMode = FALSE;
            llOwnerSay("Debug Mode: FALSE");
        }
        if (message == "gameValue") { // Received Notification of New Game Value (FreePlay or L$ 5 E.T.C)
            string value = llStringTrim((string)id, STRING_TRIM); // Trim String
            integer found = llListFindList(values, (list)value); // Check if it exists in Values List of Possible Game Costs
            if(value=="FreePlay"){
                found = 0;
            }
            if (found == -1) return; // If not found return (No Further Processing)
                // There is as List Index Association between Scores List and Values List  Both obtaind during HTTP Response in this Script Line 50
                // Send Link Message to SetScoreAndPot (Including the Values for Score to Beat and Pot
            Playing = TRUE;
            if(DebugMode){
                llOwnerSay("Setting Pot and Score to Beat!");
            }
            llMessageLinked(LINK_ALL_OTHERS, -1 * llList2Integer(scores, found), "setScoreAndPot", (key)llList2String(prizes, found));
            return;
        }
        list data           = llParseString2List(message, (list)"||", []);
        string cmd          = llList2String(data, 0);
        string value1       = llList2String(data, 1);
        string highscore    = llList2String(data, 2);
        float multiplier  = llList2Float(multipliers, llListFindList(values, (list)value1));
        string playerName   = llKey2Name(id);
        string playerKey    = (string)id;
        if (cmd == "gameReview") { // Game is Over we are reviewing if the person won
            Playing = FALSE;
            integer find = llListFindList(values, (list)value1); // Find Index of Game Value (Sent for review) in list of Valid Game Values
            if (find != -1) { // If We are reviewing a valid game value type
                if ((integer)highscore > llList2Integer(scores, find)) { // If user has beaten the HighScore for the current gameValue
                    integer MoneyPaid = (integer)llGetSubString(value1, 2, -1);
                    integer MoneyWon = llRound((float)MoneyPaid * multiplier);
                    llSay(0, "You Won!\nYou Paid: "+value1+"\nGame Multiplier: "+(string)multiplier+"\nYou Won: P$"+MoneyWon+"\nYou Have gained an entry in the JackPot\nThe Jackpot will payout in approx "+NextPot+" minutes");
                    if(DiagMode=="FALSE" || DiagMode==""){ // If we are not in Diagnostic Mode, Allow PayOut
                        llGiveMoney(playerKey, MoneyWon);
                    }else{ // If We are in Diag Mode, Print Message to Player
                        llRegionSayTo(playerKey, 0, "Diag Mode Active. Nothing Paid Out!");
                    }
                    // Log in Event Server and Update Their Entry in User Database
                    list SendList = [] + SecurityKey + ["UPDATE"] + [playerKey, "", "1", MoneyWon, MoneyPaid, "1", "0" ];
                    string SendString = llDumpList2String(SendList, "||");
                    llRegionSayTo(GameDBServer, EventDBServerComChannel, SendString);
                }else{
                    integer MoneyPaid = (integer)llGetSubString(value1, 2, -1);
                    llSay(0, "Game Over!!, Better Luck Next Time!\n You have gained an entry in the JackPot!\nThe Jackpot will payout in approx "+NextPot+" minutes");
                    // Log in Event Server and Update Their Entry in User Database
                    list SendList = [] + SecurityKey + ["UPDATE"] + [playerKey, "", "1", "0", MoneyPaid, "0", "1" ];
                    string SendString = llDumpList2String(SendList, "||");
                    llRegionSayTo(GameDBServer, EventDBServerComChannel, SendString);
                }
            }
        }
    }
}
