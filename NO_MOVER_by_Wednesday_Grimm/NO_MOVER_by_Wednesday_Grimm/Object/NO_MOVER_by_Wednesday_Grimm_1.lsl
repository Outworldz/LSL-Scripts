// :CATEGORY:Defense
// :NAME:NO_MOVER_by_Wednesday_Grimm
// :AUTHOR:Wedensday Grimm
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:558
// :NUM:762
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// NO MOVER by Wednesday Grimm.lsl
// :CODE:

// no mover
// Wednesday Grimm
// June 10, 2003
// 
// This script makes physical objects stay still
// if this script is on an object attached to your avatar, you can't be 
// pushed around
//
// THEY'RE NOT GOING TO PUSH YOU AROUND ANYMORE!!!
//

// True if we are staying still
integer nTarget;

// set up everything we need
startup()
{
    // listen to the owner for a command
    llListen(0, "", llGetOwner(), "");
    
    // we are not staying still at startup    
    nTarget = FALSE;
    llStopMoveToTarget();
}

default
{
    state_entry()
    {
        startup();        
    }
    
    on_rez(integer param)
    {
        startup();
    }
    
    listen(integer channel, string who, key id, string msg)
    {
        vector targetPos;
        if (msg == "lock")
        {
            // if we are not already staying still, start doing it
            if (nTarget == FALSE)
            {
                // where are we right now?
                targetPos = llGetPos();
                nTarget = TRUE;
                llMoveToTarget(targetPos, 2.0);
            }
        }
        else if (msg == "unlock")
        {
            // stop staying still
            llStopMoveToTarget();
            nTarget = FALSE;
        }
    }   
}// END //
