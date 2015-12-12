// :SHOW:1
// :CATEGORY:NPC
// :NAME:Hypergrid Story Three
// :AUTHOR:Ferd Frederix
// :KEYWORDS:Game, NPC
// :CREATED:2015-11-24 20:36:34
// :EDITED:2015-11-24  19:36:34
// :ID:1090
// :NUM:1860
// :REV:2
// :WORLD:Opensim
// :DESCRIPTION:
// Sample collision script for NPC animator./ Makes the racoon run off the cliff edge
// :CODE:

// Rev: 2 fixes the Linux bug for collisions.
integer debug = FALSE;

DoIt()
{
    // llOwnerSay("Racoon edge of cliff");
     llMessageLinked(1,0, "@say=Follow me down. I will wait for you there. ","");
     llMessageLinked(1,0, "@walk=<82.71397, 39.95649, 21.40128>","");
     llMessageLinked(1,0, "@walk=<81.58669, 46.91171, 21.47848>","");
     llMessageLinked(1,0, "@delete","");

}

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
        llSetText("",<1,1,1>,1.0);
        Reset();
        llSetTimerEvent(3600);
    }
    
    on_rez(integer p)
    {
        llResetScript();
    }

    collision_start(integer n) {

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

    changed(integer what)
    {
        if (what & CHANGED_REGION_START)
        {
            llResetScript();
        }
    }
}
