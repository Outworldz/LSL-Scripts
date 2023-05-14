// Wholearth Television Control Engine v1.0
// Created by Tech Guy 2015

// Configuration

    // Constants
    string MediaURL = "http://api.orbitsystems.ca/wetv.html";
    string ScreenFaceKey = "03d8e823-c9b6-49f1-bc72-a9b3e4cf83c5";
    integer ScreenLinkID = 11;
    integer ScreenFace = 5;
    integer MenuButtonID = 13;
    integer FramePrimID = 12;
    list TVParts = [];
    integer WETVMenuChannel = -4201;
    float MenuTimeOut = 30.0;
    string HelpCardName = "Wholearth TV Manual";
    
    // Variables
    integer ISON = FALSE; // State of Television (ie: Is Media Prim ON);
    integer WETVMenuHandle; // Hold Handle for Main Menu
    string MFLAG = ""; // Holds Name of Parent Menu
    key ActiveUser = NULL_KEY;
    integer SameGroup; // Hold Boolean Value Representing wether user has same group as object
    
    string AuthCard = ".whitelist"; // Contains Name of NC containing authorized people to use the tv
    list AuthedUsers = []; // List Containing Authorized Users as read from Config File.
    key notecardQueryId;
    integer TVShown = FALSE;
     // script-wise, the first notecard line is line 0, the second line is line 1, etc.
    integer notecardLine;
    
        //Menu
    list MainMenu = ["Power", "Help", "Exit Menu"]; // All Users Menu
    list AdminMenuOption = ["Admin"]; // Admin Menu Option
    list AdminMenu = ["List Users", "Add User", "Del User", "Admin Access", "TV Access", "Reset TV", "Main Menu", "Exit Menu"]; // Admin Menu
    list PermissionTypesTV = ["Owner", "Anyone", "Group", "Main Menu", "Exit Menu"];
    list PermissionTypesAdmin = ["Owner", "List", "Anyone", "Group", "Main Menu", "Exit Menu"];
    
        // Menu Security Switches
    string AdminMenuAccessMode = "Owner"; // Who do we include the Admin Menu on the Main menu for? (Anyone/Owner/List)
    string TVMenuAccessMode = "Owner"; // Who is allowed to access the TV Menu
    
     // Switches
    integer AutoPlay = TRUE; // Should we Auto Play the Media on the Face
    
    
// Functions
SetMediaFace(integer FaceState){
    if(FaceState){
        llSetLinkTexture(ScreenLinkID, ScreenFaceKey, ScreenFace);
        integer TVAccessMode;
        if(TVMenuAccessMode=="Owner"){ TVAccessMode = PRIM_MEDIA_PERM_OWNER; }
        if(TVMenuAccessMode=="Group"){ TVAccessMode = PRIM_MEDIA_PERM_GROUP; }
        if(TVMenuAccessMode=="Anyone"){ TVAccessMode = PRIM_MEDIA_PERM_ANYONE; }
        llSetLinkMedia(ScreenLinkID, ScreenFace, [
            PRIM_MEDIA_ALT_IMAGE_ENABLE, TRUE,
            PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_MINI,
            PRIM_MEDIA_HOME_URL, MediaURL,
            PRIM_MEDIA_CURRENT_URL, MediaURL,
            PRIM_MEDIA_AUTO_PLAY, AutoPlay,
            PRIM_MEDIA_AUTO_ZOOM, TRUE,
            PRIM_MEDIA_PERMS_INTERACT, TVAccessMode,
            PRIM_MEDIA_PERMS_CONTROL, TVAccessMode
        ]);
    }else if(!FaceState){
        llClearLinkMedia(ScreenLinkID, ScreenFace);
        llSetLinkTexture(ScreenLinkID, ScreenFaceKey, ScreenFace);
    }
}

ToggleMediaFace(){
    if(!ISON){
        SetMediaFace(TRUE);
        SendMessage("User", "Powering On...");
        ISON = TRUE;
    }else{
        SetMediaFace(FALSE);
        SendMessage("User", "Powering Off...");
        ISON = FALSE;
    }
}

Initialize(){
    llSay(0, "Initializing...");
    TVParts = [ ScreenLinkID, FramePrimID, MenuButtonID ];
    WETVMenuChannel = (integer)llFrand(DEBUG_CHANNEL)*-1; // Set Random MenuComChannel
    if(ISON){ // Check and Set Default Media Prim Face Parameters
        SetMediaFace(TRUE);
    }else{
        SetMediaFace(FALSE);
    }
    llListenRemove(WETVMenuHandle);
    llSleep(0.1);
    WETVMenuHandle = llListen(WETVMenuChannel, "", "", "");
    llSay(0, "TV Ready! Touch Power Button for Menu.");
}

ProcessWhiteList(string inputSTR){
    if(inputSTR=="get"){
        if (llGetInventoryKey(AuthCard) == NULL_KEY)
            {
                llSay(0,  "Notecard '" + AuthCard + "' missing or unwritten");
                state broken;
            }
        llSay(0, "Reading Authorized Users from '" + AuthCard + "'.");
        notecardQueryId = llGetNotecardLine(AuthCard, notecardLine);
    }else{
        integer spaceIndex = llSubStringIndex(inputSTR, " ");
        string  firstName  = llGetSubString(inputSTR, 0, spaceIndex - 1);
        string  lastName  = llGetSubString(inputSTR, spaceIndex + 1, -1);
        string  AuthedID = osAvatarName2Key(firstName, lastName);
        if(AuthedID!=""){
            AuthedUsers = AuthedUsers + [AuthedID];
        }else{
            llSay(0, "Invalid Username in WhiteList NoteCard.");
        }
    }
}

ShowMenu(string MenuToShow){
    list CurMenu = [];
    string DialogMsg = "";
    // Check if Touching User Has TV Access
    if(TVMenuAccessMode=="Owner" && ActiveUser!=llGetOwner()){ // If TVMenuAccess Mode is Owner Only and It is not the Owner touching
        SendMessage("User","You do not have access to the Main Menu. Please contact Owner.");
        ResetMenu(FALSE);
        return;
    }else if(TVMenuAccessMode=="List" && llListFindList(AuthedUsers, [ActiveUser])==-1){ // If TVMenuAccess Mode is List and Touching User is not in the List
        if(ActiveUser != llGetOwner()){
            SendMessage("User","You do not have access to the Main Menu. Please contact Owner.");
            ResetMenu(FALSE);
            return;
        }
    }else if(TVMenuAccessMode=="Group" && !SameGroup){
        SendMessage("User","You do not have access to the Main Menu. Please activate your group tag or contact Owner.");
        ResetMenu(FALSE);
        return;
    }
    
    if(MenuToShow=="Main"){
        // Check if Touching User has Admin Menu Access
        if(AdminMenuAccessMode=="Owner" && ActiveUser==llGetOwner()){ // Admin Access Mode is Owner and Owner is Clicking Menu Button (Include Admin Menu)
            DialogMsg = "Main Menu (Admin Access)";
            CurMenu = AdminMenuOption + MainMenu;
        }else if(AdminMenuAccessMode=="List" && llListFindList(AuthedUsers, [ActiveUser])!=-1){ // Admin Access Mode is List and Active User is found in Authed List (Include Admin Menu)
            DialogMsg = "Main Menu (Admin Access)";
            CurMenu = AdminMenuOption + MainMenu;
        }else if(AdminMenuAccessMode=="Anyone"){ // Admin Access Mode is Anyone (Include Admin Menu)
            DialogMsg = "Main Menu (Admin Access)";
            CurMenu = AdminMenuOption + MainMenu;
        }else if(AdminMenuAccessMode=="Group" && SameGroup){
            DialogMsg = "Main Menu (Admin Access)";
            CurMenu = AdminMenuOption + MainMenu;
        }else{
            DialogMsg = "Main Menu";
            CurMenu = MainMenu;
        }
    }else if(MenuToShow=="Admin"){
        DialogMsg = "Admin Menu";
        CurMenu = AdminMenu;
    }else if(MenuToShow=="AdminAccess"){
        CurMenu = PermissionTypesAdmin;
    }else if(MenuToShow=="TVAcess"){
        CurMenu = PermissionTypesTV;
    }
    llDialog(ActiveUser, DialogMsg, CurMenu, WETVMenuChannel);
    llSetTimerEvent(MenuTimeOut);
}

SendMessage(string Type, string Message){
    if(Type=="Debug"){
        
    }else if(Type=="User"){
        llRegionSayTo(ActiveUser, 0, Message);
    }
}

ResetMenu(integer ISTIMER){
    if(ISTIMER){
        SendMessage("User", "Menu Response TimeOut. Please Re-Open Menu...");
    }else{
        SendMessage("User", "Menu Closed.");
    }
    llSetTimerEvent(0);
    ActiveUser = NULL_KEY;
    MFLAG = "";
    SameGroup = 0;
    llListenRemove(WETVMenuHandle);
}

UserManager(string Action, string User){
    if(Action=="List"){
        integer i;
        string OutputString = "Authorized Users List:\n";
        for(i=0;i<llGetListLength(AuthedUsers);i++){
            string Name = osKey2Name(llList2Key(AuthedUsers, i));
            OutputString = OutputString + "User "+(string)i+": "+Name+"\n";
        }
        SendMessage("User", OutputString);
    }else if(Action=="Add"){
        integer spaceIndex = llSubStringIndex(User, " ");
        string  firstName  = llGetSubString(User, 0, spaceIndex - 1);
        string  lastName  = llGetSubString(User, spaceIndex + 1, -1);
        string  AuthedID = osAvatarName2Key(firstName, lastName);
        if(AuthedID!=""){
            AuthedUsers = AuthedUsers + [AuthedID];
            SendMessage("User", "User "+firstName+" "+lastName+" Added to List!");
            UserManager("List", "");
            ResetMenu(FALSE);
        }else{
            SendMessage("User", "Invalid Legacy Username Supplied!");
            ResetMenu(FALSE);
        }
    }else if(Action=="Del"){
        integer spaceIndex = llSubStringIndex(User, " ");
        string  firstName  = llGetSubString(User, 0, spaceIndex - 1);
        string  lastName  = llGetSubString(User, spaceIndex + 1, -1);
        string  AuthedID = osAvatarName2Key(firstName, lastName);
        if(AuthedID!=""){
            integer KeyIndex = llListFindList(AuthedUsers, [AuthedID]);
            AuthedUsers = llDeleteSubList(AuthedUsers, KeyIndex, KeyIndex);
            SendMessage("User", "User "+firstName+" "+lastName+" Removed from List!");
            UserManager("List", "");
            ResetMenu(FALSE);
        }else{
            SendMessage("User", "Invalid Legacy Username Supplied!");
            ResetMenu(FALSE);
        }
    }
}

// Toggle Displaying the TV from Behind the HotTub
ToggleShowTV(integer Mode){
    vector LocPos = ZERO_VECTOR;
    integer i;
    for(i=0;i<llGetListLength(TVParts);i++){
        list Properties = llGetLinkPrimitiveParams(llList2Integer(TVParts, i), [
            PRIM_POS_LOCAL
        ]);
        //llOwnerSay(llDumpList2String(Properties, "||"));
        LocPos = llList2Vector(Properties, 0);
        if(Mode){
            LocPos = LocPos + <1.85,0,0>;
        }else{
            LocPos = LocPos + <-1.85,0,0>;
        }
        llSetLinkPrimitiveParamsFast(llList2Integer(TVParts, i), [
            PRIM_POS_LOCAL, LocPos
        ]);
    }
    TVShown = Mode;
}

// Main Program Code
 
default{
    on_rez(integer params){
        llResetScript();
    }
    
    state_entry(){
        ProcessWhiteList("get");
        integer WETVMenuChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
    }
    
    touch_start(integer num){
        ActiveUser = llDetectedKey(0);
        integer WhatTouched = llDetectedLinkNumber(0);
        SameGroup = llDetectedGroup(0);
        //llOwnerSay((string)WhatTouched);
        if(WhatTouched==MenuButtonID){
            WETVMenuHandle = llListen(WETVMenuChannel, "", "", "");
            ShowMenu("Main");
        }else if(WhatTouched==FramePrimID){
            ToggleShowTV(!TVShown);
        }
    }
    
    listen(integer InChannel, string Name, key UserID, string Message){
        if(Message=="Exit Menu"){ // Exit Menu (Catch regardless of Parent Menu)
            ResetMenu(FALSE);
        }else if(Message=="Main Menu"){
            MFLAG = "";
            llSetTimerEvent(0);
            ShowMenu("Main");
        }
        
        if(MFLAG==""){ // We have a return from the Main Menu
            if(Message=="Power"){ // Toggle TV Power
                ToggleMediaFace();
                llSetTimerEvent(0);
            }else if(Message=="Admin"){ // Enter Admin Menu
                MFLAG = "Admin";
                ShowMenu("Admin");
            }else if(Message=="Help"){ // Give TV Manual If there is One
                integer i;
                for(i=0;i<llGetInventoryNumber(INVENTORY_NOTECARD);i++){
                    //llOwnerSay("TEST");
                    if(llGetInventoryName(INVENTORY_NOTECARD, i)==HelpCardName){
                        SendMessage("User", "Please take TV Manual...");
                        llGiveInventory(ActiveUser, llGetInventoryName(INVENTORY_NOTECARD, i));
                        ResetMenu(FALSE);
                    }
                }
            }
        }else if(MFLAG=="Admin"){ // Admin Menu was Shown as we are processing button response
            if(Message=="List Users"){ // List Authorized Users
                UserManager("List", "");
                ResetMenu(FALSE);
            }else if(Message=="Add User"){ // Add User to Authorized User List (Prompt User with TextBox)
                MFLAG = "AddUser";
                llTextBox(ActiveUser, "Add User\nPlease Enter Legacy Name:", WETVMenuChannel);
            }else if(Message=="Del User"){
                MFLAG = "DelUser";
                UserManager("List", "");
                llTextBox(ActiveUser, "Del User\nPlease Enter Legacy Name:", WETVMenuChannel);
            }else if(Message=="TV Access"){
                MFLAG = "TVAcess";
                ShowMenu(MFLAG);
            }else if(Message=="Admin Access"){
                MFLAG = "AdminAccess";
                ShowMenu(MFLAG);
            }else if(Message=="Reset TV"){
                SendMessage("User", "Resetting TV...");
                llResetScript();
            }
        }else if(MFLAG=="AddUser"){ // We received a response from TextBox about Who to Add to Authorized Users List
            UserManager("Add", Message);
        }else if(MFLAG=="DelUser"){
            UserManager("Del", Message);
        }else if(MFLAG=="AdminAccess"){
            AdminMenuAccessMode = Message;
            SendMessage("User", "Admin Menu Access Mode: "+Message);
            ResetMenu(FALSE);
        }else if(MFLAG=="TVAcess"){
            TVMenuAccessMode = Message;
            SendMessage("User", "TV Menu Access Mode: "+Message);
            ResetMenu(FALSE);
        }
    }
    
    dataserver(key query_id, string data){
        if (query_id == notecardQueryId){
            if (data == EOF){
                llOwnerSay("Done reading whitelist notecard, added " + (string) notecardLine + " authorized users.");
                Initialize();
            }else{
                // bump line number for reporting purposes and in preparation for reading next line
                ProcessWhiteList(data);
                ++notecardLine;
                llOwnerSay("Authorized User: " + (string) notecardLine + " " + data);
                notecardQueryId = llGetNotecardLine(AuthCard, notecardLine);
            }
        }
    }
    
    timer(){
        ResetMenu(TRUE);
    }
    
     changed(integer change){
        if(change & CHANGED_INVENTORY){
            llSay(0, "Rebooting...");
            llResetScript();
        }
    }
}

state broken{
    state_entry(){
        llOwnerSay("TV Broken, Please correct for previously displayed error.");
    }
    
    changed(integer change){
        if(change & CHANGED_INVENTORY){
            llSay(0, "Rebooting...");
            llResetScript();
        }
    }
}