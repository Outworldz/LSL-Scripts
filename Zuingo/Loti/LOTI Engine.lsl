// Default Program FrameWork
/*

    Replace this Section with Program Specific Information

*/

// Created by Tech Guy of IO

// Configuration Directives
/* This Section Contains Configuration Variables that will contain data set by reading the notecard specified by ConfigFile Variable */
        
    // Communication Channels
    integer MenuComChannel; // Menu Communications Channel for All User Dialog Communications
    integer ComChannel; // General Communication Channel for Inter-Device Communication
    integer ServerComChannel = -63473680;
    integer DBComChannel = -270000;
    integer ScannerComChannel = -19000;

// System Variables
/* This Section contains variables that will be used throughout the program. */
    // Admin ACL
        list Admins = []; // List of Administrator Keys Read in from ConfigFile
    // Communication Handles
        integer MenuComHandle; // Menu Communications Handle
        integer ComHandle; // General Communications Handle
        integer ServerComHandle;
        integer DBComHandle;
        integer ScannerComHandle;
    // Config Card Reading Variables
        integer cLine; // Holds Configuration Line Index for Loading Config Loop
        key cQueryID; // Holds Current Configuration File Line during Loading LooP
    // Server Keys
        key ConfigServerKey = NULL_KEY;
        key EventServerKey = NULL_KEY;
        key UserDBServerKey = NULL_KEY;
        key JackPotServerKey = NULL_KEY;
    // Server Received Configuration Directives
        string DiagMode; // Does the Game PayOut on Win? ie: Diag Mode
        integer HighScore;
        integer PlayCost = 50;
        key Player; // Currently Playing User
        integer Score = 0; // Current Score (The Running Score to be compared with HighScore)
        integer RoundTimer;
        float PotPercent; // Current Percent of Pay to Send to JackPot Server
        integer PayOutMultiplier;
        integer MaxRounds;
        
        
        
// System Constants
/* This Section contains constants used throughout the program */
string BootMessage = "Booting..."; // Default/Initial Boot Message
string ConfigFile = ".config"; // Name of Configuration File
key SecurityKey = "3d7b1a28-f547-4d10-8924-7a2b771739f4"; // Security Communications Key
string SecureRequest = "TheKeyIs(Mq=h/c2)";
string EMPTY = "";
string AdminMenuMessage = "Admin Menu:\n\tReboot: Re-Configure Machine.";
list AdminMenu = ["Reboot", "Exit Menu"];

// Color Vectors
list colorsVectors = [<0.000, 0.455, 0.851>, <0.498, 0.859, 1.000>, <0.224, 0.800, 0.800>, <0.239, 0.600, 0.439>, <0.180, 0.800, 0.251>, <0.004, 1.000, 0.439>, <1.000, 0.522, 0.106>, <1.000, 0.255, 0.212>, <0.522, 0.078, 0.294>, <0.941, 0.071, 0.745>, <0.694, 0.051, 0.788>, <1.000, 1.000, 1.000>];

// List of Names for Colors
list colors = ["BLUE", "AQUA", "TEAL", "OLIVE", "GREEN", "LIME", "ORANGE", "RED", "MAROON", "FUCHSIA", "PURPLE", "WHITE"];  

// System Switches
/* This Section contains variables representing switches (integer(binary) yes/no) or modes (string "modename" */
    // Debug Mode Swtich
        integer DebugMode = FALSE; // Is Debug Mode Enabled before Reading Obtaining Configuation Information
        string OPFLAG = "";

// Imported Functions
/* This section contains any functions that were not written by Tech Guy */

// Home-Brew Functions
/* This section contains any functions that were written by Tech Guy */

// Debug Message Function
DebugMessage(string msg){
    if(DebugMode){
        llOwnerSay(msg);
    }
}

// Send Any User a Message
SendMessage(string msg, key userid){
    if(userid=="NULL_KEY" || userid==""){
        //llSay(0, msg);
        llRegionSay(0, msg);
    }else if(msg!="" && userid!=NULL_KEY){
        //llInstantMessage(userid, msg);
        llRegionSayTo(userid, 0, msg);
    }else{
        DebugMessage("Error Sending User Message: "+msg);
    }
}

// Main Initialization Logic, Executed Once Upon Script Start    
Initialize(){
    SendMessage(BootMessage, llGetOwner()); // State Booting Message
    MenuComChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0); // Randomize Dialog Com Channel
    SendMessage("Configuring...", llGetOwner()); // Message Owner that we are starting the Configure Loop
    cQueryID = llGetNotecardLine(ConfigFile, cLine); // Start the Read from Config Notecard
}

// System has started Function (Runs After Configuration is Loaded, as a result of EOF)
SystemStart(){
    SendMessage("Connecting to Server...", llGetOwner());
    OPFLAG = "MAINCONFIG";
    GetConfiguration();
}

// Add Admin (Add provided Legacy Name to Admins List after extrapolating userKey)
AddAdmin(string LegacyName){
    string FName = llList2String(llParseString2List(LegacyName, [" "], []), 0);
    string LName = llList2String(llParseString2List(LegacyName, [" "], []), 1);
    DebugMessage("First Name: "+FName+" Last Name: "+LName);
    key UserKey = osAvatarName2Key(FName, LName);
    if(UserKey!=NULL_KEY){
        Admins = Admins + UserKey;
        DebugMessage("Added Admin: "+LegacyName);
    }else{
        DebugMessage("Unable to Resolve: "+LegacyName);
    }
}


//  Configuration Directives Processor (Called Each Time a Line is Found in the config File)
LoadConfig(string data){
    if(data!=""){ // If Line is not Empty
        //  if the line does not begin with a comment
        if(llSubStringIndex(data, "#") != 0)
        {
        //  find first equal sign
            integer i = llSubStringIndex(data, "=");
 
        //  if line contains equal sign
            if(i != -1){
                //  get name of name/value pair
                string name = llGetSubString(data, 0, i - 1);
                //  get value of name/value pair
                string value = llGetSubString(data, i + 1, -1);
                //  trim name
                list temp = llParseString2List(name, [" "], []);
                name = llDumpList2String(temp, " ");
                //  make name lowercase
                name = llToLower(name);
                //  trim value
                temp = llParseString2List(value, [" "], []);
                value = llDumpList2String(temp, " ");
                //  Check Key/Value Pairs and Set Switches and Lists
                if(name=="debugmode"){ // Check DeBug Mode
                    if(value=="TRUE" || value=="true"){
                        DebugMode = TRUE;
                        llOwnerSay("Debug Mode: Enabled!");
                    }else if(value=="FALSE" || value=="false"){
                        DebugMode = FALSE;
                        llOwnerSay("Debug Mode: Disabled!");
                    }
                }
        }else{ //  line does not contain equal sign
                SendMessage("Configuration could not be read on line " + (string)cLine, NULL_KEY);
            }
        }
    }
}

// Call In-World Server to get Confuration Data.
GetConfiguration(){
    ServerComHandle = llListen(ServerComChannel, EMPTY, EMPTY, EMPTY);
    llRegionSay(ServerComChannel, SecureRequest);
}

// Process Secure Server Response (Under OPFLAG=MAINCONFIG)
ProcessServerData(string msg){
    list Response = llParseString2List(msg, ["||"], []);
    if(llList2String(Response, 0)!=SecurityKey){
        DebugMessage("Server Response did not provide correct authorization code!");
        return;
    }
    list TempAdmins = llList2List(Response, 19, -1);
    if(DebugMode){
        DebugMessage("Main Server Key: "+(ConfigServerKey = llList2Key(Response, 2)));
        DebugMessage("UserDB Server Key: "+(UserDBServerKey = llList2Key(Response, 3)));
        DebugMessage("Event Server Key: "+(EventServerKey = llList2Key(Response, 4)));
        DebugMessage("Round Time: "+(RoundTimer = llList2Integer(Response, 5))+" seconds");
        PotPercent = llList2Float(Response, 6) / 100;
        DebugMessage("Pot Percent: "+(string)PotPercent+"%");
        DebugMessage("Diag Mode: "+(DiagMode = llList2String(Response, 7)));
        DebugMessage("Win Multiplier: "+(PayOutMultiplier = llList2Integer(Response, 8))+"x");
        DebugMessage("Play Cost: P$"+(PlayCost = llList2Integer(Response, 9)));
        DebugMessage("Number of Rounds: "+(MaxRounds = llList2Integer(Response, 17)));
        DebugMessage("Initial Highscore: "+(HighScore = llList2Integer(Response, 18)));
    }else{
        ConfigServerKey = llList2Key(Response, 2);
        UserDBServerKey = llList2Key(Response, 3);
        EventServerKey =  llList2Key(Response, 4);
        RoundTimer = llList2Integer(Response, 5);
        PotPercent = llList2Integer(Response, 6);
        DiagMode = llList2String(Response, 7);
        PayOutMultiplier = llList2Integer(Response, 8); // Positive Integer by which the pay to play amount is multiplied. The Product of which is the Amount to Pay on Win
        PlayCost = llList2Integer(Response, 9);
        MaxRounds = llList2Integer(Response, 17);
        HighScore = llList2Integer(Response, 18); // Current High Score To Beat. Gets Basic High Score from Server. Then each use beats last high score.
    }
    integer i;
    for(i=0;i<llGetListLength(TempAdmins);i++){
        AddAdmin(llList2String(TempAdmins, i));
    }
    // Set Text Displays
    llMessageLinked(LINK_SET, RoundTimer, "TimerConf", EMPTY); // Update Timer Script with Round Timer Length Value
    llMessageLinked(LINK_SET, MaxRounds, "RoundConf", EMPTY); // Update Timer Script with Max Number of Rounds
    llMessageLinked(LINK_SET, 200000, ": "+(string)PayOutMultiplier+"x", "''''");
    llMessageLinked(LINK_SET, 281000, llGetSubString((string)HighScore,0,5), "''''");
    llMessageLinked(LINK_SET, 291000, llGetSubString((string)HighScore,6,11), "''''");
    llRequestPermissions(llGetOwner(), PERMISSION_DEBIT );
}

// Open Up Listeners on Local Chat 0 but only for people on Admins List
ListenToAdmins(){
    integer i;
    for(i=0;i<llGetListLength(Admins);i++){
        llListen(0, "", llList2Key(Admins, i), "");
    }
}

// Update Event Server with User Play Details
UpdateEvent(string WinLoss, integer MoneyWon, integer MoneyPaid){
    list SendList = [];
    if(WinLoss=="Win"){
        SendList = [] + SecurityKey + ["UPDATE"] + [Player, "", "1", MoneyPaid, MoneyWon, "1", "0" ];
    }else if(WinLoss=="Loss"){
        SendList = [] + SecurityKey + ["UPDATE"] + [Player, "", "1", "0", MoneyPaid, "0", "1" ];
    }
    string SendString = llDumpList2String(SendList, "||");
    llRegionSayTo(UserDBServerKey, DBComChannel, SendString);
    if(DebugMode){
        llOwnerSay("Event DB Updated!\n"+SendString);
    }
}

//Main Program Logic
/* This section contains the main program logic. (ie: Default State, and all event triggers) */

default{
    on_rez(integer params){
        llResetScript();
    }
    
    state_entry(){
        Initialize();
    }
    
    listen(integer chan, string sender, key id, string msg){
        if(OPFLAG=="MAINCONFIG"){
            SendMessage("Server Connected! Processing Configuration Directives...", llGetOwner());
            ProcessServerData(msg);
        }
    }
    
     // DataServer Event Called for Each Line of Config NC. This Loop It was Calls LoadConfig()
    dataserver(key query_id, string data){       // Config Notecard Read Function Needs to be Finished
        if (query_id == cQueryID){
            if(data != EOF){
                LoadConfig(data); // Process Current Line
                ++cLine; // Increment Line Index
                cQueryID = llGetNotecardLine(ConfigFile, cLine); // Attempt to Read Next Config Line (Re-Calls DataServer Event)
            }else{ // IF EOF (End of Config loop, and on Blank File)
                SystemStart();
            }
        }
    }
    
    changed(integer change){
        if(change & CHANGED_INVENTORY){
            llResetScript();
        }
    }
    
    run_time_permissions (integer perm){
        if(perm & PERMISSION_DEBIT){
            state ready;
        }else{
            llOwnerSay("You have denied request to start games.");
            llSleep(2);  
            llRequestPermissions(llGetOwner(), PERMISSION_DEBIT );
        }
    }
}

state ready
{
    
    on_rez(integer param){
        llResetScript();
    }
    
    state_entry(){
        llSay(0, "Game Ready!");
        llMessageLinked(LINK_SET, 205000, "0", "''''");
        ListenToAdmins();
        Player = NULL_KEY;
        llSetPayPrice(PAY_HIDE, [PlayCost,PAY_HIDE,PAY_HIDE,PAY_HIDE]);  
    }
    
    touch(integer num){
        if(num>1){
            return;   
        }
        if(Player!=NULL_KEY){
            return;
        }else if(llListFindList(Admins, [llDetectedKey(0)])!=-1){
            MenuComHandle = llListen(MenuComChannel, EMPTY, EMPTY, EMPTY);
            llDialog(llDetectedKey(0), AdminMenuMessage, AdminMenu, MenuComChannel);
        }else{
            llGiveInventory(llDetectedKey(0),llGetInventoryName(INVENTORY_NOTECARD, 1));
        }
    }

    listen(integer channel, string name, key id, string message){
        if(channel==MenuComChannel){
            if(message=="Reboot"){
                llResetScript();
            }else if(message=="Exit Menu"){
                llRegionSayTo(id, 0, "Exiting Menu...");
                llListenRemove(MenuComHandle);
            }
        }
        list command = llParseString2List(message, ["."], []);
        if(llList2Integer(command, 2)!=PayOutMultiplier || llList2Integer(command, 2)==""){
            return;
        }
        if(llList2String(command, 0) == "winmulti"){
            PayOutMultiplier = (integer)llList2String(command, 1);
            llMessageLinked(LINK_SET, 299000, (string)PayOutMultiplier, "''''");
        }
        if(llList2String(command, 0) == "highscore"){
            HighScore = (integer)llList2String(command, 1);
            llMessageLinked(LINK_SET, 281000, llGetSubString(llList2String(command, 1),0,5), "''''");
            llMessageLinked(LINK_SET, 291000, llGetSubString(llList2String(command, 1),6,11), "''''");
        }
    }
    
    money(key id, integer amount){
        if (amount == PlayCost){
            if(DiagMode=="TRUE"){
                llWhisper(0, "Game Starting...\nDiagnostic Mode Active: Returning Money!\n No Money will be paid out upon win!");
                llGiveMoney(id, amount);
            }else{
                llWhisper(0, "Game Starting...");
            }
            Player = id;
            integer ToPot = (integer)(amount * (PotPercent / 100));
            // Update Pot Amount in Local Game Server DB
            list SendList = [] + SecurityKey + ["UPPOT"] + (list)ToPot; // Create List to be Parsed to String
            string SendString = llDumpList2String(SendList, "||");
            llRegionSayTo(UserDBServerKey, DBComChannel, SendString);
            state play;
        }
    }
}

state play
{
     on_rez(integer param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        Score = 0;
        llSetPayPrice(PAY_HIDE, [PAY_HIDE,PAY_HIDE,PAY_HIDE,PAY_HIDE]);
        //llPlaySound("9f755cb9-082a-1bd0-75ac-5d404bbef76d", 1);
        llMessageLinked(LINK_SET, 0, "apple", Player);
        llMessageLinked(LINK_SET, 0, "Start", "");
        llSleep(2);
        llMessageLinked(LINK_SET, 20110, "Next Round", "");
    }
    
    link_message(integer aset, integer dd, string cc, key ddh)
    {
        if (dd == 5){
            Score += (integer)cc;
            llMessageLinked(LINK_SET, 205000, (string)Score, "''''");
        }
        
        if (cc == "Game Over"){
            string PayOut = "0";
            if (Score > HighScore){
                llMessageLinked(LINK_SET, 281000, llGetSubString((string)Score,0,5), "''''");
                llMessageLinked(LINK_SET, 291000, llGetSubString((string)Score,6,11), "''''");
                if(PayOutMultiplier > 0){
                    PayOut = (string)(PlayCost * PayOutMultiplier);
                    if(DiagMode=="TRUE"){
                        llWhisper(0, osKey2Name(Player)+" wins P$"+(string)PayOut+"! Diagnostic Mode Active: Nothing Paid Out!");
                    }else{
                        llWhisper(0, osKey2Name(Player)+" wins P$"+(string)PayOut+"!");
                        llGiveMoney(Player, (integer)PayOut);
                    }
                    UpdateEvent("Win", PlayCost, (integer)PayOut);
                    HighScore = Score;
                    state ready;
                }
                if(PayOutMultiplier < 1){
                    if(DiagMode=="TRUE"){
                        llWhisper(0, osKey2Name(Player)+" wins!\nNothing Paid, Diagnostic Mode Active!");
                        UpdateEvent("Win", PlayCost, (integer)PayOut);
                        HighScore = Score;
                        state ready;
                    }else{
                        llWhisper(0, osKey2Name(Player)+" wins!\nNothing Paid, No Multiplier Set. Contact Support!");
                        UpdateEvent("Win", PlayCost, (integer)PayOut);
                        HighScore = Score;
                        state ready;
                    }
                }
            }
            
            if (Score < HighScore)
            {
                integer short = HighScore - Score;
                llWhisper(0, osKey2Name(Player)+" loss with a score of "+(string)Score);
                llSleep(1);
                llWhisper(0, "Fell "+(string)short+" points short.");
                llOwnerSay("PlayCost: "+PlayCost+" PayOut: "+PayOut);
                UpdateEvent("Loss", (integer)PayOut, (integer)PlayCost);
                state ready;
            }
        }
    }   
}