// :CATEGORY:Prim
// :NAME:Linked_Prim_Animator
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:31:14.597
// :EDITED:2013-09-18 15:38:56
// :ID:474
// :NUM:639
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// LPA Player
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
//	Linked Prim Animator Lite - Player
//	Author: Falados Kapuskas
//	Version: 0.5
//	Date: 12/09/2007
//	Description:
//	  Controls playback of pre-recorded animation

//CONSTANT VALUES
integer OPERATION_CHANNEL = 55;	//Channel for which all chat commands are announced
float PLAYBACK_SPEED = 0.5;	 //Delay time between frames

//GLOBAL VARIABLES
integer frame;			//Current frame
integer max_frames;		//Last frame
integer direction;		//Animation play direction
integer brang = FALSE;		//Boomerange loop (Back and forth)
integer loop = TRUE;		//Loop animation
float CURRENT_PLAYBACK;		//Current playback speed
integer listen_handle;		//Handle to listen id
key owner;			//Owner of the object



//Function:	process_command
//Description:	Will process a command and return the frame that
//		the playback speed
float process_command(string msg) {
    if( msg == "lpa_back" ) {
        if( direction != -1) {
            direction = -1;
            llMessageLinked( LINK_THIS , direction , "direction" , "player");
            return CURRENT_PLAYBACK;
        }
    }
    if( msg == "lpa_sup" ) {
        PLAYBACK_SPEED += 0.1;
        llMessageLinked( LINK_THIS , (integer)(PLAYBACK_SPEED*10) , "play" , "player");
        return PLAYBACK_SPEED;
    }
    if( msg == "lpa_sdn" ) {
        PLAYBACK_SPEED -= 0.1;
        if( PLAYBACK_SPEED <= 0.2 ) {
            PLAYBACK_SPEED = 0.2;
        }
        llMessageLinked( LINK_THIS , (integer)(PLAYBACK_SPEED*10) , "play" , "player");
        return PLAYBACK_SPEED;
    }
    if( msg == "lpa_fwd" ) {
        if( direction != 1) {
            direction = 1;
            llMessageLinked( LINK_THIS , direction , "direction" , "player");
            return CURRENT_PLAYBACK;
        }
    }
    if( msg == "lpa_stop" ) {
        llMessageLinked( LINK_THIS , 0 , "play" , "player");
        return 0.0;
    }
    if( msg == "lpa_brang on" ) {
        brang = TRUE;
        llMessageLinked( LINK_THIS , brang , "brang" , "player");
        return CURRENT_PLAYBACK;
    }
    if( msg == "lpa_brang off" ) {
        brang = FALSE;
        llMessageLinked( LINK_THIS , brang , "brang" , "player");
        return CURRENT_PLAYBACK;
    }
    if( msg == "lpa_loop on" ) {
        loop = TRUE;
        llMessageLinked( LINK_THIS , loop , "loop" , "player");
        return CURRENT_PLAYBACK;
    }
    if( msg == "lpa_loop off" ) {
        loop = FALSE;
        llMessageLinked( LINK_THIS , loop , "loop" , "player");
        return CURRENT_PLAYBACK;
    }
    if( msg == "lpa_start" ) {
        frame = 0;
        llMessageLinked( LINK_THIS , (integer)(PLAYBACK_SPEED*10) , "play" , "player");
        return PLAYBACK_SPEED;
    }
    return CURRENT_PLAYBACK;
}

default {
    on_rez(integer param) {	llResetScript(); }
    state_entry() {
        owner = llGetOwner();
    }

    link_message(integer send_num, integer num, string str, key id)	 {
        if(id == "root")
        {
            if( str == "playback")
            {
                max_frames = num;
                state playback;
            }
        }
    }
}

state playback {
    state_entry() {
        direction = 1;
        llSetTimerEvent(0.0);
    }

    on_rez( integer parm ) {
        llSetTimerEvent(CURRENT_PLAYBACK);
    }

    //For Wizard
    link_message( integer send_number, integer num, string str, key id) {
        if( id == "wizard" ) {
            CURRENT_PLAYBACK = process_command(str);
            llSetTimerEvent(CURRENT_PLAYBACK);
        }
    }

    timer() {
        llSetTimerEvent( PLAYBACK_SPEED );
        frame += direction;
        if( frame > max_frames ) {
            frame = max_frames;
            if(!loop) {
                if(!brang || direction == -1) llSetTimerEvent(0.0);
            }
            if(brang) direction *= -1;
            else if(loop) frame = 0;
        }
        if( frame < 0 ) {
            frame = 0;
            if(!loop) {
                if(!brang || direction == -1) llSetTimerEvent(0.0);
            }
            if(brang) direction *= -1;
            else if(loop) frame = max_frames;
        }
        llMessageLinked( LINK_SET , frame , "frame", "player");
    }
}
