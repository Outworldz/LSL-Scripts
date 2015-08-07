// :CATEGORY:Fireworks
// :NAME:L91fireworksred
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:440
// :NUM:596
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L9.01-fireworks-red.lsl
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

// red lines

fireworks()
{
    llParticleSystem( [
        PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK |
                         PSYS_PART_EMISSIVE_MASK |
                         PSYS_PART_FOLLOW_VELOCITY_MASK,
     //Appearance
        PSYS_PART_START_SCALE,  < 0.1, 1.0, 0.0 >, // <1,1,1>
        PSYS_PART_END_SCALE,    < 1.0, 1.0, 0.0 >,
        PSYS_PART_START_COLOR,  < 1.0, 0.0, 0.0 >, // <1,1,1>
        PSYS_PART_END_COLOR,    < 0.0, 0.0, 1.0 >, // <1,1,1>
        PSYS_PART_START_ALPHA,  1.00,
        PSYS_PART_END_ALPHA,    0.25,  // 1.0
        PSYS_SRC_TEXTURE,       "",
    
    //Flow
        PSYS_SRC_MAX_AGE,          0.0,
        PSYS_PART_MAX_AGE,         3.00, // 10.0
        PSYS_SRC_BURST_RATE,       0.50, // 0.1
        PSYS_SRC_BURST_PART_COUNT, 50,   // 50
    
    //Placement
        PSYS_SRC_PATTERN,      PSYS_SRC_PATTERN_EXPLODE, // DROP
        PSYS_SRC_BURST_RADIUS, 0.00,
        PSYS_SRC_ANGLE_BEGIN,  0.00,
        PSYS_SRC_ANGLE_END,    0.00,
        PSYS_SRC_OMEGA,        < 0.00, 0.00, 0.00 >,
    
    //Movement
        PSYS_SRC_BURST_SPEED_MIN,  5.00,  // 1.0
        PSYS_SRC_BURST_SPEED_MAX, 10.00,  // 1.0
        PSYS_SRC_ACCEL,           < 0.0, 0.0, -1.0 >, // 0,0,0
        PSYS_SRC_TARGET_KEY,      llGetKey() // come back to itself
    ]);
    llSleep(0.3);
}

init(integer delay)
{
    llSetStatus(STATUS_PHYSICS, TRUE );
    llSetStatus(STATUS_PHANTOM, TRUE );
    float d = (float)( (float)delay / 10.0 );
    llSetTimerEvent( d );
}
default {
    state_entry() {
        init(15);
    }
    on_rez(integer t) {
        init(t);
    }
    timer() {
        fireworks();
        llSetTimerEvent(0);
        llSleep(0.5);
        if (llGetStartParameter() > 0) {
            llDie();
        } else {
            llParticleSystem([]);
        }
    }
}
// END //
