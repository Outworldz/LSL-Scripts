// Variables
    //Dialog Channel
    integer DHandleChannel;
    integer ChatHandle;
    
    // Textures
list Textures = []; // Holds list of Texture keys
integer NumTextures; // Total Number of Backgrounds
key CurrentTexture = NULL_KEY; // Will Hold key of Current Background
list TextureGrid = [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]; // Link Numbers of Texture Grid
list EmitterGrid = [25,26,27,28,29,30]; // Link Numbers of Emitter Texture Grid
string NoTextureID = "940333d1-4838-46f2-9331-58de6e726fa6";
integer lastStartNumber;

    //Poses
    
list Poses = []; // Hold List of Pose Names
integer NumPoses; // Hold Total Number of Poses
integer CurrentPoseIndex = 0;
key SeatedUserID;

    // Lights Variables
    list ColorVectors = [<0.000, 0.455, 0.851>, <0.498, 0.859, 1.000>, <0.224, 0.800, 0.800>, <0.239, 0.600, 0.439>, <0.180, 0.800, 0.251>, <0.004, 1.000, 0.439>, <1.000, 0.863, 0.000>, <1.000, 0.522, 0.106>, <1.000, 0.255, 0.212>, <0.522, 0.078, 0.294>, <0.941, 0.071, 0.745>, <0.694, 0.051, 0.788>, <1.000, 1.000, 1.000>];

    
    list Colors = ["BLUE", "AQUA", "TEAL", "OLIVE", "GREEN", "LIME", "YELLOW", "ORANGE", "RED", "MAROON", "FUCHSIA", "PURPLE", "WHITE"];
    list ColorsMenuStaticOptions = ["Custom", "Main Menu", "Next Page", "Prev Page"];
    
    list Lights = [33,34,48,49];
    list LightsMenu = ["Light On", "Light Off", "Intensity", "Color", "Radius", "FallOff", "Exit Menu", "Reset Lights"];
    string CurrentSubMenu = "";
    string CurrentColor = "";
    vector CustomColorVector;
    integer CurrentMenuPage = 0;
    list IntensityMenu = ["+0.001","-0.001","+0.01","-0.01","+0.1","-0.1","Main Menu"];
    list RadiusMenu = ["+0.5","-0.5","+1.0","-1.0","+5.0","-5.0","Main Menu"];
    list FallOffMenu = ["+0.100","-0.100","+0.250","-0.250","Main Menu"];
    integer LightsOn = FALSE;
    float Intensity = 1.0;
    float Radius = 10.0;
    float FallOff = 0.0;
    
    //Sit Target Variables
    vector SitTarget;
    

    // Security
list UserKeys = []; // Hold Authorized User Keys
key notecardQueryId; // Holds NoteCard Query ID
integer notecardLine; // Hold Id of Notecard Line Being Queried
list SecurityMenu = ["Owner", "Anyone", "Auth List", "Add User", "Remove User", "List Users", "Exit Menu"];

// Constants
string AuthCardName = ".users"; // Name of Notecard that Hold Names of Authorized Users (One Per line)
vector DefaultPostion = <-3.631882,-0.110687,-0.220459>;
rotation DefaultRotation = ZERO_ROTATION;

// Switches
string AuthMode = "List"; // Hold Type of Auth Mode (Owner,List,Open)
integer FireOn = FALSE;
string TimerSwitch = "";
integer CustomColor = FALSE;
integer Debug = FALSE;

//Functions

DebugMsg(string message){
    if(Debug){
        llOwnerSay(message);
    }
}

UpdateSitLinkTarget(string direction){
    list Positions =  llGetLinkPrimitiveParams(51, [PRIM_POS_LOCAL, PRIM_ROT_LOCAL]);
    vector LocPos = llList2Vector(Positions, 0);
    rotation LocRot = llList2Rot(Positions, 1);
    if(direction=="Left"){
        LocPos.y = LocPos.y - 0.1;
        llSetLinkPrimitiveParamsFast(51, [PRIM_POS_LOCAL, LocPos]);
    }else if(direction=="Right"){
        LocPos.y = LocPos.y + 0.1;
        llSetLinkPrimitiveParamsFast(51, [PRIM_POS_LOCAL, LocPos]);
    }else if(direction=="Forward"){
        LocPos.x = LocPos.x + 0.1;
        llSetLinkPrimitiveParamsFast(51, [PRIM_POS_LOCAL, LocPos]);
    }else if(direction=="Backward"){
        LocPos.x = LocPos.x - 0.1;
        llSetLinkPrimitiveParamsFast(51, [PRIM_POS_LOCAL, LocPos]);
    }else if(direction=="Up"){
        LocPos.z = LocPos.z + 0.1;
        llSetLinkPrimitiveParamsFast(51, [PRIM_POS_LOCAL, LocPos]);
    }else if(direction=="Down"){
        LocPos.z = LocPos.z - 0.1;
        llSetLinkPrimitiveParamsFast(51, [PRIM_POS_LOCAL, LocPos]);
    }else if(direction=="Reset"){
        llSetLinkPrimitiveParamsFast(51, [PRIM_POS_LOCAL, DefaultPostion, PRIM_ROT_LOCAL, DefaultRotation]);
    }else if(direction=="RR"){
        vector RotationVector = llRot2Euler(LocRot);
        RotationVector.z = RotationVector.z + (-0.5 / PI);
        rotation NewRot = llEuler2Rot(RotationVector);
        llSetLinkPrimitiveParamsFast(51, [PRIM_ROT_LOCAL, NewRot]);
    }else if(direction=="RL"){
        vector RotationVector = llRot2Euler(LocRot);
        RotationVector.z = RotationVector.z - (-0.5 / PI);
        rotation NewRot = llEuler2Rot(RotationVector);
        llSetLinkPrimitiveParamsFast(51, [PRIM_ROT_LOCAL, NewRot]);
    }
}

ShowSecurityDialog(string DialogType, key userid, string addremove){
    if(!ChatHandle){
        ChatHandle = llListen(DHandleChannel, "", NULL_KEY, "");
    }
    if(DialogType=="Normal"){
        llDialog(userid, "Security\n\n\t Access Modes:\n\t\tOwner Only\n\t\tAnyone\n\t\tAuthorized List\n\n\tModify List:\n\t\tAdd User\n\t\tRemove User", SecurityMenu, DHandleChannel);
    }else if(DialogType=="CustomInput"){
        llTextBox(userid, "Please enter the full Username of the person you with to "+addremove+" the authorized users list.", DHandleChannel);
    }
    TimerSwitch = "DialogTimeOut";
    llSetTimerEvent(30.0);
}

Security(){
    llOwnerSay("Attempting to Load Authorized User Config...");
    if(llGetInventoryKey(AuthCardName) == NULL_KEY){
        llOwnerSay("No .users config file found!");
    }else{
        notecardQueryId = llGetNotecardLine(AuthCardName, notecardLine);
    }
}

ChangeAuthList(string action, string username, key callinguser){
    integer spaceIndex = llSubStringIndex(username, " ");
    string  firstName  = llGetSubString(username, 0, spaceIndex - 1);
    string  lastName  = llGetSubString(username, spaceIndex + 1, -1);
    key userkey = osAvatarName2Key(firstName, lastName);
    if(action=="Add"){
        UserKeys = UserKeys + userkey;
        llOwnerSay("Added User: "+firstName+" "+lastName+" to Authorized Users List");
    }else if(action=="Remove"){
        integer placeinlist = llListFindList(UserKeys, [userkey]);
        if (placeinlist != -1){
            UserKeys = llDeleteSubList(UserKeys, placeinlist, placeinlist);
            llRegionSayTo(callinguser, 0, firstName+" "+lastName+" Removed, Loading Auth List...");
            ListAuthedUsers(callinguser);
        }else{
            llRegionSayTo(callinguser, 0, "That user was not found in the list! Showing List...");
            ListAuthedUsers(callinguser);
        }
    }
}

ListAuthedUsers(key id){
    llRegionSayTo(id, 0, "Authorized User List:");
    integer i;
    for(i=0;i<=(llGetListLength(UserKeys) - 1);i++){
        llRegionSayTo(id, 0, llKey2Name(llList2Key(UserKeys, i)));
    }
}

UpdateLights(string status){
    integer i;
    string Message;
    if(CustomColor){
        Message = status+","+(string)CustomColorVector+","+(string)Intensity+","+(string)Radius+","+(string)FallOff;
    }else{
        Message = status+","+llList2String(ColorVectors, llListFindList(Colors, [CurrentColor]))+","+(string)Intensity+","+(string)Radius+","+(string)FallOff;
    }
    for(i=0;i<=3;i++){
        llMessageLinked(llList2Integer(Lights, i), 0, Message, "");
    }
}

integer CheckSecurity(key TouchedMe){
    if(AuthMode=="Open"){
        return TRUE;
    }else if(AuthMode=="Owner"){
        if(TouchedMe==llGetOwner()){
            return TRUE;
        }else{
            llSay(0, "You are not allow to use this! Please contact Owner.");
            return FALSE;
        }
    }else if(AuthMode=="List"){
        if(llListFindList(UserKeys, [TouchedMe])!=-1){
            return TRUE;
        }else{
            llSay(0, "You are not authorized. Please contact Owner");
            return FALSE;
        }
    }else{
        llOwnerSay("Securiy Error");
        return FALSE;
    }
}

LoadTextures(){
    NumTextures = llGetInventoryNumber(INVENTORY_TEXTURE);
    if(NumTextures<=0){
        llOwnerSay("No Backgrounds Found!");
        llMessageLinked(LINK_SET, 0, "NOBG", "");
        return;
    }
    integer i;
    for(i=0;i<NumTextures;i++){
        //llOwnerSay("Found Texture: "+llGetInventoryName(INVENTORY_TEXTURE, i));
        Textures = Textures + llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE, i));
    }
    llOwnerSay("Total # Backgrounds: "+llGetListLength(Textures));
}

LoadPoses(){
    NumPoses = llGetInventoryNumber(INVENTORY_ANIMATION);
    if(NumPoses<=0){
        llOwnerSay("No Poses Found!");
        llMessageLinked(LINK_SET, 0, "NOPOSE", "");
        return;
    }
    integer i;
    for(i=0;i<NumPoses;i++){
        Poses = Poses + [llGetInventoryName(INVENTORY_ANIMATION, i)];
    }
    llOwnerSay("Total # Poses: "+llGetListLength(Poses));
}

integer Initialize(){
    llOwnerSay("Starting Photo Studio...");
    DHandleChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
    LoadTextures();
    Security();
    SetLinkSitTarget();
    LoadPoses();
    return TRUE;
}

SetLinkSitTarget(){
    llSetSitText("Pose");
    llLinkSitTarget(51, <0.0,0.0,1.2>, ZERO_ROTATION);
}

// Texture Grid Functions

UpdateGrid(integer startnum){
    integer i;
    integer NumOnGrid = llGetListLength(TextureGrid) - 1;
    string TextureID;
    for(i=0;i<=NumOnGrid;i++){
        TextureID = llList2String(Textures, startnum);
        startnum++;
        integer CurrentLinkID = llList2Integer(TextureGrid, i);
        if(TextureID!=""){
            llSetLinkPrimitiveParamsFast(CurrentLinkID, [
                PRIM_TEXTURE, 0, TextureID, <1.0, 1.0, 0.0>, ZERO_VECTOR,0.0,
                PRIM_FULLBRIGHT, 0, TRUE]);
                lastStartNumber = startnum;
        }else{
            startnum = 0;
            lastStartNumber = 0;
        }
    }
}

ChangePose(string Direction){
    if(Direction=="Next"){
        llStopAnimation(llList2String(Poses, CurrentPoseIndex));
        CurrentPoseIndex++;
        if(llList2String(Poses, CurrentPoseIndex)==""){
            CurrentPoseIndex = 0;
        }
        llStartAnimation(llList2String(Poses, CurrentPoseIndex));
    }else if(Direction=="Prev"){
        llStopAnimation(llList2String(Poses, CurrentPoseIndex));
        CurrentPoseIndex--;
        if(llList2String(Poses, CurrentPoseIndex)==""){
            CurrentPoseIndex = llGetListLength(Poses) - 1;
        }
        llStartAnimation(llList2String(Poses, CurrentPoseIndex));
    }
    llSay(0, "New Pose: "+llList2String(Poses, CurrentPoseIndex));
}

default
{
    on_rez(integer start_params){
        llResetScript();
    }
    
    state_entry()
    {
        if(Initialize()){
            llOwnerSay("Initialization Complete");
            UpdateGrid(0);
        }
    }
    
    changed(integer change){
        if(change & CHANGED_INVENTORY){
            TimerSwitch = "Inventory";
            llSetTimerEvent(5.0);
        }
        if(change & CHANGED_LINK){
            SeatedUserID = llAvatarOnLinkSitTarget(51);
            if(SeatedUserID!=NULL_KEY){ // Someone is Sitting
                llRequestPermissions(SeatedUserID, PERMISSION_TRIGGER_ANIMATION);
            }else{ // Someone Just Stood Up
                if (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION){
                    llStopAnimation(llList2String(Poses, CurrentPoseIndex));
                }
            }
        }
    }
    
    run_time_permissions(integer perms){
        llStopAnimation("sit");
        llSay(0, "Starting Pose: "+llList2String(Poses, CurrentPoseIndex));
        llStartAnimation(llList2String(Poses, CurrentPoseIndex));
    }
    
    touch(integer num){
        key WhoTouched = llDetectedKey(0);
        integer WhatTouched = llDetectedLinkNumber(0);
        integer authok = CheckSecurity(WhoTouched);
        if(!authok){
            return;
        }
        if(llDetectedLinkNumber(0)==LINK_ROOT){
            vector TouchedPos = llDetectedTouchST(0); // Get Click Position
            if(TouchedPos.x >= 0.14 && TouchedPos.x <= 0.185 && TouchedPos.y <= 0.248 && TouchedPos.y >= 0.103){ // Left Texture Change Button
                UpdateGrid((lastStartNumber + 21));
            }else if(TouchedPos.x >= 0.21 && TouchedPos.x <= 0.26 && TouchedPos.y <= 0.248 && TouchedPos.y >= 0.103){ // Right Texture Change Button
                UpdateGrid((lastStartNumber - 21));
            }else if(TouchedPos.x >= 0.669 && TouchedPos.x <= 0.733 && TouchedPos.y <= 0.68 && TouchedPos.y >= 0.57){ // Fire On/Off Button
                if(FireOn){
                    llSetLinkAlpha(47, 1.0, 1);
                    llRegionSayTo(WhoTouched, 0, "Fire Off");
                }else{
                    llSetLinkAlpha(47, 0.0, 1);
                    llRegionSayTo(WhoTouched, 0, "Fire On");
                }
                FireOn = !FireOn;
            }else if(TouchedPos.x >= 0.669 && TouchedPos.x <= 0.733 && TouchedPos.y <= 0.539 && TouchedPos.y >= 0.421){ // Lights Menu Button
                ChatHandle = llListen(DHandleChannel, "", NULL_KEY, "");
                llDialog(WhoTouched, "Lighting Controls", LightsMenu, DHandleChannel);
                TimerSwitch = "DialogTimeOut";
                llSetTimerEvent(30.0);
            }else if(TouchedPos.x >= 0.379 && TouchedPos.x <= 0.457 && TouchedPos.y <= 0.187 && TouchedPos.y >= 0.045){ // Pose Scroll Left
                ChangePose("Next");
            }else if(TouchedPos.x >= 0.661 && TouchedPos.x <= 0.734 && TouchedPos.y <= 0.194 && TouchedPos.y >= 0.056){ // Pose Scroll Right
                ChangePose("Prev");
            }else if(TouchedPos.x >= 0.686 && TouchedPos.x <= 0.728 && TouchedPos.y <= 0.938 && TouchedPos.y >= 0.780){ // Pose Scroll Right
                ShowSecurityDialog("Normal", WhoTouched, ""); 
            }
        }else if(llListFindList(TextureGrid, WhatTouched)!=-1){ // If Prim Touched was a Texture Grid Prim
            list Texture = llGetLinkPrimitiveParams(WhatTouched, [PRIM_TEXTURE, 0]);
                //Lower
            llSetLinkPrimitiveParamsFast(50, [
                PRIM_TEXTURE, 0, llList2String(Texture, 0), <1.000000,0.351709,0.000000>, <0.000000,-0.324137,0.000000>, 1.570796,
                PRIM_FULLBRIGHT, 0, TRUE]);
                //Curve
            llSetLinkPrimitiveParamsFast(32, [
                PRIM_TEXTURE, 2, llList2String(Texture, 0), <-1.000000,0.681924,0.000000>, <0.000000,0.124485,0.000000>, 1.570796,
                PRIM_FULLBRIGHT, 0, TRUE]);
                //Upper
            llSetLinkPrimitiveParamsFast(46, [
                PRIM_TEXTURE, 2, llList2String(Texture, 0), <1.000000,0.494858,0.000000>, <0.000000,0.252571,0.000000>, 0.0,
                PRIM_FULLBRIGHT, 0, TRUE]);
        }else if(llListFindList(EmitterGrid, WhatTouched)!=-1){ // If Prim Touched was a Emitter Grid Prim
            list ToEmit = llGetLinkPrimitiveParams(WhatTouched, [PRIM_TEXTURE, 0]);
            llRegionSayTo(WhoTouched, 0, "Emitters Toggled");
            llMessageLinked(LINK_SET, 0, llList2String(ToEmit, 0), NULL_KEY);
        }else if(llDetectedLinkNumber(0)==2){ // If Prim Touched was the Pose Circle Menu
             vector TouchedPos = llDetectedTouchST(0); // Get Click Position
            if(TouchedPos.x >= 0.348 && TouchedPos.x <= 0.651 && TouchedPos.y <= 0.206 && TouchedPos.y >= 0.022){ // Move Avatar Left
                UpdateSitLinkTarget("Left");
            }else if(TouchedPos.x >= 0.348 && TouchedPos.x <= 0.651 && TouchedPos.y <= 0.957 && TouchedPos.y >= 0.766){ // Move Avatar Right
                UpdateSitLinkTarget("Right");
            }else if(TouchedPos.x >= 0.033 && TouchedPos.x <= 0.228 && TouchedPos.y <= 0.639 && TouchedPos.y >= 0.336){ // Move Avatar Up
                UpdateSitLinkTarget("Up");
            }else if(TouchedPos.x >= 0.777 && TouchedPos.x <= 0.996 && TouchedPos.y <= 0.642 && TouchedPos.y >= 0.336){ // Move Avatar Down
                UpdateSitLinkTarget("Down");
            }else if(TouchedPos.x >= 0.581 && TouchedPos.x <= 0.716 && TouchedPos.y <= 0.530 && TouchedPos.y >= 0.258){ // Move Avatar Forward
                UpdateSitLinkTarget("Forward");
            }else if(TouchedPos.x >= 0.270 && TouchedPos.x <= 0.416 && TouchedPos.y <= 0.696 && TouchedPos.y >= 0.429){ // Move Avatar Backward
                UpdateSitLinkTarget("Backward");
            }else if(TouchedPos.x >= 0.680 && TouchedPos.x <= 0.861 && TouchedPos.y <= 0.849 && TouchedPos.y >= 0.687){ // Move Avatar Rotate Right
                UpdateSitLinkTarget("RR");
            }else if(TouchedPos.x >= 0.144 && TouchedPos.x <= 0.318 && TouchedPos.y <= 0.303 && TouchedPos.y >= 0.144){ // Move Avatar Rotate Left
                UpdateSitLinkTarget("RL");
            }else if(TouchedPos.x >= 0.573 && TouchedPos.x <= 0.729 && TouchedPos.y <= 0.701 && TouchedPos.y >= 0.537){ // Reset Avatar Position
                llRegionSayTo(WhoTouched, 0, "Resetting Avatar Position and Rotation...");
                UpdateSitLinkTarget("Reset");
            }
        }else{ // Some Other Prim was Touched Speak It's ID
            //llOwnerSay((string)llDetectedLinkNumber(0));
        }
    }
    
    listen(integer chan, string sender, key id, string msg){
        if(msg=="Anyone"){
            AuthMode = "Open";
            llRegionSayTo(id, 0, "Security mode set to: Anyone");
        }else if(msg=="Auth List"){
            AuthMode = "List";
            llRegionSayTo(id, 0, "Security mode set to: Authorized Users List");
        }else if(msg=="Owner"){
            AuthMode = "Owner";
            llRegionSayTo(id, 0, "Security mode set to: Owner Only");
        }
        if(msg=="Reset Lights"){
            Intensity = 1.0;
            Radius = 10.0;
            FallOff = 0.0;
            CustomColor = FALSE;
            CurrentColor = "<1.0,1.0,1.0>";
            llRegionSayTo(id, 0, "Resetting Lights...");
            UpdateLights("TRUE");
        }else if(msg=="Light Off"){ // Turn Lights On
            llRegionSayTo(id, 0, "Turning Lights Off...");
            UpdateLights("FALSE");
        }else if(msg=="Light On"){ // Turn Lights Off
            llRegionSayTo(id, 0, "Turning Lights On...");
            UpdateLights("TRUE");
        }else if(msg=="Exit Menu"){ // Exit Menu
            CurrentSubMenu = "";
            llListenRemove(ChatHandle);
        }else if(msg=="Color"){ // Change Color
            CurrentSubMenu = msg;
            llRegionSayTo(id, 0, "Change Color of Lights");
            integer StartIndex = (CurrentMenuPage * 7);
            list DialogMenu = llList2List(Colors, StartIndex, (StartIndex + 7)) + ColorsMenuStaticOptions;
            llDialog(id, "Colors", DialogMenu, DHandleChannel);
            TimerSwitch = "DialogTimeOut";
            llSetTimerEvent(30.0);
        }else if(msg=="Intensity"){ // Change Intensity
            CurrentSubMenu = msg;
            llRegionSayTo(id, 0, "Change Light Intensity");
            llDialog(id, "Intensity", IntensityMenu, DHandleChannel);
            TimerSwitch = "DialogTimeOut";
            llSetTimerEvent(30.0);
        }else if(msg=="Radius"){ // Change Effective Radius
            CurrentSubMenu = msg;
            llRegionSayTo(id, 0, "Change Light Radius");
            llDialog(id, "Radius", RadiusMenu, DHandleChannel);
            TimerSwitch = "DialogTimeOut";
            llSetTimerEvent(30.0);
        }else if(msg=="FallOff"){ // Change Effective Radius
            CurrentSubMenu = msg;
            llRegionSayTo(id, 0, "Change Light Fall Off");
            llDialog(id, "FallOff", FallOffMenu, DHandleChannel);
            TimerSwitch = "DialogTimeOut";
            llSetTimerEvent(30.0);
        }else if(msg=="Add User"){ // Prompt User for Persons Name to add to Authorized User List
            CurrentSubMenu = msg;
            ShowSecurityDialog("CustomInput", id, "Add to");
        }else if(msg=="Remove User"){ // Prompt User for Persons Name to remove from Authorized User List
            CurrentSubMenu = msg;
            ShowSecurityDialog("CustomInput", id, "Remove from");
        }else if(msg=="List Users"){ // Prompt User for Persons Name to remove from Authorized User List
            CurrentSubMenu = "";
            llSetTimerEvent(0);
            llRegionSayTo(id, 0, "Listing Authorized Users...");
            ListAuthedUsers(id);
        }else if(CurrentSubMenu == "Color"){ // If we are processing a response from the Colors Sub Menu
            if(msg=="Next Page"){
                CurrentMenuPage++;
                integer StartIndex = (CurrentMenuPage * 7);
                list DialogMenu = llList2List(Colors, StartIndex, (StartIndex + 7)) + ColorsMenuStaticOptions;
                llDialog(id, "Colors", DialogMenu, DHandleChannel);
                TimerSwitch = "DialogTimeOut";
                llSetTimerEvent(30.0);
            }else if(msg == "Prev Page"){
                CurrentMenuPage--;
                integer StartIndex = (CurrentMenuPage * 7);
                list DialogMenu = llList2List(Colors, StartIndex, (StartIndex - 7)) + ColorsMenuStaticOptions;
                llDialog(id, "Colors", DialogMenu, DHandleChannel);
                TimerSwitch = "DialogTimeOut";
                llSetTimerEvent(30.0);
            }else if(msg == "Custom"){
                CurrentSubMenu = "CustomColorVector";
                llTextBox(id, "Please Enter a Valid Color Vector\nIn the format of: <128,128,128>\n\n Note: Submit Empty Value to return Menu", DHandleChannel);
                TimerSwitch = "DialogTimeOut";
                llSetTimerEvent(30.0);
            }else if(msg == "Main Menu"){
                CurrentSubMenu = msg;
                CurrentMenuPage = 0;
                llDialog(id, "Lighting Controls", LightsMenu, DHandleChannel);
                TimerSwitch = "DialogTimeOut";
                llSetTimerEvent(30.0);
            }else if(llListFindList(Colors, [msg])!=-1){
                CustomColor = FALSE;
                string ColorVector = llList2String(ColorVectors, llListFindList(Colors, [msg]));
                CurrentColor = msg;
                UpdateLights("TRUE");
                llListenRemove(ChatHandle);
            }
        }else if(CurrentSubMenu=="CustomColorVector"){
            if(msg==""){
                CurrentSubMenu = "Color";
                integer StartIndex = (CurrentMenuPage * 7);
                list DialogMenu = llList2List(Colors, StartIndex, (StartIndex + 7)) + ColorsMenuStaticOptions;
                llOwnerSay((string)llGetListLength(DialogMenu));
                llDialog(id, "Colors", DialogMenu, DHandleChannel);
                TimerSwitch = "DialogTimeOut";
                llSetTimerEvent(30.0);
            }else{
                vector NewColor = msg;
                if(NewColor.x <= 255 && NewColor.x >=0 && NewColor.y <= 255 && NewColor.y >= 0 && NewColor.z <= 255 && NewColor.z >= 0){ // Valid Input Vector
                    CustomColor = TRUE;
                    CustomColorVector = NewColor;
                    UpdateLights("TRUE");
                }else{ // InValid Input Vector
                    CustomColor = FALSE;
                   llRegionSayTo(id, 0, "Invalid Input Vector. Please Try Again");
                   CurrentSubMenu = "CustomColorVector";
                   llTextBox(id, "Please Enter a Valid Color Vector\nIn the format of: <128,128,128>\n\n Note: Submit Empty Value to return Menu", DHandleChannel);
                   TimerSwitch = "DialogTimeOut";
                   llSetTimerEvent(30.0);
                }
            }
        }else if(CurrentSubMenu=="Intensity"){
            if(msg=="Main Menu"){
                CurrentSubMenu = msg;
                CurrentMenuPage = 0;
                llDialog(id, "Lighting Controls", LightsMenu, DHandleChannel);
                TimerSwitch = "DialogTimeOut";
                llSetTimerEvent(30.0);
            }else if(llListFindList(IntensityMenu, [msg]) != -1){
                string mathOP = llGetSubString(msg, 0, 0);
                string AdjAmount = llGetSubString(msg, 1, -1);
                if(mathOP=="-"){
                    Intensity = Intensity - (float)AdjAmount;
                }else if(mathOP=="+"){
                    Intensity = Intensity + (float)AdjAmount;
                }
                UpdateLights("TRUE");
                llDialog(id, "Intensity", IntensityMenu, DHandleChannel);
                TimerSwitch = "DialogTimeOut";
                llSetTimerEvent(0);
                llSetTimerEvent(30.0);
            }
        }else if(CurrentSubMenu=="Radius"){
            if(msg=="Main Menu"){
                CurrentSubMenu = msg;
                CurrentMenuPage = 0;
                llDialog(id, "Lighting Controls", LightsMenu, DHandleChannel);
                TimerSwitch = "DialogTimeOut";
                llSetTimerEvent(30.0);
            }else if(llListFindList(RadiusMenu, [msg]) != -1){
                string mathOP = llGetSubString(msg, 0, 0);
                string AdjAmount = llGetSubString(msg, 1, -1);
                if(mathOP=="-"){
                    Radius = Radius - (float)AdjAmount;
                }else if(mathOP=="+"){
                    Radius = Radius + (float)AdjAmount;
                }
                UpdateLights("TRUE");
                llDialog(id, "Radius", RadiusMenu, DHandleChannel);
                TimerSwitch = "DialogTimeOut";
                llSetTimerEvent(0);
                llSetTimerEvent(30.0);
            }
        }else if(CurrentSubMenu=="FallOff"){
            if(msg=="Main Menu"){
                CurrentSubMenu = msg;
                CurrentMenuPage = 0;
                llDialog(id, "Lights Menu", LightsMenu, DHandleChannel);
                TimerSwitch = "DialogTimeOut";
                llSetTimerEvent(30.0);
            }else if(llListFindList(FallOffMenu, [msg]) != -1){
                string mathOP = llGetSubString(msg, 0, 0);
                string AdjAmount = llGetSubString(msg, 1, -1);
                if(mathOP=="-"){
                    FallOff = FallOff + (float)AdjAmount;
                }else if(mathOP=="+"){
                    FallOff = FallOff - (float)AdjAmount;
                }
                UpdateLights("TRUE");
                llDialog(id, "FallOff", FallOffMenu, DHandleChannel);
                TimerSwitch = "DialogTimeOut";
                llSetTimerEvent(0);
                llSetTimerEvent(30.0);
            }
        }else if(CurrentSubMenu=="Remove User"){ // Receiving Name of User to Remove from Security Tab
            ChangeAuthList("Remove", msg, id);
        }else if(CurrentSubMenu=="Add User"){ // Receiving Name of User to Add to Security Tab
            ChangeAuthList("Add", msg, id);
        }
    }
    
    
    timer(){
        if(TimerSwitch=="Inventory"){
            llOwnerSay("Inventory Change Detected... Reloading...");
            llResetScript();
        }else if(TimerSwitch=="DialogTimeOut"){
            llSay(0, "No Respose received to Dialog, Closing Listener...");
            llListenRemove(ChatHandle);
            TimerSwitch = "";
            llSetTimerEvent(0);
        }
    }
    
    dataserver(key query_id, string data)
    {
        if (query_id == notecardQueryId)
        {
            if (data == EOF)
                llOwnerSay("Done reading notecard, read " + (string) notecardLine + " notecard lines.");
            else
            {
                // bump line number for reporting purposes and in preparation for reading next line
                ++notecardLine;
                integer spaceIndex = llSubStringIndex(data, " ");
                string  firstName  = llGetSubString(data, 0, spaceIndex - 1);
                string  lastName  = llGetSubString(data, spaceIndex + 1, -1);
                UserKeys = UserKeys + osAvatarName2Key(firstName, lastName);
                llOwnerSay("Added User: "+firstName+" "+lastName);
                notecardQueryId = llGetNotecardLine(AuthCardName, notecardLine);
            }
        }
    }
}