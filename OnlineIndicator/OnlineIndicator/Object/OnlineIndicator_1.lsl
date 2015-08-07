// :CATEGORY:Online Indicator
// :NAME:OnlineIndicator
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:584
// :NUM:800
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// OnlineIndicator
// :CODE:
// From the book:
//
// Scripting Recipes for Second Life
// by Jeff Heaton (Encog Dod in SL)
// ISBN: 160439000X
// Copyright 2007 by Heaton Research, Inc.
//
// This script may be freely copied and modified so long as this header
// remains unmodified.
//
// For more information about this book visit the following web site:
//
// http://www.heatonresearch.com/articles/series/22/

string name = "";
string last_online = "";
key nameKey = NULL_KEY;
integer isAvailable = TRUE;
integer isOnline = FALSE;

list MONTHS = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

string get_date()
{
    integer t = llRound(llGetWallclock());

    integer hours = t / 3600; 
    integer minutes = (t % 3600) / 60; 
    integer seconds = t % 60; 

    string time = (string)hours + ":";
    if(minutes < 10) time += "0" + (string)minutes + ":";
    else time += (string)minutes + ":";
    if(seconds < 10) time += "0" + (string)seconds;
    else time += (string)seconds;

    string DateToday = "";
    string DateUTC = llGetDate();
    list DateList = llParseString2List(DateUTC, ["-", "-"], []);
    integer year = llList2Integer(DateList, 0);
    integer month = llList2Integer(DateList, 1);
    integer day = llList2Integer(DateList, 2);
    month = month - 1;
    if(day < 10) DateToday = "0";
    DateToday += (string)day + "-";

    DateToday += llList2String(MONTHS,month);
    DateToday += " ";
    DateToday += (string)year;

    time = time + " " + DateToday;
    return time;
}


default
{
    on_rez(integer p)
    {
        llResetScript();
    }

    state_entry()
    {
        llSetText("Online Detector\nTouch to Claim",<1,1,1>,1);
    }

    touch_start(integer total_number)
    {
        if(name == "")
        { 
            nameKey = llDetectedKey(0);
            name = llDetectedName(0);
            llSetText(name + "\nSetting up...",<1,1,1>,1);
            llSetTimerEvent(4.0);
            return;
        }

        if(llDetectedName(0) == name)
        {
            if(isAvailable == FALSE)
            {
                isAvailable = TRUE;
                llWhisper(0, "IM's will be sent to you.");
                return;
            }
            else
            {
                isAvailable = FALSE;
                llWhisper(0, "IM's will not be sent to you.");
                return;
            }

        }
        else
        { 
            if(isAvailable && isOnline) 
            {
                llInstantMessage(nameKey, llDetectedName(0) + " is paging you from " + llGetRegionName());
                llWhisper(0,"A message has been sent to " + name);
            }
        }
    }


    timer()
    {
        if(nameKey)
        {
            llRequestAgentData(nameKey,DATA_ONLINE);
        }
    }

    dataserver(key query, string data)
    {
        string text = "";

        if((integer)data == 1)
        {
            isOnline = TRUE;
            llSetColor(<0,1,0>,ALL_SIDES); 
            text = name + " is ONLINE";
            if(isAvailable) text += "\nClick to Send IM"; 
            llSetText(text, <0.25,1.0,0.25>,1);
            last_online = ""; 
        }
        else
        {
            isOnline = FALSE;
            llSetColor(<1,0,0>,ALL_SIDES); 
            text = name + " is OFFLINE";

            if(last_online == "") last_online = get_date();
            text += "\nLast Online: " + last_online;
            llSetText(text, <1.0,0.25,0.25>,1);
        }
    }
}
