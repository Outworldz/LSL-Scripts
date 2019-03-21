// :SHOW:1
// :CATEGORY:Gaming
// :NAME:Sensor to delete or start a NPC
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:Game, Sensor
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// A part of a controller set for NPC's
// When an avatar gets near this (75 meters, a looong way, it sends a @pause command to the controller. This will make it continue from an @stop.
// when no one is araound, it sends a @delete to remove the NPC. It sends these once per avatar presence.

// :CODE:

float distance = 75;    // keep this distance short - in my case, we are on a broad plain and we need to notice the avatar from a long distance, but not often.
float time = 30;        // keep this long.   

// toggle if a person is there or not so we can detect the edge condition
integer isperson = FALSE;

default
{
    state_entry()
    {
        llSensorRepeat("","",AGENT,distance,PI, time);
    }
    
    sensor(integer n)
    {
        if (! isperson)
            llMessageLinked(LINK_SET,1,"@pause=1","");
            
        isperson = TRUE;
    }
        
    no_sensor()
    {
        if (isperson)
            llMessageLinked(LINK_SET,1,"@delete","");

        isperson = FALSE;
    }
    
    on_rez(integer p) {
        llResetScript();
    }
    
    
    changed(integer what)
    {
        if (what & CHANGED_REGION_START)
        {
            llResetScript();
        }
    }
    
}