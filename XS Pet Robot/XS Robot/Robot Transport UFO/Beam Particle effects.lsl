// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Ferd Frederix
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-01-30 12:24:21
// :ID:988
// :NUM:1450
// :REV:0.50
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// XS Pet Particle Script
// :CODE:

/////////////////////////////////////////////////////////////////////
// This code is licensed as Creative Commons Attribution/NonCommercial/Share Alike

// See http://creativecommons.org/licenses/by-nc-sa/3.0/
// Noncommercial -- You may not use this work for commercial purposes
// If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
// This means that you cannot sell this code but you may share this code.
// You must attribute authorship to me and leave this notice intact.
//
// Exception: I am allowing this script to be sold inside an original build.
// You are not selling the script, you are selling the build.
// Ferd Frederix




// Particle Script 0.3
// Created by Ama Omega
// 10-10-2003
// 11-15-2011 mods by Ferd Frederix for XS Pets
// makes particles when triggered by xs_cryocrate


// 11-15-2011 Added Link message EFFECTS_ON for particles or other effects when rezzing an egg
integer LINK_EFFECTS_ON = 2000; // special particle plug in effects enabled

// tunables
integer debug = TRUE; //if set to TRUE a touch to the base will turn on effects




// Mask Flags - set to TRUE to enable
integer glow = TRUE;            // Make the particles glow
integer bounce = TRUE;          // Make particles bounce on Z plan of object
integer interpColor = TRUE;     // Go from start to end color
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
key target = "self";

// Particle paramaters
float age = 5;                  // Life of each particle
float maxSpeed = .05;            // Max speed each particle is spit out at
float minSpeed = 0;            // Min speed each particle is spit out at
string texture = "";                 // Texture used for particles, default used if blank
float startAlpha = 1;           // Start alpha (transparency) value
float endAlpha = .1;           // End alpha (transparency) value
vector startColor = <1,0,1>;    // Start color of particles <R,G,B>
vector endColor = <1,0,1>;      // End color of particles <R,G,B> (if interpColor == TRUE)
vector startSize = <0.050,0.05,1.9>;   // Start size of particles
vector endSize = <.020,.020,1.9>;       // End size of particles (if interpSize == TRUE)
vector push = <0.0,0.0,0>;          // Force pushed on particles

// System paramaters
float rate = 0.1;            // How fast (rate) to emit particles
float radius = .02;          // Radius to emit particles for BURST pattern
integer count = 10;        // How many particles to emit per BURST
float outerAngle = 0.5;    // Outer angle for all ANGLE patterns
float innerAngle = 10;    // Inner angle for all ANGLE patterns
vector omega = <0,0,0>;    // Rotation of ANGLE patterns around the source
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

Move()
{
    llSetAlpha(0.3,ALL_SIDES);      // visible
    updateParticles();
    // no need to turn them off, we will die, but it is possible there was an errors mso we wait a while and shut themdown.
    llSleep(10);
    llParticleSystem([]);       // particles OFF
    llSetAlpha(0,ALL_SIDES);      // invisible

}

default
{
    state_entry()
    {
        llSetAlpha(0,ALL_SIDES);      // invisible
        llParticleSystem([]);       // particles OFF
    }

    touch_start(integer p)
    {
        if (debug)
            Move();
    }

    link_message(integer sender_num, integer num, string str, key id)
    {
        if (num == LINK_EFFECTS_ON)
        {
            Move();
        }

    }

}
