// :CATEGORY:Particles
// :NAME:blood
// :AUTHOR:eltee Statosky
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:49
// :ID:104
// :NUM:139
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// blood!.lsl
// :CODE:

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//// eltee Statosky's Particle Creation Engine 1.0
//// 01/09/2004
//// *PUBLIC DOMAIN*
//// Free to use
//// Free to copy
//// Free to poke at
//// Free to hide in stuff you sell
//// Just please leave this header intact
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
string texturer = "e08ab401-2945-29f7-0797-a6c67a405b5b";
integer effectFlags=0;
integer running=TRUE;
key owner;

///////////////////////////////////////////////////////
// Color Secelection Variables
///////////////////////////////////////////////////////
// Interpolate between startColor and endColor
integer colorInterpolation  = TRUE;
// Starting color for each particle 
vector  startColor          = <1,1,1>;
// Ending color for each particle
vector  endColor            = <1, 1, 1>;
// Starting Transparency for each particle (1.0 is solid)
float   startAlpha          = 0.8;
// Ending Transparency for each particle (0.0 is invisible)
float   endAlpha            = 0.3;
// Enables glow around particles
integer glowEffect          = TRUE;


///////////////////////////////////////////////////////
// Size & Shape Selection Variables
///////////////////////////////////////////////////////
// Interpolate between startSize and endSize
integer sizeInterpolation   = TRUE;
// Starting size of each particle
vector  startSize           = <0.5, 0.5, 0.5>;
// Ending size of each particle
vector  endSize             = <0.5, 0.5, 0.5>;
// Turns particles to face their movement direction
integer followVelocity      = TRUE;
// Texture the particles will use ("" for default)
string  texture             = texturer;


///////////////////////////////////////////////////////
// Timing & Creation Variables Variables
///////////////////////////////////////////////////////
// Lifetime of one particle (seconds)
float   particleLife        = 2.0;
// Lifetime of the system 0.0 for no time out (seconds)
float   SystemLife          = 0.0;
// Number of seconds between particle emissions
float   emissionRate        = 0.20;
// Number of particles to releast on each emission
integer partPerEmission     = 5;


///////////////////////////////////////////////////////
// Angular Variables
///////////////////////////////////////////////////////
// The radius used to spawn angular particle patterns
float   radius              = 0.0;
// Inside angle for angular particle patterns
float   innerAngle          = 0;
// Outside angle for angular particle patterns
float   outerAngle          = 0;
// Rotational potential of the inner/outer angle
vector  omega               = <2.0, 2.0, 0.2>;


///////////////////////////////////////////////////////
// Movement & Speed Variables
///////////////////////////////////////////////////////
// The minimum speed a particle will be moving on creation
float   minSpeed            = 0.0;
// The maximum speed a particle will be moving on creation
float   maxSpeed            = 0.1;
// Global acceleration applied to all particles
vector  acceleration        = <0.0, 0.0, -0.5>;
// If true, particles will be blown by the current wind
integer windEffect          = FALSE;
// if true, particles 'bounce' off of the object's Z height
integer bounceEffect        = FALSE;
// If true, particles spawn at the container object center
integer followSource        = TRUE;
// If true, particles will move to expire at the target
//integer followTarget        = TRUE;
// Desired target for the particles (any valid object/av key)
// target Needs to be set at runtime
key     target              = "";


///////////////////////////////////////////////////////
//As yet unimplemented particle system flags
///////////////////////////////////////////////////////
integer randomAcceleration  = TRUE;
integer randomVelocity      = TRUE;
integer particleTrails      = TRUE;

///////////////////////////////////////////////////////
// Pattern Selection
///////////////////////////////////////////////////////
//   Uncomment the pattern call you would like to use
//   Drop parcles at the container objects' center
//integer pattern = PSYS_SRC_PATTERN_DROP;
//   Burst pattern originating at objects' center
//integer pattern = PSYS_SRC_PATTERN_EXPLODE;
//   Uses 2D angle between innerAngle and outerAngle
// integer pattern = PSYS_SRC_PATTERN_ANGLE;
//   Uses 3D cone spread between innerAngle and outerAngle
integer pattern = PSYS_SRC_PATTERN_EXPLODE ;
// 
//integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY



setParticles()
{
// Here is where to set the current target
// llGetKey() targets this script's container object
// llGetOwner() targets the owner of this script
// Feel free to insert any other valid key
    target="";
// The following block of if statements is used to construct the mask 
    if (colorInterpolation) effectFlags = effectFlags|PSYS_PART_INTERP_COLOR_MASK;
    if (sizeInterpolation)  effectFlags = effectFlags|PSYS_PART_INTERP_SCALE_MASK;
    if (windEffect)         effectFlags = effectFlags|PSYS_PART_WIND_MASK;
    if (bounceEffect)       effectFlags = effectFlags|PSYS_PART_BOUNCE_MASK;
    if (followSource)       effectFlags = effectFlags|PSYS_PART_FOLLOW_SRC_MASK;
    if (followVelocity)     effectFlags = effectFlags|PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target!="")       effectFlags = effectFlags|PSYS_PART_TARGET_POS_MASK;
    if (glowEffect)         effectFlags = effectFlags|PSYS_PART_EMISSIVE_MASK;
//Uncomment the following selections once they've been implemented
//    if (randomAcceleration) effectFlags = effectFlags|PSYS_PART_RANDOM_ACCEL_MASK;
//    if (randomVelocity)     effectFlags = effectFlags|PSYS_PART_RANDOM_VEL_MASK;
//    if (particleTrails)     effectFlags = effectFlags|PSYS_PART_TRAIL_MASK;
    llParticleSystem([
        PSYS_PART_FLAGS,            effectFlags,
        PSYS_SRC_PATTERN,           pattern,
        PSYS_PART_START_COLOR,      startColor,
        PSYS_PART_END_COLOR,        endColor,
        PSYS_PART_START_ALPHA,      startAlpha,
        PSYS_PART_END_ALPHA,        endAlpha,
        PSYS_PART_START_SCALE,      startSize,
        PSYS_PART_END_SCALE,        endSize,    
        PSYS_PART_MAX_AGE,          particleLife,
        PSYS_SRC_ACCEL,             acceleration,
        PSYS_SRC_TEXTURE,           texture,
        PSYS_SRC_BURST_RATE,        emissionRate,
        PSYS_SRC_INNERANGLE,        innerAngle,
        PSYS_SRC_OUTERANGLE,        outerAngle,
        PSYS_SRC_BURST_PART_COUNT,  partPerEmission,      
        PSYS_SRC_BURST_RADIUS,      radius,
        PSYS_SRC_BURST_SPEED_MIN,   minSpeed,
        PSYS_SRC_BURST_SPEED_MAX,   maxSpeed, 
        PSYS_SRC_MAX_AGE,           SystemLife,
        PSYS_SRC_TARGET_KEY,        target,
        PSYS_SRC_OMEGA,             omega   ]);
}

default
{
    on_rez(integer start)
    {
    owner = llGetOwner();    
    }
    state_entry()
    {
        llSetBuoyancy(0.0);
        llCollisionSound("",0.0);
        llCollisionSprite("");
      llParticleSystem([]);
      llSetStatus(STATUS_DIE_AT_EDGE, TRUE);   
    }
    collision_start(integer detected)
    {
     integer type = llDetectedType(0);
     key person = llDetectedKey(0);
     if(type & AGENT)
     {
         if(person != owner)
         {
             llSetForce(<0,0,0>, TRUE);
         running=TRUE;
        setParticles();
        llTriggerSound("hit", 0.7); 
         llSetBuoyancy(-0.1);
        llSleep(1.0);
        running=FALSE;
        llParticleSystem([]);
        llSetStatus(STATUS_PHANTOM, TRUE);
        llDie();
          }
        }  
        else
        {llDie();} 
    }
    land_collision(vector pos)
    {
      llParticleSystem([]);
      llSetStatus(STATUS_PHANTOM, TRUE);
      llDie();
        
    }
    
    
    
}
// END //
