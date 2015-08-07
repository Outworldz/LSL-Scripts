// :CATEGORY:Door
// :NAME:SmartDoor
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:04
// :ID:801
// :NUM:1111
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SmartDoor
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
string text;
list allow;
                             
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

string pop()
{
    string result;
    integer i = llSubStringIndex(text, " ");
    
    if( i!=-1 )
    {
        i -=1;
        result = llGetSubString(text,0,i);
        text = llGetSubString(text,i+2,-1);
        return result;
    }
    else
    {
        result = text;
        text = "";
    }
    
    text = llStringTrim(text, STRING_TRIM);
    result = llStringTrim(result, STRING_TRIM);
    
    return result;
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
        llListen(0, "", NULL_KEY, "");   
    }
    
    touch_start(integer total_number) 
    {
        key who = llDetectedKey(0);
        integer shouldOpen = 0;
        
        if( who==llGetOwner() )
            shouldOpen = 1;
            
        string name = llToUpper(llDetectedName(0));
        if( llListFindList(allow,[name]) != -1 )
            shouldOpen = 1;
        
        if( shouldOpen == 1 )
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
    
    listen(integer channel, string name, key id, string message) 
    {
        if( id==llGetOwner() )
        {
            
            text = message;
            string prefix = llToLower(pop());
            
            if( prefix=="door" )
            {
                string command = pop();
                if( command=="" )
                {
                    llSay(0,"I am the smart door!");
                }
                else if( command=="clear" )
                {
                    llSay(0,"Clearing access list.");
                    allow = [];
                }
                else if( command=="add" )
                {
                    if( llStringLength(text)> 0 )
                    {
                        text = llToUpper(text);
                        allow+=[text];
                        llSay(0,"Adding " + text );
                    }
                    else
                    {
                        llSay(0,"You must also specify an avatar when using add.");
                    }
                }
                else if( command=="list" )
                {
                    integer length = llGetListLength(allow);
                    if( length==0 )
                    {
                        llSay(0,"No one, other than my owner, may open me.");
                    }
                    else
                    {
                        integer i;
                        llSay(0,"The following people have access to open me:");
                        for (i = 0; i < length; ++i) 
                        {
                           llSay(0,llList2String(allow, i));
                        }
                    }
                }
                else
                {
                    llSay(0,"I did not understand that command, say \"door\" for a list of commands.");
                }
            }
        }
        
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
