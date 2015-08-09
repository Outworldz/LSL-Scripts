// :CATEGORY:Particles
// :NAME:Fireworks
// :AUTHOR:Ama Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:304
// :NUM:403
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Ama Omega Particle Script 0.lsl
// :CODE:

// Particle Script 0.5
// Created by Ama Omega
// 3-26-2004

// Mask Flags - set to TRUE to enable
integer glow = TRUE;            // Make the particles glow
integer bounce = FALSE;          // Make particles bounce on Z plane of object
integer interpColor = TRUE;     // Go from start to end color
integer interpSize = TRUE;      // Go from start to end size
integer wind = TRUE;           // Particles effected by wind
integer followSource = TRUE;    // Particles follow the source
integer followVel = TRUE;       // Particles turn to velocity direction

// Choose a pattern from the following:
// PSYS_SRC_PATTERN_EXPLODE
// PSYS_SRC_PATTERN_DROP
// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
// PSYS_SRC_PATTERN_ANGLE_CONE
// PSYS_SRC_PATTERN_ANGLE
integer pattern = PSYS_SRC_PATTERN_EXPLODE;

// Select a target for particles to go towards
// "" for no target, "owner" will follow object owner 
//    and "self" will target this object
//    or put the key of an object for particles to go to
key target = "self";

// Particle paramaters
float age = 1;                  // Life of each particle
float maxSpeed = 1;            // Max speed each particle is spit out at
float minSpeed = 1;            // Min speed each particle is spit out at
string texture = "";                 // Texture used for particles, default used if blank
float startAlpha = 1;           // Start alpha (transparency) value
float endAlpha = 0.1;           // End alpha (transparency) value
vector startColor = <0,1,0>;    // Start color of particles <R,G,B>
vector endColor = <1,0,0>;      // End color of particles <R,G,B> (if interpColor == TRUE)
vector startSize = <1,1,1>;     // Start size of particles 
vector endSize = <1,0,1>;       // End size of particles (if interpSize == TRUE)
vector push = <0,0,0>;          // Force pushed on particles

// System paramaters
float rate = 1.5;            // How fast (rate) to emit particles
float radius = 1;          // Radius to emit particles for BURST pattern
integer count = 1;        // How many particles to emit per BURST 
float outerAngle = 1.54;    // Outer angle for all ANGLE patterns
float innerAngle = 1.55;    // Inner angle for all ANGLE patterns
vector omega = <0,0,0>;    // Rotation of ANGLE patterns around the source
float life = 0;             // Life in seconds for the system to make particles

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
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
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
                            
    llParticleSystem(sys);
}

default
{
    state_entry()
    {
        updateParticles();
    }
    
    touch_start(integer num)
    {
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
        sys = llListSort(sys,2,TRUE);
        if (target == "") sys = llDeleteSubList(sys,38,39);
        else if (target == llGetKey() ) 
            sys = llListInsertList(llDeleteSubList(sys,39,39),["llGetKey()"],39);
        else if (target == llGetOwner() ) 
            sys = llListInsertList(llDeleteSubList(sys,39,39),["llGetOwner()"],39);
        if (texture == "") sys = llDeleteSubList(sys,24,25);
        if (!interpSize) sys = llDeleteSubList(sys,12,13);
        if (!interpColor) sys = llDeleteSubList(sys,6,7);

        llWhisper(0,"[" + llList2CSV(llList2List(sys,0,21)) + ",");
        llWhisper(0,llList2CSV(llList2List(sys,22,-1)) + "]");
    }
}// END //
