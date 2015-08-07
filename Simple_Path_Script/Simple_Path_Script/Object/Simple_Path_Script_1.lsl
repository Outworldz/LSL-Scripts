// :CATEGORY:Positioning
// :NAME:Simple_Path_Script
// :AUTHOR:Kimm Paulino
// :CREATED:2013-06-24 14:29:41.307
// :EDITED:2013-09-18 15:39:02
// :ID:765
// :NUM:1052
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Path Setting Script//// In 'edit' mode, user moves the object and 'saves' various positions// over time, then the positions can be replayed.  This either uses the physical// move functions to create smooth movement or non-physical movements// for a slightly more jerky movement!
//
// NOTE: Positions and rotations are relative to the region, so if you
// move the prim, then the positions won't move with it - you'd have to
// reset the script (using the 'reset' button) and store a new path.
//
// Depending on the settings, the system can either loop forever
// or play just once.
//
// It also has the option of resetting if you change owners, which
// might be useful if you want new owners to be able to store their
// own paths.
//
// Kimm Paulino
// Oct 2010
// 
// Copyright © 2009 Linden Research, Inc. Licensed under Creative Commons Attribution-Share Alike 3.0 
From the Sl wiki at http://wiki.secondlife.com/wiki/User:Kimm_Paulino/Scripts#Simple_Path_Script
//  
// :CODE:

 
integer gDebug = FALSE;
integer gPhysics = FALSE;        // Set to use physical movements
integer gLoop = TRUE;                // Set to continually loop through the movements
integer gResetOnOwnerChange = TRUE;    // Set if want script to auto reset when changing owners
 
list gPositionData;            // Always assume that there are the same numbers
list gRotationData;            // of position and rotation data points
integer gCurrentIdx;
float gTimePeriod = 2.0;
float gTau = 5.0;
key gOwnerId; 
integer gListen; 
integer gTimeHandle; 
integer gTauHandle; 
string gHelpMsg = "Use EDIT mode to move your object, selecting 'Save' to save each position.  Select 'Done' once complete.  Don't forget to save your first position too!"; 
string gErrorMsg = "Something unexpected went wrong, suggest you reset the script!";
string SAVE_BTN = "Save";
string DONE_BTN = "Done";
string TIME_BTN = "Time Adjust";
string TAU_BTN = "Tau Adjust";
string RESET_BTN = "Reset";
string START_BTN = "Start";
string STOP_BTN = "Stop";
string START_MSG = "start";        // What a passer by can type in via chat
integer LISTEN_CH = 600;
integer TIME_CH = 900;
integer TAU_CH = 901;
 
doDebug (string msg)
{
    if (gDebug)
    {
        llOwnerSay (msg);
    }
}
 
doMove()
{ 
    integer num_points = llGetListLength(gPositionData); 
    if (num_points != llGetListLength (gRotationData))
    {
        llOwnerSay (gErrorMsg);
        disableMove();
        return;
    }
 
    if (gCurrentIdx >= num_points)
    {
        if (gLoop)
        {
            // Loop around for another go
            gCurrentIdx = 0;
        }
        else
        {
            // All complete
            disableMove();
            return;
        }
    }
 
    doDebug ("Moving to position " + (string)gCurrentIdx);
 
    vector next_pos = llList2Vector (gPositionData, gCurrentIdx);
    rotation next_rot = llList2Rot (gRotationData, gCurrentIdx);
 
    if (next_pos == ZERO_VECTOR && next_rot == ZERO_ROTATION)
    {
        // ignore
    }
    else
    {
        if (gPhysics)
        {
            llMoveToTarget(next_pos, gTau);
            llLookAt(next_pos,1,1);
            llRotLookAt(next_rot,1,1);
        }
        else
        {
//            doDebug ("moving to: " + (string)next_pos);
            llSetRot (next_rot);
            llSetPos (next_pos);
        }
    }
 
    // Move on to the next point
    gCurrentIdx ++;
} 
 
dialog ()
{
    list buttons;
    if (gPhysics)
    {
        buttons = [SAVE_BTN, DONE_BTN, RESET_BTN, START_BTN, STOP_BTN, TIME_BTN, TAU_BTN];
    }
    else
    {
        buttons = [SAVE_BTN, DONE_BTN, RESET_BTN, START_BTN, STOP_BTN, TIME_BTN];
    }
    llDialog (gOwnerId, gHelpMsg, buttons, LISTEN_CH);
}
 
enableMove ()
{
    if (gPhysics)
    {
        doDebug ("Enabling physical move");
        llSetStatus (PRIM_PHYSICS, TRUE);
    }
    else
    {
        doDebug ("Enabling non-physical move");
        llSetStatus(PRIM_PHYSICS, FALSE); 
    }
    llSetTimerEvent (gTimePeriod);
    gCurrentIdx = 0;
    doMove ();
}
 
disableMove ()
{
    doDebug ("Disabling move");
    llSetStatus (PRIM_PHYSICS, FALSE);
    llSetTimerEvent (0.0);
}
 
default 
{
    on_rez (integer start_param)
    {
        // if we reset on rez, then a user can't take an object into
        // inventory have rerez it with the same path stored.
        //
        // Means that if they do want to clear the path, say because
        // the position in the Sim has changed, then they have to use
        // the 'reset' option.
    }
 
    state_entry() 
    {   
        llOwnerSay ("Ready to start saving positions.  Touch for menu, then go to SL Edit mode to move the object and use 'save' on the menu to save each position.");
        gOwnerId = llGetOwner();
    }
 
    touch_start(integer who)
    {
        gListen = llListen (LISTEN_CH,"",NULL_KEY,"");
        if (llDetectedKey(0) == gOwnerId)
        {
            dialog();
        }
        else
        {
            if (!gLoop)
            {
                // Let nearby users start the moving
                llWhisper  (0, "To start the movement, please type the following into local chat:  /" + (string)LISTEN_CH + " " + START_MSG);
            }
        }
    }
 
    listen (integer channel, string name, key id, string msg)
    {
        vector pos = llGetPos();
        rotation rot = llGetRot();
 
        if (channel == LISTEN_CH)
        {
            if (msg == START_BTN || msg == START_MSG)
            {
                enableMove();
            }
 
            // non-owners can't do anything else
            if (id != gOwnerId)
            {
                return;
            }
 
            if (msg == SAVE_BTN)
            {
                gPositionData += pos;
                gRotationData += rot;
                dialog ();
            } 
            else if (msg == STOP_BTN)
            {
                disableMove();
            }
            else if (msg == RESET_BTN)
            {
                llResetScript();
            }
            else if (msg == TIME_BTN)
            {
                gTimeHandle = llListen (TIME_CH, "", gOwnerId, "");
                llOwnerSay ("Adjust time using: /" + (string)TIME_CH + " <float seconds>");
            } 
            else if (msg == TAU_BTN)
            {
                gTauHandle = llListen(TAU_CH, "", gOwnerId, "");
                llOwnerSay ("Adjust Tau using: /" + (string)TAU_CH + " <float value>");
            } 
            else if (msg == DONE_BTN)
            {
                llOwnerSay("To reset use: /" + (string)LISTEN_CH + " reset");
                llOwnerSay("To start use: /" + (string)LISTEN_CH + " start");
            }
        }
 
        if (channel == TIME_CH)
        {
            gTimePeriod = (float)msg;
            llListenRemove (gTimeHandle);
            llOwnerSay ("Time period set to " + msg);
        } 
 
        if (channel == TAU_CH)
        {
            gTau = (float)msg;
            llListenRemove (gTauHandle);
            llOwnerSay ("Tau set to " + msg);
        } 
    }
 
    changed(integer ch)
    {
        if(ch & CHANGED_OWNER)
        {
            if (gResetOnOwnerChange)
            {
                // This will clear out all stored positions of course!
                llResetScript();
            }
        }
    }
 
    timer()
    {
         doMove();
    }
}
