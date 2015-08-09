// :CATEGORY:Particles
// :NAME:ButterflyGenerator
// :AUTHOR:JPvdGiessen
// :KEYWORDS:
// :CREATED:2014-10-21 20:07:12
// :EDITED:2014-10-21
// :ID:1051
// :NUM:1669
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Rezzes particle butterflies
// :CODE:
// ButterflyGenerator
// (c) JPvdGiessen IT Consultancy

MakeParticles()                //This is the function that actually starts the particle system.
{                 
    llParticleSystem([                     
        PSYS_PART_FLAGS , 0 //Comment out any of the following masks to deactivate them
    | PSYS_PART_BOUNCE_MASK           //Bounce on object's z-axis
    | PSYS_PART_WIND_MASK             //Particles are moved by wind
    | PSYS_PART_INTERP_SCALE_MASK       //Scale fades from beginning to end
    | PSYS_PART_FOLLOW_SRC_MASK         //Particles follow the emitter
    | PSYS_PART_FOLLOW_VELOCITY_MASK    //Particles are created at the velocity of the emitter
    ,
    
    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE
    
    ,PSYS_SRC_TEXTURE,           "butterfly"                 //UUID of the desired particle texture, or inventory name
    ,PSYS_SRC_MAX_AGE,           0.0                //Time, in seconds, for particles to be emitted. 0 = forever
    ,PSYS_PART_MAX_AGE,          50.0                //Lifetime, in seconds, that a particle lasts
    ,PSYS_SRC_BURST_RATE,        0.5               //How long, in seconds, between each emission
    ,PSYS_SRC_BURST_PART_COUNT,  3                  //Number of particles per emission
    ,PSYS_SRC_BURST_RADIUS,      1.0                //Radius of emission
    ,PSYS_SRC_BURST_SPEED_MIN,   1.5                //Minimum speed of an emitted particle
    ,PSYS_SRC_BURST_SPEED_MAX,   5.0                //Maximum speed of an emitted particle
    ,PSYS_SRC_ACCEL,             <0.0,0.0,-0.8>     //Acceleration of particles each second
    ,PSYS_PART_START_ALPHA,      0.9                //Starting transparency, 1 is opaque, 0 is transparent.
    ,PSYS_PART_END_ALPHA,        0.0                //Ending transparency
    ,PSYS_PART_START_SCALE,      <0.2,0.2,0.0>      //Starting particle size
    ,PSYS_PART_END_SCALE,        <0.01,0.01,0.0>      //Ending particle size, if INTERP_SCALE_MASK is on
    ,PSYS_SRC_ANGLE_BEGIN,       PI                 //Inner angle for ANGLE patterns
    ,PSYS_SRC_ANGLE_END,         PI                 //Outer angle for ANGLE patterns
    ,PSYS_SRC_OMEGA,             <0.0,0.0,0.0>       //Rotation of ANGLE patterns, similar to llTargetOmega()
            ]);
}

default
{    
    state_entry()
    {
        llSay(0, "On") ;
        MakeParticles();                //Start making particles
    }

    touch_start( integer num )            //Turn particles off when touched
    {
        state off;                  //Switch to the off state
    }
}

state off
{
    state_entry()
    {
        llSay(0, "Off") ;
        llParticleSystem([]);        //Stop making particles
    }
    
    touch_start( integer num )        //Turn particles back on when touched
    {
        state default;
    }
}
