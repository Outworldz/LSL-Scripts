// Game Server Relay Engine v1.0
// Created by Tech Guy


// Configuration

    // Constants
integer ServerComChannel = -13546788; // Secret Negative Channel for Server Communication
list KEYS = [ "5b8c8de4-e142-4905-a28f-d4d00607d3e9", "b9dbc6a4-2ac3-4313-9a7f-7bd1e11edf78", "dbfa0843-7f7f-4ced-83f6-33223ae57639" ];
list AuthedUsers = [];
string EMPTY = "";
key SecurityKey = "useyourownkey";
float LightHoldLength = 0.1;
string SecureRequest = "(Mq=h/c2)";
string cName = ".gameconfig"; // Name of Configuration NoteCard
    // Off-World Data Communication Constants
key HTTPRequestHandle; // Handle for HTTP Request
string URLBase = "http://orbitsystems.ca/";
list HTTPRequestParams = [
    HTTP_METHOD, "POST",
    HTTP_MIMETYPE, "application/x-www-form-urlencoded",
    HTTP_BODY_MAXLENGTH, 16384,
    HTTP_CUSTOM_HEADER, "CUSKEY", "(Mq=h/c2)"
];


        // Indicator Light Config
    float GlowOn = 0.10;
    float GlowOff = 0.0;
    list ONColorVectors = [<0.0,1.0,0.0>,<1.0,0.5,0.0>,<1.0,0.0,0.0>];
    list ColorNames = ["Green", "Orange", "Red"];
    list OFFColorVectors = [<0.0,0.5,0.0>,<0.5,0.25,0.0>,<0.5,0.0,0.0>];
    integer PWRLIGHT = 2;
    integer CFGLIGHT = 3;
    integer INLIGHT = 4;
    integer OUTLIGHT = 5;
    
    

    // Variables
integer ServerComHandle; // Hold Handle to Control Server Com Channel
integer cLine; // Holds Configuration Line Index for Loading Config Loop
key cQueryID; // Holds Current Configuration File Line during Loading Loop
string GameName = "";
    // Switches
integer DebugMode = FALSE; // Are we running in with Debug Messages ON?
    // Flags
    
list highscores     = ["11000", "15000", "20000", "30000", "40000", "45000", "75000", "95000", "125000", "150000"];
list pots           = ["10", "25", "75", "150", "300", "400", "1250", "2500", "3750", "5000"];
list gameValues     = ["P$5", "P$10", "P$25", "P$50", "P$75", "P$100", "P$250", "P$500", "P$750", "P$1000"];
list Multipliers    = ["2", "2.5", "3", "3", "4", "4", "5", "5", "5", "5"];
list RoundLengths   = ["5", "5", "6", "8", "8", "10", "10", "15", "15", "20"];
list lMummy = [];
string roundTime;
string pointsSingleField;
string pointsLine;
string pointsPattern;
string pointsAll;
string pointsCash;
string pointsPlus;
string PotPercent;
string DiagMode;
// JackPot Configuration Directives
string MaxJackPots;
string JackPotTimer;
string InitialJackPot;
string CommonComChannel;
string AvatarScannerChannel;

// User Database Configuration Directives
string UserUploadTimer;
    
    // Functions

Initialize(){
    llListenRemove(ServerComHandle);
    llSleep(LightHoldLength);
    llListen(ServerComChannel, EMPTY, EMPTY, EMPTY);
    if(DebugMode){
        llOwnerSay(llGetObjectName()+" Server Online");
    }
    llOwnerSay("Configuring...");
    cQueryID = llGetNotecardLine(cName, cLine);
}

LightToggle(integer LinkID, integer ISON, string Color){
    if(ISON){
        vector ColorVector = llList2Vector(ONColorVectors, llListFindList(ColorNames, [Color]));
        llSetLinkPrimitiveParamsFast(LinkID, [
            PRIM_COLOR, ALL_SIDES, ColorVector, 1.0,
            PRIM_GLOW, ALL_SIDES, GlowOn,
            PRIM_FULLBRIGHT, ALL_SIDES, TRUE
        ]);
    }else{
        vector ColorVector = llList2Vector(OFFColorVectors, llListFindList(ColorNames, [Color]));
        llSetLinkPrimitiveParamsFast(LinkID, [
            PRIM_COLOR, ALL_SIDES, ColorVector, 1.0,
            PRIM_GLOW, ALL_SIDES, GlowOff,
            PRIM_FULLBRIGHT, ALL_SIDES, FALSE
        ]);
    }
}

LoadConfig(string data){
    LightToggle(CFGLIGHT, TRUE, "Orange");
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
                if(name=="debugmode"){
                    if(value=="TRUE" || value=="true"){
                        DebugMode = TRUE;
                        llOwnerSay("Debug Mode: Enabled!");
                    }else if(value=="FALSE" || value=="false"){
                        DebugMode = FALSE;
                        llOwnerSay("Debug Mode: Disabled!");
                    }
                }else if(name=="highscores"){
                    if(DebugMode){
                        llOwnerSay("Parsing HighScore Data...");
                    }
                    highscores = llParseString2List(value, "||", "");
                    if(llGetListLength(highscores)==10){
                        if(DebugMode){
                            llOwnerSay("HighScore Data Configured!");
                        }
                    }
                }else if(name=="pots"){
                    if(DebugMode){
                        llOwnerSay("Parsing JackPot Data...");
                    }
                    pots = llParseString2List(value, "||", "");
                    if(llGetListLength(pots)==10){
                        if(DebugMode){
                            llOwnerSay("JackPot Data Configured!");
                        }
                    }
                }else if(name=="gamevalues"){
                    if(DebugMode){
                        llOwnerSay("Parsing GameValue Data...");
                    }
                    gameValues = llParseString2List(value, "||", "");
                    if(llGetListLength(gameValues)==10){
                        if(DebugMode){
                            llOwnerSay("GameValue Data Configured!");
                        }
                    }
                }else if(name=="multipliers"){
                    if(DebugMode){
                        llOwnerSay("Parsing Multipliers Data...");
                    }
                    Multipliers = llParseString2List(value, "||", "");
                    if(llGetListLength(Multipliers)==10){
                        if(DebugMode){
                            llOwnerSay("Multipliers Data Configured!");
                        }
                    }
                }else if(name=="roundlengths"){
                    if(DebugMode){
                        llOwnerSay("Parsing RoundLengths Data...");
                    }
                    RoundLengths = llParseString2List(value, "||", "");
                    if(llGetListLength(RoundLengths)==10){
                        if(DebugMode){
                            llOwnerSay("RoundLengths Data Configured!");
                        }
                    }
                }else if(name=="servercomchannel"){
                    ServerComChannel = (integer)value;
                    if(DebugMode){
                        llOwnerSay("Server Com Channel: "+(string)ServerComChannel);
                    }
                }else if(name=="securitykey"){
                    SecurityKey = value;
                    if(DebugMode){
                        llOwnerSay("Security Key: "+SecurityKey);
                    }
                }else if(name=="gameserver"){
                    KEYS = [] + [value];
                    if(DebugMode){
                        llOwnerSay("Game Server(Self): "+llKey2Name(llList2String(KEYS, 0)));
                    }
                }else if(name=="gamedbserver"){
                    KEYS = KEYS + [value];
                    if(DebugMode){
                        llOwnerSay("Game User DB: "+llKey2Name(llList2String(KEYS, 1)));
                    }
                }else if(name=="gameeventdbserver"){
                    KEYS = KEYS + [value];
                    if(DebugMode){
                        llOwnerSay("Game Event DB: "+llKey2Name(llList2String(KEYS, 2)));
                    }
                }else if(name=="user"){
                    AuthedUsers = AuthedUsers + [value];
                    if(DebugMode){
                        llOwnerSay("New Machine Authed User: "+value);
                    }
                }else if(name=="mummy"){
                    lMummy = llParseString2List(value, "||", "");
                    if(llGetListLength(lMummy)>0 && DebugMode){
                        llOwnerSay("Negative Percentages Configured!");
                    }
                }else if(name=="roundtime"){
                    roundTime = value;
                    if(roundTime!="" && DebugMode){
                        llOwnerSay("Round Time Configured!");
                    }
                }else if(name=="pointssinglefield"){
                    pointsSingleField = value;
                    if(pointsSingleField!="" && DebugMode){
                        llOwnerSay("Points Single Field Configured!");
                    }
                }else if(name=="pointsline"){
                    pointsLine = value;
                    if(pointsLine!="" && DebugMode){
                        llOwnerSay("Points Line Configured!");
                    }
                }else if(name=="pointspattern"){
                    pointsPattern = value;
                    if(pointsPattern!="" && DebugMode){
                        llOwnerSay("Points Pattern Configured!");
                    }
                }else if(name=="pointsall"){
                    pointsAll = value;
                    if(pointsAll!="" && DebugMode){
                        llOwnerSay("Points All Configured!");
                    }
                }else if(name=="pointscash"){
                    pointsCash = value;
                    if(pointsCash!="" && DebugMode){
                        llOwnerSay("Points Cash Configured!");
                    }
                }else if(name=="pointsplus"){
                    pointsPlus = value;
                    if(pointsPlus!="" && DebugMode){
                        llOwnerSay("Round Time Configured!");
                    }
                }else if(name=="potpercent"){
                    PotPercent = value;
                    if(PotPercent!="" && DebugMode){
                        llOwnerSay("JackPot Takes: "+value+"%");
                    }
                }else if(name=="gamename"){
                    GameName = value;
                    if(GameName!="" && DebugMode){
                        llOwnerSay("Game Name: "+GameName);
                    }
                }else if(name=="diagmode"){
                    DiagMode = value;
                    if(DebugMode){
                        llOwnerSay("Diagnostic Mode: "+DiagMode);
                    }   
                }else if(name=="maxjackpots"){
                    MaxJackPots = value;
                    if(DebugMode){
                        llOwnerSay("Max JackPots per Cycle: "+MaxJackPots);
                    }
                }else if(name=="jackpottimer"){
                    JackPotTimer = value;
                    if(DebugMode){
                        llOwnerSay("JackPot Timer: "+JackPotTimer);
                    }
                }else if(name=="initialjackpot"){
                    InitialJackPot = value;
                    if(DebugMode){
                        llOwnerSay("Initial JackPot Value: "+InitialJackPot);
                    }
                }else if(name=="useruploadtimer"){
                    UserUploadTimer = value;
                    if(DebugMode){
                        llOwnerSay("User DB Backup Timer: "+UserUploadTimer);
                    }
                }else if(name=="commoncomchannel"){
                    CommonComChannel = value;
                    if(DebugMode){
                        llOwnerSay("Common Com Channel: "+CommonComChannel);
                    }
                }else if(name=="scannercomchannel"){
                    AvatarScannerChannel = value;
                    if(DebugMode){
                        llOwnerSay("Scanner Com Channel: "+AvatarScannerChannel);
                    }
                }
                LightToggle(CFGLIGHT, FALSE, "Orange");
        }else{ //  line does not contain equal sign
                llOwnerSay("Configuration could not be read on line " + (string)cLine);
            }
        }
    }
}

RegisterServer(string cmd){
    if(cmd=="CheckReg"){
        string CmdString = "?"+llStringToBase64("cmd")+"="+llStringToBase64("CheckReg")+"&"+llStringToBase64("Key")+"="+llStringToBase64(SecurityKey);
        string URL = URLBase + CmdString;
        list SendParams = HTTPRequestParams + ["ServerType", "Main"];
        HTTPRequestHandle = llHTTPRequest(URL, SendParams, ""); // Send Request to Server to Check and/or Register this Server
    }
}

    
// Main Program
default{
    on_rez(integer params){
        llGiveInventory(llGetOwner(), llGetInventoryName(INVENTORY_NOTECARD, 1));
        llResetScript();
    }
    
    state_entry(){
        LightToggle(PWRLIGHT, TRUE, "Red");
        llSleep(LightHoldLength);
        LightToggle(CFGLIGHT, TRUE, "Orange");
        llSleep(LightHoldLength);
        LightToggle(CFGLIGHT, FALSE, "Orange");
        LightToggle(INLIGHT, TRUE, "Green");
        llSleep(LightHoldLength);
        LightToggle(INLIGHT, FALSE, "Green");
        LightToggle(OUTLIGHT, TRUE, "Green");
        llSleep(LightHoldLength);
        LightToggle(OUTLIGHT, FALSE, "Green");
        Initialize();
    }
    
    dataserver(key query_id, string data){       // Config Notecard Read Function Needs to be Finished
        if (query_id == cQueryID){
            if (data != EOF){ 
                LoadConfig(data); // Process Current Line
                ++cLine; // Incrment Line Index
                cQueryID = llGetNotecardLine(cName, cLine); // Attempt to Read Next Config Line (Re-Calls DataServer Event)
            }else{ // IF EOF (End of Config loop, and on Blank File)
                LightToggle(CFGLIGHT, TRUE, "Orange");
                // Check if Server is Registered with Website
                RegisterServer("CheckReg");
            }
        }
    }
    
    changed(integer c){
        if(c & CHANGED_INVENTORY){
            llResetScript();
        }
    }
    
    listen(integer chan, string cmd, key id, string data){
        if(DebugMode){
            llOwnerSay("GS Listen Event Fired!\r"+data);
        }
        LightToggle(INLIGHT, TRUE, "Green");
        llSleep(LightHoldLength);
        if(data=="GetHighScores"){ // External Call for Game Configuration Information
            list SendList = [] + SecurityKey + highscores + gameValues + pots + Multipliers; // Compile Lists
            string SendString = llDumpList2String(SendList, "||"); // Dump to String
            LightToggle(INLIGHT, FALSE, "Green");
            LightToggle(OUTLIGHT, TRUE, "Green");
            llSleep(LightHoldLength);
            llRegionSayTo(id, ServerComChannel, SendString); // Send Back to Requesting Machine.
            LightToggle(OUTLIGHT, FALSE, "Green");
            return;
        }else if(data=="GetRoundLengths"){
            list SendList = [] + SecurityKey + RoundLengths; // Compile Lists
            string SendString = llDumpList2String(SendList, "||"); // Dump to String
            LightToggle(INLIGHT, FALSE, "Green");
            LightToggle(OUTLIGHT, TRUE, "Green");
            llSleep(LightHoldLength);
            if(DebugMode){
                llOwnerSay("Sent: "+SendString);
            }
            llRegionSayTo(id, ServerComChannel, SendString); // Send Back to Requesting Machine.   
            LightToggle(OUTLIGHT, FALSE, "Green");         
            return;
        }else if(data=="GetPotTimeOut"){
            list SendList = [] + SecurityKey + JackPotTimer; // Compile Lists
            string SendString = llDumpList2String(SendList, "||"); // Dump to String
            LightToggle(INLIGHT, FALSE, "Green");
            LightToggle(OUTLIGHT, TRUE, "Green");
            llSleep(LightHoldLength);
            llRegionSayTo(id, ServerComChannel, SendString); // Send Back to Requesting Machine.            
            LightToggle(OUTLIGHT, FALSE, "Green");
            return; 
        }else if(data==SecureRequest){
            list GameConfig = [] + lMummy + [roundTime] + [pointsSingleField] + [pointsLine] + [pointsPattern] + [pointsAll] + [pointsCash] + [pointsPlus] + [PotPercent] + [DiagMode] + [MaxJackPots] + [JackPotTimer] + [InitialJackPot] + [UserUploadTimer] + [CommonComChannel] + [AvatarScannerChannel];
            list SendList = [SecurityKey] + [SecureRequest] + KEYS + GameConfig + AuthedUsers;
            string SendString = llDumpList2String(SendList, "||");
            if(DebugMode){
                llOwnerSay("Secure Response Send String: "+SendString);
            }
            LightToggle(INLIGHT, FALSE, "Green");
            LightToggle(OUTLIGHT, TRUE, "Green");
            llRegionSayTo(id, ServerComChannel, SendString);
            llSleep(LightHoldLength);
            LightToggle(OUTLIGHT, FALSE, "Green");
        }
    }
    
    http_response(key request_id, integer status, list metadata, string body)
    {
        if (request_id != HTTPRequestHandle) return;// exit if unknown
 
        vector COLOR_BLUE = <0.0, 0.0, 1.0>;
        float  OPAQUE     = 1.0;
 
        list OutputData = llCSV2List(body); // Parse Response into List
        string InputKey = llBase64ToString(llList2String(OutputData, 1));
        string InputCMD = llBase64ToString(llList2String(OutputData, 0));
        if(InputKey!=SecurityKey){
            llOwnerSay("Invalid Security Key Received from RL Server!\r"+body);
        }else{
            if(InputCMD=="ALRDYREGOK"){ // Server Already Registered
                if(DebugMode){
                    llOwnerSay("Server Already Registered!");
                }
            }else if(InputCMD=="REGOK"){ // Server Successfully Registered
                if(DebugMode){
                    llOwnerSay("Server Successfully Registered!");
                }
            }else if(InputCMD=="REGERR"){ // Error Registering Server with Off-World Database
                llOwnerSay("Error Registering Server with Database!");
            }else if(InputCMD=="CHECKERR"){ // Error Checking Database for Server Registration
                llOwnerSay("Error Checking Database for Server Registration");
            }else{
                llOwnerSay("Response from server not reconignized!");
            }
        }
        llOwnerSay(llGetObjectName()+" Server Online");
        LightToggle(CFGLIGHT, FALSE, "Orange");
    }
}