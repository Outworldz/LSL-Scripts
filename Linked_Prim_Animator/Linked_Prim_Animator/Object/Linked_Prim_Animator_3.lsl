// :CATEGORY:Prim
// :NAME:Linked_Prim_Animator
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:31:14.597
// :EDITED:2013-09-18 15:38:56
// :ID:474
// :NUM:637
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Example replay Script
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
//	Linked Prim Animator Lite - Replay Script
//	Author: Falados Kapuskas
//	Version: 0.2
//	Date: 12/03/2007
//	Description:
//	  Example replay script

//Channel for chatting
integer BOOMERANG_STATUS = FALSE;
integer LOOP_STATUS = TRUE;
integer OPERATION_CHANNEL = 55;
//Owner Key
key owner;

//This is a very basic script that shows how to use the LPA Protocol in
//Custom scripts for custom playback
default
{
    on_rez(integer p) { llResetScript(); }
    state_entry()
    {
        owner = llGetOwner();
    }
    touch_start(integer n)
    {
        if(llDetectedKey(0) == owner) {
            state testing;
        }
    }
}

state testing_loop { state_entry() { state testing; } }
state testing {
    state_entry() {
        list btn = ["Quit","Play","Pause","Backwards","Forwards","Speed Up","Speed Down"];
        if(BOOMERANG_STATUS) btn += ["[X] Boomerang"];
        else				 btn += ["[ ] Boomerang"];
        if(LOOP_STATUS)	  btn += ["[X] Loop"];
        else				 btn += ["[ ] Loop"];
        llDialog(owner,"Play your animation...",btn,-56);
        llListen( -56, "", owner, "");
        llListen( OPERATION_CHANNEL, "", owner, "lpa_lost");
    }
    listen( integer channel, string name, key id, string msg ) {
        if( msg == "lpa_lost") {state testing_loop;};
        if( msg == "Play" ) {
            llMessageLinked(LINK_THIS, 0, "lpa_start", "wizard");
        }
        if( msg == "Pause" ) {
            llMessageLinked(LINK_THIS, 0, "lpa_stop", "wizard");
        }
        if( msg == "Backwards" ) {
            llMessageLinked(LINK_THIS, 0, "lpa_back", "wizard");
        }
        if( msg == "Forwards" ) {
            llMessageLinked(LINK_THIS, 0, "lpa_fwd", "wizard");
        }
        if( msg == "Speed Up" ) {
            llMessageLinked(LINK_THIS, 0, "lpa_sdn", "wizard");
        }
        if( msg == "Speed Down" ) {
            llMessageLinked(LINK_THIS, 0, "lpa_sup", "wizard");
        }
        if( msg == "[X] Boomerang" || msg == "[ ] Boomerang" ) {
            string b = "lpa_brang";
            BOOMERANG_STATUS = !BOOMERANG_STATUS;
            if(BOOMERANG_STATUS) b += " on";
            else b += " off";
            llMessageLinked(LINK_THIS, 0, b, "wizard");
        }
        if( msg == "[X] Loop" || msg == "[ ] Loop" ) {
            string b = "lpa_loop";
            LOOP_STATUS = !LOOP_STATUS;
            if(LOOP_STATUS) b += " on";
            else b += " off";
            llMessageLinked(LINK_THIS, 0, b, "wizard");
        }
        if( msg == "Quit" ) {
            state default;
        }
        state testing_loop;
    }
}
