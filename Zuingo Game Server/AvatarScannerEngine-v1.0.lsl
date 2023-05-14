// Avatar Scanner Engine v1.0
// Created by Tech Guy (Zachary Williams) 2015
/* 
*   This Script Listens for Calls from any JackPot Servers, who provide a list of Avatar Ids to check for
*   and return a list on the same channel, but speaking only to the primitive from which the call came.
*
*   Call Format is  SecurityKey||CMD||LISTITEM||LISTITEM
*/

// Configuration

    // Constants
        integer ComChannel = -19000;
        integer DBComChannel = -270000;
        string EMPTY = "";
        string SecurityKey = "UseYourOwnKey";
        key GameEventDBServer = "b007f16b-5658-4595-91d1-17dcaa75ed28";
        string HoverTextString = "Avatar Scanner";
            // Incoming Field Ids
                integer SECKEY = 0;
                integer CMD = 1;
    // Variables
        list FoundUsers = [];
        string CallingServer = "";
        integer GListLength;
        integer SFired;
    // Switches
        integer DebugMode = TRUE;
    // Handles
        integer ComHandle;
// Custom Functions
Initialize(){
    llListenRemove(ComHandle);
    llSleep(0.1);
    ComHandle = llListen(ComChannel, EMPTY, EMPTY, EMPTY);
    llOwnerSay("Scanner Online!");
}

// Check key if any incoming request and validate against Security Key
integer SecurityCheck(key CheckID){
    if(CheckID!=SecurityKey){
        return FALSE;
    }else{
        return TRUE;
    }
}

integer ScanForUser(string userid){
    if(DebugMode){
        llOwnerSay("Scanner Received UserID String: "+userid);
    }
    if(userid!=""){
        llSensor("", (key)userid, AGENT, 64.0, PI);
    }
    return FALSE;
}


// Main Program
default{
    on_rez(integer params){
        llResetScript();
    }
    
    state_entry(){
        // Bring Scanner Online
        Initialize();
    }
    
    sensor (integer num_detected)
    {
        SFired++;
        //if(llListFindList(FoundUsers, [llDetectedKey(0)])==-1){
            FoundUsers = FoundUsers + (string)llDetectedKey(0);
            if(DebugMode){
                llOwnerSay("Found User: "+llDetectedKey(0));
            }
        //}
        if(SFired==GListLength-1){
            string ResponseString = SecurityKey+"||ACTIVEUSERS||"+llDumpList2String(FoundUsers, "||");
            if(DebugMode){
                llOwnerSay("Calling Server ID: "+CallingServer+"\rChannel: "+(string)ComChannel+"\rResponse Sent!\r"+ResponseString);
            }
            llRegionSayTo(CallingServer, ComChannel, ResponseString);
            llResetScript();
        }
    }
 
    no_sensor()
    {
        SFired++;
    }
    
    listen(integer chan, string cmd, key id, string data){
        FoundUsers = [];
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
        if(chan==ComChannel ){
            cmd = llList2String(llParseStringKeepNulls(data, ["||"], []), CMD);
            if(DebugMode){
                llOwnerSay("CMD: "+cmd);
            }
            if(cmd=="SCANFOR"){
                list UserIDS = llList2List(llParseStringKeepNulls(data, ["||"], []), 2, -1);
                integer i;
                CallingServer = id;
                if(DebugMode){
                    llOwnerSay("UserIDS: "+llDumpList2String(UserIDS, "||"));
                }
                for(i=0;i<llGetListLength(UserIDS);i++){
                    if(llList2String(UserIDS, i)!="UPPOT"){
                        GListLength = llGetListLength(UserIDS);
                        ScanForUser(llList2String(UserIDS, i));
                    }else{ // If Input is equal to UPPOT
                        
                    }
                }
            }
        }
    }
}