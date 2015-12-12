// :SHOW:1
// :CATEGORY:NPC
// :NAME:Hypergrid Story Three
// :AUTHOR:Ferd Frederix
// :KEYWORDS:Game, NPC
// :CREATED:2015-11-24 20:36:34
// :EDITED:2015-11-24  19:36:34
// :ID:1090
// :NUM:1859
// :REV:2
// :WORLD:Opensim
// :DESCRIPTION:
// Sample collision script for NPC animator. Moves the raccoon to the edge of the cliff
// :CODE:

// Rev: 2 fixes the Linux bug for collisions.


integer debug = FALSE;
Reset()
{
    llSetStatus(STATUS_PHANTOM, FALSE);
    llVolumeDetect(FALSE);
    llSleep(0.1);
    llVolumeDetect(TRUE);
}


DoIt()
{
     if (debug) llOwnerSay("Racoon halfway");
     llMessageLinked(1,0, "@say=Follow me. The bear will not hurt me.","");

     llMessageLinked(1,0, "@walk=<88.10030, 74.18887, 38.53304>","");

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

        if (! osIsNpc(llDetectedKey(0)))
        {
            if (debug) llOwnerSay("Collided with " + llKey2Name(llDetectedKey(0)));

           DoIt();
           
           
        }
            
    }
    on_rez(integer p)
    {
        llResetScript();
    }
    touch_start(integer p)
    {
        DoIt();    
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
