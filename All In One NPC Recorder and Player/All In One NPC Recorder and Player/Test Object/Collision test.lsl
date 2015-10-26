// :SHOW:1
// :CATEGORY:NPC
// :NAME:All In One NPC Recorder and Player
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-07-17 13:15:49
// :EDITED:2015-09-23  12:06:52
// :ID:27
// :NUM:1808
// :REV:3
// :WORLD:Second Life
// :DESCRIPTION:
// Sample collision script for NPC animator
// :CODE:
// rev 3: added on_rez()  and STATUS_PHANTOM to state_entry - otherwise reset on Linux boxes did no collide any more.
default
{
    state_entry()
    {
        llSetStatus(STATUS_PHANTOM,FALSE);
        llVolumeDetect(FALSE);
        llSleep(0.1);
        llVolumeDetect(TRUE);
    }
    
    collision_start(integer n) {
        llMessageLinked(LINK_SET,0, "@animate=someanimation|10","");
        llSetTimerEvent(5);
    }
    timer()
    {
        llMessageLinked(LINK_SET,0, "@animate=Stand|1","");
        llSetTimerEvent(0);
    }
    
    changed(integer what)
    {
        if (what & CHANGED_REGION_START)
        {
            llResetScript();
        }
    }
    on_rez(integer p)
    {
        llResetScript();
    }
}
