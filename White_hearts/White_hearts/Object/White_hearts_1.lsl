// :CATEGORY:Particles
// :NAME:White_hearts
// :AUTHOR:Ama Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:976
// :NUM:1398
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Ama's_Jopsy's Particle Script 0.lsl
// :CODE:

// Particle Script 0.4j
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
vector    endSize = <0.1,0.1,0>; // (Z part of vector is discarded)  
string    texture = "heartatvalentine";          // Texture used for particles. Texture must be in prim's inventory.

// SECTION TWO: FLOW -- These settings affect how Many, how Quickly, and for how Long particles are created.
//     Note, 
integer count = 5;    // Number of particles created per burst, 1(*) to 4096
float    rate = 0.1;   // Delay between bursts of new particles, 0.0 to 60, 0.1(*)
float     age = 3.0;   // How long each particle lives, 0.1 to 60, 10.0(*)
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
integer         wind = TRUE;   // TRUE or FALSE(*), Particles get blown away by wind in the sim
integer       bounce = FALSE;   // TRUE or FALSE(*), Make particles bounce on Z altitude of emitter
float       minSpeed = 0.3;     // 0.01 to ? Min speed each particle is spit out at, 1.0(*)
float       maxSpeed = 0.2;     // 0.01 to ? Max speed each particle is spit out at, 1.0(*)
vector          push = <0,0,-0.3>; // Continuous force pushed on particles, use small settings for long lived particles
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

string float2String(float in)
{
    return llGetSubString((string)in,0,pre - 7);
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
integer onoff;
default
{
    state_entry()
    {
        onoff=0;
        updateParticles();
    }
    
    touch_start(integer num)
    {
        if ( enableoutput == FALSE ) {
            if ( onoff ) llResetScript();
            onoff++;
            llParticleSystem( [ ] );
            return;
        }
        if (1) return;  //  Comment out this line to enable this function
        llWhisper(0,"...Generating List...");
        for (i=1;i<42;i+=2)
        {
            type = llGetListEntryType(sys,i);
            if(type == TYPE_FLOAT)
            {
                tempString = float2String(llList2Float(sys,i));
                sys = llDeleteSubList(sys,i,i);
                sys = llListInsertList(sys,[tempString],i);
            }
            else if (type == TYPE_VECTOR)
            {
                tempVector = llList2Vector(sys,i);
                tempString = "<" + float2String(tempVector.x) + "," 
                    + float2String(tempVector.y) + "," 
                    + float2String(tempVector.z) + ">";
                sys = llDeleteSubList(sys,i,i);
                sys = llListInsertList(sys,[tempString],i);
            }
            else if (type == TYPE_ROTATION)
            {
                tempRot = llList2Rot(sys,i);
                tempString = "<" + float2String(tempRot.x) + "," 
                    + float2String(tempRot.y) + "," 
                    + float2String(tempRot.z) + "," 
                    + float2String(tempRot.s) + ">";
                sys = llDeleteSubList(sys,i,i);
                sys = llListInsertList(sys,[tempString],i);
            }
            else if (type == TYPE_STRING || type == TYPE_KEY)
            {
                tempString = "\"" + llList2String(sys,i) + "\"";
                sys = llDeleteSubList(sys,i,i);
                sys = llListInsertList(sys,[tempString],i);
            }
        }
        i = llListFindList(sys,[20,""]);
        if (i != -1) sys = llDeleteSubList(sys,i,i+1);
        llWhisper(0,"[" + llList2CSV(llList2List(sys,0,22)) + ",");
        llWhisper(0,llList2CSV(llList2List(sys,23,-1)) + "]");
    }
}// END //
