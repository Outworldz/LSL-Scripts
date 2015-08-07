// :CATEGORY:Visitor Counter
// :NAME:Visitor_Tracker_by_Meghan_Eldrich
// :AUTHOR:Meghan Eldrich
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:957
// :NUM:1379
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Visitor Tracker by Meghan Eldrich.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************







//Useful Shop Visitor Tracker by Meghan Eldrich
//This thing started out pretty simple and sort of mushroomed on me. I wanted a way to track visitors entering my shop and tell me when they came and the time and so forth. But then I released it capped my IM's so I included an on-line/off-line state tracking thing to shut off the IM's. Then I sort of went nuts with toggling features on and off without hosing the stats to make simple changes. The code now includes a way to toggle IM's off period and just keep the last visitor list.
//
//Setting this up is simple and straight forward (I think). Simply create a prim that your visitor comes in contact with (preferably only once) when entering your shop. You can then adjust the time between when that visitor will be counted as a new hit. It does have some quirks but without making the script a lot more complex that I already made it, this is the best solution I could think of. You can toggle on-line/off-line polling if you wish as hitting the dataserver can be laggy. As the script sits now, it will poll for your online status once a minute (+/-) which seems like a good duration to me.




//**************************************************  ***********
//*****                Visitor Tracker V1.10              *****
//*****                 Written by Meghan Eldrich         *****
//*****                      09/09/2006                   *****
//*****             IM Meghan Eldrich for Support         *****
//**************************************************  ***********
// This script is free to use and copy, and is released under
// The GNU General Public License -- Please leave the header
// INTACT!  Thank you.  This script _MAY NOT_ be used in a
// commecial product!

integer     iStateTracker   = TRUE;     // Set this to false to not track your online state (helps with lag a little)
integer     hitter          = 900;      // Time in seconds between same visitor entering, and being counted again
integer     iGetIMS         = TRUE;     // Set this to False to not get IMs when visitors enter your shop
integer     iGreet          = TRUE;     // Get a nice welcome back when you return and not visits, FALSE to not get a greeting (Can be spammy with lots of                                               shops)
integer     iMyChannel      = 5050;     // The default channel for this (can be changed while running!
key         xOl;
key         MyKey;
integer     iIsOn;
list        visits;
list        afkvisits;
integer     afkhits;
integer     hits;
string      lasthit;
integer     tracked;
string      lastvisit;
integer     iJust = TRUE;

string HackTime()
{
    string xt           = llGetTimestamp();
    string x;
    integer i;
    // First process date out of xt
    i = llSubStringIndex(xt, "T");
    x = llGetSubString(xt, 0, i - 1);
    // Get rid of the date
    xt = llGetSubString(xt, i + 1, -1);
    // Second process time
    i = llSubStringIndex(xt, ".");
    x += " " + llGetSubString(xt, 0, i - 1) + "GMT";
    return x;
}

DoListThing(string x)
{
    hits++;
    string y = (string)hits + "> " +  x + " @ " + HackTime();
    if (hits > 19)
    {
        visits  = llDeleteSubList(visits,0,0);
    }
    visits += y;
}
default
{
    state_entry()
    {
        llSetAlpha(0.0,ALL_SIDES);
        llVolumeDetect(TRUE);
        MyKey = llGetOwner();
        llListen(iMyChannel, "", MyKey, "");
        llSetTimerEvent(60);
        if (iStateTracker)
        {
            xOl = llRequestAgentData(MyKey, DATA_ONLINE);
        }
        llOwnerSay("*** Visit tracker for \"" + llGetObjectDesc() + "\" now RUNNING");
        llOwnerSay("*** Type \"/" + (string)iMyChannel + " help\" for a list of commands");
    }
    on_rez(integer p)
    {
        llResetScript();
    }
    collision_start(integer n)
    {
        if (llDetectedType(0) & AGENT && llDetectedKey(0) != llGetOwner())
        {
            string x = llKey2Name(llDetectedKey(0));
            string y = x;
            if (x != lasthit)
            {
                lasthit = x;
                tracked = llGetUnixTime();
                DoListThing(x);
                lastvisit = HackTime();
                x += " Just entered \"" + llGetObjectDesc() + "\" (" + HackTime() + ")";
                if (iIsOn)
                {
                    // Owner is online send an IM
                    if (iGetIMS) { llInstantMessage(MyKey, x);}
                }
                else
                {
                    // Owner is offline store the name
                    ++afkhits;
                    if (afkhits > 9) { afkvisits = llDeleteSubList(afkvisits,0,0);}
                    afkvisits += y;
                }
            }
        }
    }
    listen(integer chan, string name, key id, string msg)
    {
        if (msg == "showme")
        {
            integer i;
            llOwnerSay("*** Visits So far: " + (string)hits + " (last: " + lastvisit + ")");
            for (i = 0; i < llGetListLength(visits); i ++)
            {
                llOwnerSay(llList2String(visits, i));
            }
            llOwnerSay("*** END of List ***");
        }
        else if (msg == "clearme")
        {
            hits = 0;
            visits = [];
            lasthit = "";
            tracked = 0;
            llOwnerSay("Stats Cleared");
        }
        else if (msg == "imtoggle")
        {
            if (iGetIMS)
            {
                iGetIMS = FALSE;
                llOwnerSay("No longer Sending IMs!");
            }
            else
            {
                iGetIMS = TRUE;
                llOwnerSay("Now Sending IMs!");
            }
        }
        else if (msg == "statetrack")
        {
            if (iStateTracker)
            {
                iStateTracker = FALSE;
                llOwnerSay("No longer tracking on-line state!");
            }
            else
            {
                iStateTracker = TRUE;
                llOwnerSay("Now tracking on-line state!");
            }
        }
        else if (msg == "greettoggle")
        {
            if (iGreet)
            {
                iGreet = FALSE;
                llOwnerSay("No longer sending greetings!");
            }
            else
            {
                iGreet = TRUE;
                llOwnerSay("Now sending greetings!");
            }
        }
        else if (msg == "help")
        {
            llOwnerSay("The tracker has the following commands:");
            llOwnerSay("showme .............. Shows you the last 19 visitors");
            llOwnerSay("clearme ............. clears all the current stats");
            llOwnerSay("imtoggle ............ Toggles sending IMs On & Off");
            llOwnerSay("statetrack .......... Toggles tracking your online/offline states");
            llOwnerSay("greettoggle ......... Toggles sending an on-line greeting to you");
            llOwnerSay("help ................ This help list");
        }
    }
    timer()
    {
        if (tracked != 0)
        {
            if ((llGetUnixTime() - tracked) > hitter)
            {
                tracked = 0;
                lasthit = "";
            }
        }
        if (iStateTracker)
        {
            xOl = llRequestAgentData(MyKey, DATA_ONLINE);
        }
    }
    dataserver(key req, string data)
    {
        if (req == xOl)
        {
            // Testing Online Status
            if (data == "1")
            {
                if (!iIsOn && llGetListLength(afkvisits) > 0 && iGetIMS)
                {
                    llInstantMessage(MyKey, "Welcome Back!  You've had " + (string)afkhits + " @ \"" + llGetObjectDesc() + "\" while you were offline");
                    string x = llList2CSV(afkvisits);
                    llInstantMessage(MyKey, "Last 10: " + x);
                }
                else if (!iIsOn && iGetIMS && iGreet && !iJust)
                {
                    llInstantMessage(MyKey, "Welcome Back from \"" + llGetObjectDesc() + "\" - No activity while you were away");
                }
                iJust = FALSE;
                afkvisits = [];
                afkhits = 0;
                iIsOn = TRUE;
            }
            else
            {
                iIsOn = FALSE;
            }
        }
    }
}// END //
