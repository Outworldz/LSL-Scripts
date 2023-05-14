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
        list Admins; // List of Administrator Keys Read in from ConfigFile
    // Dance Animation Names
        list Dances;
    // Num Dances Per Category
        list NumDances;
    // Num of Categories
        integer NumCats;
    // List of Category Names (Index Associated with {NumCats}
        list CatNames;
    // Couples Dances
        list CDances;
    // Dancers Keys
        list Dancers;
    // Maximum Dancers Supported
        integer MaxDancers = 20;
    // Number of Active Dancers (Not to Exceed Max Dancers)
        integer NumDancers;
    // Default Dance for someone who requests start
        string DefaultDance;
    
    // Communication Handles
        integer MenuComHandle; // Menu Communications Handle
        integer ComHandle; // General Communications Handle
    // Config Card Reading Variables
        integer cLine; // Holds Configuration Line Index for Loading Config Loop
        key cQueryID; // Holds Current Configuration File Line during Loading Loop
        integer DCounter;
        string DanceCat;
        
        
// System Constants
/* This Section contains constants used throughout the program */
string BootMessage = "Booting..."; // Default/Initial Boot Message
string ConfigFile = ".config"; // Name of Configuration File
string EMPTY = "";

// Menu Constants
string MainMenuMessage = "Wholearth Dance Machine v1.0";
list MainMenuButtons = [ "<<", "Stop", ">>", "Dances", "Start", "Invite", "Sync", "Random" ];
list NavButtons = [ "Prev Menu", "Exit Menu" ];
list AdminButton = [ "Admin" ];
list AdminMenuButtons = [ "Dance", "Random", "Reset", "Sync" ];
string AdminMenuMessage = "Admin Menu\n\tDance -> Sets Default Dance for start request\n\tRandom -> Should dances auto cycle.\n\tReset -> Reset Scripts\n\tSync -> Sync's Current Default Dance";
string DefaultDancesMenuMessage = "Change the Default Dance...";

// Color Vectors
list colorsVectors = [<0.000, 0.455, 0.851>, <0.498, 0.859, 1.000>, <0.224, 0.800, 0.800>, <0.239, 0.600, 0.439>, <0.180, 0.800, 0.251>, <0.004, 1.000, 0.439>, <1.000, 0.522, 0.106>, <1.000, 0.255, 0.212>, <0.522, 0.078, 0.294>, <0.941, 0.071, 0.745>, <0.694, 0.051, 0.788>, <1.000, 1.000, 1.000>];

// List of Names for Colors
list colors = ["BLUE", "AQUA", "TEAL", "OLIVE", "GREEN", "LIME", "ORANGE", "RED", "MAROON", "FUCHSIA", "PURPLE", "WHITE"];  

// System Switches
/* This Section contains variables representing switches (integer(binary) yes/no) or modes (string "modename" */
    // Debug Mode Swtich
        integer DebugMode = FALSE; // Is Debug Mode Enabled before Reading Obtaining Configuation Information
        string AdminOpFlag;

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
    MenuComHandle = llListen(MenuComChannel, EMPTY, EMPTY, EMPTY);
    SendMessage("Configuring...", llGetOwner()); // Message Owner that we are starting the Configure Loop
    cQueryID = llGetNotecardLine(ConfigFile, cLine); // Start the Read from Config Notecard
}

// System has started Function (Runs After Configuration is Loaded, as a result of EOF)
SystemStart(){
    // Clean Up Config Variables
    NumDances = NumDances + [DCounter];
    //llOwnerSay((string)llGetListLength(Dances)+llDumpList2String(Dances, "||"));
    //llOwnerSay((string)llGetListLength(CatNames)+llDumpList2String(CatNames, "||"));
    //llOwnerSay((string)llGetListLength(NumDances)+llDumpList2String(NumDances, "||"));
    DCounter = 0;
    DanceCat = EMPTY;
    SendMessage("System Started!", llGetOwner());
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
                }else if(name=="menu"){
                    DanceCat = value;
                    CatNames = CatNames + [value];
                    NumCats++;
                    Dances = Dances + [value];
                    DebugMessage("Dance Category Found: "+llList2String(Dances, -1)+"\nTotal Categories: "+(string)NumCats);
                    if(DCounter>0){
                        NumDances = NumDances + [DCounter];
                    }
                    DCounter = 0;
                }else if(name=="dance"){
                    Dances = Dances + [value];
                    DebugMessage("Dance "+value+" found! Placing into Category "+DanceCat);
                    DCounter++;
                    if(NumCats==1 && DCounter==1){
                        DefaultDance = value;
                        DebugMessage("Default Dance Set to: "+DefaultDance);
                    }
                    DebugMessage((string)DCounter+" Total Dances for "+DanceCat+".");
                }else if(name=="admin"){
                    AddAdmin(value);
                }
        }else{ //  line does not contain equal sign
                SendMessage("Configuration could not be read on line " + (string)cLine, NULL_KEY);
            }
        }
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

// Test of Requesting Users Key is found in Dancers List, Returns True or False
integer IsDancing(key id){
    if(llListFindList(Dancers, [id])!=-1){
        return TRUE;
    }else{
        return FALSE;
    }
}

// Manipulate Dancer (Start, Stop, Next/Prev Dance, 
Dancer(string CMD, key id, string Dance){
    if(CMD=="Start"){
        if(!IsDancing(id)){ // If the User is not in the dance list and is request to start.
            Dancers = Dancers + [id];
            DebugMessage("Added: "+llKey2Name(id)+" to the Dancers List!");
            Relay("Assign", id, Dance); // Assign Requesting User the next available relay
        }else{
            DebugMessage("Requesting Relay Re-Init...");
            Relay("Reload", id, Dance);
        }
    }else if(CMD=="Stop"){
        if(IsDancing(id)){
            Dancers = llDeleteSubList(Dancers, llListFindList(Dancers, [id]), llListFindList(Dancers, [id]));
            if(llListFindList(Dancers, [id])==-1){
                DebugMessage("Dancer Removed from List!");
            }else{
                DebugMessage("Failed to Remove Dancer from List!");
            }
            Relay("Stop", id, DefaultDance);
        }
    }else if(CMD==">>"){
        if(IsDancing(id)){
            DebugMessage("Advancing Dance for User: "+llKey2Name(id)+".");
            Relay(CMD, id, Dance);
        }
    }else if(CMD=="<<"){
        if(IsDancing(id)){
            DebugMessage("Retrogressing Dance for User: "+llKey2Name(id)+".");
            Relay(CMD, id, Dance);
        }
    }else if(CMD=="Sync"){
        
    }else if(CMD=="Change"){ // Change to Selected Dance
        if(IsDancing(id)){
            DebugMessage("Changing Dance for User: "+llKey2Name(id)+" to dance: "+Dance);
            Relay("Change", id, Dance);
        }
    }
}

// Relay Control
Relay(string CMD, key id, string Dance){
    string RelayName = "Relay ";
    if(CMD=="Assign"){
        integer i;
        for(i=1;i<=MaxDancers;i++){
            integer ISON = llGetScriptState(RelayName+(string)i);
            if(!ISON){ // Script is Already in Use
                RelayName = RelayName + (string)i;
                DebugMessage("Script Relay: "+RelayName);
                llSetScriptState(RelayName, TRUE);
                llResetOtherScript(RelayName);
                DebugMessage("Sending Start Message to Relay: "+RelayName);
                llMessageLinked(LINK_THIS, 0, "START||"+DefaultDance, id);
                return;
            }
        }
    }else if(CMD=="Reload"){
        
    }else if(CMD=="Stop"){
        DebugMessage("Sending Stop Message to Relay...");
        llMessageLinked(LINK_THIS, 0, "STOP||", id);
    }else if(CMD=="Change"){
        DebugMessage("Sending Change Message to Relay...");
        llMessageLinked(LINK_THIS, 0, "CHANGE||"+Dance, id);
    }else if(CMD==">>" || CMD=="<<"){
        DebugMessage("Sending Slot Adjustment Command...");
        llMessageLinked(LINK_THIS, 0, CMD+"||"+Dance, id);
    }
}

// Show Menu
ShowMenu(string Menu, key id){
    string CurMenuMessage;
    list CurMenuButtons;
    if(Menu=="MainMenu"){
        CurMenuMessage = MainMenuMessage;
        CurMenuButtons = MainMenuButtons;
        if(CheckSecurity(id)){
            CurMenuButtons =CurMenuButtons + AdminButton;
        }
    }else if(Menu=="Dances"){
        list Categories;
        integer i;
        integer CatIndex;
        for(i=0;i<NumCats;i++){
            Categories = Categories + [llList2String(Dances, CatIndex)];
            CatIndex = (CatIndex + (llList2Integer(NumDances, i)+1));
        }
        if(AdminOpFlag=="ChangeDefaultDance"){
            CurMenuMessage = DefaultDancesMenuMessage;
        }else{
            CurMenuMessage = MainMenuMessage;
        }
        CurMenuButtons = Categories;
    }else if(Menu=="Admin"){
        CurMenuMessage = AdminMenuMessage;
        CurMenuButtons = AdminMenuButtons;
    }else if(llListFindList(Dances, [Menu])!=-1){
        integer CIndex = llListFindList(CatNames, [Menu]);
        llOwnerSay("CIndex: "+(string)CIndex+" Num of Dances: "+llList2String(NumDances, CIndex));
        integer i;
        integer StartPoint = (llListFindList(Dances, [Menu])+1);
        llOwnerSay("Start Point: "+(string)StartPoint);
        for(i=0;i<llList2Integer(NumDances, CIndex);i++){
            CurMenuButtons = CurMenuButtons + llList2String(Dances, StartPoint);
            llOwnerSay(llList2String(CurMenuButtons, -1));
            StartPoint++;
        }
        CurMenuMessage = DefaultDancesMenuMessage;
    }
    // Send Constructed Dialog to User
    llDialog(id, CurMenuMessage, CurMenuButtons, MenuComChannel);
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
    
     // DataServer Event Called for Each Line of Config NC. This Loop It was Calls LoadConfig()
    dataserver(key query_id, string data){       // Config Notecard Read Function Needs to be Finished
        if (query_id == cQueryID){
            if (data != EOF){ 
                LoadConfig(data); // Process Current Line
                ++cLine; // Increment Line Index
                cQueryID = llGetNotecardLine(ConfigFile, cLine); // Attempt to Read Next Config Line (Re-Calls DataServer Event)
            }else{ // IF EOF (End of Config loop, and on Blank File)
                SystemStart();
            }
        }
    }
    
    listen(integer chan, string sender, key id, string msg){
        DebugMessage("Listen Event Fired: "+msg);
        if(msg=="Dances"){
            ShowMenu("Dances", id);
        }else if(msg=="Admin"){
            if(CheckSecurity(id)){ // Verify their Id against Admins List again to avoid message spoofing from unauthed users
                ShowMenu(msg, id); // Show Admin Menu
            }else{
                llRegionSayTo(id, 0, "Your not Smart Enough!");
            }
        }else if(msg=="Dance"){
            AdminOpFlag = "ChangeDefaultDance";
            if(CheckSecurity(id)){ // Verify their Id against Admins List again to avoid message spoofing from unauthed users
                ShowMenu("Dances", id); // Show Admin Menu
            }else{
                llRegionSayTo(id, 0, "Your not Smart Enough!");
            }
        }else if(llListFindList(Dances, [msg])!=-1){ // If the Message is either a Dance or a Category
            if(llGetInventoryKey(msg)==NULL_KEY){ // It was not a Dance, Must be a Category
                ShowMenu(msg, id); // Show Menu comprised of Dances in Category specified by {msg}
            }else{ // It was a Dance.
                if(AdminOpFlag=="ChangeDefaultDance"){
                    DefaultDance = msg;
                    SendMessage("Default Dance is now: "+msg, id);
                }else{
                    Dancer("Change", id, msg); // Change slected dance for calling user
                }
                    
            }
        }else if(msg=="Start" || msg=="Stop" || msg==">>" || msg=="<<" || msg=="Sync"){
            DebugMessage(msg+" Message Received!");
            Dancer(msg, id, DefaultDance);
        }
    }
    
    touch_start(integer num){
        if(num>1){
            return;
        }
        
        key UserKey = llDetectedKey(0);
        if(NumDancers<MaxDancers){
            ShowMenu("MainMenu", UserKey);
        }
        
    }
    
    changed(integer change){
        if(change & CHANGED_INVENTORY){
            BootMessage = "Inventory Changed Detected, Re-Initializing...";
            llResetScript();
        }
    }
}