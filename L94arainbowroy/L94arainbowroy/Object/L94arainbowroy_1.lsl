// :CATEGORY:Rainbow
// :NAME:L94arainbowroy
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:444
// :NUM:600
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L9.4a-rainbow-roy.lsl
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

integer NUM_PARTICLES_PER_RADIAN = 50;
float RAINBOW_ARC = PI_BY_TWO;

startRainbowROY()
{
    integer numParticles = (integer)(RAINBOW_ARC * 
                                     NUM_PARTICLES_PER_RADIAN);
    float age = 10.0;           // you can also use these in the call
    float burstRate = 0.2;    // to llParticleSystem()
    float total = (age * numParticles) / burstRate;
    llOwnerSay("This emitter manages "+(string)total +" particles");
    
    // Based on Listing B.1. Unchanged values removed to save trees
    llParticleSystem( [
        PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK | // change colour
                         PSYS_PART_INTERP_SCALE_MASK |   // let it grow
                         PSYS_PART_FOLLOW_VELOCITY_MASK,
     //Appearance
        PSYS_PART_START_SCALE, <2.0, 0.3, 0.0>,      // <1,1,0>,
        PSYS_PART_END_SCALE,   <2.5, 0.3, 0.0>,      // <1,1,0>,
        PSYS_PART_START_COLOR, <1.0, 1.0, 0.0>,      // <1,1,1>,
        PSYS_PART_END_COLOR,   <1.0, 0.2, 0.0>,      // <1,1,1>,
        PSYS_PART_START_ALPHA, 0.8,  // 1.00,
        PSYS_PART_END_ALPHA,   0.8,  // 1.00,
    //Flow
        PSYS_PART_MAX_AGE,         age,         // 10.00,
        PSYS_SRC_BURST_RATE,       burstRate,          // 0.10,
        PSYS_SRC_BURST_PART_COUNT, numParticles, // 1,
    
    //Placement
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE, // DROP,
        PSYS_SRC_BURST_RADIUS, 15.0,              // 0.00,
        PSYS_SRC_ANGLE_BEGIN,  0.0,               // 0.00,
        PSYS_SRC_ANGLE_END,  RAINBOW_ARC,         // 0.00,
    //Movement
        PSYS_SRC_BURST_SPEED_MIN, 0.1,  // 1.00,
        PSYS_SRC_BURST_SPEED_MAX, 0.1  // 1.00,
    ]);
}

default {
    state_entry() {
        llSetAlpha(ALL_SIDES,0);
        startRainbowROY();
    }
    on_rez(integer _n) {
        llResetScript();
    }
}
// END //
