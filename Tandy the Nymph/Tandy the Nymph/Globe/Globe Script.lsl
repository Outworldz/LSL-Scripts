// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1215
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:

// Globe script for Tandy the Nymph
// 12-10-2012

// License:
// Copyright (c) 2009, Ferd Frederix

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

vector size = <0.75,0.75,0.75>; // non tinies will need to set this size larger


integer enabled = 0;


particles(string aTexture)
{
    // mask flags - set to TRUE (or 1) to enable
    integer bounce = 0;    // Make particles bounce on Z plane of object
    integer glow = 1;        // Make the particles glow
    integer interpColor = 0;    // Go from start to end color
    integer interpSize = 1;    // Go from start to end size
    integer followSource = 0;    // Particles follow the source
    integer followVel = 1;    // Particles turn to velocity direction
    integer wind = 0;        // Particles affected by wind

    //pattern:
    //integer pattern = PSYS_SRC_PATTERN_ANGLE;
    //integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY;
    //integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE;
    //integer pattern = PSYS_SRC_PATTERN_DROP;
    integer pattern = PSYS_SRC_PATTERN_EXPLODE;

    // Select a target for particles to go towards
    // "" for no target, "owner" will follow object owner
    //    and "self" will target this object
    //    or put the key of an object for particles to go to
    //key target = "";
    key target = "";
    //key target = "owner";

    // particle parameters
    float age = 2;                  // Life of each particle

    float maxSpeed = .1;            // Max speed each particle is spit out at
    float minSpeed = .01;            // Min speed each particle is spit out at

 
    float startAlpha = 1;           // Start alpha (transparency) value
    float endAlpha = 1;           // End alpha (transparency) value (if interpColor = TRUE)

    vector startColor = <1,1,1>;    // Start color of particles <R,G,B>
    vector endColor = <1,0,0>;      // End color of particles <R,G,B> (if interpColor = TRUE)

    vector startSize = <.3,.3,0>;     // Start size of particles <x,y>
    vector endSize = <.1,.1,0>;       // End size of particles (if interpSize == TRUE)

    vector push = <0,0,-.1>;          // Force pushed on particles

    // system parameters
    float life = 0;             // Life in seconds for the system to make particles
    integer count = 2;        // How many particles to emit per BURST
    float rate = .1;            // How fast (rate) to emit particles
    float radius = .5;          // Radius to emit particles for BURST pattern
    float outerAngle = 1.54;    // Outer angle for all ANGLE patterns
    float innerAngle = 1.55;    // Inner angle for all ANGLE patterns
    vector omega = <0,0,0>;    // Rotation of ANGLE patterns around the source

    integer flags = 0;

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
        PSYS_SRC_TEXTURE, aTexture,
        PSYS_PART_START_ALPHA, startAlpha,
        PSYS_PART_END_ALPHA, endAlpha
            ]);
}


default
{
    state_entry()
    {
        llSetScale(size);
        enabled = ~ enabled;
        llSetTextureAnim(ANIM_ON | SMOOTH | LOOP , ALL_SIDES, 1, 1, 1.0, 1.0, 0.1);  // slide the texture in 10 seconds ( last param )
        llSetTimerEvent(1);
    }

    timer()
    {      
        
        if (llGetAgentInfo(llGetOwner()) & AGENT_IN_AIR)
            enabled = TRUE;
        else
            enabled = FALSE;

        if (enabled)
        {
         
            llSetAlpha(0.1, ALL_SIDES);
            llSetPrimitiveParams([PRIM_GLOW,ALL_SIDES,0.02]);
            particles(llGetInventoryName(INVENTORY_TEXTURE,(integer)llFrand(llGetInventoryNumber(INVENTORY_TEXTURE))));
            llSetScale(size);
        }
        else if (!enabled )
        {
         
            llSetAlpha(0, ALL_SIDES);
            llSetPrimitiveParams([PRIM_GLOW,ALL_SIDES,0.0]);
            llParticleSystem([]);
            llSetScale(<.1,.1,.1>);
  
        }

    }


    
    on_rez(integer p)
    {
        llSetAlpha(0.1, ALL_SIDES);
        llSetScale(<1,1,1>);
    }


}

