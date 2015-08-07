// :CATEGORY:Games
// :NAME:Random Rezzer Game
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:00
// :ID:675
// :NUM:916
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Random rezzer
// :CODE:

integer channel = -1234321; // some random integer rto talk with


default
{
    state_entry()
    {
        llSetStatus(STATUS_PHYSICS,TRUE);            // make it bouncy
        llSetStatus(STATUS_RETURN_AT_EDGE,TRUE)   ; // be nice to neighboring parcels
    }
    
    timer()
    {
        llWhisper(0,"No one grabbed the " + llGetObjectName());
        llDie();    /// Aww, another wasted prim
    }

       // if they  touch this, the name is snt to the HUD   
    touch_start(integer total_number)
    {
        llShout(channel, llDetectedName(0) + "^" + (string) llDetectedKey(0) );
        llDie();
    }

    // the rezzer sends a '1' as a start_param, so we can tell this prim to die. Otherwise it will die when you rez it to work on it.
    on_rez(integer start_param)
    {
        if (start_param)
        {
            llSetTimerEvent(llFrand(10) + 5);  // object will be here for 5 to 15 seconds, then die
        }
    }
    
}
