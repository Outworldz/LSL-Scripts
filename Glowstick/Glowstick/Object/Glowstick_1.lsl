// :CATEGORY:Particles
// :NAME:Glowstick
// :AUTHOR:eltee Statowsky
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:356
// :NUM:479
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Glowstick.lsl
// :CODE:

//// eltee Statosky's Particle Creation Engine 1.0

integer effectFlags=0;
integer running=TRUE;
float red=1.0;
float green=0.0;
float blue=0.0;

// Color Secelection Variables
integer colorInterpolation  = TRUE;
vector  startColor          = <red, green, blue>;
vector  endColor            = <red, green, blue>;
float   startAlpha          = 1.0;
float   endAlpha            = 0.2;
integer glowEffect          = TRUE;


// Size & Shape Selection Variables
integer sizeInterpolation   = TRUE;
vector  startSize           = <0.1, 0.5, 0.0>;
vector  endSize             = <0.1, 0.5, 0.0>;
integer followVelocity      = TRUE;
string  texture             = "";


// Timing & Creation Variables Variables
float   particleLife        = 2.0;
float   SystemLife          = 0.0;
float   emissionRate        = 0.06;
integer partPerEmission     = 1;


// Angular Variables
float   radius              = 0.0;
float   innerAngle          = 0;
float   outerAngle          = 0;
vector  omega               = <0.0, 0.0, 0.0>;


// Movement & Speed Variables
float   minSpeed            = 0.0;
float   maxSpeed            = 0.01;
vector  acceleration        = <0.0, 0.0, 0.0>;
integer windEffect          = FALSE;
integer bounceEffect        = FALSE;
integer followSource        = FALSE;
//integer followTarget        = TRUE;
key     target              = "";


//As yet unimplemented particle system flags
integer randomAcceleration  = FALSE;
integer randomVelocity      = FALSE;
integer particleTrails      = FALSE;

// Pattern Selection
//integer pattern = PSYS_SRC_PATTERN_DROP;
//integer pattern = PSYS_SRC_PATTERN_EXPLODE;
integer pattern = PSYS_SRC_PATTERN_ANGLE;
//integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE;
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
        llSetText("", <0.0, 1.0, 0.0>, 0.5);
        running=TRUE;
        setParticles();
        llSetTimerEvent(0.2);
    }
    
   timer()
    {
        //Red event
        if(red >= 1.0)
        {
            if (blue > 0.1)
            {blue = blue - 0.1;}
            else
            {green = green + 0.1;}
        }
        
        if(green >= 1.0)
        {
            if (red > 0.1)
            {red = red - 0.1;}
            else
            {blue = blue + 0.1;}
        }
        
       if(blue >= 1.0)
        {
            if (green > 0.1)
            {green = green - 0.1;}
            else
            {red = red + 0.1;}
        }
        
        //Colors
        startColor          = <red, green, blue>;
        endColor            = <red, green, blue>;
        
        //Set color
        setParticles();
        llSetColor(<red, green, blue>,ALL_SIDES);
        
        //loop
        llSetTimerEvent(0.2);
    
    }
}
// END //
