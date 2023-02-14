//Very Keynes - 2008 - 2009 
// 
// Version: OpenSimulator Server  0.6.1.7935  (interface version 2)  
// 
// 2009-01-06, 19:30 GMT 
// 
//------------------Begin VK-DBMS-VM----------------------------\\ 
//--------------------Introduction------------------------------\\ 
// 
// Very Keynes - DBMS - Virtual Machine 
// 
//        Implements a core set of registers and root functions 
//        to create and manage multi-table database structures as 
//        an LSL list. Although intended to under pin higher level 
//        database management tools such as VK-SQL it is usable as 
//        a small footprint database facility for system level 
//        applications. 
// 
// 
//    Naming Conventions and Code Style 
// 
//        This Code is intended to be included as a header to user generated 
//        code. As such it's naming convention was selected so that it would 
//        minimise the possibility of duplicate names in the user code portion 
//        of the application. Exposed Functions and Variables are prefixed db. 
// 
//      A full User Guide and Tutorial is availible at this URL: 
// 
//          http://docs.google.com/Doc?id=d79kx35_26df2pbbd8 
// 
// 
//    Table Control Registers 
// 
integer th_;     // Table Handle / Index Pointer 
integer tc_;     // Columns in Active Table 
integer tr_;     // Rows in Active Table 
integer ts_;     // Active Table Start Address 
// 
list _d_ = [];    // Database File 
list _i_ = [0];    // Index File 
// 
//    Exposed Variables 
// 
integer dbIndex;    // Active Row Table Pointer 
list       dbRow;    // User Scratch List 
string  dbError;    // System Error String 
// 
// Temporary / Working Variables 
// 
integer t_i; 
string  t_s; 
float     t_f; 
list     t_l; 
// 
//    System Functions 
// 
string dbCreate(string tab, list col) 
{     
    if(dbOpen(tab)) 
    { 
        dbError = tab + " already exists";  
        return ""; 
    } 
    tc_ = llGetListLength(col); 
    _i_ += [tab, tc_, 0, 0, 0]; 
    th_= 0;  
    dbOpen(tab);  
    dbInsert(col);  
    return tab;  
} 


integer dbCol(string  col) 
{ 
    return llListFindList(dbGet(0), [_trm(col)]); 
} 


integer dbDelete(integer ptr) 
{ 
    if(ptr > 0 && ptr < tr_) 
    { 
        t_i = ts_ + tc_ * ptr; 
        _d_ = llDeleteSubList(_d_, t_i, t_i + tc_ - 1);  
        --tr_; 
        return tr_ - 1; 
    } 
    else  
    { 
        dbError = (string)ptr + " is outside the Table Bounds";  
        return FALSE; 
    } 
} 


integer dbDrop(string tab) 
{ 
    t_i = llListFindList(_i_, [tab]); 
    if(-1 != t_i) 
    {     
        dbOpen(tab); 
        _d_ = llDeleteSubList(_d_, ts_, ts_ + tc_ * tr_ - 1); 
        _i_ = llDeleteSubList(_i_, th_, th_ + 4); 
        th_= 0; 
        return TRUE;     
    } 
    else  
    { 
        dbError = tab + " : Table name not recognised";  
        return FALSE; 
    } 
} 


integer dbExists(list cnd) 
{     
    for(dbIndex = tr_ - 1 ; dbIndex > 0 ; --dbIndex) 
    { 
        if(dbTest(cnd)) return dbIndex; 
    } 
    return FALSE; 
} 


list dbGet(integer ptr) 
{ 
    if(ptr < tr_ && ptr >= 0) 
    { 
        t_i = ts_ + tc_ * ptr; 
        return llList2List(_d_, t_i, t_i + tc_ - 1); 
    } 
    else  
    { 
        dbError = (string) ptr + " is outside the Table Bounds"; 
        return []; 
    } 
} 


integer _idx(integer hdl) 
{ 
    return (integer)llListStatistics(6, llList2ListStrided(_i_, 0, hdl, 5)); 
} 


integer dbInsert(list val) 
{ 
    if(llGetListLength(val) == tc_) 
    { 
        dbIndex = tr_++; 
        _d_ = llListInsertList(_d_, val, ts_ + tc_ * dbIndex); 
        return dbIndex; 
    } 
    else 
    { 
        dbError = "Insert Failed - too many or too few Columns specified";  
        return FALSE; 
    } 
} 


integer dbOpen(string tab) 
{ 
    if(th_)  
    { 
        _i_ = llListReplaceList(_i_, [tr_, dbIndex, tc_ * tr_], th_ + 2, th_ + 4); 
    } 
    t_i = llListFindList(_i_, [tab]); 
    if(-1 == t_i)    //if tab does not exist abort 
    { 
        dbError = tab + " : Table name not recognised";  
        return FALSE; 
    } 
    else if(th_ != t_i) 
    { 
        th_ = t_i++; 
        ts_ = _idx(th_); 
        tc_ = llList2Integer(_i_, t_i++); 
        tr_ = llList2Integer(_i_, t_i++); 
        dbIndex = llList2Integer(_i_, t_i); 
    } 
    return tr_ - 1; 
} 


integer dbPut(list val) 
{ 
    if(llGetListLength(val) == tc_) 
    { 
        t_i = ts_ + tc_ * dbIndex; 
        _d_ = llListReplaceList(_d_, val, t_i, t_i + tc_ - 1);  
        return dbIndex; 
    } 
    else  
    { 
        dbError = "Update Failed - too many or too few Columns specified";  
        return FALSE; 
    } 
} 


integer dbTest(list cnd) 
{  
    if(llGetListEntryType(cnd,2) >= 3) 
    { 
        t_s = llList2String(dbGet(dbIndex), dbCol(llList2String(cnd, 0))); 
        if     ("==" == llList2String(cnd, 1)){t_i =  t_s == _trm(llList2String(cnd, 2));} 
        else if("!=" == llList2String(cnd, 1)){t_i =  t_s != _trm(llList2String(cnd, 2));} 
        else if("~=" == llList2String(cnd, 1)) 
        {t_i = !(llSubStringIndex(llToLower(t_s), llToLower(_trm(llList2String(cnd, 2)))));} 
    } 
    else 
    { 
        t_f = llList2Float(dbGet(dbIndex), dbCol(llList2String(cnd, 0))); 
        t_s = llList2String(cnd, 1); 
        if     ("==" == t_s){t_i = t_f == llList2Float(cnd, 2);} 
        else if("!=" == t_s){t_i = t_f != llList2Float(cnd, 2);} 
        else if("<=" == t_s){t_i = t_f <= llList2Float(cnd, 2);} 
        else if(">=" == t_s){t_i = t_f >= llList2Float(cnd, 2);} 
        else if("<"  == t_s){t_i = t_f <  llList2Float(cnd, 2);} 
        else if(">"  == t_s){t_i = t_f >  llList2Float(cnd, 2);} 
    } 
    if(t_i) return dbIndex;  
    else return FALSE; 
} 


string _trm(string val) 
{ 
    return llStringTrim(val, STRING_TRIM); 
} 


dbTruncate(string tab) 
{ 
    dbIndex = dbOpen(tab); 
    while(dbIndex > 0) dbDelete(dbIndex--); 
} 


dbSort(integer dir) 
{ 
    t_i = ts_ + tc_; 
    _d_ = llListReplaceList(_d_, llListSort(llList2List(_d_, t_i, t_i + tc_ * tr_ - 2), tc_, dir), t_i, t_i + tc_ * tr_ - 2); 
} 


float dbFn(string fn, string col) 
{ 
    t_i = ts_ + tc_; 
    t_l = llList2List(_d_, t_i, t_i + tc_ * tr_ - 2); 
    if(dbCol(col) != 0) t_l = llDeleteSubList(t_l, 0, dbCol(col) - 1); 
    return llListStatistics(llSubStringIndex("ramimaavmedesusqcoge", llGetSubString(llToLower(fn),0,1)) / 2, 
    llList2ListStrided(t_l, 0, -1, tc_)); 
} 
// 
//--------------------------- End VK-DBMS-VM ---------------------------\\ 
// 

// Configuration

    // Constants
integer DBComChannel = -260046;
integer ServerComChannel = -13546788;
integer ScannerComChannel = -18006;
integer ServerComHandle;
integer ScannerComHandle;
string DBName = "HeavenAndHellHourlyJackPot"; // Database for Heaven and Hell Player Info
string HoverTextString = "Heaven And Hell\n Hourly Jackpot Server"; // Base String Name of Databse Engine
string EMPTY = "";
key SecurityKey = "UseYourOwnKey";
key GameServer = "";
key GameEventDBServer = "";
key GameUserDBServer = "";
integer BasePotAmt = 100;
float LightHoldLength = 0.1;
string AskForKeys = "(Mq=h/c2)";
string ServerType = "JACKPOT";
integer UploadTimer = 45; // Frequency in Seconds of User Database Upload
string TimerMode = "JackPot"; // Hold TimerMode State (either JackPot or Dump)
    // Off-World Data Communication Constants
key HTTPRequestHandle; // Handle for HTTP Request
string URLBase = "http://orbitsystems.ca";
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
    integer ACTLIGHT = 3;

    // Incoming Field Ids
integer SECKEY = 0;
integer CMD = 1;
integer UUID = 2;
integer PLAYED = 4;
integer WON = 5;
integer SPENT = 6;
integer WINS = 7;
integer LOSES = 8;

    // Switches
integer HoverText = TRUE; // Should we show hoverText
integer DebugMode = FALSE; // Should we say De bug Messages to Owner?

    // Variables
integer DBComHandle; // Database Communication Handle
integer DBEntries; // NUmber of Database Entries
integer DBEMPTY = 1;
integer TotalTouched = 0;
string HTTPFLAG = ""; // Hold Flag to know what last HTTP Resquest was for
string DiagMode; // Holds String Flag for Diagnostics Mode (ie Return all payments upon being made, and do not payout winers, ONLY LOG DATA!)

// NoteCard Reader
key nrofnamesoncard;
integer nrofnames;
list names;
list keynameoncard;
string nameoncard;
string storedname;

// Jackpot Server Type Configuration
integer PotSize;
integer PotPercentage; // Hold Percentage of JackPot to RollOver
integer JackPotCounter; // Hold Incrementally increasing JackPot Count (Increased every time a JackPot Routine is run)
integer MaxJackPots = 6; // Max number of JackPots before Off-World DB Dump and DB Truncate  (HrsBeforeReset = MaxJackPots * UploadTimer)

    // Menus


    // Functions
Initialize(){
    if(DebugMode){
        llOwnerSay("Initializing "+DBName+"...\n\t\t\t\t\t\t\t Starting System...");
    }
    if(HoverText){
        llSetText(HoverTextString, <1.0,1.0,1.0>, 0.2);
    }
    llListenRemove(DBComHandle);
    llListenRemove(ServerComHandle);
    llListenRemove(ScannerComHandle);
    llSleep(0.1);
    DBComHandle = llListen(DBComChannel, EMPTY, EMPTY, EMPTY);
    ServerComHandle = llListen(ServerComChannel, EMPTY, EMPTY, EMPTY);
    ScannerComHandle = llListen(ScannerComChannel, EMPTY, EMPTY, EMPTY);
    string CreatedDB = dbCreate(DBName, ["uuid", "name", "jackpot"]);
    if(CreatedDB==DBName && DebugMode){
        llOwnerSay("Database "+DBName+" Created...");
        llOwnerSay("Creating Pot Entry...");
    }
    //dbInsert(["uuid", "name", "spent", "won", "jackpot"]);
    DBEntries = DBEMPTY;
    LightToggle(PWRLIGHT, FALSE, "Red");
    llSleep(LightHoldLength);
    LightToggle(PWRLIGHT, TRUE, "Red");
    LightToggle(ACTLIGHT, TRUE, "Green");
    llSleep(LightHoldLength);
    LightToggle(ACTLIGHT, FALSE, "Green");
    llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
}

FindKeys(){
    llRegionSay(ServerComChannel, AskForKeys);
}

RegisterServer(string cmd){
     if(cmd=="CheckReg"){
        string CmdString = "?"+llStringToBase64("cmd")+"="+llStringToBase64("CheckReg")+"&"+llStringToBase64("Key")+"="+llStringToBase64(SecurityKey);
        string URL = URLBase + CmdString;
        list SendParams = HTTPRequestParams + ["ServerType", ServerType];
        HTTPFLAG = "CheckReg";
        HTTPRequestHandle = llHTTPRequest(URL, SendParams, ""); // Send Request to Server to Check and/or Register this Server
    }
}

// Check key if any incoming request and validate against Security Key
integer SecurityCheck(key CheckID){
    if(CheckID!=SecurityKey){
        return FALSE;
    }else{
        return TRUE;
    }
}

ToggleDebug(){
    DebugMode = !DebugMode;
    if(DebugMode){
        llOwnerSay("Debug Mode ON!");
    }else{
        llOwnerSay("Debug Mode OFF!");
    }
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

string GetUserData(){
    dbIndex = 1;
    string ReturnString = "";
    for(dbIndex=1;dbIndex<=DBEntries;dbIndex++){
        list CurrentLine = dbGet(dbIndex);
        
        if(llList2String(CurrentLine, 0)==""){ return ReturnString; }
        
        string CompiledString = llList2String(CurrentLine, 0)+"||"+llList2String(CurrentLine, 1)+"||"+llList2String(CurrentLine, 2)+"||"+llList2String(CurrentLine, 3)+"||"+llList2String(CurrentLine, 4)+"||"+llList2String(CurrentLine, 5)+"||"+llList2String(CurrentLine, 6)+",";
        ReturnString = ReturnString + CompiledString;
    }
    return ReturnString;
}

PrintJackPotWinners(string uuid){
        dbIndex = 1;
        for(dbIndex=1;dbIndex<=DBEntries;dbIndex++){
            list CurrentLine = dbGet(dbIndex);
            llRegionSayTo(uuid, 0, "\nJackPot Winners:\n" + 
            "UUID: " + llList2String(CurrentLine, 0) + "\n" +
            "Name: " + llList2String(CurrentLine, 1) + "\n" +
            "JackPot: " + llList2String(CurrentLine, 2));
        }   
}

// Scan for Users Function
// Ask Scanner for List of Users on Sim
ScanforUsers(list UsersToCheck){
    integer i;
    list UserIDS = [];
    for(i=0;i<llGetListLength(UsersToCheck);i++){
        UserIDS = UserIDS + llList2Key(llParseString2List(llList2String(UsersToCheck, i), ["~"], ""), 1);
        if(DebugMode){
            llOwnerSay("Key to scan for: "+llList2String(UserIDS, i));
        }
    }
    string ComMessage = SecurityKey+"||SCANFOR||"+llDumpList2String(UserIDS, "||");
    if(DebugMode){
        llOwnerSay("JP Server-Avatar Scanner String: "+ComMessage);
    }
    llRegionSay(ScannerComChannel, ComMessage);
}

// Log Error Event to Games Event DB Server
//Database LayOut = ["uuid", "theirip", "name", "eventtype", "message", "data"]
LogEvent(string ErrType, string userid, string name, string EventType, string Message, string Data){
    string SendString = ""; // Define Send String
    if(ErrType=="Security"){
        list SendList = [] + [SecurityKey] + ["INSERT"] + [userid, name, EventType, Message, Data];
        SendString = llDumpList2String(SendList, "||");
        
    }
    llRegionSayTo(GameEventDBServer, DBComChannel, SendString);
}

// Pay Active Users Their JackPot Share
JackPotPayOut(list ActiveUsers){
    float JackPotRollOver = (float)PotSize * (float)((float)PotPercentage / 100.0); // Determine JackPot Amount to Roll Over
    if(DebugMode){
        llOwnerSay("JPRO: "+(string)JackPotRollOver);
    }
    integer JackPotToGive = PotSize - (integer)JackPotRollOver; // Determine JackPot Amount to Give Away
    integer i;
    integer NumActiveUsers = llGetListLength(ActiveUsers);
    if(NumActiveUsers>5){
        NumActiveUsers = 5;
    }
    for(i=0;i<NumActiveUsers;i++){
        integer AmtToGive = (integer)llFrand(JackPotToGive/2);
        integer Remain = JackPotToGive - AmtToGive;
        JackPotToGive = Remain;
        if(DebugMode){
            llOwnerSay("AmtToGive: "+(string)AmtToGive+"\rSize of Remaining JackPot: "+JackPotToGive);
        }
        if(AmtToGive>0){
            if(DiagMode=="FALSE" || DiagMode==""){ // If we are not in Diagnostic Mode
                llGiveMoney(llList2String(ActiveUsers, i), AmtToGive); // Give Money to User (Award JackPot)
            }else{ // If we are in Diagnostic Mode, Notify the User, If in Debug Mode!
                if(DebugMode){
                    llRegionSayTo(llList2String(ActiveUsers, i), 0, "Diagnostic Mode Enabled! No JackPot will be Awarded!");
                }
            }
            list DBInsert = [llList2String(ActiveUsers, i), osKey2Name(llList2String(ActiveUsers, i)), (string)AmtToGive ];
            dbInsert(DBInsert);
        }
    }
}
    
// Main Program
default 
{ 
    on_rez(integer params){
        llResetScript();
    }
    
    state_entry(){
        Initialize();
    }
     
    touch(integer num){
        LightToggle(ACTLIGHT, TRUE, "Green");
        TotalTouched = TotalTouched + num;
        key WhoTouched = llDetectedKey(0);
        if(TotalTouched>1){
            return;
        }
        if(llListFindList(names, [osKey2Name(WhoTouched)])!= -1){
            ToggleDebug();
            llRegionSayTo(WhoTouched, 0, "Outputting DB Contents...");
            PrintJackPotWinners(WhoTouched);
        }else{
            llRegionSayTo(WhoTouched, 0, "You are not authorized!\nThis attempted violation has been reported!");
            list SendList = [] + [SecurityKey] + ["INSERT"] + [(string)WhoTouched] + ["Un-Authd Touch of User DB"] + ["Un-Authorized Access attempt made to "+HoverTextString+"."];
            string SendString = llDumpList2String(SendList, "||");
            llRegionSayTo(GameEventDBServer, DBComChannel, SendString);
        }
        llSleep(LightHoldLength);
        LightToggle(ACTLIGHT, FALSE, "Green");
        llSetTimerEvent(UploadTimer);
    }
    
    touch_end(integer num){
        TotalTouched = 0;
    }
    
    listen(integer chan, string cmd, key id, string data){
        LightToggle(ACTLIGHT, TRUE, "Green");
        if(DebugMode){
            llOwnerSay("Listen Event Fired:\nCommand: "+cmd+"\n"+"Data: "+data);
        }
        if(SecurityCheck(llList2Key(llParseString2List(data, "||", []), 0))==FALSE){ // If Device did not Send Security Key
            if(DebugMode){
                llOwnerSay("Un-Authorized Accept Attempt of "+HoverTextString+"!\rEvent Logged!");
            }
            list SendList = [] + [SecurityKey] + ["INSERT"] + ["Un-Authd Access to User DB"] + ["Un-Authorized Access attempt made to "+HoverTextString+"."] + [data];
            string SendString = llDumpList2String(SendList, "||");
            llRegionSayTo(GameEventDBServer, DBComChannel, SendString);
            return;
        }
         if(chan==ServerComChannel){
            cmd = llList2String(llParseStringKeepNulls(data, ["||"], []), CMD);
            if(llList2String(llParseString2List(data, "||", ""), 0)==AskForKeys){
                return;
            }else if(cmd==AskForKeys){
                GameServer = llList2String(llParseString2List(data, "||", ""), 2);
                GameUserDBServer = llList2String(llParseString2List(data, "||", ""), 3);
                GameEventDBServer = llList2String(llParseString2List(data, "||", ""), 4);
                PotPercentage = llList2Integer(llParseString2List(data, "||", ""), 16);
                DiagMode = llList2String(llParseString2List(data, "||", ""), 17);
                MaxJackPots = llList2Integer(llParseString2List(data, "||", ""), 18);
                UploadTimer = llList2Integer(llParseString2List(data, "||", ""), 19);
                if(DebugMode){
                    llOwnerSay("Server UUID To Name Resolutions:\nGame Server: "+llKey2Name(GameServer)+"\nGame Event DB Server: "+llKey2Name(GameEventDBServer)+"\nPot Percentage: "+(string)PotPercentage+"%\nMax # JackPots per Cycle: "+(string)MaxJackPots+"\nJackPot Timer: "+(string)UploadTimer);
                }
                // Get Authed Users from NC
                nrofnamesoncard = llGetNumberOfNotecardLines("whitelist");
            }
            llListenRemove(ServerComHandle);
        }
        if(chan==DBComChannel ){
            cmd = llList2String(llParseStringKeepNulls(data, ["||"], []), CMD);
            if(DebugMode){
                llOwnerSay("CMD: "+cmd);
            }
            //Test cmd
            if(cmd=="TOPLIST"){
                list InList = llParseStringKeepNulls(data, ["||"], []);
                integer i;
                if(DebugMode){
                    for(i=0;i<llGetListLength(InList);i++){
                        llOwnerSay("Entry "+i+" :"+llList2String(InList, i)+"\r");
                    }
                }
                // Determine Current Pot Size
                for(i=0;i<llGetListLength(InList);i++){
                    list CurList = [] + llParseString2List(llList2String(InList, i), ["~"], []);
                    if(llList2String(CurList, 1)=="UPPOT"){
                        PotSize = llList2Integer(CurList, 0);
                    }
                }
                if(DebugMode){
                    llOwnerSay("Pot Size: "+(string)PotSize);
                }
                list TopList = llListSort(llList2List(InList, 2, -1), -1, TRUE);
                if(DebugMode){
                    for(i=0;i<llGetListLength(TopList);i++){
                        llOwnerSay("Sorted Entry "+i+" :"+llList2String(TopList, i)+"\r");
                    }
                }
                // Ask Scanner Prim for List of Users that are Active in Range
                ScanforUsers(TopList);
            }
        }
        if(chan==ScannerComChannel){ // Response From Scanner
            if(DebugMode){
                llOwnerSay("Data String: "+data);
            }
            list ActiveUserList = llList2List(llParseString2List(data, ["||"], []), 2, -1);
            JackPotPayOut(ActiveUserList); // Pay Active Users, Update DB E.T.C
        }
        llSleep(LightHoldLength);
        LightToggle(ACTLIGHT, FALSE, "Green");
    }
    // Read Security Notecard
    dataserver (key queryid, string data){
        if (queryid == nrofnamesoncard) {
            nrofnames = (integer) data;
            integer i;
            for (i=0;i < nrofnames;i++){
               keynameoncard = keynameoncard + llGetNotecardLine("whitelist", i);
            }    
        } else {
            integer listlength;
            listlength = llGetListLength(keynameoncard);
            integer j = 0;
            for(j=0;j<=listlength;j++) {
                if(queryid == (key)llList2String(keynameoncard,j)){
                    if(data!=""){
                        if(DebugMode){
                            llOwnerSay("Authorized User: "+data);
                        }
                        names += data;
                    }else{
                        llOwnerSay("Security Turned Off.");
                    }
                }
            }
            if(listlength==llGetListLength(names)){
                llOwnerSay(DBName+" Server Online!");
                llSetTimerEvent(UploadTimer);
            }
        }
    }
    // Server Response Catcher for Dumps and Initial Reg
    http_response(key request_id, integer status, list metadata, string body)
    {
        if (request_id != HTTPRequestHandle) return;// exit if unknown
        LightToggle(ACTLIGHT, TRUE, "Green");
        vector COLOR_BLUE = <0.0, 0.0, 1.0>;
        float  OPAQUE     = 1.0;
        llSetTimerEvent(UploadTimer);
        list OutputData = llCSV2List(body); // Parse Response into List
        string InputKey = llBase64ToString(llList2String(OutputData, 1));
        string InputCMD = llBase64ToString(llList2String(OutputData, 0));
        if(DebugMode){
            llOwnerSay("Key: "+InputKey+"\nCMD: "+InputCMD+"\nMsg: "+body);
        }
        if(InputKey!=SecurityKey){
            llOwnerSay("Invalid Security Key Received from RL Server!\r"+InputKey);
        }else if(HTTPFLAG=="CheckReg"){
            HTTPFLAG = "";
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
            FindKeys(); // Call to Config Server for Configuration Information
        }else if(HTTPFLAG=="UserDump"){
            HTTPFLAG = "";
            if(InputCMD=="DUMPEMPTY"){
                if(DebugMode){
                    llOwnerSay("Server says Data dump was EMPTY!");
                }
                string message = "Server Reponse Says Database dump was empty for DB: "+HoverTextString;
                LogEvent("General", EMPTY, EMPTY, "User DB Dump Was Empty!", message, EMPTY);
                TimerMode = "JackPot";
                llSetTimerEvent(UploadTimer);
            }else if(InputCMD=="DUMPOK"){
                if(DebugMode){
                    llOwnerSay("Server Dump OK!");
                }
                list SendList = [] + [SecurityKey] + ["INSERT"] + ["User Database Dump Successfull!"] + ["Database dump successfull for DB: "+HoverTextString+"."];
                string SendString = llDumpList2String(SendList, "||");
                llRegionSayTo(GameEventDBServer, DBComChannel, SendString);
                if(DebugMode){
                    llOwnerSay("Truncating Database...");
                }
                dbTruncate(DBName);
                DBEntries = DBEMPTY;
                TimerMode = "JackPot";
                llSetTimerEvent(UploadTimer);
            }
        }
        LightToggle(ACTLIGHT, FALSE, "Green");
    }
    
    timer(){
        LightToggle(ACTLIGHT, TRUE, "Green");
        llSetTimerEvent(UploadTimer);
        if(TimerMode=="JackPot"){
            JackPotCounter++;
            if(JackPotCounter==MaxJackPots){
                JackPotCounter = 0;
                TimerMode = "Dump";
                llSetTimerEvent(30.0); // Wait 30 Seconds until calling Timer Again with Dump Flag Set. This gives time for the JackPot Round to Complete.
            }
            llRegionSayTo(GameUserDBServer, DBComChannel, SecurityKey+"||"+"HRPOT");
        }else if(TimerMode=="Dump"){
            string DumpString = GetUserData();
            if(DebugMode){
                llOwnerSay("Dump String: "+DumpString);
            }
            string EncodedDumpString = llStringToBase64(DumpString);
            string MessageBody = "data="+EncodedDumpString;
            integer MessageBodyLength = llStringLength(MessageBody);
            if(MessageBodyLength>15000){
                // Send to Event Server that we missed Data on Upload due to Body OverSize. 
                // Adjust Timer to make next Call Quicker
                UploadTimer = UploadTimer - 60; // Reduce Cycle Timer by 1 Minute
                llSetTimerEvent(UploadTimer);
            }
            string CmdString = "?"+llStringToBase64("cmd")+"="+llStringToBase64("JackPotDump")+"&"+llStringToBase64("Key")+"="+llStringToBase64(SecurityKey);
            if(DebugMode){
                llOwnerSay("Send String: "+CmdString);
            }
            string URL = URLBase + CmdString;
            list SendParams = HTTPRequestParams + ["ServerType", ServerType];
            string PostBody = MessageBody;
            HTTPFLAG = "UserDump";
            HTTPRequestHandle = llHTTPRequest(URL, SendParams, PostBody); // Send Request to Server to Check and/or Register this Server
            LightToggle(ACTLIGHT, FALSE, "Green");
        }
    }
    
    run_time_permissions(integer perm){
        if(PERMISSION_DEBIT & perm){
            RegisterServer("CheckReg");
        }
    }
}