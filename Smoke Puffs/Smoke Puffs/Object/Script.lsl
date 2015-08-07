// :CATEGORY:particles
// :NAME:Smoke Puffs
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:04
// :ID:804
// :NUM:1114
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// smoke puffs
// :CODE:

integer what;
generalParticleEmitterOn()                
{                
    llParticleSystem([                   
        PSYS_PART_FLAGS , 0 
    //| PSYS_PART_BOUNCE_MASK       //Bounce on object's z-axis
    | PSYS_PART_WIND_MASK           //Particles are moved by wind
    | PSYS_PART_INTERP_COLOR_MASK   //Colors fade from start to end
    | PSYS_PART_INTERP_SCALE_MASK   //Scale fades from beginning to end
    | PSYS_PART_FOLLOW_SRC_MASK     //Particles follow the emitter
    //| PSYS_PART_FOLLOW_VELOCITY_MASK//Particles are created at the velocity of the emitter
    //| PSYS_PART_TARGET_POS_MASK   //Particles follow the target
    | PSYS_PART_EMISSIVE_MASK       //Particles are self-lit (glow)
    //| PSYS_PART_TARGET_LINEAR_MASK//Undocumented--Sends particles in straight line?
    ,
    
    //PSYS_SRC_TARGET_KEY , NULL_KEY,//The particles will head towards the specified key
    //Select one of the following for a pattern:
    //PSYS_SRC_PATTERN_DROP                 Particles start at emitter with no velocity
    //PSYS_SRC_PATTERN_EXPLODE              Particles explode from the emitter
    //PSYS_SRC_PATTERN_ANGLE                Particles are emitted in a 2-D angle
    //PSYS_SRC_PATTERN_ANGLE_CONE           Particles are emitted in a 3-D cone
    //PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY     Particles are emitted everywhere except for a 3-D cone
    
    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE
    
    //,PSYS_SRC_TEXTURE,           "Smoke"        //UUID of the desired particle texture, or inventory name
    ,PSYS_SRC_MAX_AGE,           0.0            //Time, in seconds, for particles to be emitted. 0 = forever
    ,PSYS_PART_MAX_AGE,          3.0            //Lifetime, in seconds, that a particle lasts
    ,PSYS_SRC_BURST_RATE,        0.5            //How long, in seconds, between each emission
    ,PSYS_SRC_BURST_PART_COUNT,  15              //Number of particles per emission
    ,PSYS_SRC_BURST_RADIUS,      10.0           //Radius of emission
    ,PSYS_SRC_BURST_SPEED_MIN,   .4             //Minimum speed of an emitted particle
    ,PSYS_SRC_BURST_SPEED_MAX,   .5             //Maximum speed of an emitted particle
    ,PSYS_SRC_ACCEL,             <0.05,0,.0>    //Acceleration of particles each second
    ,PSYS_PART_START_COLOR,      <0.3,0.3,0.3>  //Starting RGB color
    ,PSYS_PART_END_COLOR,        <0.5,0.5,0.5>  //Ending RGB color, if INTERP_COLOR_MASK is on 
    ,PSYS_PART_START_ALPHA,      0.9            //Starting transparency, 1 is opaque, 0 is transparent.
    ,PSYS_PART_END_ALPHA,        0.0            //Ending transparency
    ,PSYS_PART_START_SCALE,      <.1,.1,.1>  //Starting particle size
    ,PSYS_PART_END_SCALE,        <.2,.2,.2>  //Ending particle size, if INTERP_SCALE_MASK is on
    ,PSYS_SRC_ANGLE_BEGIN,       0 * DEG_TO_RAD //Inner angle for ANGLE patterns
    ,PSYS_SRC_ANGLE_END,         1 * DEG_TO_RAD//Outer angle for ANGLE patterns
    ,PSYS_SRC_OMEGA,             <1.0,1.0,0.0>  //Rotation of ANGLE patterns, similar to llTargetOmega()
            ]);
}
 

default
{
    state_entry()
    {
        
        llSetTimerEvent(2.0);
    }

    timer()
    {
        what++;
        if (what > 1)
        {
            what = 0;
            generalParticleEmitterOn();

        }
        else
        {
            //llOwnerSay("NOsmoke");
            llParticleSystem( [ ] );
            
        }
    }

    link_message(integer sender_num, integer num, string msg, key id) 
    {
        if (msg == "no")
        {
            llParticleSystem( [ ] );
            // stop timer
            llSetTimerEvent(0);
        } 
        else
        {
            llSetTimerEvent(2.0);
        }
        
    }    
}

