// :CATEGORY:XS Pet
// :NAME:Breedable_pet_eye_scripts
// :AUTHOR:Ferd Frederix
// :CREATED:2012-08-16 10:21:14.630
// :EDITED:2013-09-17 21:48:30
// :ID:116
// :NUM:175
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Combined eye and particle script.// // This script flips between two textures for eye blinking and also supports a 'dead' eye look.  It combines the particle plug-in with eyes together.    It may be more useful on non-robot pets.// An article on how to use it, including a set of example eye textures, is located at <a href="http://www.outworldz.com/secondlife/posts/breedable-pet-robot/blinking%20eyes.htm">http://www.outworldz.com/secondlife/posts/breedable-pet-robot/blinking%20eyes.htm</a>
// :CODE:
// This code is licensed as Creative Commons Attribution/NonCommercial/Share Alike

// See http://creativecommons.org/licenses/by-nc-sa/3.0/
// Noncommercial -- You may not use this work for commercial purposes
// If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
// This means that you cannot sell this code but you may share this code.
// You must attribute authorship to me and leave this notice intact.
//
// Exception: I am allowing this script to be sold inside an original build.
// You are not selling the script, you are selling the build.
// Ferd Frederix



// the names of the textures for eyes that shut and close by flipping between them.
string OPEN = "cubit_eyes open";
string CLOSED = "cubit_eyes closed";
string DEAD = "cubit_eyes dead";    // could be a copy of eyes closed, or (X)(X)


string ANI_DIE = "death";		        // a string taught to the pet by the animator when the animal is to die.
string ANI_SLEEP  = "sleep";           // Sleeping
string ANI_STAND = "stand";             // default standing animation

integer flags;
// Original Particle Script 0.4j
// Created by Ama Omega 3-7-2004
// Updated by Jopsy Pendragon 5-11-2004
// For classes/tutorials/tricks, visit the Particle Labratory in Teal
// Values marked with (*) are defaults.

// SECTION ONE: APPEARANCE -- These settings affect how each particle LOOKS.
integer      glow = TRUE;        // TRUE or FALSE(*)
vector startColor = <1,1,1>;     // RGB color, black<0,0,0> to white<1,1,1>(*)
vector   endColor = <1,1,1>;     //
float  startAlpha = 1.0;         // 0.0 to 1.0(*), lower = more transparent
float    endAlpha = 1.0;         //
vector  startSize = <0.1,0.1,0>; // <0.04,0.04,0>(min) to <10,10,0>(max>, <1,1,0>(*)
vector    endSize = <.3,.3,0>; // (Z part of vector is discarded)
key texture = "f9b67edf-d837-e507-361b-0d34f4c64396";          // Texture used for particles. Texture must be in prim's inventory.

// SECTION TWO: FLOW -- These settings affect how Many, how Quickly, and for how Long particles are created.
//     Note,
integer count = 1;    // Number of particles created per burst, 1(*) to 4096
float    rate = 1.0;   // Delay between bursts of new particles, 0.0 to 60, 0.1(*)
float     age = 5.0;   // How long each particle lives, 0.1 to 60, 10.0(*)
float    life = 0.0;   // When to stop creating new particles. never stops if 0.0(*)

// SECTION THREE: PLACEMENT -- Where are new particles created, and what direction are they facing?
float      radius = .30;      // 0.0(default) to 64?  Distance from Emitter where new particles are created.
float  innerAngle = 0.75;  // "spread", for all ANGLE patterns, 0(default) to PI
float  outerAngle = 0.0;        // "tilt", for ANGLE patterns,  0(default) to TWO_PI, can use PI_BY_TWO or PI as well.
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
integer    followVel = FALSE;    // TRUE or FALSE(*), Particles rotate towards their direction
integer         wind = FALSE;   // TRUE or FALSE(*), Particles get blown away by wind in the sim
integer       bounce = TRUE;   // TRUE or FALSE(*), Make particles bounce on Z altitude of emitter
float       minSpeed = 0.1;     // 0.01 to ? Min speed each particle is spit out at, 1.0(*)
float       maxSpeed = 0.2;     // 0.01 to ? Max speed each particle is spit out at, 1.0(*)
vector          push = <0,0,-0.3>; // Continuous force pushed on particles, use small settings for long lived particles
key           target = "";      // Select a target for particles to arrive at when they die
// can be "self" (emitter), "owner" (you), "" or any prim/persons KEY.

list sys;

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

    on_rez(integer startparam)
    {
        llResetScript();
    }

    state_entry()
    {
        llSetTexture(OPEN, ALL_SIDES); // open
        llSetTimerEvent(llFrand(3) + 3);
    }


    timer()
    {
        llSetTexture(CLOSED, ALL_SIDES);         // closed
        llSleep(llFrand(0.2) + .1);              // sometimes blink a little faster, from 0.2 to 0.3
        llSetTexture(OPEN, ALL_SIDES);          // open
        llSetTimerEvent(llFrand(3) + 3);	    // make them blink randomly
    }


    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 1 && str == ANI_SLEEP )
        {
            llSetTexture(CLOSED, ALL_SIDES); //closed
            updateParticles();    // turn on particle Zzzz's
            llSetTimerEvent(0);		// no blink
        }

        else if (num == 1 && str == ANI_STAND)
        {
            llParticleSystem( [] );        // turn off particle ZZZ's by sending an empty list
            llSetTexture(OPEN, ALL_SIDES); //open
            llSetTimerEvent(llFrand(3) + 3);

        }
        else if (num == 1 && str == ANI_DIE)
        {
            llSetTexture(DEAD ,ALL_SIDES) ; //  dead eye (X)(X) texture
            llParticleSystem( [ ] );        // turn off particle ZZZ's
            llSetTimerEvent(0);		        // no blink
        }
    }
}
