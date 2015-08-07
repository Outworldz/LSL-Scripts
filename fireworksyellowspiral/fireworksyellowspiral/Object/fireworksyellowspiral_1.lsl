// :CATEGORY:Fireworks
// :NAME:fireworksyellowspiral
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:309
// :NUM:408
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// bonus-fireworks-yellow-spiral.lsl
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

// yellow spiral turning orange

fireworks()
{
    llParticleSystem( [
        PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK |
                         PSYS_PART_EMISSIVE_MASK,
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE, 
        PSYS_PART_MAX_AGE, 10.0,
        PSYS_SRC_BURST_SPEED_MIN, 1.0,
        PSYS_SRC_BURST_SPEED_MAX, 1.0,
        PSYS_SRC_ACCEL, <0,0,-0.1>,
        PSYS_SRC_BURST_RATE, 0.05,
        PSYS_SRC_BURST_PART_COUNT, 10,
        PSYS_SRC_ANGLE_BEGIN,  90*DEG_TO_RAD,
        PSYS_SRC_ANGLE_END, 90*DEG_TO_RAD,  
        PSYS_SRC_OMEGA, <0,0,20>, 
        PSYS_PART_START_SCALE, <0.25, 0.25, 0.0>,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA,   0.5,
        PSYS_PART_START_COLOR, <1.0, 1.0, 0.0>,
        PSYS_PART_END_COLOR,   <1.0, 0.0, 0.0>
    ]);
    llSleep(2.0);
}

init(integer delay)
{
    llSetAlpha(1, ALL_SIDES);
    llSetStatus(STATUS_PHYSICS, TRUE );
    llSetStatus(STATUS_PHANTOM, TRUE );
    llSetPrimitiveParams([PRIM_TEMP_ON_REZ, FALSE] );
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
        if (llGetStartParameter() > 0) {
            llDie();
        } else {
            llParticleSystem([]);
        }
    }
}
// END //
