// :CATEGORY:Browser
// :NAME:Browser_Launch_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:49
// :ID:120
// :NUM:183
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Browser Launch Script.lsl
// :CODE:

string card="bookmarks";
integer i=0;
integer pointer=0;
list URLs;
list Hover;
key owner;
integer listenID;

default
{
    state_entry()
    {
        llSetText("Loading bookmarks", <1,1,1>, 1.0);
        llGetNotecardLine(card, i);
        owner=llGetOwner();
    }
    touch_start(integer times)
    {
        key who=llDetectedKey(0);
        if(who==owner)
        {
            llDialog(owner, "Open URL or select new target?", ["Open", "Prev", "Next"], 1001);
            llListenRemove(listenID);
            listenID=llListen(1001, "", owner, "");
        } else {
            llLoadURL(llDetectedKey(0), "Load "+llList2String(Hover, pointer), llList2String(URLs, pointer));
        }
    }
    dataserver(key query, string data)
    {
        if(data!=EOF)
        {
            list temp=llCSV2List(data);
            Hover+=llList2String(temp, 0);
            URLs+=llList2String(temp, 1);
            i++;
            llGetNotecardLine(card, i);
        } else {
            llSetText(llList2String(Hover, pointer), <1,1,1>, 1.0);
        }
    }
    listen(integer channel, string name, key ID, string message)
    {
        llSetTimerEvent(60);
        if(message=="Open")
        {
            llLoadURL(llGetOwner(), "Load "+llList2String(Hover, pointer), llList2String(URLs, pointer));
        } else if(message=="Prev")
        {
            pointer++;
            if(pointer==llGetListLength(Hover))
            {
                pointer=0;
            }
        } else if(message=="Next")
        {
            pointer--;
            if(pointer<0)
            {
                pointer=llGetListLength(Hover);
                pointer--;
            }
        }
        llSetText(llList2String(Hover, pointer), <1,1,1>, 1.0);
        llListenRemove(listenID);
    }
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }
    timer()
    {
        llListenRemove(listenID);
    }
}// END //
