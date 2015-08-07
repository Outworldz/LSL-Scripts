// :CATEGORY:Vehicles
// :NAME:WheelScript
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:975
// :NUM:1397
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// WheelScript
// :CODE:
// From the book:
//
// Scripting Recipes for Second Life
// by Jeff Heaton (Encog Dod in SL)
// ISBN: 160439000X
// Copyright 2007 by Heaton Research, Inc.
//
// This script may be freely copied and modified so long as this header
// remains unmodified.
//
// For more information about this book visit the following web site:
//
// http://www.heatonresearch.com/articles/series/22/
default
{
    state_entry()
    {
        llSetTimerEvent(0.20);
    }
    timer()
    {
        vector vel = llGetVel();
        float speed = llVecMag(vel);
        if(speed > 0)
        {
            llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, 0, 0, 0, 0, 1, speed*0.5);            
        }
        else
        {
            llSetTextureAnim(ANIM_ON | SMOOTH | LOOP | REVERSE, 0, 0, 0, 0, 1, speed*0.5);
        }
    }
}
