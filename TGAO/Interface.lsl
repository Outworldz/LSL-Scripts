// ZHAO-II-interface - Ziggy Puff, 06/07

////////////////////////////////////////////////////////////////////////
// Interface script - handles all the UI work, sends link 
// messages to the ZHAO-II 'engine' script
//
// Interface definition: The following link_message commands are 
// handled by the core script. All of these are sent in the string 
// field. All other fields are ignored
//
// ZHAO_RESET                          Reset script
// ZHAO_LOAD|<notecardName>            Load specified notecard
// ZHAO_NEXTSTAND                      Switch to next stand
// ZHAO_STANDTIME|<time>               Time between stands. Specified 
//                                     in seconds, expects an integer.
//                                     0 turns it off
// ZHAO_AOON                           AO On
// ZHAO_AOOFF                          AO Off
// ZHAO_SITON                          Sit On
// ZHAO_SITOFF                         Sit Off
// ZHAO_RANDOMSTANDS                   Stands cycle randomly
// ZHAO_SEQUENTIALSTANDS               Stands cycle sequentially
// ZHAO_SETTINGS                       Prints status
// ZHAO_SITS                           Select a sit
// ZHAO_GROUNDSITS                     Select a ground sit
// ZHAO_WALKS                          Select a walk
//
// ZHAO_SITANYWHERE_ON                 Sit Anywhere mod On 
// ZHAO_SITANYWHERE_OFF                Sit Anywhere mod Off 
//
// ZHAO_TYPE_ON                        Typing AO On 
// ZHAO_TYPE_OFF                       Typing AO Off 
//
// ZHAO_TYPEKILL_ON                    Typing Killer On 
// ZHAO_TYPEKILL_OFF                   Typing Killer Off 
//
// So, to send a command to the ZHAO-II engine, send a linked message:
//
//   llMessageLinked(LINK_SET, 0, "ZHAO_AOON", NULL_KEY);
//
////////////////////////////////////////////////////////////////////////

// Johann Ehrler, 12/13/2008:
//          ZHAO failed to recognize owner change...FIXED!
//          This interface send a reset request to all other scripts if owner changed.

// Marcus Gray/Johann Ehrler, 09/28/2008:
//          Added ability to toggle stand ON or OFF.

// Johann Ehrler, 09/16/2008:
//          Provisory added ability to control the ZHAO's power switch via chat line or a gesture.
//          TODO: Rethink about the currently implementation. xD
//
//          WARNING: This script was MONO-recompiled!

// Marcus Gray, 04/06/2008:
//          Added TypingAO support with new NC-token [ Typing ] & Typing-kill-functionality (core)
//          Dialog-Menu entries for TypingAO & TypingKill ...made 14 buttons which forces me to do multipage dialog... 
//          f**k!!! (interface)
//          Freed huge amount of mem by moving NC-loading to an extra script (core --> zhao-II-loadcards)

// Marcus Gray, 03/26/2008:
//          Included Seamless Sit mod by Moeka Kohime (core script).
//          Freed some memory DELETING THE DEFAULT UNOVERRIDABLE ANIMS!!!!!!!! (core script)
//          Added sit anywhere functionality to replace stands by groundsits (core script).
//          Therefore changed functionality of Sit-ON/OFF button to work as Sit Anywhere button (interface).

// Johann Ehrler, 08/01/2007:
//          Color-mod - Now you can use standard RGB-notation for the ON-OFF-states.
//          Link names - You can use the link names instead the link numbers

// Marcus Gray, 08/01/2007:
//          Added some extra buttons for easier access of the main functions.
//          Created new funtions loadNotecard() and toggleSit() containing the code now used by Dialog/Listen AND Button handling.
//          In addition, swapped Menu and Sit-ON/OFF buttons

// Ziggy, 07/16/07 - Single script to handle touches, position changes, etc., since idle scripts take up
// 
// Ziggy, 06/07:
//          Single script to handle touches, position changes, etc., since idle scripts take up
//          scheduler time
//          Tokenize notecard reader, to simplify notecard setup
//          Remove scripted texture changes, to simplify customization by animation sellers

// Fennec Wind, January 18th, 2007:
//          Changed Walk/Sit/Ground Sit dialogs to show animation name (or partial name if too long) 
//          and only show buttons for non-blank entries.
//          Fixed minor bug in the state_entry, ground sits were not being initialized.
//

// Dzonatas Sol, 09/06: Fixed forward walk override (same as previous backward walk fix). 


// Based on Francis Chung's Franimation Overrider v1.8

// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.

// CONSTANTS
//////////////////////////////////////////////////////////////////////////////////////////////////////////


// Help notecard
string helpNotecard = "READ ME FIRST - ZHAO-II";

// How long before flipping stand animations
integer standTimeDefault = 30;

// Listen channel for pop-up menu... 
// should be different from channel used by ZHAO engine (-91234)
//
// Mod: Channel will now be generated from owner UUID.
integer listenChannel = -2; //-91235;

integer listenHandle;                          // Listen handlers - only used for pop-up menu, then turned off
integer listenState = 0;                       // What pop-up menu we're handling now

// Overall AO state
integer zhaoOn = TRUE;

////////////////////////////////////////////////////////////
// BEGIN mod by Johann Ehrler - 08/01/2007
//
// Link names/numbers for the extra buttons:
string btnMenu = "menu";                //Menu button
string btnLNC = "load";                 //Load notecard button
string btnTSitOnOff = "sit_toggle";     //Sit-ON/OFF button
string btnTSitAW = "toggle_gs_ao";      //Sit ANYWHERE-ON/OFF button
string btnWalk = "walks";               //Choose walk button
string btnGSits = "groundsits";         //Choose groundsit button
string btnSits = "sits";                //Choose sit button
string btnTStandOnOff = "standtoggle";  //Stand-ON/OFF button
string btnNStand = "nextstand";         //Play next stand button
string btnMinMax = "minmax";            //Minimize/Maximize button
string btnHelp = "help";                //HELP button
string btnRuns = "Runs";                //Runs Button
string btnDanceAO = "dancetoggle";      //Dance AO Button
string btnNextDance = "nextdance";      // Next Dance Button
string btnDances = "dances";            // Dances Menu Button
//
// END Mod by Johann Ehrler
////////////////////////////////////////////////////////////


// Interface script now keeps track of these states. The defaults
// match what the core script starts out with
integer standOverride = TRUE;
integer sitOverride = TRUE;
integer danceOverride = FALSE;
integer sitAnywhere = FALSE;
integer randomStands = FALSE;
integer randomRuns = FALSE;
integer randomDance = FALSE;
integer typingOverrideOn = TRUE;            // Whether we're overriding typing or not
integer typingKill = FALSE;                 // Whether we're killing the typing completely

key Owner = NULL_KEY;

// MENU VARS
integer MMAIN       = 0;
integer MSIT        = 1;
integer MSTAND      = 2;
integer MRUN        = 3;
integer MDANCE      = 4;

integer menuState = 0;

// CODE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Initialize listeners, and reset some status variables
Initialize() {
    Owner = llGetOwner();

    // On init, open a new listener...
    if ( listenHandle )
        llListenRemove( listenHandle );
    // Generate the channel from the owner UUID and adds 1 cuz we need a different channel as the core script.
    listenChannel = ( 1 + (integer)( "0xF" + llGetSubString( llGetOwner(), 0, 6) ) ) + 1;
    listenHandle = llListen( listenChannel, "", Owner, "" );

    // ... And turn it off
    llListenControl(listenHandle, FALSE);
}

DoMenu() 
{
    // The rows are inverted in the actual dialog box. This must match
    // the checks in the listen() handler
    string menutxt = "Please select an option:\n \n";
    list buttons = [];
    
    if(menuState == MMAIN)
    {
        menutxt += "Submenus:";
        menutxt += "\n \tSIT: Sit-submenu";
        menutxt += "\n \tSTAND: Stand-submenu";
        menutxt += "\n \tRUN: Run-submenu";
        
        buttons = [
            "Walks", "SIT", "STAND", "RUN", "DANCE",
            "Load", "Settings", "Next Stand",
            "Help", "Reset"
        ];

        listenState = 0;
    }
    else if(menuState == MSIT)
    {
        buttons = [
            "Sits", "Ground Sits",
            "Sit On/Off", "Sit Anywhere",
            "MAIN"
        ];
    }
    else if(menuState == MSTAND)
    {
        buttons = [
            "Rand/Seq", "Stand Time", "Next Stand",
            "MAIN"
        ];
    }
    else if(menuState == MRUN)
    {
        buttons = [
            "Rand/Single", "Select Run",
            "MAIN"
        ];
    }
    else if(menuState == MDANCE)
    {
        buttons = [
            "Rand/Single", "Select Dance",
            "MAIN"
        ];
    }
    llListenControl(listenHandle, TRUE);
    llDialog( Owner, menutxt, buttons, listenChannel );
}

////////////////////////////////////////////////////////////
// BEGIN mod by Marcus Gray - 08/01/2007
// new functions for now multi-used code for loading notecards and toggling sit
//
loadNotecard()
{
    integer n = llGetInventoryNumber( INVENTORY_NOTECARD );
    // Can only have 12 buttons in a dialog box
    if ( n > 13 ) {
        llOwnerSay( "You cannot have more than 12 animation notecards." );
        return;
    }

    integer i;
    list animSets = [];

    // Build a list of notecard names and present them in a dialog box
    for ( i = 0; i < n; i++ ) {
        string notecardName = llGetInventoryName( INVENTORY_NOTECARD, i );
        if ( notecardName != helpNotecard )
            animSets += [ notecardName ];
    }

    llListenControl(listenHandle, TRUE);
    llDialog( Owner, "Select the notecard to load:", animSets, listenChannel );
    listenState = 1;
}

toggleAO()
{
    if (zhaoOn) {
        llOwnerSay("Sending OFF Signal...");
        llMessageLinked(LINK_SET, 0, "ZHAO_AOOFF", NULL_KEY);
    } else {
        llOwnerSay("Sending ON Signal...");
        llMessageLinked(LINK_SET, 0, "ZHAO_AOON", NULL_KEY);
    }
    zhaoOn = !zhaoOn;
}

toggleStand()
{
    //s t a n d BUTTON COLOR IS HANDLED BY A SCRIPT INSIDE THE BUTTON ITSELF!!!
    if (standOverride == TRUE) {
        llMessageLinked(LINK_SET, 0, "ZHAO_STANDOFF", NULL_KEY);
    } else {
        llMessageLinked(LINK_SET, 0, "ZHAO_STANDON", NULL_KEY);
    }
    standOverride = !standOverride;
}
toggleSit()
{
    //SIT BUTTON COLOR IS HANDLED BY A SCRIPT INSIDE THE BUTTON ITSELF!!!
    if (sitOverride == TRUE) {
        llMessageLinked(LINK_SET, 0, "ZHAO_SITOFF", NULL_KEY);
    } else {
        llMessageLinked(LINK_SET, 0, "ZHAO_SITON", NULL_KEY);
    }
    sitOverride = !sitOverride;
}

toggleSitAnywhere()
{
    //SIT ANYWHERE BUTTON COLOR IS HANDLED BY A SCRIPT INSIDE THE BUTTON ITSELF!!!
    if (sitAnywhere == TRUE) {
        llMessageLinked(LINK_SET, 0, "ZHAO_SITANYWHERE_OFF", NULL_KEY);
    } else {
        llMessageLinked(LINK_SET, 0, "ZHAO_SITANYWHERE_ON", NULL_KEY);
    }
    sitAnywhere = !sitAnywhere;
}

toggleTyping()
{
    //SIT ANYWHERE BUTTON COLOR IS HANDLED BY A SCRIPT INSIDE THE BUTTON ITSELF!!!
    if (typingOverrideOn == TRUE) {
        llMessageLinked(LINK_SET, 0, "ZHAO_TYPEAO_OFF", NULL_KEY);
    } else {
        llMessageLinked(LINK_SET, 0, "ZHAO_TYPEAO_ON", NULL_KEY);
    }
    typingOverrideOn = !typingOverrideOn;
}

toggleTypingKill()
{
    //SIT ANYWHERE BUTTON COLOR IS HANDLED BY A SCRIPT INSIDE THE BUTTON ITSELF!!!
    if (typingKill == TRUE) {
        llMessageLinked(LINK_SET, 0, "ZHAO_TYPEKILL_OFF", NULL_KEY);
    } else {
        llMessageLinked(LINK_SET, 0, "ZHAO_TYPEKILL_ON", NULL_KEY);
    }
    typingKill = !typingKill;
}

toggleDanceAO()
{
    //SIT ANYWHERE BUTTON COLOR IS HANDLED BY A SCRIPT INSIDE THE BUTTON ITSELF!!!
    if (danceOverride == TRUE) {
        llMessageLinked(LINK_SET, 0, "ZHAO_DANCEOFF", NULL_KEY);
    } else {
        llMessageLinked(LINK_SET, 0, "ZHAO_DANCEON", NULL_KEY);
    }
    danceOverride = !danceOverride;
}

help()
{
    if (llGetInventoryType(helpNotecard) == INVENTORY_NOTECARD)
        llGiveInventory(Owner, helpNotecard);
    else
        llOwnerSay("No help notecard found.");
}
//
// END mod by Marcus Gray
////////////////////////////////////////////////////////////

// STATE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

default {
    state_entry() {

        Initialize();

        // Sleep a little to let other script reset (in case this is a reset)
        llSleep(2.0);

        // We start out as AO ON
        zhaoOn = TRUE;
        llMessageLinked(LINK_SET, 0, "ZHAO_AOON", NULL_KEY);
        
        //stand override ON by default
        llMessageLinked(LINK_SET, 0, "ZHAO_STANDON", NULL_KEY);
        standOverride = TRUE;
        
        //sit override ON by default
        llMessageLinked(LINK_SET, 0, "ZHAO_SITON", NULL_KEY);
        sitOverride = TRUE;
        
        //sit anywhere OFF by default
        llMessageLinked(LINK_SET, 0, "ZHAO_SITANYWHERE_OFF", NULL_KEY);
        sitAnywhere = FALSE;
        
        //show ZHAO
        llMessageLinked(LINK_SET, 0, "ZHAO_SHOW", NULL_KEY);
        
        //typing AO & typing Killer
        llMessageLinked(LINK_SET, 0, "ZHAO_TYPEAO_OFF", NULL_KEY);
        llMessageLinked(LINK_SET, 0, "ZHAO_TYPEKILL_OFF", NULL_KEY);
    }

    on_rez( integer _code ) {
        Initialize();
    }

    touch_start( integer _num ) {
        
        ////////////////////////////////////////////////////////////
        // BEGIN mod by Marcus Gray - 08/01/2007
        //
        integer lntmp = llDetectedLinkNumber(0);
        string btmp = llGetLinkName(lntmp);
        
        if (btmp == btnMenu) {
            // Menu prim... use number instead of name
            DoMenu();
        }
        //
        // Added button handlers
        //
        else if (btmp == btnLNC) {
            loadNotecard();
        }
        else if (btmp == btnTSitAW) {
            toggleSitAnywhere();
        }
        else if (btmp == btnTSitOnOff) { //while btnTSit == btnTSitAW this won't be reached!
            toggleSit();
        }
        else if (btmp == btnTStandOnOff) { //while btnTSit == btnTSitAW this won't be reached!
            toggleStand();
        }
        else if(btmp == btnRuns){
            menuState = MRUN;
            DoMenu();
        }
        else if(btmp == btnDances){
            menuState = MDANCE;
            DoMenu();
        }
        else if (btmp == btnWalk) {
            llMessageLinked(LINK_SET, 0, "ZHAO_WALKS", NULL_KEY);
        }
        else if (btmp == btnGSits) {
            llMessageLinked(LINK_SET, 0, "ZHAO_GROUNDSITS", NULL_KEY);
        }
        else if (btmp == btnSits) {
            llMessageLinked(LINK_SET, 0, "ZHAO_SITS", NULL_KEY);
        }
        else if (btmp == btnNStand) {
            llMessageLinked(LINK_SET, 0, "ZHAO_NEXTSTAND", NULL_KEY);
        }
        else if (btmp == btnMinMax) {
            llMessageLinked(LINK_SET, 0, "ZHAO_TOGGLE_SHOW", NULL_KEY);
        }
        else if (btmp == btnDanceAO) {
            toggleDanceAO();
        }
        else if (btmp == btnNextDance) {
            llMessageLinked(LINK_SET, 0, "ZHAO_NEXTDANCE", NULL_KEY);
        }
        else if (btmp == btnHelp) {
            help();
        }
        //
        // END mod by Marcus Gray
        ////////////////////////////////////////////////////////////
        

        else if (lntmp == 1) {
            // On/Off prim ==> MYSELF ^^
            toggleAO();
        }
    }
    
    listen( integer _channel, string _name, key _id, string _message) {

        // Turn listen off. We turn it on again if we need to present 
        // another menu.
        llListenControl(listenHandle, FALSE);

       if ( _message == "Help" ) {
            help();
        }
        else if ( _message == "Reset" ) {
            llMessageLinked(LINK_SET, 0, "ZHAO_RESET", NULL_KEY);
            llSleep(1.0);
            llResetScript();
        }
        else if ( _message == "Settings" ) {
            llMessageLinked(LINK_SET, 0, "ZHAO_SETTINGS", NULL_KEY);
        }
        else if ( _message == "MAIN" ) {
            menuState = MMAIN;
            DoMenu();
        }
        else if ( _message == "SIT" ) {
            menuState = MSIT;
            DoMenu();
        }
        else if ( _message == "STAND" ) {
            menuState = MSTAND;
            DoMenu();
        }
        else if ( _message == "RUN" ) {
            menuState = MRUN;
            DoMenu();
        }
        else if ( _message == "DANCE" ) {
            menuState = MDANCE;
            DoMenu();
        }
        else if ( _message == "Sit On/Off" ) {
            //code moved to toggleSit() by Marcus Gray
            toggleSit();
        }
        else if ( _message == "TypingAO" ) {
            //code moved to toggleTyping() by Marcus Gray
            toggleTyping();
        }
        else if ( _message == "TypingKill" ) {
            //code moved to toggleTypingKill() by Marcus Gray
            toggleTypingKill();
        }
        else if ( _message == "Sit Anywhere" ) {
            //toggleSitAnywhere() by Marcus Gray
            toggleSitAnywhere();
        }
        else if ( _message == "Rand/Seq" ) {
            if (randomStands == TRUE) {
                llMessageLinked(LINK_SET, 0, "ZHAO_SEQUENTIALSTANDS", NULL_KEY);
                randomStands = FALSE;
            } else {
                llMessageLinked(LINK_SET, 0, "ZHAO_RANDOMSTANDS", NULL_KEY);
                randomStands = TRUE;
            }
        }
        else if ( _message == "Rand/Single" && menuState == 3 ) {
            if (randomRuns == TRUE) {
                llMessageLinked(LINK_SET, 0, "ZHAO_SINGLERUN", NULL_KEY);
                randomRuns = FALSE;
            } else {
                llMessageLinked(LINK_SET, 0, "ZHAO_RANDOMRUN", NULL_KEY);
                randomRuns = TRUE;
            }
        }
        else if ( _message == "Rand/Single" && menuState == 4 ) {
            if (randomDance == TRUE) {
                llMessageLinked(LINK_SET, 0, "ZHAO_SINGLEDANCE", NULL_KEY);
                randomDance = FALSE;
            } else {
                llMessageLinked(LINK_SET, 0, "ZHAO_RANDOMDANCE", NULL_KEY);
                randomDance = TRUE;
            }
        }
        else if ( _message == "Next Stand" ) {
            llMessageLinked(LINK_SET, 0, "ZHAO_NEXTSTAND", NULL_KEY);
        }
        else if ( _message == "Load" ) {
            //code moved to loadNotecard() by Marcus Gray
            loadNotecard();
        }
        else if ( _message == "Stand Time" ) {
            // Pick stand times
            list standTimes = ["0", "5", "10", "15", "20", "30", "40", "60", "90", "120", "180", "240"];
            llListenControl(listenHandle, TRUE);
            llDialog( Owner, "Select stand cycle time (in seconds). \n\nSelect '0' to turn off stand auto-cycling.", 
                      standTimes, listenChannel);
            listenState = 2;
        }
        else if ( _message == "Select Run" ) {
            llMessageLinked(LINK_SET, 0, "ZHAO_RUNS", NULL_KEY);
        }
        else if ( _message == "Select Dance" ) {
            llMessageLinked(LINK_SET, 0, "ZHAO_DANCES", NULL_KEY);
        }
        else if ( _message == "Sits" ) {
            llMessageLinked(LINK_SET, 0, "ZHAO_SITS", NULL_KEY);
        }
        else if ( _message == "Walks" ) {
            llMessageLinked(LINK_SET, 0, "ZHAO_WALKS", NULL_KEY);
        }
        else if ( _message == "Ground Sits" ) {
            llMessageLinked(LINK_SET, 0, "ZHAO_GROUNDSITS", NULL_KEY);
        }
        else if ( listenState == 1 ) {
            // Load notecard
            llMessageLinked(LINK_SET, 0, "ZHAO_LOAD|" + _message, NULL_KEY);
        }
        else if ( listenState == 2 ) {
            // Stand time change
            llMessageLinked(LINK_SET, 0, "ZHAO_STANDTIME|" + _message, NULL_KEY);
        }
    }

    changed(integer _change) {
        if(_change & CHANGED_OWNER) {
            llMessageLinked(LINK_SET, 0, "ZHAO_RESET", NULL_KEY);
            llSleep(1.0);
            llResetScript();
        }
    }
}