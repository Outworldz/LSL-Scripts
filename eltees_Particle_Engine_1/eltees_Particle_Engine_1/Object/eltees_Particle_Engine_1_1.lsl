// :CATEGORY:Particles
// :NAME:eltees_Particle_Engine_1
// :AUTHOR:eltee Statosky
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:278
// :NUM:371
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// eltee's Particle Engine 1.lsl
// :CODE:

//////////////////////////////////////////////////////////////////
//// eltee Statosky's Particle Creation Engine 1.5
//// 09/09/2004
//// *PUBLIC DOMAIN*
//// Free to use/copy/poke/ripoff and sell stuff with
//////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////
// Effect Flag Collection variable
///////////////////////////////////////////////////////
integer effectFlags;
integer running=TRUE;


///////////////////////////////////////////////////////
// Color Variables
// 
//      These affect color and transparency
///////////////////////////////////////////////////////
// colorInterpolation TRUE gives a smooth start to end change
// The colors are presented as <R, G, B> values between 0 and 1
// The alphas are transparency. 1.0 is solid, 0.0 is clear
// glowEffect TRUE has bright 'light like' particles
// glowEffect FALSE has unlit 'smoke like' particles
integer colorInterpolation =        TRUE;
vector  startColor =                <0.5, 0.0, 0.75>;
vector  endColor =                  <0.0, 1.0, 1.0>;
float   startAlpha =                1.0;
float   endAlpha =                  0.0;
integer glowEffect =                TRUE;


///////////////////////////////////////////////////////
// Size & Shape Variables
//
//      These affect the particle's physical appearance
///////////////////////////////////////////////////////
// sizeInterpolation TRUE gives a smooth start to end change
// The sizes are presented as <X, Y, 0.0> (z is meaningless)
// followVelocity TRUE is the only way to get particles to 
// 'tilt' but can be very tricky to implement
// texture = "texturename" loads texturename as particle shape 
integer sizeInterpolation =         TRUE;
vector  startSize =                 <0.5, 0.5, 0.0>;
vector  endSize =                   <0.5, 0.5, 0.0>;
integer followVelocity =            TRUE;
string  texture =                   "p_lightflare";


///////////////////////////////////////////////////////
// Timing & Creation Variables Variables
//
//      Affects the number and density of particles
///////////////////////////////////////////////////////
// ParticleLife sets the Lifetime of one particle (seconds)
// SystemLife sets the lifetime of the emitter (0.0 is infinite)
// EmissionRate is how many seconds between particle spawns
// PartPerEmission is how many particles spawn at a time
float   particleLife =              1.0;
float   SystemLife =                0.0;
float   emissionRate =              0.25;
integer partPerEmission =           1;


///////////////////////////////////////////////////////
// 3D Particle Space Variables
//
//      Affect how the particles spawn into the world
///////////////////////////////////////////////////////
// The radius is used to spawn angular particle patterns
// The angles are represented on 'both' sides of a prim
// The begin angle is the 'upper' starting point (radians)
// The end angle is the 'lower' stopping point (radians)
// Omega sets the speed of rotation about the <x,y,z> axis
float   radius =                    0.0;
float   beginAngle =                0.0;
float   endAngle =                  0.0;
vector  omega =                     <0.0, 0.0, 0.0>;


///////////////////////////////////////////////////////
// Movement & Speed Variables
// 
//      Affects how particles travel in 3D space
///////////////////////////////////////////////////////
// The speed values set the minimum and maximum speed
// particles have upon spawning.
// The acceleration is global to all particles (think gravity)
// WindEffect TRUE applies the current sim wind to particles
// BounceEffect TRUE means particles bounce on the 'floor'
// aka the z height of their emitter
// FollowSource TRUE means particles start on their emitter
// and move as it moves.
// FollowTarget means particles travel in linear path from 
// emitter to their target object
// Target is declared here but used in the setParticles function
float   minSpeed =                  0.02;
float   maxSpeed =                  0.02;
vector  acceleration =              <0.0, 0.0, 0.0>;
integer windEffect =                FALSE;
integer bounceEffect =              FALSE;
integer followSource =              TRUE;
integer followTarget =              FALSE;
key     target;


///////////////////////////////////////////////////////
// Pattern Selection    
//      
//      (Uncomment one of the following)
///////////////////////////////////////////////////////
// DROP simply drops the particles at the emitters center
// EXPLODE has all particles moving outward from the center
// ANGLE has particles at radius distance and between angle
// values in a 2D plane shape
// ANGLE_CONE has particles at radius distance and between
// angle values in a 3D cone shape

//integer pattern =                   PSYS_SRC_PATTERN_DROP;
integer pattern =                   PSYS_SRC_PATTERN_EXPLODE;
//integer pattern =                   PSYS_SRC_PATTERN_ANGLE;
//integer pattern =                   PSYS_SRC_PATTERN_ANGLE_CONE;



///////////////////////////////////////////////////////
// Particle System Call Function
// 
//      Calling this function applies the particle 
//      parameters to the current prim the script is in.
///////////////////////////////////////////////////////
setParticles()
{
// Here is where to set the current target to any valid key
//    target=llGetKey();    //Targets the emitter
//    target=llGetOwner();  //Targets the owner

// The following if statements are used to construct the mask 
    if (colorInterpolation) effectFlags = effectFlags|PSYS_PART_INTERP_COLOR_MASK;
    if (sizeInterpolation)  effectFlags = effectFlags|PSYS_PART_INTERP_SCALE_MASK;
    if (windEffect)         effectFlags = effectFlags|PSYS_PART_WIND_MASK;
    if (bounceEffect)       effectFlags = effectFlags|PSYS_PART_BOUNCE_MASK;
    if (followSource)       effectFlags = effectFlags|PSYS_PART_FOLLOW_SRC_MASK;
    if (followVelocity)     effectFlags = effectFlags|PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target!="")       effectFlags = effectFlags|PSYS_PART_TARGET_POS_MASK;
    if (glowEffect)         effectFlags = effectFlags|PSYS_PART_EMISSIVE_MASK;
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
        PSYS_SRC_ANGLE_BEGIN,       beginAngle,
        PSYS_SRC_ANGLE_END,        endAngle,
        PSYS_SRC_BURST_PART_COUNT,  partPerEmission,      
        PSYS_SRC_BURST_RADIUS,      radius,
        PSYS_SRC_BURST_SPEED_MIN,   minSpeed,
        PSYS_SRC_BURST_SPEED_MAX,   maxSpeed, 
        PSYS_SRC_MAX_AGE,           SystemLife,
        PSYS_SRC_TARGET_KEY,        target,
        PSYS_SRC_OMEGA,             omega   ]);
}

vector colorChoose()
{
    integer col=0;
    col=(integer)llFrand(12);  
    if (col==0) return <1,0,0>;
    if (col==1) return <0,1,0>;
    if (col==2) return <0,0,1>;
    if (col==3) return <1,1,0>;
    if (col==4) return <1,0,1>;
    if (col==5) return <0,1,1>;
    if (col==6) return <1,0.5,0>;
    if (col==7) return <1,0,0.5>;
    if (col==8) return <0.5,1,0>;
    if (col==9) return <0,1,0.5>;
    if (col==10) return <0.5,0,1>;
    if (col==11) return <0,0.5,1>;
    return <1,1,1>; 
}

default
{
    state_entry()
    {
        startColor=colorChoose();
        endColor=startColor;
        setParticles();
        llListen(0, "", "", "");
    }
    
    on_rez(integer param)
    {
        startColor=colorChoose();
        endColor=startColor;
        setParticles();
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        if (id==llGetOwner())
        {
            if (msg=="die")
            {
                llDie();
            }
        }   
    }
}
// END //
