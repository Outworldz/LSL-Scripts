// :CATEGORY:Water
// :NAME:L6a3splash
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:436
// :NUM:592
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L6a.3-splash.lsl
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

// Listing 6a.3: Turbulent Waters
splash() {
    integer InterpColorMask    = TRUE;
    integer InterpScaleMask    = TRUE;
    integer EmissiveMask       = TRUE;
    integer FollowSrcMask      = FALSE;
    integer FollowVelocityMask = TRUE;
    integer WindMask           = TRUE;
    integer BounceMask         = TRUE;
    integer TargetPosMask      = FALSE;
    integer TargetLinearMask   = FALSE;
    llParticleSystem([
        PSYS_PART_FLAGS, ( 
                (       EmissiveMask * PSYS_PART_EMISSIVE_MASK ) | 
                (         BounceMask * PSYS_PART_BOUNCE_MASK ) | 
                (    InterpColorMask * PSYS_PART_INTERP_COLOR_MASK ) | 
                (    InterpScaleMask * PSYS_PART_INTERP_SCALE_MASK ) | 
                (           WindMask * PSYS_PART_WIND_MASK ) | 
                (      FollowSrcMask * PSYS_PART_FOLLOW_SRC_MASK ) | 
                ( FollowVelocityMask * PSYS_PART_FOLLOW_VELOCITY_MASK ) | 
                (   TargetLinearMask * PSYS_PART_TARGET_LINEAR_MASK ) | 
                (      TargetPosMask * PSYS_PART_TARGET_POS_MASK ) ),
     //Appearance
        PSYS_PART_START_SCALE,  < 0.25, 0.25, 0.0>,  // <1,1,0>
        
        // you can have end scale vary from really small to
        // really large, for different effects. Usually a value larger
        // than the start scale makes it appear more "misty"
        PSYS_PART_END_SCALE,    < 1.00, 1.00, 1.0>,  // <1,1,0>
        PSYS_PART_START_COLOR,  < 0.9, 0.9, 1.0 >,   // <1,1,1>
        PSYS_PART_END_COLOR,    < 1.0, 1.0, 1.0 >,   // <1,1,1>
        PSYS_PART_START_ALPHA,  0.5,                 // 1.0
        PSYS_PART_END_ALPHA,    0.0,                 // 0.0
        
        // Water Particle 3 is in the Library
        PSYS_SRC_TEXTURE,       "Water Particle 3",  // ""
    //Flow
        PSYS_SRC_MAX_AGE,          0.0,    // 0.0
        PSYS_PART_MAX_AGE,         3.00,   // 10.0
        PSYS_SRC_BURST_RATE,       0.10,   // 0.10
        
        // range from about 1 for a smaller splash to 16 or so for a big one
        PSYS_SRC_BURST_PART_COUNT, 16,     // 1
    //Placement
        PSYS_SRC_PATTERN,      PSYS_SRC_PATTERN_ANGLE_CONE, // DROP
        PSYS_SRC_BURST_RADIUS, 1.00,       // 0.0
        PSYS_SRC_ANGLE_BEGIN,  0.00,       // 0.0
        PSYS_SRC_ANGLE_END,    0.65,       // 0.0
        PSYS_SRC_OMEGA,        < 0.00, 0.00, 0.00 >,
    //Movement
        PSYS_SRC_BURST_SPEED_MIN, 0.00,      // 1.0
        PSYS_SRC_BURST_SPEED_MAX, 0.01,      // 10.0
        PSYS_SRC_ACCEL,           < 0.0, 0.0, -2.0 >, // <0,0,0>
        PSYS_SRC_TARGET_KEY,      llGetKey() // ignored because TARGET_POS is false
    ]);
}
default {
    state_entry() {
         splash();
    }
}
// END //
