// :SHOW:1
// :CATEGORY:NPC
// :NAME:All In One NPC Recorder and Player
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-07-17 13:15:49
// :EDITED:2015-07-20  00:23:28
// :ID:27
// :NUM:1808
// :REV:2
// :WORLD:Second Life
// :DESCRIPTION:
// Sample collision script for NPC animator
// :CODE:
default
{
    state_entry()
    {
        llSetText("",<1,1,1>,1.0);
        llVolumeDetect(FALSE);
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
}
