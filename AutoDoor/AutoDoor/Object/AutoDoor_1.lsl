// :CATEGORY:Door
// :NAME:AutoDoor
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:66
// :NUM:93
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// AutoDoor
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
        llSensorRepeat("", "",AGENT, 5, PI, 1);   
    }
    
    sensor(integer num_detected)
    {
        door(DOOR_OPEN);
        state open_state;
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
        llSensorRepeat("", "",AGENT, 5, PI, 1); 
    }
    
    no_sensor()
    { 
        door(DOOR_CLOSE);
        llSetPos(originalPos);            
        state default;
    }
    
    sensor(integer num_detected)
    {
    }
    
    
    moving_start() 
    { 
        door(DOOR_CLOSE);
        state default;
    }
}
