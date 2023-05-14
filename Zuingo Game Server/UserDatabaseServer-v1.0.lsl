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
integer DBComChannel = -260002;
integer ServerComChannel = -63473672;
integer ServerComHandle;
string DBName = "GunsCarsAndGirlsUserDatabase"; // Database for Heaven and Hell Player Info
string HoverTextString = "Guns Cars and Girls\n User Database"; // Base String Name of Databse Engine
string EMPTY = "";
key SecurityKey = "3d7b1a28-f547-4d10-8924-7a2b771739f4";
key GameServer = "";
key GameEventDBServer = "";
integer BasePotAmt = 100;
float LightHoldLength = 0.1;
string AskForKeys = "TheKeyIs(Mq=h/c2)";
integer UploadTimer = 3720; // Frequency in Seconds of User Database Upload
integer DBEMPTY = 1;
    // Off-World Data Communication Constants
key HTTPRequestHandle; // Handle for HTTP Request
string URLBase = "http://api.orbitsystems.ca/api.php";
list HTTPRequestParams = [
    HTTP_METHOD, "POST",
    HTTP_MIMETYPE, "application/x-www-form-urlencoded",
    HTTP_BODY_MAXLENGTH, 16384,
    HTTP_CUSTOM_HEADER, "CUSKEY", "TheKeyIs(Mq=h/c2)"
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
integer DebugMode = TRUE; // Should we say De bug Messages to Owner?

    // Variables
integer DBComHandle; // Database Communication Handle
integer DBEntries = 1; // NUmber of Database Entries
integer TotalTouched = 0;
string HTTPFLAG = ""; // Hold Flag to know what last HTTP Resquest was for

// NoteCard Reader
key nrofnamesoncard;
integer nrofnames;
list names;
list keynameoncard;
string nameoncard;
string storedname;

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
    llSleep(0.1);
    DBComHandle = llListen(DBComChannel, EMPTY, EMPTY, EMPTY);
    ServerComHandle = llListen(ServerComChannel, EMPTY, EMPTY, EMPTY);
    string CreatedDB = dbCreate(DBName, ["uuid", "name", "played", "won", "spent", "wins", "loses"]);
    if(CreatedDB==DBName && DebugMode){
        llOwnerSay("Database "+DBName+" Created...");
        llOwnerSay("Creating Pot Entry...");
    }
    dbInsert(["UPPOT", "100", "0", "0", "0", "0", "0"]);
//    dbInsert(["3d7b1a28-f547-4d10-8924-7a2b771739f4", "0", "0", "0", "5", "0", "0"]);
//    dbInsert(["3d7b1a28-f547-4d10-8924-7a2b771739f4", "0", "0", "0", "12", "0", "0"]);
//    dbInsert(["3d7b1a28-f547-4d10-8924-7a2b771739f4", "0", "0", "0", "32", "0", "0"]); 
    DBEntries = 1;
    LightToggle(PWRLIGHT, FALSE, "Red");
    llSleep(LightHoldLength);
    LightToggle(PWRLIGHT, TRUE, "Red");
    LightToggle(ACTLIGHT, TRUE, "Green");
    llSleep(LightHoldLength);
    LightToggle(ACTLIGHT, FALSE, "Green");
    RegisterServer("CheckReg");
}

FindKeys(){
    llOwnerSay("Finding Keys...");
    llRegionSay(ServerComChannel, AskForKeys);
}

RegisterServer(string cmd){
     if(cmd=="CheckReg"){
        string CmdString = "?"+llStringToBase64("cmd")+"="+llStringToBase64("CheckReg")+"&"+llStringToBase64("Key")+"="+llStringToBase64(SecurityKey);
        string URL = URLBase + CmdString;
        list SendParams = HTTPRequestParams + ["ServerType", "USERDB"];
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
    dbIndex = 2;
    string ReturnString = "";
    for(dbIndex=2;dbIndex<=DBEntries;dbIndex++){
        list CurrentLine = dbGet(dbIndex);
        
        if(llList2String(CurrentLine, 0)==""){ return ReturnString; }
        
        string CompiledString = llList2String(CurrentLine, 0)+"||"+llList2String(CurrentLine, 1)+"||"+llList2String(CurrentLine, 2)+"||"+llList2String(CurrentLine, 3)+"||"+llList2String(CurrentLine, 4)+"||"+llList2String(CurrentLine, 5)+"||"+llList2String(CurrentLine, 6)+",";
        ReturnString = ReturnString + CompiledString;
    }
    return ReturnString;
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
            dbIndex = 1;
            for(dbIndex=1;dbIndex<=DBEntries;dbIndex++){
                list CurrentLine = dbGet(dbIndex);
                llRegionSayTo(WhoTouched, 0, "Played Users:\n" + 
                "UUID: " + llList2String(CurrentLine, 0) + "\n" +
                "Name: " + llList2String(CurrentLine, 1) + "\n" +
                "Played: " + llList2String(CurrentLine, 2) + "\n" +
                "Won: " + llList2String(CurrentLine, 3) + "\n" +
                "Spent: " + llList2String(CurrentLine, 4) + "\n" +
                "Wins: " + llList2String(CurrentLine, 5) + "\n" +
                "Loses: " + llList2String(CurrentLine, 6) + "\n");
            }
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
            }else if(cmd==AskForKeys){ // Read Configuration Data and Configure Script Parameters
                GameServer = llList2String(llParseString2List(data, "||", ""), 2);
                GameEventDBServer = llList2String(llParseString2List(data, "||", ""), 4);
                BasePotAmt = llList2Integer(llParseString2List(data, "||", ""), 20);
                UploadTimer = llList2Integer(llParseString2List(data, "||", ""), 21);
                if(DebugMode){
                    llOwnerSay("Server UUID To Name Resolutions:\nGame Server: "+llKey2Name(GameServer)+"\nGame Event DB Server: "+llKey2Name(GameEventDBServer)+"\nBase JackPot Amount: "+(string)BasePotAmt+"\nUpload Timer: "+(string)UploadTimer);
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
            if(cmd=="UPDATE"){
                list InputData = llParseStringKeepNulls(data, ["||"], []);
                if(DebugMode){ // If Debug Mode is TRUE
                    integer i; // Integer  for Counting
                    for(i=0;i<=llGetListLength(InputData)-1;i++){ // Loop Based on List Length (Adjusted for 0 Offset)
                        llOwnerSay("Processed Input Line: "+(string)i+" "+llList2String(InputData, i)); // Print Each Value in the list
                    }
                }
                if(dbExists(["uuid", "==", llList2String(InputData, UUID)])){ // UUID Already Exists in DB so we Need to Extract Info and Update
                    if(DebugMode){ // IF Debug Mode output
                        llOwnerSay("User Found, Extracting Info for Update...");
                    }
                    list dbRow = dbGet(dbIndex); // Get Current Entry
                    string uuid = llList2String(dbRow, 0); // Extract UUID From Entry
                    string name = llList2String(dbRow, 1); // Extract Name From Entry
                    integer played = llList2Integer(dbRow, 2); // Extract Number of Times Played
                    played = played + llList2Integer(InputData, PLAYED); // Adjust Value by Input Amount
                    integer won = llList2Integer(dbRow, 3); // Extract Amount of P$ Won
                    won = won + llList2Integer(InputData, WON); // Adjust Value by Input Amount
                    integer spent = llList2Integer(dbRow, 4); // Extract Amount of P$ Spent
                    spent = spent + llList2Integer(InputData, SPENT); // Adjust Value by Input Amount
                    integer wins = llList2Integer(dbRow, 5); // Extract Number of Times Won
                    wins = wins + llList2Integer(InputData, WINS); // Adjust Value by Input Amount
                    integer loses = llList2Integer(dbRow, 6); // Extract Number of Times Lost
                    loses = loses + llList2Integer(InputData, LOSES); // Adjust Value by Input Amount
                    dbPut([uuid, name, played, won, spent, wins, loses]); // Update Entry
                    if(DebugMode){ // If Debug Output
                        llOwnerSay("Update Performed for UUID: "+uuid);
                        list newRow = dbGet(dbIndex);
                        llOwnerSay("New Record:\r
                        UUID: "+llList2String(newRow, 0)+"\r
                        Username: "+llList2String(newRow, 1)+"\r
                        Times Played: "+llList2String(newRow, 2)+"\r
                        P$ WON: "+llList2String(newRow, 3)+"\r
                        P$ SPENT: "+llList2String(newRow, 4)+"\r
                        Times Won: "+llList2String(newRow, 5)+"\r
                        Times Lost: "+llList2String(newRow, 6));
                    }
                }else{ // User has not played since last off-world backup. Just Insert New Record
                    if(DebugMode){
                        llOwnerSay("Inserting New Record for UUID: "+llList2String(InputData, UUID));
                    }
                    dbInsert([
                        llList2String(InputData, UUID),
                        osKey2Name(llList2Key(InputData, UUID)),
                        llList2Integer(InputData, PLAYED),
                        llList2Integer(InputData, WON),
                        llList2Integer(InputData, SPENT),
                        llList2Integer(InputData, WINS),
                        llList2Integer(InputData, LOSES)
                    ]);
                    DBEntries = DBEntries + 1;
                }
            }else if(cmd=="UPPOT"){
                list InputData = llParseStringKeepNulls(data, ["||"], []);
                if(dbExists(["uuid", "==", "UPPOT"])){ // Check for and Move Pointer to Pot Index (If DB Line Exists)
                    list dbRow = dbGet(dbIndex); // Get Row
                    integer NewPot = llList2Integer(dbRow, CMD) + llList2Integer(InputData, 2); // AdjustPot
                    dbPut(["UPPOT", (integer)NewPot, "0", "0", "0", "0", "0"]); // Place back into DB
                    if(DebugMode){
                        llOwnerSay("Pot Updated...");
                        list NewList = dbGet(dbIndex);
                        llOwnerSay(llDumpList2String(NewList, "||"));
                        return;
                    }
                }
            }else if(cmd=="CLRPOT"){
                if(dbExists(["uuid", "==", "UPPOT"])){ // Check for and Move Pointer to Pot Index
                    list InputData = llParseStringKeepNulls(data, ["||"], []);
                    if(llList2Integer(InputData, 2)<BasePotAmt){
                        dbPut(["UPPOT", BasePotAmt, "0", "0", "0", "0", "0"]);
                    }else{
                        dbPut(["UPPOT", llList2Integer(InputData, 2), "0", "0", "0", "0", "0"]);
                    }
                    if(DebugMode){
                        llOwnerSay("Cleared pot by adjustment.");
                    }
                }else{
                    dbInsert(["UPPOT", BasePotAmt, "0", "0", "0", "0", "0"]);
                    if(DebugMode){
                        llOwnerSay("Cleared pot by Insert");
                    }
                }
            }else if(cmd=="GetPot"){
                integer dbIndexBKP = dbIndex;
                dbIndex = DBEMPTY;
                list JackPot = dbGet(dbIndex);
                dbIndex = dbIndexBKP;
                string SendString = "CurPot||"+llList2String(JackPot, 1);
                if(DebugMode){
                    llOwnerSay("Sending GETPOT Response: "+SendString);
                }
                llRegionSayTo(id, chan, SendString);
            }else if(cmd=="HRPOT"){ // If Hourly JackPot Server is Calling (Give i s List of Sorted Top Spenders and JackPot Total)
                dbIndex = 1; // Set Database Inquiry Start Point
                list UnSortedOutPut = []; // Prepare Output List
                for(dbIndex=1;dbIndex<=DBEntries;dbIndex++){ // Loop for all DB Entires
                    list CurrentLine = dbGet(dbIndex); // Extract Current DB Entry into List
                    if(llList2String(CurrentLine, 0)!="UPPOT"){
                        UnSortedOutPut = UnSortedOutPut + [llList2String(CurrentLine, 4) + "~" + llList2String(CurrentLine, 0)]; // Extract Spent and UUID and Place into List
                    }else{
                        UnSortedOutPut = UnSortedOutPut + [llList2String(CurrentLine, 1) + "~" + llList2String(CurrentLine, 0)]; // Extract Spent and UUID and Place into List
                    }
                }
                list SortedOutPut = llListSort(UnSortedOutPut, 1, FALSE); // Sort the UnSortedOutPut and place into SortedOutPut
                if(DebugMode){
                    llOwnerSay("\n\t\tList of Top Spenders:\r"+llDumpList2String(SortedOutPut, "||"));
                }
                string FormattedOutPut = llDumpList2String(SortedOutPut, "||");
                llRegionSayTo(id, DBComChannel, SecurityKey+"||TOPLIST||"+FormattedOutPut);
                dbIndex = DBEMPTY;
                list JackPot = dbGet(dbIndex);
                dbTruncate(DBName);
                dbInsert(JackPot);
                DBEntries = DBEMPTY;
            }
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
                        names = names + data;
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
            FindKeys();
        }else if(HTTPFLAG=="UserDump"){
            HTTPFLAG = "";
            if(InputCMD=="DUMPEMPTY"){
                if(DebugMode){
                    llOwnerSay("Server says Data dump was EMPTY!");
                }
                list SendList = [] + [SecurityKey] + ["INSERT"] + ["User DB Dump Was Empty!"] + ["Server Reponse Says Database dump was empty for DB: "+HoverTextString+"."];
                string SendString = llDumpList2String(SendList, "||");
                llRegionSayTo(GameEventDBServer, DBComChannel, SendString);
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
                dbIndex = 1;
                list JackPot = dbGet(dbIndex);
                if(DebugMode){
                    llOwnerSay("JackPot Dump: "+llDumpList2String(JackPot, "||"));
                }
                dbTruncate(DBName);
                dbInsert(JackPot);
                DBEntries = 1;
                llSetTimerEvent(UploadTimer);
            }
        }
        LightToggle(ACTLIGHT, FALSE, "Green");
    }
    
    timer(){
        LightToggle(ACTLIGHT, TRUE, "Green");
        llSetTimerEvent(UploadTimer);
        string DumpString = GetUserData();
        string EncodedDumpString = llStringToBase64(DumpString);
        string MessageBody = "data="+EncodedDumpString;
        integer MessageBodyLength = llStringLength(MessageBody);
        if(MessageBodyLength>15000){
            // Send to Event Server that we missed Data on Upload due to Body OverSize.
            // Adjust Timer to make next Call Quicker
            UploadTimer = UploadTimer - 60; // Reduce Cycle Timer by 1 Minute
            llSetTimerEvent(UploadTimer);
        }
        string CmdString = "?"+llStringToBase64("cmd")+"="+llStringToBase64("UserDump")+"&"+llStringToBase64("Key")+"="+llStringToBase64(SecurityKey);
        if(DebugMode){
            llOwnerSay("Send String: "+CmdString);
        }
        string URL = URLBase + CmdString;
        list SendParams = HTTPRequestParams + ["ServerType", "USERDB"];
        string PostBody = MessageBody;
        HTTPFLAG = "UserDump";
        HTTPRequestHandle = llHTTPRequest(URL, SendParams, PostBody); // Send Request to Server to Check and/or Register this Server
        LightToggle(ACTLIGHT, FALSE, "Green");
    }
}