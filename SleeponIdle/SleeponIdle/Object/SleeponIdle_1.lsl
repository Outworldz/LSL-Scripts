// :CATEGORY:Animation
// :NAME:SleeponIdle
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:04
// :ID:793
// :NUM:1102
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sleep-on-Idle.lsl
// :CODE:

integer idle = FALSE;

default
{
    state_entry()
    {
        llSensorRepeat("","",AGENT,20,PI,30);
    }
    
    sensor(integer num_detected){
        if(idle){
            llSetScriptState("Collision Avoidance",TRUE);
            llSetScriptState("Random Movement",TRUE);
            llSetScriptState("Collision Avoidance",TRUE);
            llMessageLinked(LINK_SET,47,"walk",NULL_KEY);
            idle = FALSE;
        }
    }
    
    no_sensor(){
        idle = TRUE;
        llSetScriptState("Collision Avoidance",FALSE);
        llSetScriptState("Random Movement",FALSE);
        llSetScriptState("Collision Avoidance",FALSE);
        llMessageLinked(LINK_SET,48,"",NULL_KEY);
        llMessageLinked(LINK_SET,47,"down",NULL_KEY);
    }   
}
// END //
