// :CATEGORY:Swarm
// :NAME:Swarming Bees
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:856
// :NUM:1192
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Swarm of bees
// :CODE:

//Swarming Bee's By: Frankwhiteaka Blanco 
// TRUE = swarm bees on startup
// False = Listen on channel 0 for commands
integer bStartImmediately = FALSE;
StartSteam()
{
                                // MASK FLAGS: set  to "TRUE" to enable
integer glow = FALSE;                                // Makes the particles glow
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
    integer pattern = PSYS_SRC_PATTERN_EXPLODE;       // PSYS_SRC_PATTERN_EXPLODE;
 
                                                    // Select a target for particles to go towards
                                                    // "" for no target, "owner" will follow object owner
                                                    //    and "self" will target this object
                                                    //    or put the key of an object for particles to go to
 
         key target = "";
 
 
                                // PARTICLE PARAMETERS
 
    float age = 1;                                // Life of each particle
    float maxSpeed = 1.5;                           // Max speed each particle is spit out at
    float minSpeed = 1;                             // Min speed each particle is spit out at
    string texture = "8ff51374-338a-9e0e-c7d6-fca4c722ff29";              // Texture used for particles, default used if blank
    float startAlpha = 100;                         // Start alpha (transparency) value
    float endAlpha = 100;                             // End alpha (transparency) value
    vector startColor = <1,1,1>;              // Start color of particles <R,G,B>
    vector endColor = <1,1,1>;                      // End color of particles <R,G,B> (if interpColor == TRUE)
    vector startSize = <.1,.1,.1>;            // Start size of particles
    vector endSize = <.1,.1,.1>;                      // End size of particles (if interpSize == TRUE)
    vector push = <0.0,0.0,-2.0>;                    // Force pushed on particles
 
                                // SYSTEM PARAMETERS
 
    float rate = 0.01;                               // How fast (rate) to emit particles
    float radius = 0.25;                            // Radius to emit particles for BURST pattern
    integer count = 120;                              // How many particles to emit per BURST
    float outerAngle = 4*PI;                        // Outer angle for all ANGLE patterns   PI/4
    float innerAngle = 0;                         // Inner angle for all ANGLE patterns
    vector omega = <0,0,0>;                         // Rotation of ANGLE patterns around the source
    float life = 0;                                 // Life in seconds for the system to make particles
 
                                // SCRIPT VARIABLES
 
    integer flags;
 
 
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
StartSpray ()
{
 
}
 
StopSpray()
{
    llParticleSystem([]);   
}
 
 
 
default
{
    state_entry()
    {
        if(bStartImmediately==TRUE){
            StartSteam();
        } else { 
            llOwnerSay("bee (swarm|stop) to make bee's swarm");
            llListen(0,"",NULL_KEY,"");
        }
    }
 
    listen(integer channel, string name, key id, string message)
    {
 
        if (0 == llSubStringIndex(message, "bee swarm"))
        {
            StartSteam();
 
        }
        else if (0 == llSubStringIndex(message, "bee stop"))
        {
            StopSpray();
        }
    }
}
 
