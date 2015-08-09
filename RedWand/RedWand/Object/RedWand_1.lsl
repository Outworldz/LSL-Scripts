// :CATEGORY:Particles
// :NAME:RedWand
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:687
// :NUM:935
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// RedWand.lsl
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

integer effectFlags=0;
integer running=TRUE;


///////////////////////////////////////////////////////
// Color Secelection Variables
///////////////////////////////////////////////////////
// Interpolate between startColor and endColor
integer colorInterpolation  = TRUE;
// Starting color for each particle 
vector  startColor          = <1, .7, 0.>;
// Ending color for each particle
vector  endColor            = <1, .7, 0>;
// Starting Transparency for each particle (1.0 is solid)
float   startAlpha          = 1.0;
// Ending Transparency for each particle (0.0 is invisible)
float   endAlpha            = 0.0;
// Enables Absolute color (true) ambient lighting (false)
integer glowEffect          = TRUE;


///////////////////////////////////////////////////////
// Size & Shape Selection Variables
///////////////////////////////////////////////////////
// Interpolate between startSize and endSize
integer sizeInterpolation   = TRUE;
// Starting size of each particle
vector  startSize           = <0.1, 0.1, 0.0>;
// Ending size of each particle
vector  endSize             = <0.1, 0.1, 0.0>;
// Turns particles to face their movement direction
integer followVelocity      = TRUE;
// Texture the particles will use ("" for default)
string  texture             = "";


///////////////////////////////////////////////////////
// Timing & Creation Variables Variables
///////////////////////////////////////////////////////
// Lifetime of one particle (seconds)
float   particleLife        = 3.0;
// Lifetime of the system 0.0 for no time out (seconds)
float   SystemLife          = 0.0;
// Number of seconds between particle emissions
float   emissionRate        = 0.001;
// Number of particles to releast on each emission
integer partPerEmission     = 5;


///////////////////////////////////////////////////////
// Angular Variables
///////////////////////////////////////////////////////
// The radius used to spawn angular particle patterns
float   radius              = .5;
// Inside angle for angular particle patterns
float   innerAngle          = 1;
// Outside angle for angular particle patterns
float   outerAngle          = 90;
// Rotational potential of the inner/outer angle
vector  omega               = <1.0, 1.0, 0.0>;


///////////////////////////////////////////////////////
// Movement & Speed Variables
///////////////////////////////////////////////////////
// The minimum speed a particle will be moving on creation
float   minSpeed            = 0.0;
// The maximum speed a particle will be moving on creation
float   maxSpeed            = 0.1;
// Global acceleration applied to all particles
vector  acceleration        = <0.0, 0.0, 0.0>;
// If true, particles will be blown by the current wind
integer windEffect          = FALSE;
// if true, particles 'bounce' off of the object's Z height
integer bounceEffect        = FALSE;
// If true, particles spawn at the container object center
integer followSource        = FALSE;
// If true, particles will move to expire at the target
//integer followTarget        = TRUE;
// Desired target for the particles (any valid object/av key)
// target Needs to be set at runtime
key     target              = "";


///////////////////////////////////////////////////////
//As yet unimplemented particle system flags
///////////////////////////////////////////////////////
integer randomAcceleration  = FALSE;
integer randomVelocity      = FALSE;
integer particleTrails      = FALSE;

///////////////////////////////////////////////////////
// Pattern Selection
///////////////////////////////////////////////////////
//   Uncomment the pattern call you would like to use
//   Drop parcles at the container objects' center
//integer pattern = PSYS_SRC_PATTERN_DROP;
//   Burst pattern originating at objects' center
integer pattern = PSYS_SRC_PATTERN_EXPLODE;
//   Uses 2D angle between innerAngle and outerAngle
//integer pattern = PSYS_SRC_PATTERN_ANGLE;
//   Uses 3D cone spread between innerAngle and outerAngle
//integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE;
// 
//integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY;



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
    state_entry()
    {
        running=TRUE;
        llSetText("Running", <1.0, 1.0, 1.0>, 0.5);
        setParticles();
    }
    
    touch_start(integer num_detected)
    {
        if (running==TRUE)
        {
            running=FALSE;
            llSetText("Stopped", <1.0, 1.0, 1.0>, 0.5);
            llParticleSystem([]);
        }
        else
        {
            running=TRUE;
            llSetText("Running", <1.0, 1.0, 1.0>, 0.5);
            setParticles();
        }
    }
}
// END //
