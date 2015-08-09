// :CATEGORY:Building
// :NAME:ScaleByFactor
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2014-02-07 19:09:28
// :EDITED:2014-02-07 19:09:28
// :ID:1018
// :NUM:1582
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Touching this script causes the object to double or halve in size.
// :CODE:
// From the Second Life Wiki.
// Copyright © 2009 Linden Research, Inc. Licensed under Creative Commons Attribution-Share Alike 3.0 
// Touching this script causes the object to double or halve in size.
 
integer growing;
 
default
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Touch to toggle scale.");
    }
 
    touch_start(integer num_detected)
    {
        growing = !growing;
 
        float min_factor = llGetMinScaleFactor();
        float max_factor = llGetMaxScaleFactor();
 
        llSay(PUBLIC_CHANNEL, "min_scale_factor = " + (string)min_factor
                            + "\nmax_scale_factor = " + (string)max_factor);
 
        integer success;
 
        if (growing) success = llScaleByFactor(2.0);
        else         success = llScaleByFactor(0.5);
 
        if (!success) llSay(PUBLIC_CHANNEL, "Scaling failed!");
    }
}
