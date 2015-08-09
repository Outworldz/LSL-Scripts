// :CATEGORY:AO
// :NAME:Franimation_Overrider
// :AUTHOR:Amanda Vanness
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:337
// :NUM:454
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Manual Animation script - add to the same prim as the other scripts and notecards
// :CODE:
// Manual Animation Script
// Copyright (C) 2004 Francis Chung
//
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


integer VERBOSE = 1;
integer listenRelay = 0x80000000;

integer gotPermission = 0;

// Stop all active animations
stopAllAnimations() {
    integer i;
    list animList;
    
    if ( VERBOSE > 1 )
        llInstantMessage( llGetPermissionsKey(), "Stopping Animations...." );

    animList = llGetAnimationList( llGetPermissionsKey() );
    for ( i=0; i < llGetListLength(animList); i++) {
        if ( llList2Key(animList,i) != NULL_KEY ) {
            llStopAnimation( llList2String(animList,i) );  
            if ( VERBOSE > 1 )
                llInstantMessage( llGetOwner(), "Stopping " + llList2String(animList,i) );
        }
    }
    
    if ( VERBOSE > 0 )
        llInstantMessage( llGetPermissionsKey(), "Stopping Animations....Done" );
}

// Check if any of the list of elements causes a prefix match. If they do, return argv[1], otherwise ""
// Used for parsing verbal commands
string checkMatch( string str, list prefixes  ) {
    integer numElements = llGetListLength( prefixes );
    integer i;
    integer lastChar;
    string curPrefix;
    string curStr = llToLower( str );

    // Check against all the list to see if the prefix (argv[0]) matches
    for( i=0; i<numElements; i++ ) {
        curPrefix = llList2String(prefixes, i);
        lastChar = llStringLength( curPrefix ) - 1;
        if ( llGetSubString(curStr, 0, lastChar) == curPrefix )
           return llGetSubString( str, lastChar+1, llStringLength(str) );
    }
    return "";
}


default {
    state_entry()     {
       if ( llGetAttached() )
          llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
    }

    run_time_permissions(integer parm) {
        if( parm == PERMISSION_TRIGGER_ANIMATION )
            gotPermission = 1;
        else
            gotPermission = 0;
    }

    on_rez(integer st) {
        llResetScript();
    }
    
    link_message( integer _sender, integer _channel, string _message, key _k ) {
        if ( _channel == listenRelay && gotPermission ) {
            string match;
            
            match = checkMatch( _message, ["/anim ", "anim "] );
            if ( match != "" )
                llStartAnimation( match );
                
            match = checkMatch( _message, ["/noanim ", "noanim "] );
            if ( match == "all" )
                stopAllAnimations();
            else if ( match != "" )
                llStopAnimation( match );
        }
    }
}
