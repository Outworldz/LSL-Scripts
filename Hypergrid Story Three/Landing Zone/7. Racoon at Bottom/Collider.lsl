// :SHOW:1
// :CATEGORY:NPC
// :NAME:Hypergrid Story Three
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-11-24 20:36:34
// :EDITED:2015-11-24  19:36:34
// :ID:1090
// :NUM:1863
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// Sample collision script for NPC animator
// :CODE:


integer debug = FALSE;
 
DoIt()
{
     if (debug) llOwnerSay("Raccoon at bottom");
        llMessageLinked(LINK_SET,0, "@walk=<79.46262, 39.34087, 21.64303>","");     
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

    collision_start(integer n) {

        if (! osIsNpc(llDetectedKey(0)))
        {
            if (debug) llOwnerSay("Collided with " + llKey2Name(llDetectedKey(0)));

           DoIt();
        }
            
    }
    timer()
    {
        llSetTimerEvent(3600);
        Reset();
    }
    on_rez(integer p)
    {
        llResetScript();
    }
    touch_start(integer p)
    {
        DoIt();    
    }   
    
    changed(integer what)
    {
        if (what & CHANGED_REGION_START)
        {
            llResetScript();
        }
    }
}
