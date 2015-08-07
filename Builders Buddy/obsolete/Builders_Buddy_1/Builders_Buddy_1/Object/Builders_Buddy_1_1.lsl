// :CATEGORY:Building
// :NAME:Builders_Buddy_1
// :AUTHOR:Newfie Pendragon
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-17 21:48:31
// :ID:123
// :NUM:186
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Builders Buddy 1.lsl
// :CODE:

///////////////////////////////////////////////////////////////////////////////
// Builders' Buddy 1.6 (Component Pieces)
// by Newfie Pendragon, March 2006
//
// This script is distributed with permission that it may be used in
// any way, or may be further modified/included in resale items.
// HOWEVER, if this script is used as part of a for-sale product,
// it is required that appropriate credit be given to Newfie for
// the script (or portions used in derivatives).  That's a fair price
// in exchange for unlimited use of this script, dontcha think?
//
//  SL Forum thread and new versions found here:
//  http://forums.secondlife.com/showthread.php?t=96792
///////////////////////////////////////////////////////////////////////////////
//  
//  Script Purpose & Use
//
//  Functions are dependent on the "component script"
//
//  QUICK USE:
//  - Drop this script in the Base.
//  - Drop the "Component" Script in each building part.
//  - Touch  your Base, and choose RECORD
//  - Take all building parts into inventory
//  - Drag building parts from inventory into Base Prim
//  - Touch your base and choose BUILD
//
//  OTHER COMMANDS from the Touch menu
//  - To reposition, move/rotate Base Prim choose POSITION
//  - To lock into position (removes scripts) choose DONE
//  - To delete building pieces: choose CLEAN
//
///////////////////////////////////////////////////////////////////////////////
//
//  History
//
// v1.0 - 20060328 - Newfie Pendragon
//      - Original Version
// v1.1 - 20060331 - Kalidor Lazarno
//      - Added a Dialog Engine to the base script
// v1.5 - 20060612 - Androclese Antonelli
//      - Added a random number generator to the dialog engine to elimintate
//        problems with multiple BB boxes cross-talking
//      - Added a timer to the listen command to put it asleep after 10sec.
//      - Added a Menu Description
//      - Added n "creator" flag so the owner could use the same object with full
//        menu options and only a single flag change
//      - Added an "ingroup" flag to enable/disable the same group use function
//      - Non-Admin usage cleans the inventory items as they spawn
// v1.6 - 20060624 - Newfie Pendragon
//      - Added active repositioning (building moves as the base piece moves)
//      - Added "Reset" Option to unlink parts from base temporarily
//      - Modified creator flag to automatically set based if owner is creator
//      - Minor changes to improve code readability (for those learning LSL)

///////////////////////////////////////////////////////////////////////////////
// User Variables
///////////////////////////////////////////////////////////////////////////////

// Set to TRUE to allow group members to use the dialog menu
// Set to FALSE to disallow group members from using the dialog menu
integer ingroup = TRUE;

//Name each option-these names will be your button names.
string optRecord = "Record"; 
string optReset = "Reset";
string optBuild = "Build";
string optPos = "Position";
string optClean = "Clean";
string optDone = "Done";

//Menu option descriptions
string descRecord = " : Record the position of all parts\n";
string descReset = " : Forgets the position of all parts\n";
string descBuild = " : Spawn inv. items and position them\n";
string descPos = " : Reposition the parts to a new location\n";
string descClean = " : De-Rez all pieces\n";
string descDone = " : Remove all BB scripts and make the parts permanent.\n";

//How often (in seconds) to check for change in position when moving
float fMovingRate = 0.25;

//How long to sit still before exiting active mode
float fStoppedTime = 30.0;

//Minimum amount of time (in seconds) between movement updates
float fShoutRate = 0.25;

// Channel used by Base Prim to talk to Component Prims
// This channel must be the same one in the component script
// A negative channel is used because it elimited accidental activations
// by an Avatar talking on obscure channels
integer PRIMCHAN = -19730611;

///////////////////////////////////////////////////////////////////////////////
// DO NOT EDIT BELOW THIS LINE.... NO.. NOT EVEN THEN
///////////////////////////////////////////////////////////////////////////////
integer MENU_CHANNEL;
integer MENU_HANDLE;
key agent;
key objectowner;
integer group;
string title = "";
list optionlist = [];
integer bMoving;
vector vLastPos;
rotation rLastRot;
integer iListenTimeout = 0;

//To avoid flooding the sim with a high rate of movements
//(and the resulting mass updates it will bring), we used
// a short throttle to limit ourselves
announce_moved()
{
    llShout(PRIMCHAN, "MOVE " + llDumpList2String([ llGetPos(), llGetRot() ], "|"));
    llResetTime();        //Reset our throttle
    vLastPos = llGetPos();
    rLastRot = llGetRot();
    return;
}


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
default {
    ///////////////////////////////////////////////////////////////////////////////
    changed(integer change) {
        if(change & CHANGED_OWNER)
        llResetScript();
    }

    ///////////////////////////////////////////////////////////////////////////////
    state_entry () {
        //Use which menu?
        if ( llGetCreator() == llGetOwner() ) {
            //Display all options
            optionlist = [optPos, optClean, optDone, optRecord, optReset, optBuild];
            title = optRecord + descRecord;
            title += optReset + descReset;
            title += optBuild + descBuild;
            title += optPos + descPos;
            title += optClean + descClean;
            title += optDone + descDone;

        } else {
            //Display limited options
            optionlist = [optBuild, optPos, optDone];
            title = optBuild + descBuild;
            title += optPos + descPos;
            title += optDone + descDone;
        }
        
        //Record our position
        vLastPos = llGetPos();
        rLastRot = llGetRot();

    }

    ///////////////////////////////////////////////////////////////////////////////
    touch_start (integer total_number) {
        group = llDetectedGroup(0); // Is the Agent in the objowners group?
        agent = llDetectedKey(0); // Agent's key
        objectowner = llGetOwner(); // objowners key
        // is the Agent = the owner OR is the agent in the owners group
        if ( (objectowner == agent) || ( group && ingroup )  )  {
            iListenTimeout = llGetUnixTime() + 10;
            MENU_CHANNEL = llFloor(llFrand(-99999.0 - -100));
            MENU_HANDLE = llListen(MENU_CHANNEL,"","","");
            llDialog(agent, title, optionlist, MENU_CHANNEL);
            llSetTimerEvent(fShoutRate);
        }
    }

    ///////////////////////////////////////////////////////////////////////////////
    listen(integer channel, string name, key id, string message) {
        if ( message == optRecord ) {
            llOwnerSay("Recording positions...");
            llShout(PRIMCHAN, "RECORD " + llDumpList2String([ llGetPos(), llGetRot() ], "|"));
            return;
        }
        if( message == optReset ) {
            llOwnerSay("Forgetting positions...");
            llShout(PRIMCHAN, "RESET");
            return;
        }
        if ( message == optBuild ) {
            vector vThisPos = llGetPos();
            rotation rThisRot = llGetRot();
            integer i;
            integer iCount = llGetInventoryNumber(INVENTORY_OBJECT);
            
            //Loop through backwards (safety precaution in case of inventory change)
            llOwnerSay("Rezzing build pieces...");
            for( i = iCount - 1; i >= 0; i-- )
            {
                llRezObject(llGetInventoryName(INVENTORY_OBJECT, i), vThisPos, ZERO_VECTOR, rThisRot, PRIMCHAN);
                if ( llGetCreator() != llGetOwner() )
                    llRemoveInventory(llGetInventoryName(INVENTORY_OBJECT, i));
            }
            
            llOwnerSay("Positioning");
            llShout(PRIMCHAN, "MOVE " + llDumpList2String([ vThisPos, rThisRot ], "|"));
            return;
        }
        if ( message == optPos ) {
            llOwnerSay("Positioning");
            vector vThisPos = llGetPos();
            rotation rThisRot = llGetRot();
            llShout(PRIMCHAN, "MOVE " + llDumpList2String([ vThisPos, rThisRot ], "|"));
            return;
        }
        if ( message == optClean ) {
            llShout(PRIMCHAN, "CLEAN");
            return;
        }
        if ( message == optDone ) {
            llShout(PRIMCHAN, "DONE");
            //llDie();
            llOwnerSay("Removing mover scripts.");
            return;
        }   
    }

    ///////////////////////////////////////////////////////////////////////////////
    moving_start()
    {
        if( !bMoving )
        {
            bMoving = TRUE;
            llSetTimerEvent(0.0);    //Resets the timer if already running
            llSetTimerEvent(fMovingRate);
            announce_moved();
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    timer() {
        //Were we moving?
        if( bMoving )
        {
            //Did we change position/rotation?
            if( (llGetRot() != rLastRot) || (llGetPos() != vLastPos) )
            {
                if( llGetTime() > fShoutRate ) {
                    announce_moved();
                }
            }
        } else {
            //Have we been sitting long enough to consider ourselves stopped?
            if( llGetTime() > fStoppedTime )
                bMoving = FALSE;
        }
        
        //Open listener?
        if( iListenTimeout != 0 )
        {
            //Past our close timeout?
            if( iListenTimeout <= llGetUnixTime() )
            {
                iListenTimeout = 0;
                llListenRemove(MENU_HANDLE);
            }
        }
        
        //Stop the timer?
        if( (iListenTimeout == 0) && ( !bMoving ) )
        {
            llOwnerSay("Stopping Timer");
            llSetTimerEvent(0.0);
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    on_rez(integer iStart)
    {
        //Reset ourselves
        llResetScript();
    }
}// END //
