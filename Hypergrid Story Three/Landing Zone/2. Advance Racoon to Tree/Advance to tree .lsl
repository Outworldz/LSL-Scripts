// :SHOW:1
// :CATEGORY:NPC
// :NAME:Hypergrid Story Three
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-11-24 20:36:34
// :EDITED:2015-11-24  19:36:34
// :ID:1090
// :NUM:1858
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// Sample collision script for NPC animator
// :CODE:

integer debug = FALSE;

DoIt()
{
     llMessageLinked(1,5, "@walk=<121.16252, 121.84969, 37.72606>","");
     llMessageLinked(1,1, "@say=The route is easy and not dangerous. Just follow me. ","");
     llMessageLinked(1,1, "@walk=<103, 103, 39>","");
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
