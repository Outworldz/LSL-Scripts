// :SHOW:
// :CATEGORY:tipjar
// :NAME:Phaze TipJar
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2016-05-02 13:00:35
// :EDITED:2016-05-02  12:00:35
// :ID:1103
// :NUM:1890
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// This paricle script released butterflies from my tipjar when it was tipped.
// :CODE:
// Particle Script 0.4j
// Created by Ama Omega 3-7-2004
// Updated by Jopsy Pendragon 5-11-2004
// For classes/tutorials/tricks, visit the Particle Labratory in Teal
// Values marked with (*) are defaults.

integer flagger = 0;

// SECTION ONE: APPEARANCE -- These settings affect how each particle LOOKS.
integer      glow = TRUE;        // TRUE or FALSE(*)
vector startColor = <1,1,1>;     // RGB color, black<0,0,0> to white<1,1,1>(*)
vector   endColor = <1,1,1>;     // 
float  startAlpha = 1.0;         // 0.0 to 1.0(*), lower = more transparent
float    endAlpha = 1.0;         // 
vector  startSize = <0.0,0.0,0>; // <0.04,0.04,0>(min) to <10,10,0>(max>, <1,1,0>(*)
vector    endSize = <0.05,0.05,0>; // (Z part of vector is discarded)  
string    texture = "44c04376-637b-ef18-9404-723acd0fce91";          // Texture used for particles. Texture must be in prim's inventory.

// SECTION TWO: FLOW -- These settings affect how Many, how Quickly, and for how Long particles are created.
//     Note, 
integer count = 1;    // Number of particles created per burst, 1(*) to 4096
float    rate = 1;   // Delay between bursts of new particles, 0.0 to 60, 0.1(*)
float     age = 5.0;   // How long each particle lives, 0.1 to 60, 10.0(*)
float    life = 0.0;   // When to stop creating new particles. never stops if 0.0(*)

// SECTION THREE: PLACEMENT -- Where are new particles created, and what direction are they facing?
float      radius = 0.15;      // 0.0(default) to 64?  Distance from Emitter where new particles are created.
float  innerAngle = .1 ;  // "spread", for all ANGLE patterns, 0(default) to PI
float  outerAngle = .1;        // "tilt", for ANGLE patterns,  0(default) to TWO_PI, can use PI_BY_TWO or PI as well.
integer   pattern = PSYS_SRC_PATTERN_ANGLE_CONE; // Choose one of the following:
                // PSYS_SRC_PATTERN_EXPLODE (sends particles in all directions)
                // PSYS_SRC_PATTERN_DROP  (ignores minSpeed and maxSpeed.  Don't bother with count>1 )
                // PSYS_SRC_PATTERN_ANGLE_CONE (set innerangle/outerange to make rings/cones of particles)
                // PSYS_SRC_PATTERN_ANGLE (set innerangle/outerangle to make flat fanshapes of particles)
vector      omega = <0,0,0>; // How much to rotate the emitter around the <X,Y,Z> axises. <0,0,0>(*)
                             // Warning, there's no way to RESET the emitter direction once you use Omega!!
                             // You must attach the script to a new prim to clear the effect of omega.

// SECTION FOUR: MOVEMENT -- How do the particles move once they're created?
integer followSource = FALSE;   // TRUE or FALSE(*), Particles move as the emitter moves, (TRUE disables radius!)
integer    followVel = TRUE;    // TRUE or FALSE(*), Particles rotate towards their direction
integer         wind = FALSE;   // TRUE or FALSE(*), Particles get blown away by wind in the sim
integer       bounce = FALSE;   // TRUE or FALSE(*), Make particles bounce on Z altitude of emitter
float       minSpeed = 0.04;     // 0.01 to ? Min speed each particle is spit out at, 1.0(*)
float       maxSpeed = 0.08;     // 0.01 to ? Max speed each particle is spit out at, 1.0(*)
vector          push = <0,0,-0.03>; // Continuous force pushed on particles, use small settings for long lived particles
key           target = "";      // Select a target for particles to arrive at when they die
                                // can be "self" (emitter), "owner" (you), "" or any prim/persons KEY.

// SECTION FIVE:   Ama's "Create Short Particle Settings List"
integer  enableoutput = FALSE; // If this is TRUE, clicking on your emitter prim will cause it to speak
                // very terse "shorthand" version of your particle settings.  You can cut'n'paste
                // this abbreviated version into a call to llParticleSystem([ ]); in another script.
                // Pros:  Takes up far less scripting space, letting you focus on the rest of your code.
                // Cons:  makes tune your settings afterwards rather awkward

// === Don't muck about below this line unless you're comfortable with the LSL scripting language ====

// Script variables
integer pre = 2;          //Adjust the precision of the generated list.
integer flags;
list sys;
integer type;
vector tempVector;
rotation tempRot;
string tempString;
integer i;


Play()
{
        //llOwnerSay("Touched");
        count = 10;
        age = 30;  
        //minSpeed = 1.0;
        maxSpeed = 0.5 ;
        endSize = <1.5,1.5,0>; // (Z part of vector is discarded)  
        float x = llFrand(0.1);
        float y = llFrand(0.1);
        push = <x,y,0.03>; // Continuous force pushed on particles
        wind = TRUE; 
        updateParticles();
        llSleep(8);
        reset();
        updateParticles();
}



reset()
{
    
    count = 1;    // Number of particles created per burst, 1(*) to 4096
    age = 5.0;   // How long each particle lives, 0.1 to 60, 10.0(*)
    maxSpeed = 0.08; // speed issued at 
    endSize = <0.05,0.05,0>; // (Z part of vector is discarded)  
    push = <0,0,-0.03>; // Continuous force pushed on particles
    wind = FALSE; 

    
}

updateParticles()
{
    flags = 0;
    if (target == "owner") target = llGetOwner();
    if (target == "self") target = llGetKey();
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (startColor != endColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (startSize != endSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
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
    float newrate = rate;
    if (newrate == 0.0) newrate=.01;
    if ( (age/rate)*count < 4096) llParticleSystem(sys);
    else {
        llInstantMessage(llGetOwner(),"Your particle system creates too many concurrent particles.");
        llInstantMessage(llGetOwner(),"Reduce count or age, or increate rate.");
        llParticleSystem( [ ] );
    }

}

default
{
    state_entry()
    {
        reset();
        updateParticles();
    }
    
    touch_start(integer total_number)
    {
        llSay(0,"Butterfly Tip Jar for 'Phase Demesnes', pay it to pop!");  
    }
    
     link_message(integer sender_num, integer num, string msg, key id) 
     {
         Play();
     }


}
