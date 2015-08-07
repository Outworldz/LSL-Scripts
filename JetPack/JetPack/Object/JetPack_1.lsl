// :CATEGORY:Vehicles
// :NAME:JetPack
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:410
// :NUM:566
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// JetPack
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
        llReleaseControls();
    }
    
    attach(key id)
    {
        if(id)
        {
            state attached;
        }
    }
}

state attached
{    
    state_entry()
    {
        llSetTimerEvent(1);
    }
    
    attach(key id)
    {
        if(id==NULL_KEY)
        {
            state default;
        }
    }
    
    timer()
    {
        if (llGetAgentInfo(llGetOwner()) & AGENT_FLYING) 
        {
            state flying;
        }
    }   
}

state flying
{
    state_entry()
    {        
        llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
        llSetTimerEvent(1);
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TAKE_CONTROLS) {
            llTakeControls(CONTROL_UP|CONTROL_FWD|CONTROL_BACK, TRUE, FALSE);
        }
    }
    
    attach(key id)
    {
        if(id==NULL_KEY)
        {
            state default;
        }
    }
    
    timer()
    {
        vector pos = llGetPos();
        llSetText("Altitude: " + (string)pos.z, <0,1,0>, 1 );
        
        if (!(llGetAgentInfo(llGetOwner()) & AGENT_FLYING)  ) 
        {
            llReleaseControls();
            state attached;
        }        
    }
    
    control(key id, integer held, integer change)
    {
        if (held & CONTROL_UP)
        {
            llPushObject(llGetOwner(), <0,0,2>, ZERO_VECTOR, FALSE);
        }
        else if (held & CONTROL_FWD)
        {
            rotation rot = llGetRot();               
            vector vel = llRot2Fwd(rot);  
            
            if( llGetAgentInfo(llGetOwner()) & AGENT_FLYING )
                vel*=4;    
            else
                vel/=2;
                
            llPushObject(llGetOwner(), vel, ZERO_VECTOR, FALSE);
        }
    }
}
