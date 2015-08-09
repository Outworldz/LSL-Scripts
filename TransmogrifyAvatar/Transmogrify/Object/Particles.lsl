// :CATEGORY:Transmogrify
// :NAME:TransmogrifyAvatar
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-08
// :EDITED:2014-01-01 12:18:57
// :ID:921
// :NUM:1324
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// makes a flash of smoke when you transmogrify
// :CODE:
// Transmogrifyer script
// License: CC-BY. Please do not remove the copyright or this notice
// Author: Ferd Frederix

// Particles is a poofer effect for changing.  Put it in the head, body and feet section of the avatar and in the pet.
// Easy to change the colors, or add a texture.

// Sends a RED  flash of 400 particles for 1 second.
// If you add a texture to it, put the same texture on the side of a small box inside your pet so it will be cached and appear instantly.

// MASK FLAGS: set  to "TRUE" to enable

integer glow = TRUE;                                // Makes the particles glow
integer bounce = FALSE;                             // Make particles bounce on Z plane of objects
integer interpColor = TRUE;                         // Color - from start value to end value
integer interpSize = TRUE;                          // Size - from start value to end value
integer wind = FALSE;                               // Particles effected by wind
integer followSource = FALSE;                       // Particles follow the source
integer followVel = TRUE;                           // Particles turn to velocity direction
 
 
 
// Choose a pattern from the following:
// PSYS_SRC_PATTERN_EXPLODE
// PSYS_SRC_PATTERN_DROP
// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
// PSYS_SRC_PATTERN_ANGLE_CONE
// PSYS_SRC_PATTERN_ANGLE
// PSYS_SRC_PATTERN_EXPLODE;

integer pattern = PSYS_SRC_PATTERN_EXPLODE;       
                                                // Select a target for particles to go towards
                                                // "" for no target, "owner" will follow object owner
                                                //    and "self" will target this object
                                                //    or put the key of an object for particles to go to
 
 key target = "";        // if set to a UUID, such as llGetOwner(0), the particles go that-away
 
 
                            // PARTICLE PARAMETERS
 
float age = 0.1;                              // Life of each particle
float maxSpeed = 10.0;                        // Max speed each particle is spit out at
float minSpeed = 3;                           // Min speed each particle is spit out at
string texture = "";                          // Texture used for particles, default used if blank
float startAlpha = 0.5;                       // Start alpha (transparency) value
float endAlpha = 0.5;                         // End alpha (transparency) value
vector startColor = <0,0,1>;                  // Start color of particles <R,G,B>
vector endColor = <0,0,1>;                    // End color of particles <R,G,B> (if interpColor == TRUE)
vector startSize = <1.0,2.0,1.0>;             // Start size of particles
vector endSize = <1,2,1.0>;                   // End size of particles (if interpSize == TRUE)
vector push = <0.0,0.0,0.0>;                  // Force pushed on particles

 
// SYSTEM PARAMETERS
 
float rate = 0.1;                               // How fast (rate) to emit particles


float life = 1.0;                                 // Life in seconds for the system to make particles
integer count = 40;                              // How many particles to emit per BURST
// life (1) / age (.1) * count (4)  = 400 particles, about 10% of what anyone can see

float radius = 0.25;                            // Radius to emit particles for BURST pattern, helps cover up the avatar
float outerAngle = TWO_PI;                        // Outer angle for all ANGLE patterns, TWO_PI is a full sphere
float innerAngle = 0.5;                         // Inner angle for all ANGLE patterns
vector omega = <0,0,0>;                         // Rotation of ANGLE patterns around the source

 
// SCRIPT VARIABLES
integer flags;

// nothing to see here. Go play somewhere else        
StartSteam()
{

    flags = 0;
 
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
        StartSteam();   // show the flash when it resets
    }
 
    link_message(integer sender_number, integer number, string message, key id)
    {
        
        if (message == "switch")
        {
            StartSteam();
        }
    }
}


