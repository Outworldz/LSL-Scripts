// :CATEGORY:Parachute
// :NAME:Parachute
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:604
// :NUM:828
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Parachute
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

displayChute(float alpha)
{
    llSetLinkPrimitiveParams(2,[PRIM_COLOR, ALL_SIDES,<1,1,1>, alpha ]);
    llSetLinkPrimitiveParams(3,[PRIM_COLOR, ALL_SIDES,<1,1,1>, alpha ]);
    llSetLinkPrimitiveParams(4,[PRIM_COLOR, ALL_SIDES,<1,1,1>, alpha ]);
    llSetLinkPrimitiveParams(5,[PRIM_COLOR, ALL_SIDES,<1,1,1>, alpha ]);
    llSetLinkPrimitiveParams(6,[PRIM_COLOR, ALL_SIDES,<1,1,1>, alpha ]);
}

integer calculateGroundDistance()
{
    vector pos = llGetPos();
    float ground = llGround(pos);
    float distance = llRound(pos.z-ground);
    return (integer)distance;
}

displayGroundDistance()
{
    llSetText("Distance to Ground: " + (string)calculateGroundDistance(),<0,1,0>,1);
}



default
{   
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
        displayChute(0);
        llSetTimerEvent(1);
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        llPreloadSound( "parachute" );
    
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
        if(  (llGetAgentInfo(llGetOwner()) & AGENT_IN_AIR) && 
            !(llGetAgentInfo(llGetOwner()) & AGENT_FLYING) ) 
        {
            state falling;
        }
        displayGroundDistance();
    } 
}

state falling
{
    state_entry()
    {
        llSetTimerEvent(1);
    }
    
    timer()
    {
        integer dist = calculateGroundDistance();
        
        if( (dist<150) && (dist>20) )
            state deployed;   
        displayGroundDistance(); 
    }
    
    attach(key id)
    {
        if(id==NULL_KEY)
        {
            state default;
        }
    }
}

state deployed
{
    state_entry()
    {
        llTriggerSound("parachute",1);
        displayChute(1);
        llSetTimerEvent(0.1);
        llStopAnimation("falldown");
        llStartAnimation("hover");
    }
    
    timer()
    {
        // on the ground
        if (    !(llGetAgentInfo(llGetOwner()) & AGENT_IN_AIR) && 
            !(llGetAgentInfo(llGetOwner()) & AGENT_FLYING) ) 
        {
            llStopAnimation("hover");   
            state attached;
        }
        
        // started flying
        if( llGetAgentInfo(llGetOwner()) & AGENT_FLYING) 
        {
            llStopAnimation("hover");
            state attached;
        }

        vector v = llGetVel();
        if( v.z < -7 )
        {
            llPushObject(llGetOwner(), <0,0,7>, ZERO_VECTOR, FALSE);
        }
        
        displayGroundDistance();                        
    } 
    
    attach(key id)
    {
        if(id==NULL_KEY)
        {
            llStopAnimation("hover");
            state default;
        }
    }
}
