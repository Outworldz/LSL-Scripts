// :CATEGORY:Particles
// :NAME:engine_effect
// :AUTHOR:nick failight
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:285
// :NUM:383
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// engine effect.lsl
// :CODE:


//edited by nick fairlight
// Mask Flags - set to TRUE to enable
integer glow = FALSE;            // Make the particles glow
integer bounce = FALSE;          // Make particles bounce on Z plan of object
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
integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE;

// Select a target for particles to go towards
// "" for no target, "owner" will follow object owner 
//    and "self" will target this object
//    or put the key of an object for particles to go to
key target = ""; 

// Particle paramaters
float age = 1.6; //How long particles last
float maxSpeed = .1; //The fastest they will go
float minSpeed = .1; //The slowest they will go
string texture = ""; //Particle texture, if blank its set to delault orb type.
float startAlpha = 0; //don't change yet, not sure what this is.
float endAlpha = 1; //don't change yet, not sure what this is.
vector startColor = <0,1,0>; //Starting color stream
vector endColor = <.2,3,.0>; // Color of particles at end of stream
vector startSize = <.4,.4,.3>; //Size of particles at the start
vector endSize = <.1,.1,.1>; //Sizes of particles at end of stream
vector push = <0,0,0>; //Physical style push in a vector direction

// System paramaters
float rate = .001;      // How fast to emit particles
float radius = 0;       // Radius to emit particles for BURST pattern
integer count = 1;   // How many particles to emit per BURST 
float outerAngle = TWO_PI;   // Outer angle for all ANGLE patterns
float innerAngle = PI;   // Inner angle for all ANGLE patterns
vector omega = <0,0,0>; // Rotation of ANGLE patterns around the source
float life = 0; //Not sure what this is yet



// Script variables
integer flags;

updateParticles()
{
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
        llSetTimerEvent(1);
    }
    
    timer()
    {
        
    }
}

// END //
