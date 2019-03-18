// :SHOW:1
// :CATEGORY:NPC
// :NAME:Hypergrid Story Three
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2015-11-24 20:36:34
// :EDITED:2015-11-24  19:36:34
// :ID:1090
// :NUM:1862
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// Sample collision script for NPC animator
// :CODE:


integer debug = FALSE;


DoIt()
{
     llMessageLinked(2,1, "@animate=avatar_type","");     
     llMessageLinked(2,5, "@say=Be wary of the water, for it is deadly","");     
}

Reset()
{
    llVolumeDetect(FALSE);
    llSetStatus(STATUS_PHANTOM, FALSE);
    llSleep(0.1);
    llVolumeDetect(TRUE);
}

default
{
    state_entry()
    {
        llSetText("",<1,1,1>,1.0);
        llSetTimerEvent(3600);
        Reset();
    }

    collision_start(integer n) {
        
         if (debug) llOwnerSay("Collided with " + llKey2Name(llDetectedKey(0)));

        if (! osIsNpc(llDetectedKey(0)))
        {
            if (debug) llOwnerSay("Collided with " + llKey2Name(llDetectedKey(0)));

           DoIt();
           
        }
            
    }
     
    timer()
    {
        Reset(); 
        llSetTimerEvent(3600);
    }
    
    on_rez(integer p)
    {
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
