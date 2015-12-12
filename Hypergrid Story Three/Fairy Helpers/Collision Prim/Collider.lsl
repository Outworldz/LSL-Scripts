// :SHOW:1
// :CATEGORY:Gaming
// :NAME:Collider for All in One NPC Controller
// :AUTHOR:Ferd Frederix
// :KEYWORDS:Game, Collider
// :REV:2.0
// :WORLD:OpenSim
// :DESCRIPTION:
// Triggers the NPC controller to play the Greet notecard when collided.
// :CODE:


Reset()
{
    llSetStatus(STATUS_PHANTOM, FALSE);
    llVolumeDetect(FALSE);
    llSleep(0.1);
    llVolumeDetect(TRUE);
}


default
{
    state_entry()
    {
        Reset();
        llSetTimerEvent(3600);
    }
    
    collision_start(integer n)
    {
        if (osIsNpc(llDetectedKey(0)))
        {
            return;
        }
        
        llMessageLinked(LINK_SET,0,"@notecard=Greet","");
       
    }
    
    on_rez(integer p)
    {
        llResetScript();
    }
    
    timer()
    {
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