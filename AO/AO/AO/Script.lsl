// :CATEGORY:AO
// :NAME:AO
// :AUTHOR:Francis Chung
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:47
// :ID:46
// :NUM:64
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Animation Overrider
// :CODE:


// Francis wuz here
// For tech support, please contact one of our generous volounteers:
// Support Help:
//  Second Life: Gwyneth Llewelyn
//     Email:       gwyneth.llewelyn@secondlife.game-host.org
//     MSN:         gwyneth.llewelyn@secondlife.game-host.org
//     Yahoo:       gwyneth_llewelyn
//  Second Life: Ulrika Zugzwang

// Franimation Overrider v1.5
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


// Special thanks to Gwyneth Llewyn and Kex Godel for their technical
// suggestions and contributions, as well as their heroic documentation
// efforts.

// I would also like to take the time here to recognize Archanox Underthorn
// as the creator of the original animation override.

// Mods to fix Opensim Crap by Fred Beckhusen (Ferd Frederix)



// CONSTANTS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Default notecard we read on script_entry
integer debug = TRUE;
string defaultNoteCard = "Animation Notecard";

// Instruction notecard
string instructionNoteCard = "Manual";

// Anything we hear through a listen() even will be relayed on this linkmessage channel
integer listenRelay = 0x80000000;

// List of all the animation states
list animState = ["Sitting on Ground", "Sitting", "Striding", "Crouching", "CrouchWalking",
                  "Soft Landing", "Standing Up", "Falling Down", "Hovering Down", "Hovering Up",
                  "FlyingSlow", "Flying", "Hovering", "Jumping", "PreJumping", "Running",
                  "Turning Right", "Turning Left", "Walking", "Landing", "Standing" ];

// Animations in which we automatically disable animation overriding
// Try to keep this list short, the longer it is the worse it affects our runtime
// (Note: This is *almost* constant. We have to type-convert this to keys instead of strings
// on initialization - blargh)
list autoDisableList ;


// Index of interesting animations
integer noAnimIndex     = -1;
integer standIndex      = 20;
integer sittingIndex    = 1;
integer sitgroundIndex  = 0;
integer hoverIndex      = 12;
integer flyingIndex     = 11;
integer flyingslowIndex = 10;
integer hoverupIndex    = 9;
integer hoverdownIndex  = 8;
integer waterTreadIndex = 25;
integer swimmingIndex   = 26;
integer swimupIndex     = 27;
integer swimdownIndex   = 28;
integer standingupIndex = 6;

// list of animations that have a different value when underwater
list underwaterAnim ;

// corresponding list of animations that we override the overrider with when underwater
list underwaterOverride ;

// list of animation states that we need to stop the default animations for
//list stopAnimState = [ "Sitting" ];
list stopAnimState = [ ];

// corresponding list of animations to stop when entering that state
//list stopAnimName  = [ "sit" ];
list stopAnimName  = [ ];

// Lines in the notecards where to grab animation names
// This list is indexed the same as list overrides
list lineNums = [ 45, // 0  Sitting on Ground
                  33, // 1  Sitting
                   1, // 2  Striding
                  17, // 3  Crouching
                   5, // 4  CrouchWalking
                  39, // 5  Soft Landing
                  41, // 6  Standing Up
                  37, // 7  Falling Down
                  19, // 8  Hovering Down
                  15, // 9  Hovering Up
                  43, // 10 FlyingSlow
                   7, // 11 Flying
                  31, // 12 Hovering
                  13, // 13 Jumping
                  35, // 14 PreJumping
                   3, // 15 Running
                  11, // 16 Turning Right
                   9, // 17 Turning Left
                   1, // 18 Walking
                  39, // 19 Landing
                  21, // 20 Standing 1
                  23, // 21 Standing 2
                  25, // 22 Standing 3
                  27, // 23 Standing 4
                  29, // 24 Standing 5
                  47, // 25 Treading Water
                  49, // 26 Swimming
                  51, // 27 Swim up
                  43  // 28 Swim Down
                ];

// This is an ugly hack, because the standing up animation doesn't work quite right
// (SL is borked, this has been bug reported)
// If you play a pose overtop the standing up animation, your avatar tends to get
// stuck in place.
// This is a list of anims that we'll stop automatically
list autoStop = [ 5, 6, 19 ];
// Amount of time we'll wait before autostopping the animation (set to 0 to turn off autostopping )
float autoStopTime = 1.5;

// List of stands                      
list standIndexes = [ 20, 21, 22, 23, 24 ];

// How long before flipping stand animations
float standTimeDefault = 40.0;

// Command prefixes we accept                
list loadCmd = [ "animset ", "/animset " ];
list animCmd = [ "ao ", "/ao " ];

// How fast we should poll for changed anims (as fast as possible)
// In practice, you will not poll more than 8 times a second.
float timerEventLength = 0.001;

// The key for the typing animation
key typingAnim = "c541c47f-e0c0-058b-ad1a-d6ae3a4584d9";

// Kex likes the following behaviour:
//  - When you switch to a standing pose, start again from the beginning of the stand list
//  - when you switch to a standing pose, don't override with an animation for 5 seconds
integer kexMode = FALSE;
float kexTime = 5;

// Send a message if we encounter a state we've never seen before
integer DEBUG = FALSE;

// GLOBALS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

list stands = [ "", "", "", "", "" ];          // List of stand animations
integer curStandIndex = 0;                     // Current stand we're on (indexed [0, numStands])
string curStandAnim = "";                      // Current Stand animation
integer numStands;                             // # of stand anims we use (constant: ListLength(stands))
integer curStandAnimIndex = 0;                 // Current stand we're on (indexed [0, numOverrides] )

list overrides = [];                           // List of animations we override
list notecardLineKey = [];                     // notecard reading keys
integer notecardLinesRead;                     // number of notecard lines read
integer numOverrides;                          // # of overrides (a constant - llGetListLength(lineNums))

string  lastAnim = "";                         // last Animation we ever played
integer lastAnimIndex = 0;                     // index of the last animation we ever played
string  lastAnimState = "";                    // last thing llGetAnimation() returned

float standTime ;            // How long before flipping stand animations

integer animOverrideOn = TRUE;                 // Is the animation override on?
integer gotPermission  = FALSE;                // Do we have animation permissions?

integer listenHandler0;                        // Listen handlers
integer listenHandler1;

string stopLeftOverAnim = "";                  // Hack to get around LSL goofiness

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// This would be totally unecessary if we had arrays
// _source[_index] = newEntry
list listReplace ( list _source, list _newEntry, integer _index ) {
    return llListInsertList( llDeleteSubList(_source,_index,_index), _newEntry, _index );
}

// Find if two lists/sets share any elements in common
integer hasIntersection( list list1, list list2 ) {
    list bigList;
    list smallList;
    integer smallListLength; 
    integer i;

    if (  llGetListLength( list1 ) <= llGetListLength( list2 ) ) {
        smallList = list1;
        bigList = list2;
    }
    else {
        bigList = list1;
        smallList = list2;
    }
    smallListLength = llGetListLength( smallList );
    
    for ( i=0; i<smallListLength; i++ ) {
        if ( llListFindList( bigList, llList2List(smallList,i,i) ) != -1 ) {
            return TRUE;
        }
    }
    
    return FALSE;
}

startAnimationList( string csvAnims ) {
    list anims = llCSV2List( csvAnims );
    integer numAnims = llGetListLength( anims );
    integer i;
    for( i=0; i<numAnims; i++ )
    {
        llStartAnimation( llList2String(anims,i) );
        if (debug) llOwnerSay(llList2String(anims,i) );
    }
}

stopAnimationList( string csvAnims ) {
    list anims = llCSV2List( csvAnims );
    integer numAnims = llGetListLength( anims );
    integer i;
    for( i=0; i<numAnims; i++ ) {
         if (debug) llOwnerSay("stop " + llList2String(anims,i) );
        llStopAnimation( llList2String(anims,i) );
    }
} 

startNewAnimation( string _anim, integer _animIndex, string _state ) {
    if ( _anim != lastAnim ) {
        
        if ( _anim != "" ) {   // Time to play a new animation
            startAnimationList( _anim );
            
            if ( _state != lastAnimState && llListFindList(stopAnimState, [_state]) != -1 ) {
                // Stop the default sit/sit ground animation
                llStopAnimation( llList2String(stopAnimName, llListFindList(stopAnimState, [_state])) );
                 if (debug) llOwnerSay( "stop " + llList2String(stopAnimName, llListFindList(stopAnimState, [_state])) );
            } 
            else if ( llListFindList( autoStop, [_animIndex] ) != -1 ) {
                // This is an ugly hack, because the standing up animation doesn't work quite right
                // (SL is borked, this has been bug reported)
                // If you play a pose overtop the standing up animation, your avatar tends to get
                // stuck in place.
                if ( lastAnim != "" ) {
                    stopAnimationList( lastAnim );
                    lastAnim = "";
                }
                llSleep( autoStopTime );
                stopAnimationList( _anim );
            }
        }
        if ( lastAnim != "" )
            stopAnimationList( lastAnim );
        lastAnim = _anim;
    }
    lastAnimIndex = _animIndex;
    lastAnimState = _state;
}

// Load all the animation names from a notecard
loadNoteCard( string _notecard ) {
    integer i;
    
    if ( llGetInventoryKey(_notecard) == NULL_KEY ) {
        llSay( 0, "Notecard '" + _notecard + "' does not exist." );
        return;
    }

    llInstantMessage( llGetOwner(), "Loading notecard '" + _notecard + "'..." );
    // Start reading the data
    notecardLinesRead = 0;
    notecardLineKey = [];
    for ( i=0; i<numOverrides; i++ )
        notecardLineKey += [ llGetNotecardLine( _notecard, llList2Integer(lineNums,i) ) ];
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

// Figure out what animation we should be playing right now
animOverride() {
    string  curAnimState = llGetAnimation(llGetOwner());
    integer curAnimIndex;
    integer underwaterAnimIndex;
    vector  curPos;
    
    // Hack, because, SL really likes to switch between crouch and crouchwalking for no reason
    if ( curAnimState == "CrouchWalking" ) {
        if ( llVecMag(llGetVel()) < .5 )
            curAnimState = "Crouching";
    }
    
    if ( curAnimState == lastAnimState ) {
        // This conditional not absolutely necessary (In fact it's better if it's not here)
        // But it's good for increasing performance.
        // One of the drawbacks of this performance hack is the underwater animations
        // If you fly up, it will keep playing the "swim up" animation even after you've
        // left the water.
        return;
    }
    
    curAnimIndex        = llListFindList( animState, [curAnimState] );
    underwaterAnimIndex = llListFindList( underwaterAnim, [curAnimIndex] );
    curPos              = llGetPos();

    if ( curAnimIndex == -1 ) {
        if ( DEBUG )
            llInstantMessage( llGetOwner(), "Unknown animation state '" + curAnimState + "'" );
    }
    else if ( curAnimIndex == standIndex ) {
        if ( kexMode ) {
            if ( lastAnimIndex != standIndex ) {
                resetStand();
                standTime = kexTime;
            }
        }
        startNewAnimation( curStandAnim, curStandAnimIndex, curAnimState );
    }
    else {
        if ( underwaterAnimIndex != -1 && llWater(ZERO_VECTOR) > curPos.z )
            curAnimIndex = llList2Integer( underwaterOverride, underwaterAnimIndex );
        startNewAnimation( llList2String(overrides,curAnimIndex), curAnimIndex, curAnimState );
    }
}

// For kexMode
// Reset to a non-override (last index)
resetStand() {
   curStandIndex = numStands - 1;
   curStandAnimIndex = llList2Integer(standIndexes,curStandIndex);
   curStandAnim = "";
   llResetTime();
}


// Switch to the next stand anim
doNextStand() {
    if ( kexMode ) {
       // Make sure we reset to a reasonable stand time
       standTime = standTimeDefault;
    }
    curStandIndex = (curStandIndex+1) % numStands;
    curStandAnimIndex = llList2Integer(standIndexes,curStandIndex);
    curStandAnim = llList2String(overrides, curStandAnimIndex);
    if ( lastAnimState == "Standing" )
        startNewAnimation( curStandAnim, curStandAnimIndex, lastAnimState );
    llResetTime();
}

// Returns true if we should override the current animation
integer shouldOverride() {
    if ( animOverrideOn && gotPermission ) {
        // Check if we should explicitly NOT override a playing animation
        if ( hasIntersection( autoDisableList, llGetAnimationList(llGetOwner()) ) ) {
            startNewAnimation( "", noAnimIndex, "" );
            return FALSE;
        }
        return TRUE;
    }
    return FALSE;
}

// Initialize listeners, and reset some status variables
initialize() {
    if ( animOverrideOn )
        llSetTimerEvent( timerEventLength );
    else
        llSetTimerEvent( 0 );

    // Stop this animation after we regain animation permissions
    // LSL can be a bit gooofy, because you can teleport somewhere, and have animation permissions
    // on arrival. Not entirely sure if this is by design, or what, but I'll use a conservative
    // work-around to this issue.
    stopLeftOverAnim = lastAnim;

    lastAnim = "";
    lastAnimIndex = noAnimIndex;
    lastAnimState = "";
    gotPermission = FALSE;
    
    if ( listenHandler0 )
        llListenRemove( listenHandler0 );
    listenHandler0 = llListen( 0, "", llGetOwner(), "" );
    if ( listenHandler1 )
        llListenRemove( listenHandler1 );
    listenHandler1 = llListen( 1, "", llGetOwner(), "" );
    
    llInstantMessage( llGetOwner(), (string) llGetFreeMemory() + " bytes free" );
}

// STATE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

default {
    state_entry() {
        
        standTime = standTimeDefault;
        underwaterAnim = [ hoverIndex, flyingIndex, flyingslowIndex, hoverupIndex, hoverdownIndex ];
        underwaterOverride = [ waterTreadIndex, swimmingIndex, swimmingIndex, swimupIndex, swimdownIndex];
         autoDisableList = [
    "3147d815-6338-b932-f011-16b56d9ac18b", // aim_R_handgun
    "ea633413-8006-180a-c3ba-96dd1d756720", // aim_R_rifle
    "b5b4a67d-0aee-30d2-72cd-77b333e932ef", // aim_R_bazooka
    "46bb4359-de38-4ed8-6a22-f1f52fe8f506", // aim_l_bow
    "9a728b41-4ba0-4729-4db7-14bc3d3df741", // Launa's hug
    "f3300ad9-3462-1d07-2044-0fef80062da0", // punch_L
    "c8e42d32-7310-6906-c903-cab5d4a34656", // punch_r
    "85428680-6bf9-3e64-b489-6f81087c24bd", // sword_strike_R
    "eefc79be-daae-a239-8c04-890f5d23654a"  // punch_onetwo
];

        
        integer i;

        if ( llGetAttached() )
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS);
            
        // Initialize!
        numStands = llGetListLength( stands );
        numOverrides = llGetListLength(lineNums);
        curStandAnimIndex = llList2Integer(standIndexes,curStandIndex);

        // Type convert strings to keys :P
        for ( i=0; i<llGetListLength(autoDisableList); i++ ) {
            key k = llList2Key( autoDisableList, i );
            autoDisableList = listReplace ( autoDisableList, [ k ], i );
        }

        // populate override list with blanks
        for ( i=0; i<numOverrides; i++ ) {
            overrides += [ "" ];
        }
        initialize();
        loadNoteCard( defaultNoteCard );
        
        // turn off the auto-stop anim hack
        if ( autoStopTime == 0 )
            autoStop = [];
            
        llResetTime();
    }
    
    run_time_permissions(integer _parm) {
        if( _parm == (PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS) ) {
            llTakeControls( CONTROL_DOWN|CONTROL_UP|CONTROL_FWD|CONTROL_BACK|CONTROL_LEFT|CONTROL_RIGHT
                            |CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT, TRUE, TRUE);
            gotPermission = TRUE;
            if ( stopLeftOverAnim != "" )
                stopAnimationList( stopLeftOverAnim );
        }
    }
    
    attach( key _k ) {
        if ( _k != NULL_KEY )
            llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS);
    }
    
    listen( integer _channel, string _name, key _id,string _message ) {
        string match;
        
        // Send a link message to all other scripts, so they don't have to use a listen
        llMessageLinked( LINK_SET, listenRelay, _message, _id );
        
        match = checkMatch( _message, loadCmd );
        if( match != "" )
            loadNoteCard( match );
        match = checkMatch( _message, animCmd );
        if( match == "on" ) {
            llSetTimerEvent( timerEventLength );
            animOverrideOn = TRUE;
            if ( gotPermission )
                animOverride();
            llInstantMessage( llGetOwner(), "Franimation override on." );
        }
        else if ( match == "off" ) {
            llSetTimerEvent( 0 );
            animOverrideOn = FALSE;
            startNewAnimation( "", noAnimIndex, lastAnimState );
            llInstantMessage( llGetOwner(), "Franimation override off." );
        }
        else if ( match == "hide" ) {
            llSetLinkAlpha( LINK_SET, 0, ALL_SIDES );
            llInstantMessage( llGetOwner(), "Franimation override set invisible." );
        }
        else if ( match == "show" ) {
            llSetLinkAlpha( LINK_SET, 1, ALL_SIDES );
            llInstantMessage( llGetOwner(), "Franimation override set visible." );
        }
        else if ( match == "nextstand" ) {
            if ( animOverrideOn && gotPermission )
                doNextStand();
        }
        else if ( match == "reset" ) {
            llResetScript();
        }
    }
    
    dataserver( key _query_id, string _data ) {
        integer index = llListFindList( notecardLineKey, [_query_id] );
        if ( _data != EOF && index != -1 ) {    // not at the end of the notecard and not random crap
            if ( index == curStandAnimIndex )   // Pull in the current stand animation
                curStandAnim = _data;
                
            // Whoops, we're replacing the currently playing anim                
            if ( animOverrideOn && gotPermission && index == lastAnimIndex )  {
                integer stopAnim;

                // Better play the new one :)
                startNewAnimation( _data, lastAnimIndex, lastAnimState );

                // If we're not override an animation we've explicitly stopped, we
                // had better replay the explicitly stopped animation
                if ( _data != "" ) {
                    stopAnim = llListFindList( stopAnimState, [ lastAnimState ] );
                    if ( stopAnim != -1 )
                    {
                        if (debug) llOwnerSay(llList2String(stopAnimName,stopAnim) );
                        llStartAnimation( llList2String(stopAnimName, stopAnim) );
                    }
                }
            }

            // Store the name of the new animation
            overrides = listReplace( overrides, [_data], index );
            
            // See if we're done loading the notecard. Users like status messages.
            if ( ++notecardLinesRead == numOverrides )
                llInstantMessage( llGetOwner(), "Finished reading notecard. (" +
                                  (string) llGetFreeMemory() + " bytes free)" );
        }
    }
    
    on_rez( integer _code ) {
        initialize();
    }

    control( key _id, integer _level, integer _edge ) {
        if ( shouldOverride() )
            animOverride();
    }

    touch_start( integer _num ) {
        llGiveInventory( llDetectedKey(0), instructionNoteCard );
    }

    timer() {
        if ( shouldOverride() ) {
            animOverride();

            // Is it time to switch stand animations?
            if ( llGetTime() > standTime ) {
                // Don't interupt the typing animation with a stand change
                if ( llListFindList(llGetAnimationList(llGetOwner()), [typingAnim]) == -1 )
                    doNextStand();
            }
        }
    }
}

