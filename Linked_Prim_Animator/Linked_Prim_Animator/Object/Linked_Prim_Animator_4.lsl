// :CATEGORY:Prim
// :NAME:Linked_Prim_Animator
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:31:14.597
// :EDITED:2013-09-18 15:38:56
// :ID:474
// :NUM:638
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// LPA Editor
// :CODE:
//	This file is part of Linked Prim Animator Lite (LPAL).
//
//	LPAL is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	LPAL is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with LPAL.  If not, see <http://www.gnu.org/licenses/>.
//
//	Linked Prim Animator Lite - Editor Ltd
//	Author: Falados Kapuskas
//	Version: 0.6
//	Date: 12/27/2007
//	Description:
//	  Controls all operations of the Linked-Prim animator during the setup and snapshot phase.

//----- CONSTANT VALUES -----//
string MODULE_PREFIX = "LPAL Frame Capture";		//All loadable modules are prefixed with this
integer SCRIPT_PIN = 3014;				//To load scripts on other prims, this should be set the same
integer OPERATION_CHANNEL = 55;				//Channel for which all chat commands are announced

//GLOBAL VARIABLES
integer link_len = 0;
integer link_i = 0;
integer link_scripts = 0;
key owner;						//Key of the owner is stored in this script
integer frame;						//Current animation frame stored here
integer max_frames;					//The last frame in the recorded animation sequence
list animators = [];				//These are the link numbers which responded to the initial setup query
list ex = [];						//When loading scripts, exclude these modules	(Usually a parameter to a function)
list mods = [];						//List of all modules to be loaded into linked prims (Populated via function)

//----- Functions -----//

//Function:	ERROR
//Description:	Say an error on the debug channel
ERROR(string mystate , string msg) {
    llSay(DEBUG_CHANNEL, llGetScriptName() + ": state " + mystate + " - " + msg);
}


//Function: find_modules
//Description:	Finds the scripts in (this object's) inventory
//		that match the MODULES_PREFIX prefix in their name
find_modules() {
    integer i;
    integer invs = llGetInventoryNumber( INVENTORY_ALL );
    string name;
    for( i = 0; i < invs; ++i){
        name = llGetInventoryName(INVENTORY_SCRIPT,i);
        if( llGetInventoryType(name) == INVENTORY_SCRIPT )
        {
            if( llSubStringIndex(name,MODULE_PREFIX) == 0 ) {
                mods += name;
            }
        }
    }

}

//Function:	give_scripts
//Description:	Gives scripts to the linked primitive (num),
//		excluding those scripts listed in exclude
give_scripts(integer num,list exclude) {
    integer i;
    integer len = llGetListLength( mods );
    integer len2 = llGetListLength(exclude);
    string name;
    link_scripts = 0;
    for( i = 0; i < len; ++i) {
        name = llList2String( mods , i );
        if( len2 == 0 || llListFindList( exclude , [name] )  == -1 ) {
            llMessageLinked( LINK_THIS , num , name , "loader" );
            ++link_scripts;
        }
    }
}

//Function:	uncheck_scripts
//Description:	Makes sure the modules in this object are not running
uncheck_scripts() {
    //Make sure the Root's collector scripts are OFF
    integer i;
    integer len = llGetListLength( mods );
    string name;
    for( i = 0; i < len; ++i ) {
        name = llList2String( mods, i);
        if( llGetInventoryType( name ) == INVENTORY_SCRIPT ) {
            llSetScriptState( name , FALSE );
        }
    }
}

//Function:	remove_scripts
//Description:	Removes all uneeded scripts after this object is done with the setup
remove_scripts() {
    //Make sure the Root's collector scripts are OFF
    integer i;
    integer len = llGetListLength( mods );
    string name;
    for( i = 0; i < len; ++i ) {
        name = llList2String( mods, i);
        if( llGetInventoryType( name ) == INVENTORY_SCRIPT ) {
            llRemoveInventory(name);
        }
    }
}

//Function:	process_command
//Description:	Will process a command and return TRUE or FALSE
//				Upon success and failure.  Return value of 2 indicates
//				lpa_done message (Move on to next state)
integer process_command(string message,integer num) {
    //Tell children to record their status
    if( message == "lpa_capture" )
    {
        llMessageLinked( LINK_SET , frame , "cap", "root");
        ++frame;
        return TRUE;
    }
    if( message == "lpa_rwd" )
    {
        --frame;
        if( frame < 0) frame = 0;
        llMessageLinked( LINK_SET , frame , "rwd", "root");
        return TRUE;
    }
    if( message == "lpa_ff" )
    {
        ++frame;
        llMessageLinked( LINK_SET , frame , "ff", "root");
        return TRUE;
    }
    if( message == "lpa_reset" )
    {
        llMessageLinked( LINK_SET , frame , "reset", "root");
        return TRUE;
    }
    if( message == "lpa_done" )
    {
        max_frames = frame;
        llMessageLinked( LINK_SET , frame , "pb", "root");
        return 2;
    }
    return FALSE;
}


default
{
    state_entry()
    {
        owner = llGetOwner();
    }

    on_rez(integer param) {llResetScript();}

    //For Wizard
    link_message( integer send_number, integer num, string str, key id)
    {
        if( id == "wizard" && str == "setup" ) {
            state setup;
        }
    }
}

state setup
{
    state_entry()
    {
        find_modules();
        //Timeout for responses
        llSetTimerEvent( 4.0 );
        llMessageLinked( LINK_SET , 0 , "setup", "root");
        llOwnerSay("Setup Initiating...");
    }

    link_message( integer send_number, integer num, string str, key id)
    {
        if( str == "SYN")
        {
            llMessageLinked( send_number , 0 , "ACK", "root");
            llSetTimerEvent( 4.0 );
            if( llListFindList( animators , [send_number]) == -1)
                animators += send_number;
        }
    }
    timer()
    {
        llOwnerSay("Distributing Recording Scripts...");
        llSetTimerEvent(0.0);
        link_i = 0;
        link_len = llGetListLength(animators);
        state seed_links;
    }
}

state seed_links_loop {
    state_entry()
    {
        ++link_i;
        integer percent = (integer)((float)(link_i)/(float)link_len * 100.0);
        llOwnerSay((string)percent + "% Done");
        state seed_links;
    }
}
state seed_links {
    state_entry()
    {
        if( link_i >= link_len ) {
            llOwnerSay("Setup Complete.");
            llMessageLinked( LINK_SET , 0 , "end", "root");
            state record;
        }
        give_scripts(llList2Integer(animators,link_i),[]);
    }
    link_message( integer send_num , integer num, string str, key id) {
        if( num == link_scripts && send_num == llList2Integer(animators,link_i) ) { state seed_links_loop; }
    }
}

//
state record {
    state_entry() {
        frame = 0;
        uncheck_scripts();
    }
    //For Wizard
    link_message( integer send_number, integer num, string str, key id) {
        integer r;
        if( id == "wizard" ) {
            r = process_command(str,num);
            if(r == 2) {
                llMessageLinked( LINK_THIS , max_frames , "playback" , "root");
                state playback;
            }
            if(!r) ERROR("record","Unknown command " + str + " from wizard");
        }
    }
}

//Once the setup processes goes into playback mode, this script is no longer needed
state playback {
    state_entry() {
        remove_scripts();
        llSleep( 5.0 );
        llRemoveInventory(llGetScriptName());
    }
}
