// :CATEGORY:Bling
// :NAME:GoldBling2_last_Longer
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:359
// :NUM:492
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// GoldBling2 (last Longer).lsl
// :CODE:

//BLING PARTICLES FOR BLINGY JEWELS AND STUFF Adapted by Stormy Roentgren

//For those not knowing how to alter particle scripts, the parameters you'll want to alter here (if you choose to) are the "float rate" and the start and end sizes.


// Particle Script 0.3
// Created by Ama Omega
// 10-10-2003

// Mask Flags - set to TRUE to enable
integer glow = TRUE;            // Make the particles glow
integer bounce = FALSE;          // Make particles bounce on Z plan of object
integer interpColor = FALSE;     // Go from start to end color
integer interpSize = TRUE;      // Go from start to end size
integer wind = FALSE;           // Particles effected by wind
integer followSource = FALSE;    // Particles follow the source
integer followVel = TRUE;       // Particles turn to velocity direction

// Choose a pattern from the following:
// PSYS_SRC_PATTERN_EXPLODE
// PSYS_SRC_PATTERN_DROP
// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
// PSYS_SRC_PATTERN_ANGLE_CONE
// PSYS_SRC_PATTERN_ANGLE
integer pattern = PSYS_SRC_PATTERN_EXPLODE;

// Select a target for particles to go towards
// "" for no target, "owner" will follow object owner 
//    and "self" will target this object
//    or put the key of an object for particles to go to
key target = "";

// Particle paramaters
float age = .5;                  // Life of each particle
float maxSpeed = .1;            // Max speed each particle is spit out at
float minSpeed = .1;            // Min speed each particle is spit out at
string  texture             = "be5ee4dc-2fbb-8cd9-1fac-bdab4ab93972";                 // Texture used for particles, default used if blank
float startAlpha = 10;           // Start alpha (transparency) value
float endAlpha = 10;           // End alpha (transparency) value
vector startColor = <1,1,1>;    // Start color of particles <R,G,B>
vector endColor = <1,1,1>;      // End color of particles <R,G,B> (if interpColor == TRUE)
vector startSize = <.04,.25,.01>;     // Start size of particles 
vector endSize = <.03,.25,.01>;       // End size of particles (if interpSize == TRUE)
vector push = <0,0,0>;          // Force pushed on particles

// System paramaters
float rate = 5;            // How fast (rate) to emit particles
float radius = .0;          // Radius to emit particles for BURST pattern
integer count = 5;        // How many particles to emit per BURST 
float outerAngle = 1.54;    // Outer angle for all ANGLE patterns
float innerAngle = 1.55;    // Inner angle for all ANGLE patterns
vector omega = <0,0,10>;    // Rotation of ANGLE patterns around the source
float life = 0;             // Life in seconds for the system to make particles

// Script variables
integer flags; 

updateParticles()
{
    flags = 0;
    if (target == "owner") target = llGetOwner();
    if (target == "self") target = llGetKey();
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;

    llParticleSystem([  PSYS_PART_MAX_AGE,age,
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, startColor,
                        PSYS_PART_END_COLOR, endColor,
                        PSYS_PART_START_SCALE,startSize,
                        PSYS_PART_END_SCALE,endSize, 
                        PSYS_SRC_PATTERN, pattern,
                        PSYS_SRC_BURST_RATE,rate,
                        PSYS_SRC_ACCEL, push,
                        PSYS_SRC_BURST_PART_COUNT,count,
                        PSYS_SRC_BURST_RADIUS,radius,
                        PSYS_SRC_BURST_SPEED_MIN,minSpeed,
                        PSYS_SRC_BURST_SPEED_MAX,maxSpeed,
                        PSYS_SRC_TARGET_KEY,target,
                        PSYS_SRC_INNERANGLE,innerAngle, 
                        PSYS_SRC_OUTERANGLE,outerAngle,
                        PSYS_SRC_OMEGA, omega,
                        PSYS_SRC_MAX_AGE, life,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, startAlpha,
                        PSYS_PART_END_ALPHA, endAlpha
                            ]);
}

default
{
    state_entry()
    {
        updateParticles();
    }
}// END //
