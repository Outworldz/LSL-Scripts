// :CATEGORY:Vehicles
// :NAME:Attitude_Indicator_Artificial_Horiz
// :AUTHOR:Timeless Prototype
// :CREATED:2011-09-04 15:50:28.580
// :EDITED:2013-09-18 15:38:48
// :ID:58
// :NUM:85
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// DESCRIPTION: []::Attitude_Indicator_Artificial_Horizizon
// :CODE:
// myGetRoll(), myGetPitch(), myGetBearing(), mySetHorizonTexture()
// by Timeless Prototype
// Helps with attitude indicator (artificial horizon) display on a prim, plus a few other functions you will probably want for any flying vehicle instruments.
// Created 2009-12-01
// Please give credit to Timeless Prototype in documentation when using anything from this script.

key craftKey = NULL_KEY;

// Returns the roll relative to the horizon (0.0), ranging from 90.0 (right wing down) to -90.0 (left wing down). Assumes frame of reference is East-facing at zero rotation.
float myGetRoll(rotation rot)
{
    vector vOffset = <0,1,0> * rot;
    vector noX = <0.0, llVecMag(<0.0, vOffset.x, vOffset.y>), vOffset.z>;
    float roll = llAtan2(noX.z, noX.y) * RAD_TO_DEG;
    // However, this is the only indicator we're using to check if we're upside down.
    // Therefore the only indicator we want to exceed the -90.0 and 90.0 thresholds.
    vector upsideDownCheck = <0,0,1> * rot;
    if (upsideDownCheck.z < 0.0)
    {
        if (roll < 0.0)
        {
            roll = -180.0 - roll;
        }
        else
        {
            roll = 180.0 - roll;
        }
    }
    return roll * DEG_TO_RAD;
}


// Returns the pitch relative to the horizon (0.0), ranging from 90.0 (up) to -90.0 (down). Assumes frame of reference is East-facing at zero rotation.
float myGetPitch(rotation rot)
{
    vector vOffset = <1,0,0> * rot;
    vector noY = <llVecMag(<vOffset.x, vOffset.y, 0.0>), 0.0, vOffset.z>;
    return llAtan2(noY.z, noY.x);
}

// Returns a compass bearing. Assumes frame of reference is East-facing at zero rotation.
float myGetBearing(rotation rot)
{
    vector vOffset = <1,0,0> * rot;
    float bearing = llAtan2(vOffset.x, vOffset.y) * RAD_TO_DEG;
    if (bearing < 0.0)
    {
        bearing += 360.0;
    }
    return bearing * DEG_TO_RAD;
}


mySetHorizonTexture(rotation vehicleRotation, integer primFace) {
    llSetPrimitiveParams([PRIM_TEXTURE, primFace, "973bb206-0812-89e6-21d3-a268f47dfa65", <0.3, 0.3, primFace>, <0.0, (myGetPitch(vehicleRotation)/6.39)-0.25, primFace>, myGetRoll(vehicleRotation)]);
}

default
{
    state_entry()
    {
        llSetTimerEvent(0.0);
        llListen(55, "", NULL_KEY, "");
    }
    
    attach(key id)
    {
        llSetTimerEvent(0.0);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (llSubStringIndex(message, "cmd|hud|connect|") == 0)
        {
            key pilotId = (key)llGetSubString(message, 16, -1);
            if (pilotId == llGetOwner())
            {
                craftKey = id;
                llSetTimerEvent(0.5);
            }
        }
    }

    timer()
    {
        list details = llGetObjectDetails(craftKey, [OBJECT_NAME, OBJECT_POS, OBJECT_ROT, OBJECT_VELOCITY]);
        if (llList2String(details, 2) == "")
        {
            llSetTimerEvent(0.0);
            llOwnerSay("Vehicle has left the region. Please use autopilot features to control the vehicle.");
        }
        mySetHorizonTexture((rotation)llList2String(details, 2), 4);
    }
}

