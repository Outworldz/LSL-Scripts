// :CATEGORY:Particles
// :NAME:SteamJunk_Factory_Smoker_BigStack
// :AUTHOR:anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:836
// :NUM:1164
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SteamJunk_Factory_Smoker_BigStack
// :CODE:
// Particle Script 0.5
// Created by Ama Omega
// 3-26-2004

integer keystate = 0 ;

// Mask Flags - set to TRUE to enable
integer glow = FALSE;            // Make the particles glow
integer bounce = FALSE;          // Make particles bounce on Z plane of object
integer interpColor = TRUE;     // Go from start to end color
integer interpSize = TRUE;      // Go from start to end size
integer wind = TRUE;           // Particles effected by wind
integer followSource = FALSE;    // Particles follow the source
integer followVel = FALSE;       // Particles turn to velocity direction

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
float age = 5;                  // Life of each particle
float maxSpeed = 1;            // Max speed each particle is spit out at
float minSpeed = 0.8;            // Min speed each particle is spit out at
string texture = "4f714019-c1cf-6b16-994f-44b217022f1a";                 // Texture used for particles, default used if blank
float startAlpha = 0.8;           // Start alpha (transparency) value
float endAlpha = 0.0;           // End alpha (transparency) value
vector startColor = <0.5,0.5,0.5>;    // Start color of particles <R,G,B>
vector endColor = <0,0,0>;      // End color of particles <R,G,B> (if interpColor == TRUE)
vector startSize = <5.01,5.01,5.0>;     // Start size of particles 
vector endSize = <12.0,12.0,10.0>;       // End size of particles (if interpSize == TRUE)
vector push = <.2,0,3>;          // Force pushed on particles

// System paramaters
float rate = 1;            // How fast (rate) to emit particles
float radius = 0.0;          // Radius to emit particles for BURST pattern
integer count = 40;        // How many particles to emit per BURST 
float outerAngle = 0;    // Outer angle for all ANGLE patterns
float innerAngle = 0.1;    // Inner angle for all ANGLE patterns
vector omega = <0,0,0>;    // Rotation of ANGLE patterns around the source
float life = 0;             // Life in seconds for the system to make particles


integer flags;
list sys;
integer type;
vector tempVector;
rotation tempRot;
string tempString;
integer i;


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
    sys = [  PSYS_PART_MAX_AGE,age,
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
                            ];
                            
    llParticleSystem(sys);
}

    
    

default
{
    state_entry()
    {
        //updateParticles();
        keystate = 0 ;
        //target = llGetLinkKey(2) ;
        updateParticles() ;
        //llParticleSystem([]) ;
    }
    
}
