// :CATEGORY:Positioning
// :NAME:KeyFrame_Animator_Script
// :AUTHOR:Jasper Flossberg
// :CREATED:2013-05-13 10:08:48.537
// :EDITED:2013-09-18 15:38:55
// :ID:421
// :NUM:577
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// A simple yet useful  script for recording and playing back prim movement.// // To use this, put the script into a prim or a set of prims, type "Init", move the entire prim linkset, and type " set".  Repeat. When done  type "Run".      // // You may want to remove or edit the line in the Run section where it does a llSetPrimitiveParams so you can re-position the prim somewhere, as all prim movements are relative to the the current position. // 
// Commands are typed in Chat:
// 
// Init - resets the script and gets it ready
// set - records a position and rotation
// Run - Plays back the animation
// Export - Prints the list to chat so you can save it or put it into another script.
// :CODE:
// This work uses content from the Second Life® Wiki article at http://wiki.secondlife.com/wiki/User:Jasper_Flossberg.  Copyright © 2007-2012 Linden Research, Inc. Licensed under the Creative Commons Attribution-Share Alike 3.0 License.  
// Attribution — You must attribute the work 
// Share Alike — If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.

integer channel=0;
integer MODE=0;  // 0 NonInit 1 Init 2 Run
list keys=[];
vector last_pos;
rotation last_rot;
 
vector start_pos;
rotation start_rot;
 
update_loc()
{
    last_pos=llGetPos();
    last_rot=llGetRot();
}
 
default
{
    state_entry()
    {
        llSay(0, "Welcome to the KeyFrame Setter v1.0 by Jasper Flossberg");
        llListen(0,"",NULL_KEY,"");
    }
 
    touch_start(integer total_number)
    {
        channel=(integer)llFrand(4000000);
        llDialog(llDetectedKey(0),"Please choose option",["Init","Run","Export"],channel);
        llListen(channel,"",NULL_KEY,"");
    }
    listen(integer channel, string name, key id, string message)
    {
        if(message=="Init")
        {
            llSay(0,"Intializing KeyFrame Setter");
            llSetKeyframedMotion([],[]);
            keys=[];
            update_loc();
            start_pos=llGetPos();
            start_rot=llGetRot();
            MODE=1;
 
        }
        if(llGetSubString(message,0,2)=="set")
        {
            if(MODE==1)
            {
                string time=llList2String(llParseString2List(message,[" "],[]),1);
                llSay(0,"Setting new KeyFrame with "+time);
                keys+=[llGetPos()-last_pos,ZERO_ROTATION*(llGetRot()/last_rot),(integer)time];
                update_loc();
            }
 
        }
        if(message=="Run")
        {
            MODE=2;
            llSetPrimitiveParams([PRIM_POSITION,start_pos,PRIM_ROTATION,start_rot]);
            llSetKeyframedMotion(keys,[KFM_MODE,KFM_LOOP]);
        }
        if(message=="Export")
        {
            llSay(0,(string)keys);
        }
    }
}
