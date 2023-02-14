// Game Server Relay Engine v1.0
// Created by Tech Guy


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
integer ComChannel = -63473670; // Secret Negative Channel for Server Communication
integer UnitComChannel; // Channel Used to Communicate with Furniture inside Unit
list KEYS = [ "5b8c8de4-e142-4905-a28f-d4d00607d3e9", "b9dbc6a4-2ac3-4313-9a7f-7bd1e11edf78", "dbfa0843-7f7f-4ced-83f6-33223ae57639" ];
list Admins = [];
string EMPTY = "";
key SecurityKey = "3d7b1a28-f547-4d10-8924-7a2b771739f4";
float LightHoldLength = 0.1;
string SecureRequest = "TheKeyIs(Mq=h/c2)";
string cName = ".config"; // Name of Configuration NoteCard
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
    integer CFGLIGHT = 3;
    integer INLIGHT = 4;
    integer OUTLIGHT = 5;
    
    

    // Variables
integer ComHandle; // Hold Handle to Control Server Com Channel
integer cLine; // Holds Configuration Line Index for Loading Config Loop
key cQueryID; // Holds Current Configuration File Line during Loading Loop
string GameName = "";
string DBName = "Units";
integer DBEntries = 0;

    // Switches
integer DebugMode = TRUE; // Are we running in with Debug Messages ON?
    // Flags
    string OpFlag = "";

// User Database Configuration Directives
string UserUploadTimer;
    
    // Functions
    
// Debug Message
DebugMessage(string message){
    if(DebugMode){
        llOwnerSay(message);
    }
}

Initialize(){
    llListenRemove(ComHandle);
    llListen(ComChannel, EMPTY, EMPTY, EMPTY);
    // UNITID, PRICE, DISCOUNT, MINRENT, MAXRENT, RENTED, RENTERKEY, EXPIRE
    string CreatedDB = dbCreate(DBName, ["unitid", "price", "discount", "minrent", "maxrent", "rented", "renterkey", "expire", "prims", "texture"]);
    if(CreatedDB==DBName && DebugMode){
        llOwnerSay("Database "+DBName+" Created...");
    }
    DebugMessage("Configuring...");
    cQueryID = llGetNotecardLine(cName, cLine);
}

SystemStart(){
    llOwnerSay("System Online!");
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

// Add Admin (Add provided Legacy Name to Admins List after extrapolating userKey)
AddAdmin(string LegacyName){
    string FName = llList2String(llParseString2List(LegacyName, [" "], []), 0);
    string LName = llList2String(llParseString2List(LegacyName, [" "], []), 1);
    //DebugMessage("First Name: "+FName+" Last Name: "+LName);
    key UserKey = osAvatarName2Key(FName, LName);
    if(UserKey!=NULL_KEY){
        Admins = Admins + UserKey;
        DebugMessage("Added Admin: "+LegacyName);
    }else{
        DebugMessage("Unable to Resolve: "+LegacyName);
    }
}

// Check Security
integer CheckSecurity(key id){
    if(llListFindList(Admins, [id])!=-1){
        return TRUE;
    }else{
        return FALSE;
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
                        DebugMessage("Debug Mode: Enabled!");
                    }else if(value=="FALSE" || value=="false"){
                        DebugMode = FALSE;
                        llOwnerSay("Debug Mode: Disabled!");
                    }
                }else if(name=="comchannel"){
                    ComChannel = (integer)value;
                    if(ComHandle>0){
                        DebugMessage("Closing Old Com Channel...");
                        llListenRemove(ComHandle);
                        ComHandle = 0;
                    }
                    DebugMessage("Opening Com Channel ("+(string)ComChannel+")...");
                    ComHandle = llListen(ComChannel, EMPTY, EMPTY, EMPTY);
                    if(ComHandle>0){
                        DebugMessage("Com Channel Open!");
                    }
                }else if(name=="securitykey"){
                    SecurityKey = (key)value;
                    if(SecurityKey!=NULL_KEY){
                        DebugMessage("Inter Device Communications Key: "+(string)SecurityKey);
                    }else{
                        DebugMessage("Inter Device Communications Key NOT FOUND!");
                    }
                }else if(name=="unit"){
                    list InputData = llParseString2List(value, ["||"], []);
                    string UnitID = llList2String(InputData, 0);
                    integer Price = llList2Integer(InputData, 1);
                    float Discount = llList2Float(InputData, 2);
                    integer MinRent = llList2Integer(InputData, 3);
                    integer MaxRent = llList2Integer(InputData, 4);
                    integer Prims = llList2Integer(InputData, 5);
                    key Texture = llList2Key(InputData, 6);
                    DebugMessage("\nNew Unit Details: \nUnit ID: "+UnitID+"\nPrice: "+(string)Price+" /wk\nDiscount: "+(integer)Discount+" %\nMin Rental Time: "+(string)MinRent+" Week(s)\nMax Rental Time: "+(string)MaxRent+" Week(s)"+"\nMax Prims: "+(string)Prims+"\nImg Texture Key: "+(string)Texture);
                    // UNITID, PRICE, DISCOUNT, MINRENT, MAXRENT, RENTED, RENTERKEY, EXPIRE, PRIMS, Texture
                    DBEntries = dbInsert([UnitID, Price, Discount, MinRent, MaxRent, "FALSE", NULL_KEY, 0, Prims, Texture]);
                    //DebugMessage("DBEntries: "+(string)DBEntries);
                }else if(name=="admin"){
                    AddAdmin(value);
                }else if(name=="unitcomchannel"){
                    UnitComChannel = (integer)value;
                    DebugMessage("Unit Com Channel: "+(string)UnitComChannel);
                }
                LightToggle(CFGLIGHT, FALSE, "Orange");
        }else{ //  line does not contain equal sign
                llOwnerSay("Configuration could not be read on line " + (string)cLine);
            }
        }
    }
}

// Register Server with Off-World Database System (Also Sync)
RegisterServer(string cmd, list UnitData){
    if(cmd=="CheckReg"){
        DebugMessage("Registering Server...");
        OpFlag = cmd;
        string CmdString = "?"+llStringToBase64("cmd")+"="+llStringToBase64("CheckReg")+"&"+llStringToBase64("Key")+"="+llStringToBase64(SecurityKey);
        string URL = URLBase + CmdString;
        list SendParams = HTTPRequestParams + ["ServerType", "Rental"];
        HTTPRequestHandle = llHTTPRequest(URL, SendParams, ""); // Send Request to Server to Check and/or Register this Server
    }else if(cmd=="Sync"){
        DebugMessage("Syncing...");
        OpFlag = cmd;
        string CmdString = "?"+llStringToBase64("cmd")+"="+llStringToBase64(OpFlag)+"&"+llStringToBase64("Key")+"="+llStringToBase64(SecurityKey);
        string URL = URLBase + CmdString;
        list SendParams = HTTPRequestParams + ["ServerType", "Rental"];
        string DumpString = GetData();
        //llOwnerSay(DumpString);
        string EncodedDumpString = llStringToBase64(DumpString);
        string MessageBody = "data="+EncodedDumpString;
        integer MessageBodyLength = llStringLength(MessageBody);
        HTTPRequestHandle = llHTTPRequest(URL, SendParams, MessageBody); // Send Request to Server to Check and/or Register this Server
    }else if(cmd=="Update"){
        OpFlag = cmd;
        string CmdString = "?"+llStringToBase64("cmd")+"="+llStringToBase64(OpFlag)+"&"+llStringToBase64("Key")+"="+llStringToBase64(SecurityKey);
        string URL = URLBase + CmdString;
        list SendParams = HTTPRequestParams + ["ServerType", "Rental"];
        string DumpString = llDumpList2String(UnitData, "||");
        //llOwnerSay(DumpString);
        string EncodedDumpString = llStringToBase64(DumpString);
        string MessageBody = "data="+EncodedDumpString;
        integer MessageBodyLength = llStringLength(MessageBody);
        HTTPRequestHandle = llHTTPRequest(URL, SendParams, MessageBody); // Send Request to Server to Check and/or Register this Server
    }
}

// Get All Entires out of Database and Return them as String Formatted as such:
//  {UnitID}||{Price}||{Discount}||{MinRent}||{MaxRent}||{Rented}||{RenterKey}||{Expire}||{Prims}||{Texture},
string GetData(){
    dbIndex = 1;
    string ReturnString = "";
    for(dbIndex=1;dbIndex<=DBEntries;dbIndex++){
        list CurrentLine = dbGet(dbIndex);
        if(llList2String(CurrentLine, 0)==""){ return ReturnString; }
        // UNITID, PRICE, DISCOUNT, MINRENT, MAXRENT, RENTED, RENTERKEY, EXPIRE, PRIMS
        string UnitID = llList2String(CurrentLine, 0);
        string Price = llList2String(CurrentLine, 1);
        string Discount = (string)llList2Integer(CurrentLine, 2);
        string MinRent = llList2String(CurrentLine, 3);
        string MaxRent = llList2String(CurrentLine, 4);
        string Rented = llList2String(CurrentLine, 5);
        string RenterKey = llList2String(CurrentLine, 6);
        string Expire = llList2String(CurrentLine, 7);
        string Prims = llList2String(CurrentLine, 8);
        string Texture = llList2String(CurrentLine, 9) + ",";
        list TempList = [ UnitID, Price, Discount, MinRent, MaxRent, Rented, RenterKey, Expire, Prims, Texture];
        string CompiledString = llDumpList2String(TempList, "||");
        ReturnString = ReturnString + CompiledString;
    }
    return ReturnString;
}

// Prep Unit After Rental
PrepUnit(string UnitID, key Renter){
    //llRegionSayTo(Renter, 0, "Setting up your Unit...");
    list SendList = [ SecurityKey, "NR", UnitID, Renter ];
    string SendString = llStringToBase64(llDumpList2String(SendList, "||"));
    DebugMessage(SendString);
    llRegionSay(ComChannel, SendString);
}
    
// Main Program
default{
    on_rez(integer params){
        //llGiveInventory(llGetOwner(), llGetInventoryName(INVENTORY_NOTECARD, 1));
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
                RegisterServer("CheckReg", []);
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
            llOwnerSay("Listen Event Fired!\r"+data);
        }
        LightToggle(INLIGHT, TRUE, "Green");
        list InputData = llParseString2List(data, ["||"], []);
        string CMD = llList2String(InputData, 0);
        if(CMD=="GETCONFIG"){
            string UnitID = llList2String(InputData, 1);
            DebugMessage("Configuration Data Requested for Unit: "+UnitID);
            integer IDLength = llStringLength(UnitID);
            string Wing = EMPTY;
            string Unit = EMPTY;
            integer DBIndex;
            if(IDLength==2){
                Wing = llGetSubString(UnitID, 1, 1);
                Unit = llGetSubString(UnitID, 0, 0);
            }else if(IDLength==3){
                Wing = llGetSubString(UnitID, 2, 2);
                Unit = llGetSubString(UnitID, 0, 1);
            }
            if(llToLower(Wing)=="a"){
                DBIndex = (integer)Unit;
            }else if(llToLower(Wing)=="b"){
                DBIndex = ((integer)Unit + (DBEntries / 2));
            }else{
                llOwnerSay("ERROR");
            }
            list UnitData = dbGet(DBIndex);
            string UnitIDb = llList2String(UnitData, 0);
            if(UnitID!=UnitIDb){
                DebugMessage("UnitID: "+UnitID+" UnitIDb: "+UnitIDb);
                return;
            }
            LightToggle(INLIGHT, FALSE, "Green");
            LightToggle(OUTLIGHT, TRUE, "Green");
            string Price = llList2String(UnitData, 1);
            string Discount = (string)llList2Integer(UnitData, 2);
            string MinRent = llList2String(UnitData, 3);
            string MaxRent = llList2String(UnitData, 4);
            string Rented = llList2String(UnitData, 5);
            string RenterKey = llList2String(UnitData, 6);
            string Expire = llList2String(UnitData, 7);
            string Prims = llList2String(UnitData, 8);
            string Texture = llList2String(UnitData, 9);
            list Output = [ SecurityKey, "UNIT", UnitID, Price, Discount, MinRent, MaxRent, Rented, RenterKey, Expire, Prims, Texture];
            string OutputString = llDumpList2String(Output, "||");
            DebugMessage("Sending Config Data: "+OutputString);
            llRegionSayTo(id, ComChannel, OutputString);
            LightToggle(OUTLIGHT, FALSE, "Green"); 
        }else if(CMD=="RENTED" || CMD=="AVAIL"){
           list NewUnitData = llList2List(InputData, 1, -1);
           string UnitID = llList2String(NewUnitData, 0);
           integer IDLength = llStringLength(UnitID);
           string Wing = EMPTY;
           string Unit = EMPTY;
           integer DBIndex;
           if(IDLength==2){
               Wing = llGetSubString(UnitID, 1, 1);
               Unit = llGetSubString(UnitID, 0, 0);
           }else if(IDLength==3){
               Wing = llGetSubString(UnitID, 2, 2);
               Unit = llGetSubString(UnitID, 0, 1); 
           }
           if(llToLower(Wing)=="a"){
               DBIndex = (integer)Unit;
           }else if(llToLower(Wing)=="b"){
               DBIndex = ((integer)Unit + (DBEntries / 2));
           }else{
               llOwnerSay("ERROR");
           }
           
           dbIndex = DBIndex;
           // UNITID, PRICE, DISCOUNT, MINRENT, MAXRENT, RENTED, RENTERKEY, EXPIRE, PRIMS, Texture
           integer NewIndex = dbPut([llList2String(NewUnitData, 0), llList2String(NewUnitData, 1), llList2String(NewUnitData, 2), llList2String(NewUnitData, 3), llList2String(NewUnitData, 4), llList2String(NewUnitData, 5), llList2String(NewUnitData, 6),  llList2String(NewUnitData, 7), llList2String(NewUnitData, 8), llList2String(NewUnitData, 9)]);
            list UpData = dbGet(DBIndex);
            DebugMessage("Updating Remote Server...");
            RegisterServer("Update", UpData);
        }
    }
    
    touch_start(integer num){
        if(num>1){
            return;
        }
        if(!CheckSecurity(llDetectedKey(0))){
            llRegionSayTo(llDetectedKey(0), 0, "You are not authorized!");
            return;
        }
        DebugMode = !DebugMode;
        if(DebugMode){
            DebugMessage("Debug Mode Enabled!");
            DebugMessage("Dumping Database...");
            integer i;
            for(i=1;i<=DBEntries;i++){
                list UnitData = dbGet(i);
                DebugMessage("DB Entry #: "+(string)i+"\nUnit ID: "+llList2String(UnitData, 0)+"\nPrice: "+llList2String(UnitData, 1)+" /wk\nDiscount: "+(string)llList2Integer(UnitData, 2)+" %\nMin Rent: "+llList2String(UnitData, 3)+"Week(s)\nMax Rent: "+llList2String(UnitData, 4)+"Weeks(s)\nRented: "+llList2String(UnitData, 5)+"\nRenter: "+llKey2Name(llList2Key(UnitData, 6))+"\nExpiry: "+llList2String(UnitData, 7)+"\nMax Prims: "+llList2String(UnitData, 8)+"\nTexture Key: "+llList2String(UnitData, 9));
            }
        }else{
            llOwnerSay("Debug Mode Disabled!");
        }
    }
    
    http_response(key request_id, integer status, list metadata, string body)
    {
        if (request_id != HTTPRequestHandle) return;// exit if unknown 
        if(OpFlag=="CheckReg"){
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
            LightToggle(CFGLIGHT, FALSE, "Orange");
            RegisterServer("Sync", []);
        }else if(OpFlag=="Sync"){
            list InputData = llParseString2List(body, [":"], []);
            string ResponseCode = llList2String(InputData, 0);
            if(ResponseCode=="UPDATE"){ // In-Ward Sync
                list OffWorldData = llCSV2List(llList2String(InputData, 1));
                if(dbDrop(DBName)){
                    string CreatedDB = dbCreate(DBName, ["unitid", "price", "discount", "minrent", "maxrent", "rented", "renterkey", "expire", "prims", "texture"]);
                    if(CreatedDB==DBName && DebugMode){
                        llOwnerSay("Database "+DBName+" Cleared...");
                    }
                    integer i;
                    for(i=0;i<DBEntries;i++){
                        list ThisUnit = llParseString2List(llList2String(OffWorldData, i), ["||"], []);
                        // UNITID, PRICE, DISCOUNT, MINRENT, MAXRENT, RENTED, RENTERKEY, EXPIRE
                        string UnitID = llList2String(ThisUnit, 0);
                        integer Price = llList2Integer(ThisUnit, 1);
                        float Discount = llList2Float(ThisUnit, 2);
                        integer MinRent = llList2Integer(ThisUnit, 3);
                        integer MaxRent = llList2Integer(ThisUnit, 4);
                        string Rented = llList2String(ThisUnit, 5);
                        key RenterKey = llList2Key(ThisUnit, 6);
                        integer Expiry = llList2Integer(ThisUnit, 7);
                        integer Prims = llList2Integer(ThisUnit, 8);
                        key Texture = llList2Key(ThisUnit, 9);
                        integer NewEntry = dbInsert([UnitID, Price, Discount, MinRent, MaxRent, Rented, RenterKey, Expiry, Prims, Texture]);
                        if(NewEntry!=(i+1)){
                            DebugMessage("ERROR: New Entry #: "+(string)NewEntry+" Index #: "+(string)i);
                            state borked;
                        }
                    }
                    DebugMessage("Databases Sync'd!");
                    SystemStart();
                }
            }else if(ResponseCode=="SYNCERROR"){ // Sync Error
                string ErrorString = llList2String(InputData, 1);
                DebugMessage("Sync Error!\nMessage:\n"+ErrorString);
                state borked;
            }else if(ResponseCode=="OK"){ // Sync OK (New Database Setup)
                DebugMessage("New Database Setup!");
                SystemStart();
            }
        }else if(OpFlag=="Update"){
            list Response = llParseString2List(body, ["||"], []);
            if(llToUpper(llList2String(Response, 0))=="OK"){
                string UnitID = llList2String(Response, 1);
                key Renter = llList2Key(Response, 2);
                PrepUnit(UnitID, Renter);
            }
        }
    }
}

state borked{
    state_entry(){
        llOwnerSay("Error Has Occured! Please re-run with Diagnostics Mode On for full details!");
    }
}