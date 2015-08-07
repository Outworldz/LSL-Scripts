// :CATEGORY:Elevator
// :NAME:Elevator
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:275
// :NUM:367
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Elevator
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

integer CHANNEL = 42; // dialog channel
list MENU_MAIN = ["Floor 1", "Floor 2", "Floor 3", "Floor 4", "Floor 5", "Floor 6", "Floor 7", "Floor 8", "Floor 9", "Floor 10","Roof"]; // the main menu

float BOTTOM = 22.260;
float FLOOR_HEIGHT = 10;
float SPEED = 2;
float target;


default
{
    state_entry()
    {
        llListen(CHANNEL, "", NULL_KEY, ""); // listen for dialog answers (from multiple users)
        llSitTarget(<0,-0.5,0.5>, llEuler2Rot(<0,0,-90>) );
        llSetText("Sit Here to Ride Elevator",<0,0,0>,1.0);
        target = BOTTOM;
    }
    
    listen(integer channel, string name, key id, string message) 
    {
        integer idx = llListFindList(MENU_MAIN, [message]);
        if( idx!=-1 )
        {
            llSay(0,"Elevator heading to " + message + "." );
            target = BOTTOM + (idx*10);
            state moving;
        } 
    }

    changed(integer Change) 
    {
        llDialog(llAvatarOnSitTarget(), "Where to?", MENU_MAIN, CHANNEL);
    }
    
}

state moving
{
    
    
    state_entry()
    {
        llSetTimerEvent(0.1);
    }
    
    timer()
    {
        vector pos = llGetPos();
        
        if( pos.z!=target )
        {
            if( pos.z>target )
            {
                pos.z = pos.z - SPEED;
            }
            else
            {
                pos.z = pos.z + SPEED;
            }
        }
        
        if(  llFabs(pos.z - target) < SPEED )
        {
            pos.z = target;
            llSetTimerEvent(0);
            llSetPos(pos);
            llSay(0,"Elevator has reached its target." );
            state default;
        }   
        
        llSetPos(pos);
        
    }
}
