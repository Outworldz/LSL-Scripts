// :CATEGORY:Particles
// :NAME:Chains
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:50
// :ID:162
// :NUM:230
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Sends particle chains to another prim, like for a drawbridge
// :CODE:



// sends particle chains to the owner
// Particle System 1.0

StartSteam()
{
                                // MASK FLAGS: set  to "TRUE" to enable
integer glow = FALSE;                                // Makes the particles glow
integer bounce = FALSE;                             // Make particles bounce on Z plane of objects
integer interpColor = FALSE;                         // Color - from start value to end value
integer interpSize = FALSE;                          // Size - from start value to end value
integer wind = TRUE;                               // Particles effected by wind
integer followSource = TRUE;                       // Particles follow the source
integer followVel = TRUE;                       // Particles turn to velocity direction



                                // Choose a pattern from the following:
                                                    // PSYS_SRC_PATTERN_EXPLODE
                                                    // PSYS_SRC_PATTERN_DROP
                                                    // PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
                                                    // PSYS_SRC_PATTERN_ANGLE_CONE
                                                    // PSYS_SRC_PATTERN_ANGLE
    integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY;       // PSYS_SRC_PATTERN_EXPLODE;

                                                    // Select a target for particles to go towards
                                                    // "" for no target, "owner" will follow object owner 
                                                    //    and "self" will target this object
                                                    //    or put the key of an object for particles to go to
                                                    
         //key target = "2d180e40-017a-a88a-76cd-ec84c773dac5";
        //  key target = "e32b8b3e-ebab-06fe-590d-df4bcceeb73b";
     key target = llGetOwner();
                                // PARTICLE PARAMETERS
    
    float age = 5;                                // Life of each particle
    float maxSpeed = 0.05;                           // Max speed each particle is spit out at
    float minSpeed = 0.05;                             // Min speed each particle is spit out at
    string texture = "chain";              // Texture used for particles, default used if blank
    float startAlpha = 0.8;                         // Start alpha (transparency) value
    float endAlpha = 0.8;                             // End alpha (transparency) value
    vector startColor = <0.75,0.85,1>;              // Start color of particles <R,G,B>
    vector endColor = <0.75,0.85,1>;                      // End color of particles <R,G,B> (if interpColor == TRUE)
    vector startSize = <0.05,0.05,0.05>;            // Start size of particles 
    vector endSize = <0.05,0.05,0.05>;                      // End size of particles (if interpSize == TRUE)
    vector push = <0.05,0.0,0.0>;                    // Force pushed on particles

                                // SYSTEM PARAMETERS
    
    float rate = .025;                               // How fast (rate) to emit particles
    float radius = 0.75;                            // Radius to emit particles for BURST pattern
    integer count = 4;                              // How many particles to emit per BURST 
    float outerAngle = 3*PI;                        // Outer angle for all ANGLE patterns   PI/4
    float innerAngle = 0.5;                         // Inner angle for all ANGLE patterns
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
    
     changed(integer change)
    {
        if (change & CHANGED_OWNER)
            llResetScript();

    }
    
    
    state_entry()
    {
         StartSteam();
         // llOwnerSay(llGetKey());
    }

    listen(integer channel, string name, key id, string message)
    {
 
         if (0 == llSubStringIndex(message, "chain on"))
        {
            StartSteam();
            
        }
        else if (0 == llSubStringIndex(message, "chain off"))
        {
            StopSpray();
        }
    }
}



