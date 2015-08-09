// :CATEGORY:Particles
// :NAME:tropfen
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:922
// :NUM:1326
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// tropfen.lsl
// :CODE:

//This is an updated version of a normal particle script- James Hanner
// Mask Flags - set to TRUE to enable
integer glow = TRUE;            // Make the particles glow
integer bounce = FALSE;          // Make particles bounce on Z plane of object
integer interpColor = TRUE;     // Go from start to end color
integer interpSize = TRUE;      // Go from start to end size
integer wind = FALSE;           // Particles effected by wind
integer followSource = TRUE;    // Particles follow the source
integer followVel = FALSE;       // Particles turn to velocity direction

//Set these as the channel and message to use to turn on and off the system
integer ch = 42;
string messageon = "";
string messageoff = "";

// Choose a pattern from the following:
// PSYS_SRC_PATTERN_EXPLODE
// PSYS_SRC_PATTERN_DROP
// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
// PSYS_SRC_PATTERN_ANGLE_CONE
// PSYS_SRC_PATTERN_ANGLE
integer pattern = PSYS_SRC_PATTERN_DROP;

// Select a target for particles to go towards
// "" for no target, "owner" will follow object owner 
//    and "self" will target this object
// and "detected" to use the nearest person
//    or put the key of an object for particles to go to
key target = "";

// Particle paramaters
float age = 4;                  // Life of each particle
float maxSpeed = 15;            // Max speed each particle is spit out at
float minSpeed = 1.5;            // Min speed each particle is spit out at
string texture = "28adc6ed-a359-1512-68a9-6a2b4b77c7b7";                 // Texture used for particles, default used if blank
float startAlpha = .7;           // Start alpha (transparency) value
float endAlpha = .4;           // End alpha (transparency) value
vector startColor = <.8,.8,.9>;    // Start color of particles <R,G,B>
vector endColor = <1,.6,.2>;      // End color of particles <R,G,B> (if interpColor == TRUE)
vector startSize = <.13,.13,.13>;     // Start size of particles 
vector endSize = <0.11,0.11,0.11>;       // End size of particles (if interpSize == TRUE)
vector push = <0, 0, -3>;          // Force pushed on particles

// System paramaters
float rate = 1;            // How fast (rate) to emit particles
float radius = 0.2;          // Radius to emit particles for BURST pattern
integer count = 1;        // How many particles to emit per BURST 
float outerAngle = 0;    // Outer angle for all ANGLE patterns float outerAngle = 1.54
float innerAngle = 0;    // Inner angle for all ANGLE patterns float innerAngle = 1.55
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
    if(target == "detected") target = llDetectedKey(0);
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
                        PSYS_SRC_ANGLE_BEGIN,innerAngle, 
                        PSYS_SRC_ANGLE_END,outerAngle,
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
    on_rez(integer dummy){llResetScript();}
    state_entry()
    {
        updateParticles();                //Start making particles
        llListen(ch, "", NULL_KEY, messageoff);
    }

    listen(integer channel, string name, key id, string message)
    {
        state off;        //Switch to the off state
    }
}

state off
{
    state_entry()
    {
        llParticleSystem([]);        //Stop making particles
        llListen(ch, "", NULL_KEY, messageon);
    }
    
    listen(integer channel, string name, key id, string message)
    {
    state default;
    }
}// END //
