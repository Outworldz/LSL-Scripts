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

// System Variables
/* This Section contains variables that will be used throughout the program. */
    // Admin ACL
        list Admins = []; // List of Administrator Keys Read in from ConfigFile
    // Communication Handles
        integer MenuComHandle; // Menu Communications Handle
        integer ComHandle; // General Communications Handle
    // Config Card Reading Variables
        integer cLine; // Holds Configuration Line Index for Loading Config Loop
        key cQueryID; // Holds Current Configuration File Line during Loading Loop
        
        
// System Constants
/* This Section contains constants used throughout the program */
string BootMessage = "Booting..."; // Default/Initial Boot Message
string ConfigFile = ".config"; // Name of Configuration File  
string EMPTY = "";
string SecurityKey;
list Wings;
integer Floors;
string CurrentWing;
list Units;
integer CurUnitID;
integer CurPayPrice;
list CurUnitData;
integer CurrentYear = 2015; 

// Color Vectors
list colorsVectors = [<0.000, 0.455, 0.851>, <0.498, 0.859, 1.000>, <0.224, 0.800, 0.800>, <0.239, 0.600, 0.439>, <0.180, 0.800, 0.251>, <0.004, 1.000, 0.439>, <1.000, 0.522, 0.106>, <1.000, 0.255, 0.212>, <0.522, 0.078, 0.294>, <0.941, 0.071, 0.745>, <0.694, 0.051, 0.788>, <1.000, 1.000, 1.000>];

// List of Names for Colors
list colors = ["BLUE", "AQUA", "TEAL", "OLIVE", "GREEN", "LIME", "ORANGE", "RED", "MAROON", "FUCHSIA", "PURPLE", "WHITE"];  

// XyText Cell Com Numbers
integer CA1 = 281000;
integer CA2 = 282000;
integer CA3 = 283000;
integer CA4 = 284000;
integer CB1 = 285000;
integer CB2 = 286000;
integer CB3 = 287000;
integer CB4 = 288000;
integer CC1 = 289000;
integer CC2 = 290000;
integer CC3 = 291000;
integer CC4 = 292000;

// Display Prim and Face IDs
integer DisplayPrim = 14;
integer DisplayFace = 4;

// System Switches
/* This Section contains variables representing switches (integer(binary) yes/no) or modes (string "modename" */
    // Debug Mode Swtich
        integer DebugMode = FALSE; // Is Debug Mode Enabled before Reading Obtaining Configuation Information

// Imported Functions
/* This section contains any functions that were not written by Tech Guy */

list uUnix2StampLst( integer vIntDat ){
    if (vIntDat / 2145916800){
        vIntDat = 2145916800 * (1 | vIntDat >> 31);
    }
    integer vIntYrs = 1970 + ((((vIntDat %= 126230400) >> 31) + vIntDat / 126230400) << 2);
    vIntDat -= 126230400 * (vIntDat >> 31);
    integer vIntDys = vIntDat / 86400;
    list vLstRtn = [vIntDat % 86400 / 3600, vIntDat % 3600 / 60, vIntDat % 60];
 
    if (789 == vIntDys){
        vIntYrs += 2;
        vIntDat = 2;
        vIntDys = 29;
    }else{
        vIntYrs += (vIntDys -= (vIntDys > 789)) / 365;
        vIntDys %= 365;
        vIntDys += vIntDat = 1;
        integer vIntTmp;
        while (vIntDys > (vIntTmp = (30 | (vIntDat & 1) ^ (vIntDat > 7)) - ((vIntDat == 2) << 1))){
            ++vIntDat;
            vIntDys -= vIntTmp;
        }
    }
    return [vIntYrs, vIntDat, vIntDys] + vLstRtn;
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--


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

// Convert Input (S)ColorName to (V)Color
vector Color2Vector(string ColorName){
    integer VectorIndex = llListFindList(colors, [llToUpper(ColorName)]);
    vector Color;
    if(VectorIndex==-1){
        Color = ZERO_VECTOR;
    }else{
        Color = llList2Vector(colorsVectors, VectorIndex);        
    }
    return Color;
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
    SendMessage("System Started!", llGetOwner());
    CurUnitID = 0;
    //llSetTimerEvent(300.0);
    UpdateUnitInfo("", (string)CurUnitID, NULL_KEY);
    llSetTimerEvent(10.0);
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

// Update Stats
UpdateUnitInfo(string UnitName, string UnitIndex, key WhoTouched){
    list UnitData;
    integer CurUnitIndex;
    if(UnitName!=""){
        CurUnitIndex = llListFindList(Units, [UnitName]);
    }else if(UnitIndex!=""){
        CurUnitIndex = ((integer)UnitIndex * 10);
        if(CurUnitIndex==1){
            CurUnitIndex--;
        }
        //llOwnerSay("Inex: "+(string)CurUnitIndex);
    }
    UnitData = llList2List(Units, CurUnitIndex, (CurUnitIndex + 9));
    CurUnitData = UnitData;
    // Set Price to make board payable if unit is available
    if(llList2String(UnitData, 5)=="FALSE" || (llList2String(UnitData, 5)=="TRUE" && llList2Key(UnitData, 6) == WhoTouched)){
        //llOwnerSay("Path1");
        CurPayPrice = llList2Integer(UnitData, 1);
        if(CurPayPrice>0){
            llSetPayPrice(CurPayPrice, [ CurPayPrice, (CurPayPrice * 2), (CurPayPrice * 3), (CurPayPrice * 4)]);
        }
        llMessageLinked(LINK_SET, 0, "green", "");
    }else if(llList2String(UnitData, 5)=="TRUE"){
        //llOwnerSay(llList2String(UnitData, 5));
        llSetPayPrice(PAY_HIDE, [ PAY_HIDE, PAY_HIDE, PAY_HIDE, PAY_HIDE ]);
        llMessageLinked(LINK_SET, 0, "red", "");
    }
    //llOwnerSay(llDumpList2String(UnitData, "||"));
    // Update Display Text
    string DisplayUnitName;
    if(llStringLength(llList2String(UnitData, 0))==2){
        DisplayUnitName = llList2String(UnitData, 0)+"    ";
    }else{
        DisplayUnitName = llList2String(UnitData, 0)+"   ";
    }
    string DisplayString;
    if(llStringLength(llList2String(UnitData, 8))==3){
        DisplayString = "Unit: "+DisplayUnitName+" Prims: "+llList2String(UnitData, 8)+" Price: "+llList2String(UnitData, 1)+"wk ";
    }else{
        DisplayString = "Unit: "+DisplayUnitName+" Prims: "+llList2String(UnitData, 8)+"Price: "+llList2String(UnitData, 1)+"wk ";
    }
    if(llList2String(UnitData, 5)=="FALSE"){
        DisplayString = DisplayString + "Available  ";
    }else{
        DisplayString = DisplayString + "UnAvailable";
    }
    DisplayString = DisplayString + "Expires: ";
    integer InputExpireTimeStamp = llList2Integer(UnitData, 7);
    if(InputExpireTimeStamp==0){
        DisplayString = DisplayString + "12 Weeks 6 Days";
    }else{
        list TimeList = uUnix2StampLst(InputExpireTimeStamp);
        DisplayString = DisplayString + "    " + (string)(llList2Integer(TimeList, 0) + (CurrentYear - llList2Integer(TimeList, 0))) + "/" + llList2String(TimeList, 1) + "/" + llList2String(TimeList, 2);
        //llOwnerSay(DisplayString);
    }
    //llOwnerSay("T"+(string)llStringLength(DisplayString));
    //llOwnerSay(DisplayString);
    llMessageLinked(LINK_SET, CA1, llGetSubString(DisplayString, 0, 5), "''''");
    llMessageLinked(LINK_SET, CA2, llGetSubString(DisplayString, 6, 11), "''''");
    llMessageLinked(LINK_SET, CA3, llGetSubString(DisplayString, 12, 17), "''''");
    llMessageLinked(LINK_SET, CA4, llGetSubString(DisplayString, 18, 23), "''''");
    llMessageLinked(LINK_SET, CB1, llGetSubString(DisplayString, 24, 29), "''''");
    llMessageLinked(LINK_SET, CB2, llGetSubString(DisplayString, 30, 35), "''''");
    llMessageLinked(LINK_SET, CB3, llGetSubString(DisplayString, 36, 41), "''''");
    llMessageLinked(LINK_SET, CB4, llGetSubString(DisplayString, 42, 47), "''''");
    llMessageLinked(LINK_SET, CC1, llGetSubString(DisplayString, 48, 53), "''''");
    llMessageLinked(LINK_SET, CC2, llGetSubString(DisplayString, 54, 60), "''''");
    llMessageLinked(LINK_SET, CC3, llGetSubString(DisplayString, 61, 66), "''''");
    llMessageLinked(LINK_SET, CC4, llGetSubString(DisplayString, 67, -1), "''''");
    // Update Main Texture Display and Buffer Display
    llSetLinkPrimitiveParamsFast(DisplayPrim, [PRIM_TEXTURE, DisplayFace, llList2String(UnitData, 9), <1.0,1.0,1.0>, ZERO_VECTOR, 0.0]);
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
                }else if(name=="comchannel"){
                    ComChannel = (integer)value;
                    DebugMessage("Com Channel: "+(string)ComChannel);
                }else if(name=="securitykey"){
                    SecurityKey = value;
                    DebugMessage("Security Key: "+SecurityKey);
                }else if(name=="admin"){
                    AddAdmin(value);
                }else if(name=="wings"){
                    Wings = llCSV2List(value);
                    CurrentWing = llList2String(Wings, 0);
                    DebugMessage("Wings: "+llDumpList2String(Wings, " & "));
                }else if(name=="floors"){
                    Floors = (integer)value;
                    DebugMessage("Total Number of Floors Per Wing: "+(string)Floors);
                }
        }else{ //  line does not contain equal sign
                SendMessage("Configuration could not be read on line " + (string)cLine, NULL_KEY);
            }
        }
    }
}

// Get Unit Configuration Information from the Server
GetServerConfig(){
    if(ComHandle<=0){ // Need to Open Com Handle
        DebugMessage("Opening Com Channel "+(string)ComChannel+"...");
        ComHandle = llListen(ComChannel, EMPTY, EMPTY, EMPTY);
    }
    integer count = 0;
    string GetConfigCmd;
    DebugMessage("Calling Server...");
    for(count=0;count<=Floors;count++){
        GetConfigCmd = "GETCONFIG||"+count+llToUpper(CurrentWing);
        llRegionSay(ComChannel, GetConfigCmd);
        if(count==Floors){
            integer NumWings = llGetListLength(Wings);
            integer NextWingIndex = (llListFindList(Wings, [CurrentWing]) + 1);
            if(NextWingIndex>=NumWings){
                count = Floors;
            }else{
                count = 0;
                CurrentWing = llList2String(Wings, NextWingIndex);
            }
        }
    }
}


// Validate the Servers Security Key
integer CheckServerSecurity(string InKey){
    if(InKey==SecurityKey){
        return TRUE;
    }else{
        return FALSE;
    }
}

// Next / Prev Unit Display Changer
ChangeUnit(string Direction, key WhoTouched){
    if(Direction=="Next"){
        CurUnitID++;
        if(CurUnitID>=(Floors * llGetListLength(Wings))){
            CurUnitID = 0;
        }
    }else if(Direction=="Prev"){
        if(CurUnitID==0){
            CurUnitID = (Floors * llGetListLength(Wings));
            CurUnitID--;
        }else{
            CurUnitID--;
        }
    }
    //llOwnerSay("CurUnitID: "+(string)CurUnitID);
    UpdateUnitInfo("", (string)CurUnitID, WhoTouched);
}

AnnounceUnitStateChange(list InputData){
    string SendString = llDumpList2String(InputData, "||");
    llRegionSay(-86000, SendString);
}

// Check for Expired Units
CheckExpires(){
    integer count;
    integer Start;
    integer End;
    list CurrentUnit;
    string CurrentWing = "a";
    integer CurrentTime;
    for(count=1;count<=Floors;count++){
        Start = llListFindList(Units, (string)count+llToUpper(CurrentWing));
        End = (Start + 9);
        CurrentUnit = llList2List(Units, Start, End);
        CurrentTime = llGetUnixTime();
        integer UnitExpiry = llList2Integer(CurrentUnit, 7);
        if(CurrentTime>UnitExpiry && UnitExpiry>0){
            if(llList2String(CurrentUnit, 0)=="1A" || llList2String(CurrentUnit, 0)=="1B"){
                // Do Nothing
            }else{
                 // Notify Server of Rented Unit
                list SendList = [ "AVAIL" ] + CurrentUnit;
                string SendString = llDumpList2String(SendList, "||");
                DebugMessage("Updating Server...");
                llRegionSay(ComChannel, SendString);
                
                // Announce Change to Front Door Panels (And Anything Else we later want to listen)
                AnnounceUnitStateChange(SendList);
                //llOwnerSay("Expired "+llList2String(CurrentUnit, 0));
            }
        }
//        llOwnerSay(llDumpList2String(CurrentUnit, "||"));
        if(count==Floors){
            integer NumWings = llGetListLength(Wings);
            integer NextWingIndex = (llListFindList(Wings, [CurrentWing]) + 1);
            if(NextWingIndex>=NumWings){
                count = Floors;
            }else{
                count = 1;
                CurrentWing = llList2String(Wings, NextWingIndex);
            } 
        }
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
    
    touch_start(integer num){
        vector WhereTouched = llDetectedTouchST(0);
        key WhoTouched = llDetectedKey(0);
        //llOwnerSay("X Vector: "+(string)WhereTouched.x+" Y Vector: "+(string)WhereTouched.y);
        if(WhereTouched.x>=0.0597 && WhereTouched.x<=0.3779 && WhereTouched.y>=0.5845 && WhereTouched.y<=0.6212){
            ChangeUnit("Prev", WhoTouched);
        }else if(WhereTouched.x>=0.6308 && WhereTouched.x<=0.9434 && WhereTouched.y>=0.5867 && WhereTouched.y<=0.6213){
            ChangeUnit("Next", WhoTouched);
        }
    }
    
    listen(integer channel, string sender, key id, string msg){
        if(channel==ComChannel){ // Message comes from Server
            list InputData = llParseString2List(msg, ["||"], []);
            if(!CheckServerSecurity(llList2String(InputData, 0))){
                DebugMessage("Server Security Code Invalid!\n Closing Com Handle...");
                //llListenRemove(ComHandle);
                //state borked;
            }
            string CMD = llList2String(InputData, 1);
            if(CMD=="UNIT"){ // Receiving Configuration for Unit
                integer UnitPropCount = llGetListLength(Units);
                Units = Units + llList2List(InputData, 2, -1);
//                llOwnerSay("Unit Configured:\n"+llDumpList2String(llList2List(Units, UnitPropCount, (UnitPropCount + 8)), ","));
                AnnounceUnitStateChange(llList2List(InputData, 1, -1));
                //llOwnerSay((string)llGetListLength(Units));
                if((llGetListLength(Units) / 8)==(Floors * llGetListLength(Wings))){
                    llOwnerSay("Please accept debit permissions...");
                    llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
                }
            }
        }else if(channel==MenuComChannel){ // Message comes from Board Dialog Menu
            
        }
    }
    
    run_time_permissions(integer perms){
        if(perms & PERMISSION_DEBIT){
            llOwnerSay("Permissions Granted! System Configured!");
            SystemStart();
        }
    }
    
     // DataServer Event Called for Each Line of Config NC. This Loop It was Calls LoadConfig()
    dataserver(key query_id, string data){       // Config Notecard Read Function Needs to be Finished
        if (query_id == cQueryID){
            if (data != EOF){ 
                LoadConfig(data); // Process Current Line
                ++cLine; // Increment Line Index
                cQueryID = llGetNotecardLine(ConfigFile, cLine); // Attempt to Read Next Config Line (Re-Calls DataServer Event)
            }else{ // IF EOF (End of Config loop, and on Blank File)
                GetServerConfig();
            }
        }
    }
    
    changed(integer change){
        if(change & CHANGED_INVENTORY){
            BootMessage = "Inventory Changed Detected, Re-Initializing...";
            llResetScript();
        }
    }
    
    money(key Payor, integer AmountPaid){
        //llOwnerSay((string)CurPayPrice+" "+(string)CurUnitID);
        integer OneWeek = CurPayPrice;
        integer TwoWeek = (CurPayPrice * 2);
        integer ThreeWeek = (CurPayPrice * 3);
        integer FourWeek = (CurPayPrice * 4);
        integer Expiry;
        if(AmountPaid != OneWeek && AmountPaid != TwoWeek && AmountPaid != ThreeWeek && AmountPaid != FourWeek){ // Incorrent Amount Paid
            llRegionSayTo(Payor, 0, "You paid an invalid amount! Returning your money...");
            llGiveMoney(Payor, AmountPaid);
            return;
        }else if(AmountPaid==OneWeek){
            Expiry = (llGetUnixTime() + 604800);
        }else if(AmountPaid==TwoWeek){
            Expiry = (llGetUnixTime() + (604800 * 2));
        }else if(AmountPaid==ThreeWeek){
            Expiry = (llGetUnixTime() + (604800 * 3));
        }else if(AmountPaid==FourWeek){
            Expiry = (llGetUnixTime() + (604800 * 4));
        }
        llRegionSayTo(Payor, 0, "Thank you for Renting Unit: "+llList2String(CurUnitData, 0));
        list ExpiryList = uUnix2StampLst(Expiry);
        integer ExpYear = llList2Integer(ExpiryList, 0) + (CurrentYear - llList2Integer(ExpiryList, 0));
        list Public = [ExpYear] + llList2List(ExpiryList, 1, 2);
        llOwnerSay("Pre New Expire: "+llDumpList2String(CurUnitData, "||"));
        list NewUnitData = llList2List(CurUnitData, 0, 4) + ["TRUE"] + [(string)Payor] + [Expiry] + llList2List(CurUnitData, 8, -1);
        llOwnerSay("New Unit Data: "+llDumpList2String(NewUnitData, "||"));
        llMessageLinked(LINK_SET, 0, "red", "");
        integer UnitIndex = llListFindList(Units, [llList2String(NewUnitData, 0)]);
        if(UnitIndex==-1){
            llOwnerSay("Error Unit Not Found in List!");
            state borked;
        }else{
            list OldUnitData = llList2List(Units, UnitIndex, (UnitIndex + 9));
            llOwnerSay("Old Unit Data: "+llDumpList2String(OldUnitData, "||"));
            if(llList2String(OldUnitData, 6)==Payor){
                integer OldExpiry = llList2Integer(NewUnitData, 7);
                if(AmountPaid==OneWeek){
                    Expiry = (OldExpiry + 604800);
                }else if(AmountPaid==TwoWeek){
                    Expiry = (OldExpiry + (604800 * 2));
                }else if(AmountPaid==ThreeWeek){
                    Expiry = (OldExpiry + (604800 * 3));
                }else if(AmountPaid==FourWeek){
                    Expiry = (OldExpiry + (604800 * 4));
                }
            }
        }
        NewUnitData = [] + llList2List(CurUnitData, 0, 4) + ["TRUE"] + [(string)Payor] + [Expiry] + llList2List(CurUnitData, 8, -1);
        llOwnerSay("New Unit Data Final: "+llDumpList2String(NewUnitData, "||"));
        list Start;
        list End;
        if(UnitIndex==0){
            Start = [];
        }else{
            Start = llList2List(Units, 0, (UnitIndex - 1)); 
        }
        End = llList2List(Units, (UnitIndex + 10), -1);
        list NewUnits = Start + NewUnitData + End;
        Units = [] + NewUnits;
        
        // Notify Server of Rented Unit
        list SendList = [ "RENTED" ] + NewUnitData;
        string SendString = llDumpList2String(SendList, "||");
        DebugMessage("Updating Server...");
        llRegionSay(ComChannel, SendString);
        
        // Announce Change to Front Door Panels (And Anything Else we later want to listen)
        AnnounceUnitStateChange(SendList);
        // Update Display Text
        //llOwnerSay(llList2String(NewUnitData, 0));
        UpdateUnitInfo(llList2String(NewUnitData, 0), "", Payor);
    }
    
    timer(){
        CheckExpires();
    }
}

state borked {
    state_entry(){
        llInstantMessage(llGetOwner(), llGetObjectName()+" failure!");
    }
}