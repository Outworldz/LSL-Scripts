// :CATEGORY:Clock
// :NAME:AnalogClock
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:34
// :NUM:45
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// AnalogClock
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

setClock()
{
    integer t = llRound(llGetWallclock());
    integer hours = t / 3600; 
    integer minutes = (t % 3600) / 60;
     integer minutes_angle = minutes;
     integer hours_angle = hours;
    
    minutes_angle*=6;
    minutes_angle = 180-minutes_angle;
    
    hours_angle *= 30;
    hours_angle+= (minutes/12)*6;
    hours_angle =180 - hours_angle;
    
    
    llSetLinkPrimitiveParams(3,[PRIM_TEXTURE, 0, "hour", <1,1,1>, <0,0,0>, hours_angle * DEG_TO_RAD ]);
    llSetLinkPrimitiveParams(2,[PRIM_TEXTURE, 0, "minute", <1,1,1>, <0,0,0>, minutes_angle * DEG_TO_RAD]);
}

default
{
    state_entry()
    {

        llSetTimerEvent(60);
        setClock();
    
    }
    
    timer()
    {
        setClock();
    }


}


