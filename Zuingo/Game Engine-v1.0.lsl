// Number Grid Texture UUID
key texture = "fa16bd77-af56-4149-b9d4-75f6ceda8448";

key creatorKey;

float PotPercentage   = 0.10;
float creatorPercentage = 0.01;
list lPay   = ["P$5", "P$10", "P$25", "P$50", "P$75", "P$100", "P$250", "P$500", "P$750", "P$1000"];
vector lineColor = <1.0, 0.0, 0.0>;

list lMummy = [0.20, 0.30, 0.40, 0.50];
integer TotalNumbers = 25;

integer totalRounds = 5;
integer roundTime   = 25;

integer pointsSingleField   =   200;
integer pointsLine          =  1000;
integer pointsBlues         =  5000;
integer pointsAll           = 10000;
integer pointsCash          =  1000;
integer pointsPharao        =  1000;

integer EMPTY   =  1;
integer FILLED  =  2;
integer CASH    =  4;
integer DOUBLE  =  8;
integer BLUE    = 16;

//string cmdFloatText     = "FloatText";
string cmdConfig        = "Admin";

string cmdFloatOn       = "Float ON";
string cmdFloatOff      = "Float OFF";
string cmdTimeOn        = "Time ON";
string cmdCurrentOn     = "Current ON";
string cmdCurrentOff    = "Current OFF";
string cmdTimeOff       = "Time OFF";
string cmdPrevOn        = "Prev ON";
string cmdPrevOff       = "Prev OFF";

string cmdFreeYes       = "Free YES";
string cmdFreeNo        = "Free NO";
string cmdFreeOnly      = "Free Only";
string cmdOn            = "ON";
string cmdOff           = "OFF";
string cmdDebug         = "Debug Toggle";
//string cmdStatistics    = "Statistics";
string cmdResetStats    = "Reset Machine";

string cmdFreePlay      = "FreePlay";
string cmdNote          = "Help";

list lNumbers;
list lFields;
integer iBlues;

integer bCheckAll;
integer bCheckBlues;
integer iPoints = 0;
integer bCash = TRUE;
integer bDouble = FALSE;
integer bGame = TRUE;

integer freePlay = 0;

integer dialogChannel;
integer playing = FALSE;
key player;

string gameValueName;

key GameServer = "f77c9eb4-4d0a-48a3-8157-613b9f8342a7"; // UUID of Game Server  Prim in Server Cabinet
key SecurityKey = "3d7b1a28-f547-4d10-8924-7a2b771739f4"; // Security Key for Secure Communication. Currently my UUID
key GameEventDBServer = "508e0211-5cfe-4bda-acbe-8576b02dc00e"; // UUID of Game Event Logger Database Server
key GameDBServer = "5d9b8231-ed73-4aa5-b3c8-a7b0a88b1aa6"; // UUID of Game Database Server in Server Cabinet
integer ServerComChannel = -63473672; // Game Server Communication Channel
integer EventDBServerComChannel = -260002; // Game Event Database Server Communication Channel
integer ServerComHandle;
list RoundLengthList = [];
integer DebugMode = FALSE;
string AskForKeys = "TheKeyIs(Mq=h/c2)";
list AdminMenuUsers = [];
string DiagMode;

list ssCreateMenu(string menu) {
    if (menu == "main")         return [cmdConfig];
    //if (menu == cmdFloatText)   return [cmdFloatOn, cmdFloatOff, cmdTimeOn, cmdCurrentOn, cmdCurrentOff, cmdTimeOff, cmdPrevOn, cmdPrevOff];
    if (menu == cmdConfig)      return [cmdFreeYes, cmdFreeNo, cmdFreeOnly, cmdOff, cmdDebug, cmdResetStats];
    if (menu == "pay") {
        if (freePlay == 0)      return order_buttons(lPay + [cmdNote]);
        if (freePlay == 1)      return order_buttons([cmdFreePlay] + lPay + [cmdNote]);
        if (freePlay == 2)      return [cmdFreePlay, cmdNote];
    }
    return [];
}
list order_buttons(list buttons) { //From the wiki By Redux
    integer offset;
    list fixt;
    while((offset = llGetListLength(buttons))) {
        offset = -3 * (offset > 3);
        fixt = fixt + llList2List(buttons, offset, -1);
//      fixt += llList2List(buttons, offset = -3 * (offset > 3), -1);
        buttons = llDeleteSubList(buttons, offset, -1);
    }
    return fixt;
}
integer ssRandomChannel() {
    integer n = llRound(llFrand(-1 * (DEBUG_CHANNEL - 1)));
    if (n > -1000)
        return ssRandomChannel();
    else
        return n;
}

ssGenerateNumbers() {
    bDouble = FALSE;
    llMessageLinked(LINK_ALL_OTHERS, totalRounds, "totalRounds", NULL_KEY);
    llSleep(0.1);
    llMessageLinked(LINK_ALL_OTHERS, roundTime, "roundTime", NULL_KEY);
    bCheckBlues = bCheckAll = TRUE;
    iPoints = 0;
    integer num;
    lNumbers = lFields = [];
    integer blue = 1;
    
    integer double;
    integer cash;
    
    // find 2x
    double = (integer)llFrand(TotalNumbers);
    
    if (bCash = !bCash) { // find cash
        do {
            cash = (integer)llFrand(TotalNumbers);
        } while (cash == double);
    }
    
    
    while (num < 25) {
        integer fieldValue = EMPTY;
        vector offset = ZERO_VECTOR;
        integer random;
        integer isBlue = FALSE;
        
        integer extra = (num / 5) * 15;
        
        if (iBlues & blue) {
            fieldValue = fieldValue + BLUE;
            isBlue = TRUE;
        }
        blue = blue << 1;
        
        do {
            random = extra + (integer)llFrand(DEBUG_CHANNEL) % 15;
        } while (llListFindList(lNumbers, (list)random) != -1);
        
        lNumbers = lNumbers + random;
        
        llMessageLinked(
                LINK_ALL_OTHERS
                , num
                , llDumpList2String(["startGame", (string)random, (string)isBlue], "~~")
                , player
            );
            
        if (num == double)  fieldValue += DOUBLE;
        if (bCash && num == cash)    fieldValue += CASH;
        
        lFields += fieldValue;

        ++num;
    }
    llMessageLinked(LINK_ALL_OTHERS, -1, "startGame", player);
}


integer ssCheckLines(integer num) {
    integer i;
    integer points = 0;
    integer n = 0;
    list lined = [];
    string say;
    
    //Horizontal check
    while (n < 5) {
        i = (num % 5) + n * 5;
        if (llList2Integer(lFields, i) & EMPTY) jump away1;
        ++n;
    }
    n = -1;
    while(++n < 5) {
        integer x = ((num % 5) + n * 5);
        if (llListFindList(lined, (list)x) == -1) lined += x;
    }
    points = points + pointsLine;
    @away1;
    
    //Vertical check
    n = 0;
    while (n < 5) {
        i = (num / 5) * 5 + n;
        if (llList2Integer(lFields, i) & EMPTY) jump away2;
        ++n;
    }
    n = -1;
    while(++n < 5) {
        integer x = ((num / 5) * 5 + n);
        if (llListFindList(lined, (list)x) == -1) lined += x;
    }
    points = points + pointsLine;
    @away2;
    
    //Diagonal -> \
    n = 0;
    if (num % 6 == 0) {
        while (n < 5) {
            i = 6 * n;
            if (llList2Integer(lFields, i) & EMPTY) jump away3;
            ++n;
        }
        n = -1;
        while(++n < 5) {
            integer x = (6 * n);
            if (llListFindList(lined, (list)x) == -1) lined += x;
        }
        points = points + pointsLine;
    }
    @away3;

    //Diagonal -> /
    n = 0;
    if (num && num % 4 == 0 && num < 24) {
        while (n < 5) {
            ++n;
            i = 4 * n;
            if (llList2Integer(lFields, i) & EMPTY) jump away4;
        }
        n = -1;
        while(++n < 5) {
            integer x = (4 * n + 4);
            if (llListFindList(lined, (list)x) == -1) lined += x;
        }
        points = points + pointsLine;
    }
    @away4;
    
    //check blue fields
    n = 0;
    if (bCheckBlues) {
        while(n < 25) {
            integer test = llList2Integer(lFields, n);
            if ((test & BLUE) && (test & EMPTY)) jump away5;
            ++n;
        }
        bCheckBlues = FALSE;
        points = points + pointsBlues;
        say = "Hurray! You filled the pattern! "  + (string)pointsBlues + " extra points!";
        if (bDouble) say = "Hurray! You filled the pattern! "  + (string)(pointsBlues * 2) + " extra points!";
        llWhisper(0, say);
    }
    @away5;
    
    //check if all numbers are filled
    n = 0;
    if (bCheckAll) {
        while(n < 25) {
            if (llList2Integer(lFields, n) & EMPTY) jump away6;
            ++n;
        }
        bCheckAll = FALSE;
        points = points + pointsAll;
        say = "Hurray! You found all numbers! " + (string)pointsAll + " extra points!";
        if (bDouble) say = "Hurray! You found all numbers! " +(string)(pointsAll * 2) + " extra points!";
        llWhisper(0, say);
        llMessageLinked(LINK_THIS, 0, "gameOver", "");
    }
    @away6;
    
    integer total = lined != [];
    n = -1;
    while(++n < total)
        llMessageLinked(LINK_SET, llList2Integer(lined, n), "line", (string)lineColor);
    return points;
}


default {
    state_entry() {
        creatorKey = llGetCreator();
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        llListenRemove(ServerComHandle);
        ServerComHandle = llListen(ServerComChannel, "", "", "");
        if(DebugMode){
            llOwnerSay("Booted Main Script");
        }
        //llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }
    
    run_time_permissions(integer perm){
        if(PERMISSION_DEBIT & perm){
            llRegionSay(ServerComChannel, AskForKeys);
        }
    }
    
    listen(integer chan, string name, key id, string msg){
        if(DebugMode){
            llOwnerSay("Listen Msg: "+msg);
        }
        if(llList2String(llParseString2List(msg, "||", ""), 1)==AskForKeys){
            list NewKeys = llParseString2List(msg, "||", "");
            if(llList2String(NewKeys, 0)!=SecurityKey){
                if(DebugMode){
                    llOwnerSay("Invalid Security Key Received during SERVER Key Update!");
                }
                return;
            }
            // UUIDS of Game Servers
            GameServer = llList2Key(NewKeys, 2);
            GameDBServer = llList2Key(NewKeys, 3);
            GameEventDBServer = llList2Key(NewKeys, 4);
            // Game Configuration Directives
            lMummy = llList2List(NewKeys, 5, 8);
            roundTime   = llList2Integer(NewKeys, 9);
            pointsSingleField   = llList2Integer(NewKeys, 10);
            pointsLine          = llList2Integer(NewKeys, 11);
            pointsBlues         = llList2Integer(NewKeys, 12);
            pointsAll           = llList2Integer(NewKeys, 13);
            pointsCash          = llList2Integer(NewKeys, 14);
            pointsPharao        = llList2Integer(NewKeys, 15);
            PotPercentage       = llList2Float(NewKeys, 16) / 100;
            DiagMode            = llList2String(NewKeys, 17);
            if(
                llGetListLength(lMummy)>0 &&
                roundTime>0 &&
                pointsSingleField>0 &&
                pointsLine>0 &&
                pointsBlues>0 &&
                pointsAll>0 &&
                pointsCash>0 &&
                pointsPharao>0 &&
                PotPercentage>0
            ){
                llOwnerSay("Game Configured!");
                if(DiagMode=="TRUE"){
                    llOwnerSay("Diagnostic Mode Active!");
                }
            }else{
                llOwnerSay("Game Configureation ERROR!");
            }
            integer i;
            list TempList = llList2List(NewKeys, 24, -1);
            if(DebugMode){
                llOwnerSay("Loading Admin Menu Users...");
            }
            for(i=0;i<llGetListLength(TempList);i++){ // For all Keys in string beyond 4 include as Authd Users
                integer SpaceIndex = llSubStringIndex(llList2String(TempList, i), " ");
                string FName = llGetSubString(llList2String(TempList, i), 0, SpaceIndex-1);
                string LName = llGetSubString(llList2String(TempList, i), SpaceIndex+1, -1);
                key theirkey = osAvatarName2Key(FName, LName);
                AdminMenuUsers = AdminMenuUsers + [theirkey];
                if(DebugMode){
                    llOwnerSay("\nFirst Name: "+FName+"\nLast Name: "+LName+"\nTheir Key: "+theirkey);
                }
            }
            if(DebugMode){
                llOwnerSay("Server Key Update Complete!\rGame Server: "+(string)GameServer+"\rGameDBServer: "+(string)GameDBServer+"\rGameEventDBServer: "+(string)GameEventDBServer);
            }
            llRegionSayTo(GameServer, ServerComChannel, "GetRoundLengths");
            return;
        }else if(llList2String(llParseString2List(msg, "||", ""), 0)==AskForKeys){
            return;
        }
        list Inputs = llParseString2List(msg, "||", "");
        if(llList2Key(Inputs, 0)!=SecurityKey){
            list SendList = [SecurityKey, "INSERT", id, "Un-Authorized Access Attempt!", "Machine ID: "+llGetObjectDesc(), msg];
            string SendString = llDumpList2String(SendList, "||");
            llRegionSayTo(GameEventDBServer, EventDBServerComChannel, SendString);
            return;
        }
        if(llList2Integer(Inputs, 1)<50){
            llSetText("Configured!\n Waiting for Stats...", <1.0,1.0,1.0>, 1.0);
            RoundLengthList = [] + [llList2Integer(Inputs, 1),  llList2Integer(Inputs, 2),  llList2Integer(Inputs, 3),  llList2Integer(Inputs, 4),  llList2Integer(Inputs, 5),  llList2Integer(Inputs, 6),  llList2Integer(Inputs, 7),  llList2Integer(Inputs, 8),  llList2Integer(Inputs, 9),  llList2Integer(Inputs, 10)];
            state Ready;
        }
    }
    
    state_exit(){ 
        llListenRemove(ServerComHandle);
    }
}

state Ready {
    state_entry() {
        llOwnerSay("State Ready");
        //llSetText("", <1,1,1>, 0.0);
        llSetClickAction(CLICK_ACTION_TOUCH);
        llMessageLinked(LINK_SET, -1, "setTexture", texture);
        dialogChannel = ssRandomChannel();
        llListen(dialogChannel, "", NULL_KEY, "");
        llSetPayPrice(PAY_HIDE, [PAY_HIDE, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
    }

    touch_start(integer n) {
        if (!playing) {
            key id = llDetectedKey(0);
            // Calls User Menu to Select Game Cost 
            if (bGame) llDialog(id, "Game price:", ssCreateMenu("pay"), dialogChannel);
            // Calls Admin Menu
            if (llListFindList(AdminMenuUsers, [id])!=-1) {
                llSleep(2.0);
                llDialog(id, "Admin menu:", ssCreateMenu("main"), dialogChannel);
            }
        }
    }
    
    listen(integer channel, string name, key id, string message) {
        if (channel == dialogChannel) { // Listen for Dialog Response
            if (id == llGetOwner()) { // If Owner is using Menu
                if (message == cmdConfig)       {llDialog(id, "Config menu:", ssCreateMenu(message), dialogChannel); return;} // Show Config Menu
                //if (message == cmdFloatText)    {llDialog(id, "Floating Text menu:", ssCreateMenu(message), dialogChannel); return;} // Show FloatText Menu
                
                if (message == cmdFreeNo) { // Disables Free Play Option
                    freePlay = 0;
                    llOwnerSay("FreePlay disabled.");
                    return;
                }
                if (message == cmdFreeYes) { // Enables Free Play Option
                    freePlay = 1;
                    llOwnerSay("FreePlay enabled."); 
                    return;
                }
                if (message == cmdFreeOnly) { // Makes game ONLY Free to Play
                    freePlay = 2;
                    llOwnerSay("FreePlay only.");
                    return;
                }
                if (message == cmdOn) { // Turns System On
                    bGame = TRUE;
                    llSetText("Game Ready!\nClick MENU to select Price!", <1.0, 1.0, 1.0>, 1.0);
                    return;
                }
                if (message == cmdOff) { // Turns System Off
                    bGame = FALSE;
                    llSetText("Game Offline!", <1.0, 0,0>, 1.0);
                    llMessageLinked(LINK_SET, -1, "stopGame", NULL_KEY);
                    return;
                }
                if(message == cmdDebug) {
                    if(DebugMode){
                        DebugMode = FALSE;
                        llMessageLinked(LINK_THIS, -34, "debugOFF", NULL_KEY);
                    }else{
                        DebugMode = TRUE;
                        llMessageLinked(LINK_THIS, -34, "debugON", NULL_KEY);
                    }
                        
                }
                if(message==cmdResetStats){
                    bGame = FALSE;
                    if(DebugMode){
                        llOwnerSay("Rebooting Machine...");
                    }
                    llMessageLinked(LINK_SET, -420, "stopGame", NULL_KEY);
                    llSleep(1.0);
                    llMessageLinked(LINK_SET, -420, "Reboot", NULL_KEY);
                    string ScriptName = llGetScriptName(); // Get Current Script
                    integer ScriptTotal = llGetInventoryNumber(INVENTORY_SCRIPT); // Get Total Number of Scripts in Inventory
                    integer i;
                    for(i=0;i<ScriptTotal;i++){
                        if(llGetInventoryName(INVENTORY_SCRIPT, i)!=ScriptName){
                            llResetOtherScript(llGetInventoryName(INVENTORY_SCRIPT, i));
                        }
                    }
                    llResetScript();
                }
            }
// GAME START POINT!!!!
            if (!playing) { // If No Game is in Session
                if (message == cmdNote)         {llGiveInventory(id, llGetInventoryName(INVENTORY_NOTECARD, 0)); return;} // Send First Notecard in Object
                if (message == cmdFreePlay) {  // If we received a request to start a FreePlayGame
                    player = id;
                    llSetPayPrice(PAY_HIDE, [PAY_HIDE, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
                    llSetClickAction(CLICK_ACTION_TOUCH);
                    gameValueName = message; // gameValueName Now Equals "FreePlay"
                    llMessageLinked(LINK_ALL_OTHERS, -1, "setPicture", gameValueName);
                    llMessageLinked(LINK_SET, -1, "gameValue", gameValueName);
                    llMessageLinked(LINK_THIS, 0, "getblues", id);
                    playing = TRUE; // Set game to Playing True State
                    llWhisper(0, gameValueName + " game starts now."); // Tell User Game is Starting
                    return;
                }
                if (llListFindList(lPay, (list)message) != -1) { // If Price of Game Requested is an Option in the lPay List
                    llSetClickAction(CLICK_ACTION_PAY);
                    integer GameTypeIndex = llListFindList(lPay, (list)message);
                    totalRounds = llList2Integer(RoundLengthList, GameTypeIndex);
                    if(DebugMode){
                        llOwnerSay("Total Rounds: "+(string)totalRounds);
                    }
                    llMessageLinked(LINK_ALL_OTHERS, -1, "setPicture", message);
                    llSetPayPrice(PAY_HIDE, [(integer)llGetSubString(message, 2, -1), PAY_HIDE, PAY_HIDE, PAY_HIDE]);
                    llWhisper(0, "You have 10 seconds to pay the game!");
                    gameValueName = message; // gameValueName Now Equals P$ 5 (Or What ever was selected from menu)
                    llSetTimerEvent(10.0); // Increased from 5.0 to 10.0 By Tech Guy (Time to Pay Machine TimeOut)
                    return;
                }
            }
        }
    }
    
    money(key id, integer amount) { // Money Paid Into Game
        if (!playing) { // We are not playing the game
            if(DiagMode=="TRUE"){ // If we are in Diagnostic Mode (Give Any Paid Money Back Right Away)
                llRegionSayTo(id, 0, "Diagnostic Mode Enabled! Returning your money, You can NOT win any money either!");
                llSleep(0.5);
                llSay(0, "Returning...");
                llGiveMoney(id, amount);
            }
            player = id;
            llSetPayPrice(PAY_HIDE, [PAY_HIDE, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
            llSetClickAction(CLICK_ACTION_TOUCH);
            llWhisper(0, gameValueName + " game starts now.");
            llMessageLinked(LINK_SET, -1, "gameValue", gameValueName);
            llMessageLinked(LINK_THIS, 0, "getblues", id);
            playing = TRUE;
            integer ToPot    = (integer)(amount * PotPercentage);
            // Update Pot Amount in Local Game Server DB
            list SendList = [] + SecurityKey + ["UPPOT"] + (list)ToPot; // Create List to be Parsed to String
            string SendString = llDumpList2String(SendList, "||");
            llRegionSayTo(GameDBServer, EventDBServerComChannel, SendString);
        }
    }
    
    link_message(integer sender, integer num, string msg, key id) {
        integer iCurrentPoints;
        string text = "";
        
        if (msg == "setblues") {
            iBlues = num;
            ssGenerateNumbers();
        } else if (msg == "useNumber") {
            integer n = llList2Integer(lFields, num);
            if (n & EMPTY) {
                iCurrentPoints += pointsSingleField;
                lFields = [] + llListReplaceList(lFields, (list)((n & ~EMPTY) | FILLED), num, num);
            } if (n & CASH) {
                text = "You got "+(string)pointsCash+" extra points!";
                iCurrentPoints += pointsCash;
                lFields = [] + llListReplaceList(lFields, (list)((n & ~EMPTY) | FILLED), num, num);
                llMessageLinked(LINK_SET, num, "setTextureCash", NULL_KEY);
            } if (n & DOUBLE) {
                text = "Double Points!!\nAll your points will now be doubled!";
                bDouble = TRUE;
                lFields = [] + llListReplaceList(lFields, (list)((n & ~EMPTY) | FILLED), num, num);
                llMessageLinked(LINK_SET, num, "setTexture2x", NULL_KEY);
            }
            iCurrentPoints = iCurrentPoints + ssCheckLines(num);
        } else if (msg == "pharao") {
            iCurrentPoints = iCurrentPoints + pointsPharao;
        } else if (msg == "mummy") {
            if (iPoints) {
                integer total = lMummy != [];
                float perc = llList2Float(lMummy, (integer)llFrand(total));
                integer end = (integer)(iPoints * perc);
                llWhisper(0, "Ouch! The you lost " + (string)((integer)(perc * 100)) + "% of your score!");
                if (end) iPoints -= end;
            }
        } else if (msg == "gameOver") { // Received gameOver from randomBar
            playing = FALSE;
            llMessageLinked(LINK_THIS, -123, llDumpList2String([
                "gameReview",
                gameValueName,
                (string)iPoints], "||"),
                player);
                
            llWhisper(0, gameValueName + " game over!");
            //iPoints = 0;
            gameValueName = "";
            player = NULL_KEY;
        }
        
        if (bDouble) { //2x
            iCurrentPoints = iCurrentPoints * 2;
        }
        iPoints = iPoints + iCurrentPoints;
        llMessageLinked(4, iPoints, "playerPoints", NULL_KEY);
        //llSetText("Points: " + (string), <1,1,1>, 1);
        if (text != "") llWhisper(0, text);
    }
    timer() {
        llSetTimerEvent(0.0);
        llSetPayPrice(PAY_HIDE, [PAY_HIDE, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
        llSetClickAction(CLICK_ACTION_TOUCH);
    }
    on_rez(integer p) {
        llResetScript();
    }
    changed(integer c) {
        if (c & CHANGED_OWNER) llResetScript();
    }
}