// :CATEGORY:Profile Status
// :NAME:Online_Status_Indicator
// :AUTHOR:janasadvertise
// :CREATED:2012-07-26 04:59:39.143
// :EDITED:2013-09-18 15:38:59
// :ID:582
// :NUM:798
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Online_Status_Indicator
// :CODE:
integer gIsOnline = FALSE;
integer gLandOwner = FALSE;
key gKey = NULL_KEY;
string gName = "";
float UPDATE_INTERVAL = 5.0; 
string onlinetexture = "_onlinetexture_";
string offlinetexture = "_offlinetexture_";

updateStatus(string s){
    key k = llGetLandOwnerAt(llGetPos());
    if(s=="1"){
        gIsOnline = TRUE;
    }else{
        gIsOnline = FALSE;
    }
}

key getWhom(){
    if(gKey == NULL_KEY){
        if(gLandOwner){
            return llGetLandOwnerAt(llGetPos());
        }else{
            return llGetOwner();
        }
    }else{
        return gKey;
    }
}

doUpdate(){
    llRequestAgentData(getWhom(),DATA_ONLINE);
}

updateName(){
    llRequestAgentData(getWhom(),DATA_NAME);
}

enable(){
    updateName();
    doUpdate();
    llSetTimerEvent(1);
    llWhisper(0,"Online status display enabled.");
    
}
disable(){
    llSetTimerEvent(0);
    llSetText("Display Disabled",<1,1,1>,1);
    llSetTexture(offlinetexture, 1);
    llWhisper(0,"Online status display disabled.");
}

default
{
    state_entry()
    {
        llListen(0, "", llGetOwner(), "");
        enable();
        llWhisper(0,"Type /ol help for a list of commands");
    }
    on_rez(integer n){
        llResetScript();
    }
    dataserver(key req, string data){
        if(data == "1" || data == "0"){
            updateStatus(data);
        }else{
            gName = data;
            llSetText("Getting online status for " + gName,<1,1,1>,1);
            llSetTexture(offlinetexture, 1);
            llSetTimerEvent(UPDATE_INTERVAL);
        }
    }
    timer(){
        doUpdate();
        if(gIsOnline){
            llSetText(gName + " is Online",<1,1,1>,1);
            llSetTexture(onlinetexture, 1);
        }else{
            llSetText(gName + " is Offline",<1,1,1>,1);
            llSetTexture(offlinetexture, 1);
        }
    }
    listen(integer number, string name, key id, string msg){
        if (llGetSubString(msg, 0,0) != "/"){
            return;
        }
        list argv = llParseString2List(msg, [" "], []);
        integer argc = llGetListLength(argv);
        string cmd = llToLower(llList2String(argv, 0));
        if(cmd == "/ol"){
            string arg =  llToLower(llList2String(argv, 1));
            if(arg=="on"){
                enable();
            }else if(arg=="off"){
                disable();
            }else if(arg=="land"){
                gLandOwner = TRUE;
                gKey = NULL_KEY;
                updateName();
            }else if(arg=="key"){
                gKey = llList2Key(argv,2);
                updateName();
            }else if(arg=="me"){
                gLandOwner = FALSE;
                gKey = NULL_KEY;
                updateName();
            }else if(arg=="help"){
                llWhisper(0,"/ol on - activate online status display");
                llWhisper(0,"/ol off - disable online status display");
                llWhisper(0,"/ol land - display online status for owner of this land");
                llWhisper(0,"/ol me - display your online status");
            }
        }
    }
    
}
