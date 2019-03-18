// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1223
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:

integer secs = 0;

integer particles = TRUE;

integer glow = TRUE;        // Make the particles glow from inside
                            // if FALSE they will be effected by the local light.
                            
integer bounce = FALSE;     // Particles won't go lower than the emitter and will                                  //bounce on the "ground" level if negative push is applied.

integer interpColor = TRUE;     // Changes from start to end color
                                // Start and End colors are set below

integer interpSize = TRUE;      // Changes from start to end size
                                // Also Set below

integer wind = FALSE;           // Particles effected by wind
                                // Particles REALLY effected, will fly like crazy

integer followSource = FALSE;    // Particles follow the emitter, so they will move
                                 // In direct lines even if emitter is in motion
                                 // IF FALSE they will sway like smoke, leaving a trail

integer followVel = TRUE;       // Particles will emit in direction object facing
integer pattern = PSYS_SRC_PATTERN_EXPLODE;

key target = "";
float age = 2;                // How long each particle will survive
float maxSpeed = .1;          // Max speed each particle is spit out at
float minSpeed = .1;          // Min speed each particle is spit out at

string texture = "";            // Texture used for particles, default used if blank
                                // Type the name of the texture in the " ", Make sure 
                                // To drag the Texture into the emitters contents.

float startAlpha = 1.0;         // Start alpha (transparency) value
float endAlpha = 0.5;           // End alpha (transparency) value
                                // Alpha is between 0.0 and 1.0
//remove the // from the two lines below and put // in front of 172 and 173
vector StartColor = <1, .7, 0>;    // Starting color of particles <R,G,B>
vector EndColor = <1, 0.3, 0.3>;     // End color of particles <R,G,B> 
                                // <0,0,0> = Black <1,1,1> = White
                                // InterpColor (above) must be TRUE for color to change

vector startSize = <.2, .2, 0>; // Start size of particles 
vector endSize = <.4, .4, 0>;   // End size of particles (if interpSize == TRUE)
                                    // Size Range is 0.01 to 7.00
                                    // Further the 3rd number doesn't effect anything

vector push = <0,0,0>;          // Force pushed on particles (X,Y,Z)
                                  // X = East/West    Y = North/South    Z= Up/Down
    
    
// PARTICLE PARAMETERS
float rate = .01;           // How many seconds between particle emissions
float radius = .01;          // Starting radius for Particles to appear within
integer count = 10;           // How many particles per emission (Per Rate) 


float outerAngle = 1.54;    // Outer angle for all ANGLE patterns (for a stream 0.1)
float innerAngle = 1.54;    // Inner angle for all ANGLE patterns (for a stream 0.0)
                            // In Radians, so every 1 is 90 degrees between 0 and 3

vector omega = <0,0,0>;    // Rotation of ANGLE patterns (X,Y,Z axis (E/W,N/S,UP/DOWN)
                           // This rotates the spray in a circle, not the particles

float life = 0;             // Time from Start to Stop to emit Particles
        
// Script variables
integer flags;

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

    llParticleSystem([  PSYS_PART_MAX_AGE,age,
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, StartColor,
                        PSYS_PART_END_COLOR, EndColor,
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

float red;
float green;
float blue;


default
{
    state_entry()
    {
        llSetStatus(PRIM_PHYSICS,TRUE);
        llSetBuoyancy(1);
        llSetDamage(0.25);    // 1/4 damage
        llSetStatus(PRIM_TEMP_ON_REZ, TRUE); 
        updateParticles();
    }

    collision_start(integer i){
        if (secs <1)
            return;
            
        llPushObject(llDetectedKey(0),<100,100,100>,<0,0,0>,TRUE);
        startSize  = <1,1,1>;
        endSize  = <1,1,1>;
        StartColor = <1,1,1>;
        EndColor = <1,1,1>;
        age = 3;
        updateParticles();
        llSleep(1);
        llDie();    
    }
    
    land_collision_start(vector pos) {

        startSize  = <1,1,1>;
        endSize  = <1,1,1>;
        StartColor = <1,1,1>;
        EndColor = <1,1,1>;
        age = 3;
        updateParticles();
        llSleep(1);
        llDie();
    }
    
    on_rez(integer para){

        llSetTimerEvent(1);
        
        red = (float) (para & 0xff0000)/256/256;
        blue = (float) (para  & 0xff00)/256;
        green =  (float) (para & 0xff);
    

        StartColor =< red/256, green/256,blue/256>;
        EndColor = <llFrand(1.0), llFrand(1.0), llFrand(1.0)>;
        updateParticles();
    }       
    
   
    
    
    timer()
    { 
        if (secs++ > 10)
            llDie();
    }

}

