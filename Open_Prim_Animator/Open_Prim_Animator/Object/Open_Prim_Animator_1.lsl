// :CATEGORY:Prim
// :NAME:Open_Prim_Animator
// :AUTHOR:Todd Borst
// :CREATED:2011-03-02 10:01:11.283
// :EDITED:2013-09-18 15:38:59
// :ID:588
// :NUM:806
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is provided AS IS without support.  Please don't bug me demanding // help or custom work for this free script. // // Authors License:// You are welcome to use this anyway you like, even bring to other grids// outside of Second Life.  If you try to sell what I'm giving away for
// free, you will be cursed with unimaginably bad juju. 
// 
// 
This work uses content from the Second Life® Wiki article at http://wiki.secondlife.com/wiki/Open_Prim_Animatorand is Copyright © 2007-2009 Linden Research, Inc.   
// :CODE:

integer COMMAND_CHANNEL = 32;
 
integer primCount = 0;
integer commandListenerHandle = -1;
 
list posList     = [];
list rotList     = [];
list scaleList   = [];
integer currentSnapshot   = 0;
integer recordedSnapshots = 0;
 
vector rootScale   = ZERO_VECTOR;
vector scaleChange = <1,1,1>;
 
// For tracking memory usage.  The amount of snapshots you can record is based
// on the number of prims and available memory.  Less prims = more snapshots
integer maxMemory  = 0;
integer freeMemory = 0;
 
integer playAnimationStyle = 0;
// The values for playAnimationStyle means
// 0 = no animation playing
// 1 = play animation once
// 2 = play animation looping
 
// This function is used to display a recorded snapshot
showSnapshot(integer snapNumber)
{
    if(snapNumber > 0 && snapNumber <= recordedSnapshots )
    {
        integer i = 0;
        vector   pos;
        rotation rot;
        vector   scale;
 
        vector rootPos = llGetPos();
 
        // Might want to move llGetRot() into the loop for fast rotating objects.
        // Rotation during the animation playback may cause errors.
        rotation rootRot = llGetRot();
 
        //2 is the first linked prim number.
        for( i = 2; i <= primCount; i++)
        {
            pos     = llList2Vector(posList,((snapNumber-1)*(primCount-1))+(i-2));
            rot     = llList2Rot(rotList,((snapNumber-1)*(primCount-1))+(i-2));
            scale   = llList2Vector(scaleList,((snapNumber-1)*(primCount-1))+(i-2));
 
            //Adjust for scale changes
            if( rootScale.x != 1.0 || rootScale.y != 1.0 || rootScale.z != 1.0 )
            {
                pos.x *= scaleChange.x;
                pos.y *= scaleChange.y;
                pos.z *= scaleChange.z;
                scale.x *= scaleChange.x;
                scale.y *= scaleChange.y;
                scale.z *= scaleChange.z;
            }
 
            llSetLinkPrimitiveParamsFast( i, [ PRIM_POSITION, pos, PRIM_ROTATION, rot/rootRot, PRIM_SIZE, scale ] );
        }
    }
}
 
// This function is used to start a sequential animation playback.
// If the delay speed is set too low, the script might not be able to keep up.
playAnimation(float delay, integer loop)
{
    if(delay < 0.1) delay = 1.0;
 
    if( loop == FALSE)
        playAnimationStyle = 1;
    else
        playAnimationStyle = 2;
 
    if (recordedSnapshots >= 1)
        llSetTimerEvent(delay);
}
 
// This shows the edit menu
showMenuDialog()
{
    string temp = (string)((float)freeMemory/(float)maxMemory * 100.0);
    string menuText = "Available Memory: " + (string)freeMemory + " (" + llGetSubString(temp, 0, 4) +"%)" +
    "\nCurrent Snapshot: " + (string)currentSnapshot +"\tSnapshots Recorded: " + (string)recordedSnapshots +
    "\n\n[ Record ] - Record a snapshot of prim positions\n[ Play ] - Play back all the recorded snapshots\n[ Publish ] - Finish the recording process\n[ Show Next ] - Show the next snapshot\n[ Show Prev ] - Show the previous snapshot";
 
    llDialog(llGetOwner(), menuText, ["Record","Play","Publish","Show Prev","Show Next"], COMMAND_CHANNEL);
}
 
default
{
    state_entry()
    {
        maxMemory = llGetFreeMemory();
        freeMemory = llGetFreeMemory();
 
        primCount = llGetNumberOfPrims();
        commandListenerHandle = llListen(COMMAND_CHANNEL,"", llGetOwner(), "");
        showMenuDialog();
 
        //setting initial root scale.  this allows the animation to scale if the root size is changed afterwards.
        rootScale = llGetScale();
    }
 
    //Feel free to remove this on-touch trigger if you are using your own script to control playback
    touch_start(integer num_detected)
    {
        //only activate after publish.
        if (commandListenerHandle == -1)
        {
            //if animation not playing start it, else stop it.
            if( playAnimationStyle == 0)
                playAnimation(1.0,TRUE);
            else
            {
                playAnimationStyle = 0;
                llSetTimerEvent(0);
            }
        }
    }
 
    changed(integer change)
    {
        //this is needed to detect scale changes and record the differences in order to adjust the animation accordingly.
        if (change & CHANGED_SCALE)
        {
            if (rootScale != ZERO_VECTOR)
            {
                vector newScale = llGetScale();
                //since change_scale is triggered even with linked prim changes,
                //this is to filter out non-root changes.
                if( ( newScale.x / rootScale.x) != scaleChange.x ||
                    ( newScale.y / rootScale.y) != scaleChange.y ||
                    ( newScale.z / rootScale.z) != scaleChange.z )
                {
                    scaleChange.x = newScale.x / rootScale.x;
                    scaleChange.y = newScale.y / rootScale.y;
                    scaleChange.z = newScale.z / rootScale.z;
                }
            }
        }
        // if new prims are added or removed from this object then the script resets
        // because the animations are now broken.
        else if (change & CHANGED_LINK)
        {
            if( primCount != llGetNumberOfPrims() )
            {
                llOwnerSay("Link change detected, reseting script.");
                llResetScript();
            }
        }
    }
 
    //The message link function is to allow other scripts to control the snapshot playback
    //This command will display snapshot #2:
    //      llMessageLinked(LINK_ROOT, 2, "XDshow", NULL_KEY);  llSleep(1.0);
    //
    //This command will play through all the recorded snapshots in ascending order.  The number "1.0" is the delay speed and can be changed.
    //      llMessageLinked(LINK_ROOT, 0, "XDplay", "1.0");
    //
    //This command will loop through all the recorded snapshots in ascending order.  The number "1.0" is the delay speed and can be changed.
    //      llMessageLinked(LINK_ROOT, 0, "XDplayLoop", "1.0");
    //
    //To stop any playing animation use
    //      llMessageLinked(LINK_ROOT, 0, "XDstop", NULL_KEY);
    link_message(integer sender_num, integer num, string str, key id)
    {
        if ("XDshow" == str && num >= 1 && num <= recordedSnapshots)
            showSnapshot(num);
        else if ("XDplay" == str)
        {
            currentSnapshot = 1;
            float delay = (float)((string)id);
            playAnimation(delay,FALSE);
        }
        else if ("XDplayLoop" == str)
        {
            float delay = (float)((string)id);
            playAnimation(delay,TRUE);
        }
        else if ("XDstop" == str)
        {
            playAnimationStyle = 0;
            llSetTimerEvent(0);
        }
    }
 
    //This event handler takes care of all the editing commands.
    //Available commands are: record, play, publish, show next, show prev, show #
    listen(integer channel, string name, key id, string message)
    {
        list parsedMessage = llParseString2List(message, [" "], []);
        string firstWord = llToLower(llList2String(parsedMessage,0));
        string secondWord = llToLower(llList2String(parsedMessage,1));
 
        //display a snapshot
        if("show" == firstWord && recordedSnapshots > 0)
        {
            //stop any currently playing animation.
            llSetTimerEvent(0);
 
            if(secondWord == "next")
            {
                currentSnapshot++;
                if(currentSnapshot > recordedSnapshots)
                    currentSnapshot = 1;
 
                showSnapshot(currentSnapshot);
            }
            else if(secondWord == "prev")
            {
                currentSnapshot--;
                if(currentSnapshot < 1)
                    currentSnapshot = recordedSnapshots;
 
                showSnapshot(currentSnapshot);
            }
            else
            {
                // when the conversion fails, snapshotNumber = 0
                currentSnapshot = (integer)secondWord;
                if(currentSnapshot > 0 && currentSnapshot <= recordedSnapshots )
                {
                    showSnapshot(currentSnapshot);
                    llOwnerSay("Showing snapshot: "+(string)currentSnapshot);
                }
                else
                {
                    llOwnerSay("Invalid snapshot number given: " + (string) currentSnapshot +
                                "\nA valid snapshot number is between 1 and " + (string) recordedSnapshots);
                    currentSnapshot = 1;
                }
            }
        }
        //record a snapshot
        else if(firstWord == "record")
        {
            integer i = 0;
            //2 is the first linked prim number.
            vector rootPos = llGetPos();
            for( i = 2; i <= primCount; i++)
            {
                vector pos = llList2Vector(llGetLinkPrimitiveParams(i, [PRIM_POSITION]),0);
                //need to convert into local position
                pos.x -= rootPos.x;
                pos.z -= rootPos.z;
                pos.y -= rootPos.y;
                pos = pos / llGetRot();
                posList += pos;
 
                rotation rot = llList2Rot(llGetLinkPrimitiveParams(i, [PRIM_ROTATION]),0);
                //Converting into local rot
                rot = rot / llGetRot();
                rotList += rot;
 
                scaleList += llList2Vector(llGetLinkPrimitiveParams(i, [PRIM_SIZE]),0);
            }
            recordedSnapshots++;
 
            llOwnerSay("Total number of snapshots recorded: " + (string)recordedSnapshots);
            freeMemory = llGetFreeMemory();
        }
        //play the animation from beginning to end once without looping.
        else if (firstWord == "play")
        {
            float delay = (float)secondWord;
            currentSnapshot = 1;
            //play the animation once without loop
            playAnimation(delay, FALSE);
        }
        //publish disables the recording features and enables the on-touch trigger
        else if("publish" == firstWord)
        {
            //stop any currently playing animation.
            llSetTimerEvent(0);
            playAnimationStyle = 0;
            currentSnapshot = 1;
 
            //remove listeners to disable recording
            llListenRemove(commandListenerHandle);
            commandListenerHandle = -1; //indicating that it's been published
 
            llOwnerSay("Recording disabled. Publish complete.\nClick me to toggle animation on/off.");
        }
 
        //if not published, show menu
        if(commandListenerHandle != -1)
            showMenuDialog();
    }
 
    //Timer event is used to handle the animation playback.
    timer()
    {
        showSnapshot(currentSnapshot);
 
        //if not at the end of the animation, increment the counter
        if(currentSnapshot < recordedSnapshots)
            currentSnapshot++;
        else
        {
            // if animation is looping, set the counter back to 1
            if( playAnimationStyle == 2)
                currentSnapshot = 1;
            // if animation isn't looping, stop the animation
            else
            {
                llSetTimerEvent(0);
                //if not published, show dialog menu
                if(commandListenerHandle != -1)
                    showMenuDialog();
            }
        }
    }
}
