// :CATEGORY:Building
// :NAME:Builders Buddy
// :AUTHOR:Newfie Pendragon
// :KEYWORDS:
// :CREATED:2014-10-21 20:01:53
// :EDITED:2014-10-21
// :ID:122
// :NUM:1665
// :REV:10.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Builder's Buddy lets ordinary SL users rez a set of unlinked items in their proper places in relation to each other, without needing any building skills.
// The "Set" is usually a building, but there is no reason it can't also be a statue, a furniture set, etc.
// You prepare the unlinked items according to the easy steps below, then for distribution put them in a Packing Box.
// This script goes in the Builders Buddy box along with all parts
// :CODE:

///////////////////////////////////////////////////////////////////////////////
// Builders' Buddy 1.10 (Base Script)
// by Newfie Pendragon, 2006-2008
///////////////////////////////////////////////////////////////////////////////
//
// Script Purpose & Use
// Functions are dependent on the "component script"
//
// QUICK USE:
// - Drop this script in the Base.
// - Drop the "Component" Script in each building part.
// - Touch your Base, and choose RECORD
// - Take all building parts into inventory
// - Drag building parts from inventory into Base Prim
// - Touch your base and choose BUILD
//
// OTHER COMMANDS from the Touch menu
// - To reposition, move/rotate Base Prim choose POSITION
// - To lock into position (removes scripts) choose DONE
// - To delete building pieces: choose CLEAN
///////////////////////////////////////////////////////////////////////////////
// This script is copyrighted material, and has a few (minor) restrictions.
// For complete details, including a revision history, please see
//  http://wiki.secondlife.com/wiki/Builders_Buddy
///////////////////////////////////////////////////////////////////////////////

// Channel used by Base Prim to talk to Component Prims
// This channel must be the same one in the component script
// A negative channel is used because it elimited accidental activations
// by an Avatar talking on obscure channels
integer DefaultPRIMCHAN = -192567;     // Default channel to use
//integer PRIMCHAN = DefaultPRIMCHAN;    // Channel used by Base Prim to talk to Component Prims;
integer PRIMCHAN = -192567;  // OpenSim Modification - also comment out the previous line for OpenSim
                                       // ***THIS MUST MATCH IN BOTH SCRIPTS!***

///////////////////////////////////////////////////////////////////////////////
// Change these values if your using Megaregions or want to limit otherwise.
// Variables for Positioninglimits within the sim of a 1024 X 1024 var or mega
float vDestPosXMIN = 0.0;
float vDestPosXMAX = 1024.0;
float vDestPosYMIN = 0.0;
float vDestPosYMAX = 1024.0;
float vDestPosZMAX = 10000.0;



//The UUID of the creator of the object
//Leave this as "" unless SL displays wrong name in object properties
key creatorUUID = "";

// Set to TRUE to allow group members to use the dialog menu
// Set to FALSE to disallow group members from using the dialog menu
integer ingroup = TRUE;

// Set to TRUE to delete piece from inventory when rezzed
// (WARNING) If set to FALSE, user will be able to rez multiple copies
integer deleteOnRez = FALSE;

// Allow non-creator to use CLEAN command?
// (WARNING) If set to TRUE, it is recommended to set
// deleteOnRez to FALSE, or user could lose entire building
integer allowClean = TRUE;

//When user selects CLEAN, delete the base prim too?
integer dieOnClean = FALSE;

// Set to TRUE to record piece's location based on sim
// coordinates instead of relationship to base prim
integer recordSimLocation = FALSE;

// Set to TRUE to rez all building pieces before positioning,
// or FALSE to do (slower?) one at a time
integer bulkBuild = TRUE;

//Set to FALSE if you dont want the script to say anything while 'working'
integer chatty = TRUE;

//How long to listen for a menu response before shutting down the listener
float fListenTime = 30.0;

//How often (in seconds) to perform any timed checks
float fTimerRate = 0.25;

//How long to sit still before exiting active mode
float fStoppedTime = 30.0;

//SL sometimes blocks rezzing to prevent "gray goo" attacks
//How long we wait (seconds) before we assume SL blocked our rez attempt
integer iRezWait = 10;

//Specify which Menu Options will be displayed
//FALSE will restrict full options to creator
//TRUE will offer full options to anyone
integer fullOptions = FALSE;

//Set to TRUE if you want ShapeGen channel support
// (Last 4 digits of channel affected)
integer SGCompatible = FALSE;


///////////////////////////////////////////////////////////////////////////////
//Part of KEYPAD CODE BY Andromeda Quonset....More added below in seevral places
list Menu2 = [ "-", "0","enter","7","8","9","4","5","6","1","2","3"];
string Input = "";
string Sign = "+";
string SignInput = " ";
string Caption = "Enter a number, include any leading 0's: ";

///////////////////////////////////////////////////////////////////////////////
// DO NOT EDIT BELOW THIS LINE.... NO.. NOT EVEN THEN
///////////////////////////////////////////////////////////////////////////////

//Name each option-these names will be your button names.
string optRecord = "Record";
string optReset = "Reset";
string optBuild = "Build";
string optPos = "Position";
string optClean = "Clean";
string optDone = "Done";
string optChannel = "Channel";

//Menu option descriptions
string descRecord = ": Record the position of all parts\n";
string descReset = ": Forgets the position of all parts\n";
string descBuild = ": Rez inv. items and position them\n";
string descPos = ": Reposition the parts to a new location\n";
string descClean = ": De-Rez all pieces\n";
string descDone = ": Remove all BB scripts and freeze parts in place.\n";
string descChannel = ": Change Channel used on base and parts.\n";

integer MENU_CHANNEL;
integer MENU2_CHANNEL;
integer MENU_HANDLE;
integer MENU2_HANDLE;
key agent;
key objectowner;
integer group;
string title = "";
list optionlist = [];
integer bMoving;
vector vLastPos;
rotation rLastRot;
integer bRezzing;
integer iListenTimeout = 0;
integer iLastRez = 0;
integer iRezIndex;


InvertSign()
{
    if(Sign == "+")
        Sign = "-";
    else
        Sign = "+";
}

//To avoid flooding the sim with a high rate of movements
//(and the resulting mass updates it will bring), we used
// a short throttle to limit ourselves
announce_moved()
{
    llRegionSay(PRIMCHAN, "MOVE " + llDumpList2String([ llGetPos(), llGetRot() ], "|"));
    llResetTime();        //Reset our throttle
    vLastPos = llGetPos();
    rLastRot = llGetRot();
    return;
}


rez_object()
{
    //Rez the object indicated by iRezIndex
    llRezObject(llGetInventoryName(INVENTORY_OBJECT, iRezIndex), llGetPos(), ZERO_VECTOR, llGetRot(), PRIMCHAN);
    iLastRez = llGetUnixTime();
    llSleep(2);

    if(!bRezzing) {
        bRezzing = TRUE;
        //timer_on();
    }
    llSay(PRIMCHAN, "SET_LIMITS " + (string)vDestPosXMIN + " " + (string)vDestPosXMAX + " " + (string)vDestPosYMIN + " " + (string)vDestPosYMAX + " " + (string)vDestPosZMAX );
}

post_rez_object()
{
    if ( creatorUUID != llGetOwner() ) {
        if(deleteOnRez) llRemoveInventory(llGetInventoryName(INVENTORY_OBJECT, iRezIndex));
    }
}

heard(integer channel, string name, key id, string message)
{
    if( channel == PRIMCHAN ) {
        if( message == "READYTOPOS" ) {
            //New prim ready to be positioned
            vector vThisPos = llGetPos();
            rotation rThisRot = llGetRot();
            llRegionSay(PRIMCHAN, "MOVESINGLE " + llDumpList2String([ vThisPos, rThisRot ], "|"));

        } else if( message == "ATDEST" ) {
            //Rez the next in the sequence (if any)
            iRezIndex--;
            if(iRezIndex >= 0) {
                //Attempt to rez it
                rez_object();
            } else {
                //We are done building, reset our listeners
                iLastRez = 0;
                bRezzing = FALSE;
                state reset_listeners;
            }
        }
        return;

    } else if( channel == MENU_CHANNEL ) {   //Process input from original menu
        if ( message == optRecord ) {
            PRIMCHAN = DefaultPRIMCHAN;
            llOwnerSay("Recording positions...");
            if(recordSimLocation) {
                //Location in sim
                llRegionSay(PRIMCHAN, "RECORDABS " + llDumpList2String([ llGetPos(), llGetRot() ], "|"));
            } else {
                //Location relative to base
                llRegionSay(PRIMCHAN, "RECORD " + llDumpList2String([ llGetPos(), llGetRot() ], "|"));
            }
            return;
        }
        if( message == optReset ) {
            llOwnerSay("Forgetting positions...");
            llShout(PRIMCHAN, "RESET");
            return;
        }
        if ( message == optBuild ) {
            if(chatty) llOwnerSay("Rezzing build pieces...");

            //If rezzing/positioning one at a time, we need
            // to listen for when they've reached their dest
            if(!bulkBuild) {
                llListen(PRIMCHAN, "", NULL_KEY, "READYTOPOS");
                llListen(PRIMCHAN, "", NULL_KEY, "ATDEST");
            }

            //Start rezzing, last piece first
            iRezIndex = llGetInventoryNumber(INVENTORY_OBJECT) - 1;
            rez_object();
            return;
        }
        if ( message == optPos ) {
            if(chatty) llOwnerSay("Positioning");
            vector vThisPos = llGetPos();
            rotation rThisRot = llGetRot();
            llRegionSay(PRIMCHAN, "MOVE " + llDumpList2String([ vThisPos, rThisRot ], "|"));
            return;
        }
        if ( message == optClean ) {
            llRegionSay(PRIMCHAN, "CLEAN");
            if(dieOnClean) llDie();
            return;
        }
        if ( message == optDone ) {
            llRegionSay(PRIMCHAN, "DONE");
            if(chatty) llOwnerSay("Removing Builder's Buddy scripts.");
            return;
        }
        if ( message == optChannel ) {
            Sign = "+"; //default is a positive number
            Input = "";
            llDialog( agent, Caption, Menu2, MENU2_CHANNEL );
        }

    } else if ( channel == MENU2_CHANNEL ) {    //process input from MENU2
        // if a valid choice was made, implement that choice if possible.
        // (llListFindList returns -1 if Choice is not in the menu list.)
        if ( llListFindList( Menu2, [ message ]) != -1 ) {
            if( llListFindList(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], [message]) != -1) {
                Input += message;
                SignInput = Sign + Input;
                llDialog( agent, Caption + SignInput, Menu2, MENU2_CHANNEL );

            } else if( message == "-" ) {
                InvertSign();
                SignInput = Sign + Input;
                llDialog( agent, Caption + SignInput, Menu2, MENU2_CHANNEL );

            } else if( message == "enter" ) {     //terminate input from menu2
                string CalcChan = Input;

                //Apply ShapeGen compatibility?
                if(SGCompatible) {
                    //new assign channel number, forcing last 4 digits to 0000
                    integer ChanSize = llStringLength(Input); //determine number of digits (chars)
                    if(ChanSize > 5) {
                        CalcChan = llGetSubString(Input, 0, 4);    //Shorten to 5 digits
                    }
                    CalcChan += "0000"; //append 0000
                    if(Sign == "-")
                        CalcChan = Sign + CalcChan;
                }
                PRIMCHAN = (integer)CalcChan; //assign channel number
                llOwnerSay("Channel set to " + (string)PRIMCHAN + ".");
            }

        } else {
            llDialog( agent, Caption, Menu2, MENU2_CHANNEL );
        }
    }
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
        //Determine the creator UUID
        if(creatorUUID == "") creatorUUID = llGetCreator();

        //Use which menu?
        if (creatorUUID == llGetOwner() || fullOptions) {
            //Display all options
            optionlist = [optPos, optClean, optDone, optRecord, optReset, optBuild, optChannel];
            title = optRecord + descRecord;
            title += optReset + descReset;
            title += optBuild + descBuild;
            title += optPos + descPos;
            title += optClean + descClean;
            title += optDone + descDone;
            title += optChannel + descChannel;

        } else {
            //Display limited options
            if(allowClean) {
                optionlist = [optBuild, optPos, optClean, optDone];
                title = optBuild + descBuild;
                title += optPos + descPos;
                title += optClean + descClean;
                title += optDone + descDone;
            } else {
                optionlist = [optBuild, optPos, optDone];
                title = optBuild + descBuild;
                title += optPos + descPos;
                title += optDone + descDone;
            }
        }

        //Record our position
        vLastPos = llGetPos();
        rLastRot = llGetRot();

        llSetTimerEvent(fTimerRate);
    }

    ///////////////////////////////////////////////////////////////////////////////
    touch_start (integer total_number) {
        group = llDetectedGroup(0); // Is the Agent in the objowners group?
        agent = llDetectedKey(0); // Agent's key
        objectowner = llGetOwner(); // objowners key
        // is the Agent = the owner OR is the agent in the owners group
        if ( (objectowner == agent) || ( group && ingroup )  )  {
            iListenTimeout = llGetUnixTime() + llFloor(fListenTime);
            MENU_CHANNEL = llFloor(llFrand(-99999.0 - -100));
            MENU2_CHANNEL = MENU_CHANNEL + 1;
            MENU_HANDLE = llListen(MENU_CHANNEL,"","","");
            MENU2_HANDLE = llListen(MENU2_CHANNEL,"","","");
            if ( creatorUUID == llGetOwner() || fullOptions) {
                llDialog(agent,title + "Now on Channel " + (string)PRIMCHAN, optionlist, MENU_CHANNEL); //display channel number if authorized
            } else {
                llDialog(agent, title, optionlist, MENU_CHANNEL);
            }
            //timer_on();
        }
    }

    ///////////////////////////////////////////////////////////////////////////////
    listen(integer channel, string name, key id, string message) {
        heard(channel, name, id, message);
        return;
    }

    ///////////////////////////////////////////////////////////////////////////////
    moving_start()
    {
        if( !bMoving )
        {
            bMoving = TRUE;
            //timer_on();
            announce_moved();
        }
    }

    ///////////////////////////////////////////////////////////////////////////////
    object_rez(key id) {
        //The object rezzed, perform any post-rez processing
        post_rez_object();

        //Rezzing it all before moving?
        if(bulkBuild) {
            //Move on to the next object
            //Loop through backwards (safety precaution in case of inventory change)
            iRezIndex--;
            if(iRezIndex >= 0) {
                //Attempt to rez it
                rez_object();

            } else {
                //Rezzing complete, now positioning
                iLastRez = 0;
                bRezzing = FALSE;
                if(chatty) llOwnerSay("Positioning");
                llRegionSay(PRIMCHAN, "MOVE " + llDumpList2String([ llGetPos(), llGetRot() ], "|"));
            }
        }
    }

    ///////////////////////////////////////////////////////////////////////////////
    timer() {
        //Did we change position/rotation?
        if( (llGetRot() != rLastRot) || (llGetPos() != vLastPos) )
        {
            if( llGetTime() > fTimerRate ) {
                announce_moved();
            }
        }

        //Are we rezzing?
        if(bRezzing) {
            //Did the last one take too long?
            if((llGetUnixTime() - iLastRez) >= iRezWait) {
                //Yes, retry it
                if(chatty) llOwnerSay("Reattempting rez of most recent piece");
                rez_object();
            }
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
    }

    ///////////////////////////////////////////////////////////////////////////////
    on_rez(integer iStart)
    {
        //Reset ourselves
        llResetScript();
    }
}


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
state reset_listeners
{
    //////////////////////////////////////////////////////////////////////////////////////////
    state_entry()
    {
        state default;
    }
}
