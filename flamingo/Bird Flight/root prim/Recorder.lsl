// :CATEGORY:Bird
// :NAME:flamingo
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:53
// :ID:314
// :NUM:421
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Recorder for movement paths
// :CODE:

// Bird flock recorder script
// Author: Ferd Frederix
// This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
// This means that this script itself is not for sale, that the script must be full Mod at all time, and that modifications to it MUST be provided to anyone upon request. Pets made with this script may be sold. ~ Ferd Frederix
// 5-26-2013 

//
//Commands are typed in Chat:
//
//Init - resets the script and gets it ready
//set - records a position and rotation
//Run - Plays back the animation
//Export - Prints the list to chat so you can save it or put it into another script.
//
// This work uses content from the Second Life® Wiki article at http://wiki.secondlife.com/wiki/User:Jasper_Flossberg.  Copyright © 2007-2012 Linden Research, Inc. Licensed under the Creative Commons Attribution-Share Alike 3.0 License.  
// Attribution — You must attribute the work 
// Share Alike — If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.


integer debug = FALSE;


// Link message numbers to/from the main bird menu
integer fromRoot = -3500;
integer toRoot = -3501;
integer toFlight = -3502;

list keys=[];
vector last_pos;
rotation last_rot;
 
vector start_pos;
rotation start_rot;
integer comChannel;    // holds the owners channel
integer comHandle;
    
update_loc()
{
    last_pos=llGetPos();
    last_rot=llGetRot();
}

DEBUG(string msg)
{
    if (debug)
        llOwnerSay(msg);
}

Reset()
{
    DEBUG("Intializing flight recorder");
    llSetKeyframedMotion([],[]);
    keys=[];
    start_pos=llGetPos();
    start_rot=llGetRot();
    update_loc();
}

list menu = ["Set Start","Record", "Finish"];

dialog()
{
    if (comHandle)
        llListenRemove(comHandle);
    comChannel = llCeil((llFrand(1000000) + 10000) * -1);
    comHandle = llListen(comChannel,"","","");
    integer memory = llGetFreeMemory();
    llDialog(llGetOwner(),"Select a recording option\nMemory Free:\n" + (string) memory,menu,comChannel);
}


default
{
    state_entry()
    {
        Reset();
    }

    touch_start(integer n)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            dialog();
        }
    }
            
        
    link_message(integer sender_number, integer number, string message, key id)
    {
        if(message=="Setup")
        {
            Reset();
            dialog();
        }
    }

    listen(integer channel, string name, key id, string message)
    {
         if(message == "Set Start")
        {
            Reset();
            dialog();
        }
        else         if(message == "Record")
        {
            keys+=[llGetPos()-last_pos,ZERO_ROTATION*(llGetRot()/last_rot)];
            update_loc();
            dialog();
        }
        else if(message=="Finish")
        {
            llOwnerSay("Saving Route");
            integer i;
            integer j = llGetListLength(keys);
            for ( ; i < j; i+=2)
            {
                string msg;
                vector myPos = llList2Vector(keys,i);
                rotation myRot = llList2Rot(keys,i+1);
                msg = (string) myPos + "|" + (string) myRot;
        
                DEBUG("Recorder:" + msg);
        
                llMessageLinked(LINK_SET,toFlight,msg,"");    // tell the root prim to go silent on the menu
                llSleep(0.1);    // time to dequeue it and encode it.
            }
            llMessageLinked(LINK_THIS,toRoot,"Playback","");    // tell the root prim to go silent on the menu
            state idle;
        }
    

    }
}


state idle
{
    state_entry()
    {
    }
    
    link_message(integer sender_number, integer number, string message, key id)
    {
        if(message=="Setup")
        {
            llOwnerSay("Flight route is empty.  Move the bird and click Record");    
            Reset();
            dialog();
            state default;
        }

    }
}

