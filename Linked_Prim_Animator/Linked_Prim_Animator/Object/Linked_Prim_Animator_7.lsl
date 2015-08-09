// :CATEGORY:Prim
// :NAME:Linked_Prim_Animator
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:31:14.597
// :EDITED:2013-09-18 15:38:56
// :ID:474
// :NUM:641
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// LPA Frame Controller
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
//	Linked Prim Animator Lite - Frame Controller
//	Author: Falados Kapuskas
//	Version: 0.7
//	Date: 12/27/2007
//	Description:
//	  Sets up linked prims for accepting modules

//----- CONSTANTS -----//
integer SCRIPT_PIN = 3014;	//This pin is set on the prim
string MODULE_PREFIX = "LPAL Frame Capture";

//----- GLOBAL VARIABLES -----//
string scripts;			//During resume, the existing scripts are recorded here

default
{
    on_rez(integer param) {llResetScript(); }
    state_entry() {llSetRemoteScriptAccessPin( 0 ); }
    link_message( integer sender_num, integer num, string str, key id )
    {
        if( id == "root") {
            if( str == "setup") {
                //Respond to the setup request
                llSetRemoteScriptAccessPin( SCRIPT_PIN );
                llMessageLinked( LINK_ROOT , 0 , "SYN", "link");
                llSetTimerEvent(5.0);
            }
            if( str == "ACK" ) {
                //Response received! Accept scripts.
                llSetTimerEvent(0.0);
                state receive;
            }
        }
    }
    timer() { //Keep trying until a response is heard
        llMessageLinked( LINK_ROOT , 0 , "SYN", "link");
        llSetTimerEvent(5.0);
    }
}

state receive {
    changed(integer change) {
        if( change & CHANGED_INVENTORY ) {
            integer len = llGetInventoryNumber(INVENTORY_SCRIPT);
            integer i;
            integer num = 0;
            for( i = 0; i < len; ++i) {
                if( llSubStringIndex(llGetInventoryName(INVENTORY_SCRIPT,i),MODULE_PREFIX) != -1 ) ++num;
            }
            llMessageLinked(LINK_ROOT,num,"","link");
        }
    }
    link_message( integer sender_num, integer num, string str, key id )
    {
        if( id == "root" && str == "end") {
            llSetRemoteScriptAccessPin( 0 );
            llRemoveInventory(llGetScriptName());
        }
    }
}
