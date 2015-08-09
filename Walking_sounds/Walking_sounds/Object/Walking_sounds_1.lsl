// :CATEGORY:Attachment
// :NAME:Walking_sounds
// :AUTHOR:robokitty9000
// :CREATED:2010-11-10 05:24:42.897
// :EDITED:2013-09-18 15:39:09
// :ID:962
// :NUM:1384
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// here be dragons
// :CODE:
default
{
    state_entry()
    {
        llStopSound();

        llSetTimerEvent(0.2);
    }
    
    timer()
    {
        if (llGetAgentInfo(llGetOwner()) & AGENT_WALKING)
        {
            state walking;
        }
    }
}
state walking
{
    state_entry()
    {

        llSetTimerEvent(0.2);
        llLoopSound("PLACE_SOUND_HERE",1.0);
    }
    timer()
    {
        if (!(llGetAgentInfo(llGetOwner()) & AGENT_WALKING))
        {
            state default;
        }
    }
}
