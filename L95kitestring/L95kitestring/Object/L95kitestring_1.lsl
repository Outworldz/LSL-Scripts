// :CATEGORY:Kites
// :NAME:L95kitestring
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:446
// :NUM:602
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L9.05-kite-string.lsl
// :CODE:

// Copyright (c) 2008, Scripting Your World
// All rights reserved.
//
// Scripting Your World
// By Dana Moore, Michael Thome, and Dr. Karen Zita Haigh
// http://syw.fabulo.us
// http://www.amazon.com/Scripting-Your-World-Official-Second/dp/0470339837/
//
// You are permitted to use, share, and adapt this code under the 
// terms of the Creative Commons Public License described in full
// at http://creativecommons.org/licenses/by/3.0/legalcode.
// That means you must keep the credits, do nothing to damage our
// reputation, and do not suggest that we endorse you or your work.

// Listing 9.5: The Kite String
string SPOOL_REZZED = "SpoolRezzed";

makeString(key targetID) {
    // Based on Listing B.1. Unchanged values removed to save trees
    integer FollowSrcMask      = TRUE; // move with emitter
    integer FollowVelocityMask = TRUE; // turn to face
    integer WindMask           = TRUE; // let wind blow string
    integer TargetPosMask      = TRUE; // head to the spool
    integer ScaleMask          = TRUE; // grow
    llParticleSystem([
        PSYS_PART_FLAGS, ( 
              (           WindMask * PSYS_PART_WIND_MASK ) | 
              (      FollowSrcMask * PSYS_PART_FOLLOW_SRC_MASK ) | 
              ( FollowVelocityMask * PSYS_PART_FOLLOW_VELOCITY_MASK ) |
              (          ScaleMask * PSYS_PART_INTERP_SCALE_MASK ) |
              (      TargetPosMask * PSYS_PART_TARGET_POS_MASK ) ),
     //Appearance
        PSYS_PART_START_SCALE,  < 0.04, 0.2, 0.0>,   // <1,1,0>
        PSYS_PART_END_SCALE,    < 0.04, 1.00, 0.0>,  // <1,1,0>
        PSYS_PART_END_ALPHA,    1.0,                 // 0.0
    //Flow
        PSYS_PART_MAX_AGE,         5.00,   // 10.0
        PSYS_SRC_BURST_RATE,       0.05,   // 0.10
        PSYS_SRC_BURST_PART_COUNT, 1,      // 1
    //Placement
        PSYS_SRC_PATTERN,      PSYS_SRC_PATTERN_ANGLE, // DROP
    //Movement
        PSYS_SRC_BURST_SPEED_MIN, 1.00,      // 1.0
        PSYS_SRC_BURST_SPEED_MAX, 1.00,      // 10.0
        PSYS_SRC_TARGET_KEY,      targetID   // llGetKey()
    ]);
}
default
{
    state_entry() { 
        llParticleSystem([]);
    }
    on_rez(integer param) {
        llResetScript();
    }
    link_message(integer sender,integer num, string str, key id) {
        if (str==SPOOL_REZZED) {
            makeString( id );
        } else {
            llParticleSystem([]);
        }
    }
}
// END //
