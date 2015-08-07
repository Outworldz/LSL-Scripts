// :CATEGORY:Clock
// :NAME:Clock_Linkable
// :AUTHOR:donjr Spiegelblatt
// :CREATED:2012-06-18 08:12:09.780
// :EDITED:2013-09-18 15:38:50
// :ID:181
// :NUM:252
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// place this script in the "clock" prim
// :CODE:
// Copyright 2009 by Donjr Spiegelblatt
//
// You are permitted to use, share, and adapt this code under the 
// terms of the Creative Commons Public License described in full
// at http://creativecommons.org/licenses/by/3.0/legalcode.
// That means you must keep the credits, do nothing to damage our
// reputation, and do not suggest that we endorse you or your work.

float Offset = 0.0;
integer ListenHandle = 0;
integer dTimer = 0;

Dialog(key id)
{
    list ShortMenuForButtons = ["-1", "-0.5", "1", "-3", "done", "3", "-6", "0.5", "6"];
    llListenRemove(ListenHandle);
    integer channel = (integer)(llFrand(-1000000000.0) - 1000000000.0); //we generate random channel...
    ListenHandle = llListen(channel,"", id,"");                         //...and we start to listen on it
    dTimer = llGetUnixTime() + 60;                                      // Give the user 60 seconces to respond.
    llDialog(id, "\nSelect Your time OffSet:\n Curren Offset is " + ((string)Offset), ShortMenuForButtons, channel);
}

integer GetLinkNames(string name)
{// return a 'list link numbers' of objects with the name 'name'
    integer n;
    integer stop = llGetNumberOfPrims() + 1;
    for (n=llGetLinkNumber() + 1; n < stop; n++)
    {
        // llSay(0, llGetLinkName(n) + " is " + (string)n);
        if ( llGetLinkName(n) == name )
            return n;
    }
    return -1;
}

integer HourHand;
integer MinuteHand;
integer SecondHand;

SetHand(integer lnk, float Z)
{
    integer this = llGetLinkNumber();
    vector rotPoint = llGetPos(); // in global coordinates
    rotation rot = llEuler2Rot(<0,0.0,DEG_TO_RAD * (Z * -1)>);
    list parms;
    if (this > 1)
    {
        rot = (rot * llGetLocalRot()) / llGetRootRotation();
        parms = [PRIM_POSITION, (rotPoint + ((llGetRootPosition() - rotPoint) * rot)) / llGetLocalRot(), PRIM_ROTATION, rot];
    }
    else
        parms = [PRIM_ROTATION, rot / llGetRootRotation()];
    if ( this != lnk )
        llSetLinkPrimitiveParamsFast(lnk, parms );
}

default
{
    state_entry()
    {
        HourHand = GetLinkNames("HourHand");
        MinuteHand = GetLinkNames("MinuteHand");
        SecondHand = GetLinkNames("SecondHand");
        if ( HourHand > 0 && MinuteHand > 0 && SecondHand > 0 )
            llSetTimerEvent(1);
        else
            llSay(0, "ERROR: Object is invalidly configured!!! HourHand=" + ((string)HourHand) + " MinuteHand=" + ((string)MinuteHand) + " SecondHand=" + ((string)SecondHand));
    }
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            HourHand = GetLinkNames("HourHand");
            MinuteHand = GetLinkNames("MinuteHand");
            SecondHand = GetLinkNames("SecondHand");
            if ( HourHand > 0 && MinuteHand > 0 && SecondHand > 0 )
                llSetTimerEvent(1);
            else
            {
             llSay(0, "ERROR: Invalidly configured!!! HourHand=" + ((string)HourHand) + " MinuteHand=" + ((string)MinuteHand) + " SecondHand=" + ((string)SecondHand));
                llSetTimerEvent(0); // Stop the clock
            }
        }
    }
    timer()
    {
        if ( ListenHandle )
        {
            if ( dTimer < llGetUnixTime() )
            {
                // Handle menu timeout
                llListenRemove(ListenHandle);
                ListenHandle = 0;
            }
        }
        //llOwnerSay("here");
        integer t= (integer)(llGetGMTclock() + ( Offset * 3600 ));
        if((Offset * 3600) + t > 86400)
        {
            t -= 86400;
        }
        else if((Offset * 3600) + t < 0)
        {
            t += 86400;
        }

        integer hour = (t / 3600) % 12;
        integer min = (t % 3600) / 60;
        integer sec = t % 60;

        float adj = ((float)sec);
        // llSay(0, "sec adj=" + (string)adj);
        SetHand(SecondHand, ( adj * 6.0) );

        adj /= 60.0;
        adj += (float)min;
        // llSay(0, "min adj=" + (string)adj);
        SetHand(MinuteHand, (adj * 6.0) );

        adj /= 60.0;
        adj += ((float)hour);
        SetHand(HourHand, (adj * 30.0));
        // llSay(0, "hrs adj=" + (string)adj);
    }
    touch_start(integer num)
    {
        key toucher = llDetectedKey(0);
        Dialog(toucher);
    }
    listen(integer channel, string name, key id, string str)
    {
        llListenRemove(ListenHandle);
        ListenHandle = 0;
        if ( str != "done" )
        {
            float par = (float)str;
            Offset += par;
            Dialog(id);
        }
    }
}
