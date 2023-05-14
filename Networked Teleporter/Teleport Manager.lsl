//
// Telepad Instructions
// 
// This Networked Telepad system allows you to
// create teleport points throughout a region.
// Its almost too easy to use.
// 
// 1)  Simply Rez a pad where you want a TP Point.
// 2)  Edit the description (*not* the name) of
//     the object to the name of the place
//     (House, Pool, Skybox, etc...)
// 3)  Click on the telepad, and choose "Reset" 
//     from the dialog box. Only the owner can do this.
//     (this adds the telepad to the network)
//
// InWorldz and OpenSim 0.6.9 (osgrid and others) Caviat!  (fixed in 0.7.1)
//     Don't rotate the prim! Be sure it is set to Rotation 0,0,0
//     There is a little bug that prevents the teleporter from dropping
//     you off in the right place. However, when the bug is fixed, this script
//     should work even with rotations, or child rotaions, unless rotations will
//     be working differently than the other place.  Also, if it is inside a child
//     prim, it is likely to have rotation issues as well.
// 
// **Important** if you move a telepad, or delete one,
// you must use "Reset" to be sure all telepads receive
// the changes. (Reset just the one you moved, not all of them)
// 
// To use it, touch it, choose the destination, then right
// click it and choose Teleport.
// 
// ** advanced **
// If the description starts with a minus  (for example -Beach)
// then the telepad will serve as a direct telepad to that // // location.
// 
// To use a special channel number for the network other
// than the default.. add colon channel number to the description.
// For example    Beach:-99999
//




integer network_channel = -23423432;  // default
integer dialog_channel = 0;

integer same_owner = TRUE;
integer directMode = FALSE;
float timeout = 15.0;

string myname;
list pads;

string destination;

integer collecting = FALSE;

//== dialog control stuff

// ********** DIALOG FUNCTIONS **********
// Dialog constants
integer lnkDialog = 14001;
integer lnkDialogNotify = 14004;
integer lnkDialogResponse = 14002;
integer lnkDialogTimeOut = 14003;

integer lnkDialogReshow = 14011;
integer lnkDialogCancel = 14012;

integer lnkMenuClear = 15001;
integer lnkMenuAdd = 15002;
integer lnkMenuShow = 15003;

string seperator = "||";
integer dialogTimeOut = 0;

string packDialogMessage(string message, list buttons, list returns){
    string packed_message = message + seperator + (string)dialogTimeOut;

    integer i;
    integer count = llGetListLength(buttons);
    for(i=0; i<count; i++){
        string button = llList2String(buttons, i);
        if(llStringLength(button) > 24) button = llGetSubString(button, 0, 23);
        packed_message += seperator + button + seperator + llList2String(returns, i);
    }

    return packed_message;
}

dialogReshow(){llMessageLinked(LINK_THIS, lnkDialogReshow, "", NULL_KEY);}
dialogCancel(){
    llMessageLinked(LINK_THIS, lnkDialogCancel, "", NULL_KEY);
    llSleep(1);
}

dialog(key id, string message, list buttons, list returns){
    llMessageLinked(LINK_THIS, lnkDialog, packDialogMessage(message, buttons, returns), id);
}

dialogNotify(key id, string message){
    list rows;

    llMessageLinked(LINK_THIS, lnkDialogNotify,
        message + seperator + (string)dialogTimeOut + seperator,
        id);
}
// ********** END DIALOG FUNCTIONS **********




dotext()
{
    
string tex = "Telepad\n";
    if (directMode)
    {
        tex += "Direct Teleport to "+myname;
        llSetSitText("Teleport");
    }
    else
    {
        if (destination != "")
        {
            tex += "Click to go to "+destination +
                "\n.\nRight-Click->Touch\nfor another Destination\n";
            llSetSitText("Teleport");
        }
        else
        {
            tex += "Click to choose Destination\n";
            llSetSitText(".");
        }
    }
    llSetText(tex,<1.0,1.0,1.0>,1.0);
}

pinger()
{
    if (directMode) return;
    llRegionSay(network_channel,llDumpList2String(
        [ myname, llGetPos(), llGetRot() ], ":"));
}

setupMenus()
{
    
    llMessageLinked(LINK_THIS, lnkMenuClear, "", NULL_KEY);
    
    list b1;
    list b2;

    integer n;
    integer i;

    pads = llListSort(pads,3,TRUE);
    n = llGetListLength(pads);
    for (i = 0; i < n; i += 3)
    {
        b1 += [ llList2String(pads,i) ];
        b2 += [ "pad," + llList2String(pads,i) ];
    }
    //llOwnerSay(llDumpList2String(b1,":"));

    llMessageLinked(LINK_THIS, lnkMenuAdd, packDialogMessage(
            "[ Networked Telepad ]\n" +
            " Choose Destination",
            b1 + [ " " ],
            b2 + [ " " ]
        ), "MainMenu");
    

    llMessageLinked(LINK_THIS, lnkMenuAdd, packDialogMessage(
            "[ Networked Telepad ]\n" +
            " Choose Destination",
            b1 + [ "Reset" ],
            b2 + [ "RESET" ]
        ), "OwnerMenu");
    
}




default
{
    state_entry()
    {
        //llSetRot(ZERO_ROTATION);
        llSetClickAction(CLICK_ACTION_TOUCH);
        dotext();
        string mydesc = llGetObjectDesc();
        list d = llParseString2List(mydesc,[ ":" ],[]);
        myname = llList2String(d,0);
        if (llGetSubString(myname,0,0) == "-")
        {
            directMode = TRUE;
            myname = llGetSubString(myname,1,-1);
            dotext();
        }
        string altchan = llList2String(d,1);
        integer n = (integer)altchan;
        if (n != 0) 
        {
            if (n > 0) n = - n;
            network_channel = n;
        }
        if ((float)llList2String(d,2) > 0)
        {
            timeout = (float)llList2String(d,2);
        }
        if (myname == "")
        {
            llOwnerSay("Please name this telepad by putting a name in the objects description");
            return;
        }
        llListen(network_channel,"",NULL_KEY,"");
        llRegionSay(network_channel,"ping");
        collecting = TRUE;
        llSleep(0.2 + llFrand(0.3));
        llSetTimerEvent(2.0);
        pinger();
    }
    on_rez(integer num)
    {
        llResetScript();
    }
    listen(integer chan, string name, key id, string message)
    {
        if (same_owner)
        {
            key ok = llGetOwnerKey(id);
            if (ok != llGetOwner()) return;
        }
        if (message == "ping")
        {
            pads = [];
            llSetTimerEvent(2.0);
            collecting = TRUE;
            pinger();
            return;
        }
        list v = llParseString2List(message,[ ":" ],[]);
        if (llGetListLength(v) != 3) return;
        
        string n = llList2String(v,0);
        if (directMode && n != myname) return;
        
        vector vec = (vector)llList2String(v,1);
        rotation rot = (rotation)llList2String(v,2);        
        integer i = llListFindList(pads, [ n ]);
        if (i > -1)
        {
            pads = llListReplaceList(pads, [ n, vec, rot ], i, i+2);
        }
        else
        {
            pads += [ n, vec, rot ];
        }
        if (directMode)
        {
            vec = ( vec - llGetPos() ) / llGetRot();
            rot = rot / llGetRot();
            vec.z += 1.5;
            llSitTarget(vec,rot);
            llSetClickAction(CLICK_ACTION_SIT);
        }
        else
        {
            collecting = TRUE;
            llSetTimerEvent(2.0);
        } 
            
    }
    touch_start(integer num)
    {
        if (collecting) return;
        key toucher = llDetectedKey(0);
        if (toucher == llGetOwner())
        {
            llMessageLinked(LINK_THIS, lnkMenuShow, "OwnerMenu", llDetectedKey(0));
        }
        else
        {
            llMessageLinked(LINK_THIS, lnkMenuShow, "MainMenu", llDetectedKey(0));
        }
    }
    timer()
    {
        if (collecting)
        {
            llSetTimerEvent(0.0);
            setupMenus();
            collecting = FALSE;
            return;
        }
        llSitTarget(ZERO_VECTOR,ZERO_ROTATION);
        llSetClickAction(CLICK_ACTION_TOUCH);
        destination = "";
        dotext();
    }
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            llSleep(0.1);
            if (llAvatarOnSitTarget() != NULL_KEY)
            {
                llUnSit(llAvatarOnSitTarget());
                if (!directMode) llSetTimerEvent(timeout);
            }
        }
    }       
    link_message(integer sender, integer num, string message, key id)
    {
        if(num == lnkDialogResponse)
        {
            integer p = llSubStringIndex(message,",");
            integer s;
            string cmd;
            string rest;
            if (p > -1)
            {
                cmd = llToLower(llGetSubString(message,0,p-1));
                rest = llGetSubString(message,p+1,-1);
            }
            else
            {
                cmd = llToLower(message);
            }
            if (id == llGetOwner() && message == "RESET") llResetScript();
            if (cmd == "pad")
            {
                integer ii = llListFindList(pads, [ rest ]);
                if (ii > -1)
                {
                    destination = rest;
                    vector vv = llList2Vector(pads,ii+1); 
                    rotation rr = llList2Rot(pads,ii+2); 
                    vv = (vv - llGetPos()) / llGetRot();
                    rr = rr / llGetRot();
                    vv.z += 1.5;
                    llSitTarget(vv,rr);
                    llSetClickAction(CLICK_ACTION_SIT);
                    if (!directMode) llSetTimerEvent(timeout);
                    dotext();
                }
            }
        }
    }
}