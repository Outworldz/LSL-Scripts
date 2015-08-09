// :CATEGORY:Door
// :NAME:OwnerLockedDoor
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:601
// :NUM:823
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// OwnerLockedDoor
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

float       TIMER_CLOSE = 5.0;      
integer     DIRECTION   = -1;       // direction door opens in. Either 1 (outwards) or -1 (inwards);

integer     DOOR_OPEN   = 1;
integer     DOOR_CLOSE  = 2;

vector      originalPos;      
                      
door(integer what) 
{
    rotation    rot;
    rotation    delta;
    vector eul;
    
    llSetTimerEvent(0); 
    
    if ( what == DOOR_OPEN ) 
    {
        llTriggerSound("doorOpen", 1);  
        eul = <0, 0, 90*DIRECTION>; //90 degrees around the z-axis, in Euler form 
           
    } else if ( what == DOOR_CLOSE) 
    {
        llTriggerSound("doorClose", 1);  
        eul = <0, 0, 90*-DIRECTION>; //90 degrees around the z-axis, in Euler form
    }
    
    eul *= DEG_TO_RAD; //convert to radians rotation
    rot = llGetRot();
    delta = llEuler2Rot(eul);
    rot = delta * rot;                  
    llSetRot(rot); 
}
        

default 
{   
    on_rez(integer start_param) 
    { 
        llResetScript();
    }
    
    state_entry() 
    {
        originalPos = llGetPos();     
    }
    
    touch_start(integer total_number) 
    {
        key who = llDetectedKey(0);
        if( who==llGetOwner() )
        {
            llSay(0,"Hello " + llDetectedName(0) );
            door(DOOR_OPEN);
            state open_state;
        }
        else
        {
            llSay(0,llDetectedName(0) + " is at the door." );
            llTriggerSound("doorbell", 0.8);
        }
    }
    
    moving_end() 
    {  
        originalPos = llGetPos();
    }
}

state open_state
{
    state_entry() 
    {
        llSetTimerEvent(TIMER_CLOSE);
    }
    
    touch_start(integer num) 
    {
        door(DOOR_CLOSE);
        llSetPos(originalPos);            
        state default;
    }
    
    timer() 
    { 
        door(DOOR_CLOSE);
        llSetPos(originalPos);            
        state default;
    }
    
    moving_start() 
    { 
        door(DOOR_CLOSE);
        state default;
    }
}
