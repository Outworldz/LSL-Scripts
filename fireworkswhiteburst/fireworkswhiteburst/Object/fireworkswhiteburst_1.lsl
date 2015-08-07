// :CATEGORY:Fireworks
// :NAME:fireworkswhiteburst
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:308
// :NUM:407
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// bonus-fireworks-whiteburst.lsl
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

// white burst turning to green

fireworks()
{
    llParticleSystem( [
        PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK |
                         PSYS_PART_EMISSIVE_MASK,
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE, 
        PSYS_PART_MAX_AGE, 5.0,
        PSYS_SRC_BURST_SPEED_MIN, 3.0,
        PSYS_SRC_BURST_SPEED_MAX, 5.,
        PSYS_SRC_ACCEL, <0,0,-0.2>,
        PSYS_SRC_BURST_RATE, 0.1,
        PSYS_SRC_BURST_PART_COUNT, 50,
        PSYS_PART_START_SCALE, <0.5, 0.5, 0.0>,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA,   0.25,
        PSYS_PART_START_COLOR, <1.0, 1.0, 1.0>,
        PSYS_PART_END_COLOR,   <0.0, 1.0, 0.0>
    ]);
}

init(integer delay)
{
    llSetAlpha(1, ALL_SIDES);
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
