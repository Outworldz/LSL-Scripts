// :CATEGORY:Browser
// :NAME:SL_Browser_launch
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:781
// :NUM:1069
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Create a notecard 'bookmarks' with a list of URLS
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
}
