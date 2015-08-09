// :CATEGORY:Clock
// :NAME:AnalogClock
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:34
// :NUM:46
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Minute Hand
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

// Listing 10.2: Clock Hands
integer gCurrentHour;
integer gCurrentMin;

setHandPosition(integer hours, integer minutes) {
    integer degrees;
    if (llGetObjectName() == "MinuteHand") {
        float degreesPerMinute = 360.0 / 60.0;
        degrees = (integer)(minutes * degreesPerMinute);
    } else {
        if (hours>12) hours -= 12;
        integer degreesPerHour = 360 / 12;
        float degreesPerMinute = 360.0 / (12.0 * 60.0);
        degrees = hours * degreesPerHour + (integer)(minutes * degreesPerMinute);
    }
    rotation deltaRot = llEuler2Rot( <0,0,-degrees> * DEG_TO_RAD);

    // we know that midnight/noon is 0 degrees around the z axis
    // so we simply want to add minutes from zero
    vector currentOffset = ZERO_VECTOR;
    vector size = llGetScale();
    currentOffset.x += size.x / 2.0;
    vector newOffset = currentOffset * deltaRot;
    llSetLocalRot(deltaRot);
    llSetPos(newOffset);
}
default
{
    link_message(integer sender, integer _num, string msg, key id) {
        llOwnerSay(llGetObjectName()+" received time: "+msg);
        vector time = (vector)msg;
        integer gCurrentHour = (integer)time.x;
        integer gCurrentMin = (integer)time.y;
        setHandPosition(gCurrentHour, gCurrentMin);
    }
}
