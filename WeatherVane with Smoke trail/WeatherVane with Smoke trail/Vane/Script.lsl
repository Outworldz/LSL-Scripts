// :CATEGORY:Weather
// :NAME:WeatherVane with Smoke trail
// :AUTHOR:Dana Moore
// :CREATED:2014-01-20 18:13:30
// :EDITED:2014-01-20 18:13:30
// :ID:1014
// :NUM:1568
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Makes a prim rotate and face the wind with smoke trailing from it.
// :CODE:

// Copyright (c) 2008, Scripting Your World
// All rights reserved.
//
// Scripting Your World
// By Dana Moore, Michael Thome, and Dr. Karen Zita Haigh
// http://syw.fabulo.us
// http://www.amazon.com/Scripting-Your-World-Official-Second/dp/0470339837/
//
// You are permitted to use, share, and adapt this code under the 
// terms of the Creative Commons Public License described in full
// at http://creativecommons.org/licenses/by/3.0/legalcode.
// That means you must keep the credits, do nothing to damage our
// reputation, and do not suggest that we endorse you or your work.

float gTimerInterval = 2.0; // check wind direction every 2 seconds

smokeParticleSystem()
{
    llParticleSystem([
        PSYS_PART_FLAGS,            PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK | PSYS_PART_WIND_MASK,
        PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE,
        PSYS_PART_START_COLOR,      <0.6, 0.6, 0.6>,
        PSYS_PART_END_COLOR,        <0.8, 0.8, 0.8>,
        PSYS_PART_START_ALPHA,      1.0,
        PSYS_PART_END_ALPHA,        0.0,
        PSYS_PART_START_SCALE,      <0.1, 0.1, 0.0>,
        PSYS_PART_END_SCALE,        <0.5, 0.5, 0.0>,
        PSYS_PART_MAX_AGE,          2.5,
        PSYS_SRC_ACCEL,             <0.0, 0.0, -0.01>,
        PSYS_SRC_TEXTURE,           "d1df5743-efa9-8fab-0d2f-8c206931299b",
        PSYS_SRC_BURST_RATE,        0.04,
        PSYS_SRC_INNERANGLE,        0.0,
        PSYS_SRC_OUTERANGLE,        0.0,
        PSYS_SRC_BURST_PART_COUNT,  1,
        PSYS_SRC_BURST_RADIUS,      0.0,
        PSYS_SRC_BURST_SPEED_MIN,   0.0,
        PSYS_SRC_BURST_SPEED_MAX,   0.1
    ]);
}

float calcWindAngle() {
    vector windVelocity = llWind(ZERO_VECTOR);
    float windDir=llAtan2(windVelocity.y,windVelocity.x);
    
    // adjust for rotation of root
    quaternion currRotQ=llGetRootRotation();
    vector currRotE=llRot2Euler(currRotQ);    
    float relativeWindAngle = windDir - currRotE.z;

    return relativeWindAngle;
}

default
{
    state_entry()
    {
        smokeParticleSystem();
        llSetTimerEvent( gTimerInterval );
    }

    timer()
    {
        float windAngle = calcWindAngle();
        
        quaternion windAngleQ = llEuler2Rot(<0.0,0.0,windAngle>);
        quaternion currentRotQ = llGetLocalRot();
        quaternion deltaRotQ = windAngleQ / currentRotQ;
        
        quaternion newRotQ = currentRotQ * deltaRotQ;
        vector currentOffset = llGetLocalPos();
        vector newOffset = currentOffset * deltaRotQ;
    
        llSetLocalRot( newRotQ );
        llSetPos( newOffset ); 
    }
}
