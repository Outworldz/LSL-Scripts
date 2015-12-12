// :SHOW:
// :CATEGORY:NPC
// :NAME:Collider
// :AUTHOR:Ferd Frederix
// :KEYWORDS:

// :REV:1
// :WORLD:Open Sim
// :DESCRIPTION:
// Sample collision script for NPC animator
// :CODE:

Reset()
{
    llSetStatus(STATUS_PHANTOM, FALSE);
    llSleep(0.1);
    llVolumeDetect(FALSE);
    llVolumeDetect(TRUE);
}


 
default
{
    state_entry()
    {
        llSetText("",<1,1,1>,1.0);
        Reset();
        llSetTimerEvent(3600);
    }
    
    collision_start(integer n) {
        
        if (!osIsNpc(llDetectedKey(0))) {
            llMessageLinked(LINK_SET,0, "@notecard=Hello","");
        }
    }
    timer()
    {
        llSetTimerEvent(3600);
        Reset();
    }
    
    changed(integer what)
    {
        if (what & CHANGED_REGION_START)
        {
            llResetScript();
        }
    }
}