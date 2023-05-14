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
string DBName = "HeavenAndHellEvents"; // Database for Heaven and Hell Player Info
string HoverTextString = "Heaven And Hell\n Event Database"; // Base String Name of Databse Engine
string EMPTY = "";
key SecurityKey = "UserYourOwnKey";
integer BasePotAmt = 100;
float LightHoldLength = 0.1;
float UploadTimer = 1800;
string ServerType = "EVENT"; // Defines to Remote Server what type of table to build. Send as header in register request. (USERDB, EVENT, JACKPOT, Main)
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
integer UUID = 0;
integer NAME = 1;
integer EVENTTYPE = 2;
integer MESSAGE = 3;
integer DATA = 4;

    // Switches
integer DebugMode = FALSE; // Should we say Debug Messages to Owner?

    // Variables
integer DBComHandle; // Database Communication Handle
integer DBEntries = 0; // NUmber of Database Entries
integer TotalTouched = 0;
string HTTPFLAG = "";
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
        llOwnerSay("Initializing "+DBName+"...");
    }
    nrofnamesoncard = llGetNumberOfNotecardLines("whitelist");
    llListenRemove(DBComHandle);
    llSleep(0.1);
    DBComHandle = llListen(DBComChannel, EMPTY, EMPTY, EMPTY);
    string CreatedDB = dbCreate(DBName, ["uuid", "theirip", "name", "eventtype", "message", "data"]);
    if(CreatedDB==DBName && DebugMode){
        llOwnerSay("Database "+DBName+" Created...");
    }
    LightToggle(PWRLIGHT, TRUE, "Red");
    LightToggle(ACTLIGHT, TRUE, "Green");
    llSleep(LightHoldLength);
    LightToggle(ACTLIGHT, FALSE, "Green");
    llSetTimerEvent(UploadTimer);
    RegisterServer("CheckReg");
//  llOwnerSay(DBName+" Server Online!");
}

// Check key if any incoming request and validate against Security Key
integer SecurityCheck(key CheckID){
    if(CheckID!=SecurityKey){
        // Send Access Log Entry to Security Logging Server
        return FALSE;
    }else{
        return TRUE;
    }
}

DumpRecentEvents(string uuid){
    integer i;
    for(i=1;i<=DBEntries;i++){
        list CurrentLine = dbGet(i);
        llRegionSayTo(uuid, 0,
        "Event ID: "+(string)i+"\n
        UUID: "+llList2String(CurrentLine, 0)+"\n
        Name: "+llList2String(CurrentLine, 2)+"\n
        Event Type: "+llList2String(CurrentLine, 3)+"\n
        Message: "+llList2String(CurrentLine, 4)+"\n
        Data: "+llList2String(CurrentLine, 5)
        );
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

string GetEventData(){
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

RegisterServer(string cmd){
     if(cmd=="CheckReg"){
        string CmdString = "?"+llStringToBase64("cmd")+"="+llStringToBase64("CheckReg")+"&"+llStringToBase64("Key")+"="+llStringToBase64(SecurityKey);
        string URL = URLBase + CmdString;
        list SendParams = HTTPRequestParams + ["ServerType", ServerType];
        HTTPFLAG = "CheckReg";
        HTTPRequestHandle = llHTTPRequest(URL, SendParams, ""); // Send Request to Server to Check and/or Register this Server
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
        if(TotalTouched>1){
            return;
        }
        ToggleDebug();
        key WhoTouched = llDetectedKey(0);
        if(llListFindList(names, [osKey2Name(WhoTouched)])==-1){
            llRegionSayTo(WhoTouched, 0, "Un-Authorized Access Attempted Logged!");
            dbInsert([WhoTouched, "", osKey2Name(WhoTouched), "Un-Authed Touch!", "Somebody tried to touch the server who was not authorized", ""]);
            return;
        }
        llRegionSayTo(WhoTouched, 0, "Dumping Events to Local Chat...");
        DumpRecentEvents(WhoTouched);
        llSleep(LightHoldLength);
        LightToggle(ACTLIGHT, FALSE, "Green");
    }
    
    touch_end(integer num){
        TotalTouched = 0;
    }
    
    listen(integer chan, string cmd, key id, string data){
        LightToggle(ACTLIGHT, TRUE, "Green");
        list InputData = llParseStringKeepNulls(data, ["||"], []);
        if(DebugMode){
            llOwnerSay("Listen Event Fired:\nCommand: "+cmd+"\n"+"Data: "+data);
        }
        if(SecurityCheck(llList2Key(InputData, 0))==FALSE && data != ""){ // If Device did not Send Security Key
            dbInsert(["THISOBJ", "", llGetObjectName(), "Invalid Security Key!", "External Caller '"+cmd+"' did not provide valid Security Key.", data]);
            if(DebugMode){
                llOwnerSay("Security Error writing to User Database!");
            }
            return;
        }
        if(chan==DBComChannel ){
            cmd = llList2String(InputData, 1);
            if(cmd=="INSERT"){
                if(DebugMode){ // If Debug Mode is TRUE
                    llOwnerSay(cmd+" Command Received!");
                    integer i; // Integer  for Counting
                    for(i=0;i<=llGetListLength(InputData)-1;i++){ // Loop Based on List Length (Adjusted for 0 Offset)
                        llOwnerSay("Processed Input Line: "+llList2String(InputData, i)+" "+osKey2Name(llList2Key(InputData, i))); // Print Each Value in the list
                    }
                }
                // Insert New Data
                list InsertList = llList2List(InputData, 2, -1);
                if(DebugMode){
                    llOwnerSay("Attempting to Insert New Event...");
                }
                integer Inserted = dbInsert([
                    llList2String(InsertList, 0), 
                    "",
                    osKey2Name(llList2String(InsertList, 0)),
                    llList2String(InsertList, 1),
                    llList2String(InsertList, 2),
                    llList2String(InsertList, 3)
                ]);
                if(Inserted && DebugMode){
                    llOwnerSay("Record Inserted!");
                }else if(!Inserted && DebugMode){
                    llOwnerSay("Error Inserting New Event Record!");
                }
                DBEntries++;
            }
        }
        llSleep(LightHoldLength);
        LightToggle(ACTLIGHT, FALSE, "Green");
    }
    // Read Security Notecard
    dataserver (key queryid, string data){
        if (queryid == nrofnamesoncard) 
        {
            nrofnames = (integer) data;
            integer i;
            for (i=0;i < nrofnames;i++){
               keynameoncard = keynameoncard + llGetNotecardLine("whitelist", i);
            }    
        } else 
        {
            integer listlength;
            listlength = llGetListLength(keynameoncard);
            integer j;
            for(j=0;j<listlength;j++) {
                if (queryid == (key) llList2String(keynameoncard,j))
                {
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
        }
    }
    
    // Server Response Catcher for Dumps and Initial Reg
    http_response(key request_id, integer status, list metadata, string body)
    {
        if (request_id != HTTPRequestHandle) return;// exit if unknown
 
        vector COLOR_BLUE = <0.0, 0.0, 1.0>;
        float  OPAQUE     = 1.0;
        llSetTimerEvent(UploadTimer);
        list OutputData = llCSV2List(body); // Parse Response into List
        string InputKey = llBase64ToString(llList2String(OutputData, 1));
        string InputCMD = llBase64ToString(llList2String(OutputData, 0));
        if(DebugMode){
            llOwnerSay("Key: "+InputKey+"\nCMD: "+InputCMD);
        }
        if(InputKey!=SecurityKey){
            llOwnerSay("Invalid Security Key Received from RL Server!\r"+InputKey);
        }else if(HTTPFLAG=="CheckReg"){
            HTTPFLAG = "";
            if(InputCMD=="ALRDYREGOK"){ // Server Already Registered
                if(DebugMode){
                    llOwnerSay("Server Already Registered!");
                }
                llOwnerSay(DBName+" Server Online!");
            }else if(InputCMD=="REGOK"){ // Server Successfully Registered
                if(DebugMode){
                    llOwnerSay("Server Successfully Registered!");
                    llOwnerSay(DBName+" Server Online!");
                }
            }else if(InputCMD=="REGERR"){ // Error Registering Server with Off-World Database
                llOwnerSay("Error Registering Server with Database!");
            }else if(InputCMD=="CHECKERR"){ // Error Checking Database for Server Registration
                llOwnerSay("Error Checking Database for Server Registration");
            }else{
                llOwnerSay("Response from server not reconignized!");
            }
        }else if(HTTPFLAG=="EventDump"){
            HTTPFLAG = "";
            if(InputCMD=="DUMPEMPTY"){
                if(DebugMode){
                    llOwnerSay("Server says Event Dump was EMPTY!");
                }
                llSetTimerEvent(UploadTimer);
            }else if(InputCMD=="DUMPOK"){
                if(DebugMode){
                    llOwnerSay("Server Dump OK!");
                }
                if(DebugMode){
                    llOwnerSay("Truncating Database...");
                }
                dbIndex = 1;
                dbTruncate(DBName);
                DBEntries = 1;
                llSetTimerEvent(UploadTimer);
            }
        }
    }
    
    timer(){
        llSetTimerEvent(UploadTimer);
        LightToggle(ACTLIGHT, TRUE, "Green");
        string DumpString = GetEventData();
        string EncodedDumpString = llStringToBase64(DumpString);
        string MessageBody = "data="+EncodedDumpString;
        integer MessageBodyLength = llStringLength(MessageBody);
        if(MessageBodyLength>15000){
            // Adjust Timer to make next Call Quicker
            UploadTimer = UploadTimer - 60; // Reduce Cycle Timer by 1 Minute
            dbInsert(["THISOBJ", "", "Excess Dump Length", "Event Dump String Exceeded 15KB, Some upload data has been lost in this dump. Reducing Upload Timer by 60 Seconds. Timer Now: "+(string)UploadTimer, ""]);
            llSetTimerEvent(UploadTimer);
        }
        string CmdString = "?"+llStringToBase64("cmd")+"="+llStringToBase64("EventDump")+"&"+llStringToBase64("Key")+"="+llStringToBase64(SecurityKey);
        string URL = URLBase + CmdString;
        list SendParams = HTTPRequestParams + ["Servertype", ServerType];
        string PostBody = MessageBody;
        HTTPFLAG = "UserDump";
        HTTPRequestHandle = llHTTPRequest(URL, SendParams, PostBody); // Send Request to Server to Check and/or Register this Server
        LightToggle(ACTLIGHT, FALSE, "Green");
    }
}