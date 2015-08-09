// :CATEGORY:Defense
// :NAME:NoPush
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:563
// :NUM:767
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// NoPush
// :CODE:
// From the book:
//
// Scripting Recipes for Second Life
// by Jeff Heaton (Encog Dod in SL)
// ISBN: 160439000X
// Copyright 2007 by Heaton Research, Inc.
//
// This script may be freely copied and modified so long as this header
// remains unmodified.
//
// For more information about this book visit the following web site:
//
// http://www.heatonresearch.com/articles/series/22/

integer locked; 
float LOCKTIME = 1.0; 

default
{
    state_entry()
    {
    }


    on_rez(integer start_param)
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
        locked = FALSE;
    }


    run_time_permissions(integer perm)
    {
        if(perm & (PERMISSION_TAKE_CONTROLS))
        {
            llTakeControls(CONTROL_FWD|
                CONTROL_BACK|
                CONTROL_RIGHT|
                CONTROL_LEFT|
                CONTROL_ROT_RIGHT|
                CONTROL_ROT_LEFT|
                CONTROL_UP|
                CONTROL_DOWN,
                TRUE, TRUE);
            
            llSetTimerEvent(1);
        }
    }

    control(key id, integer level, integer edge)
    {
        if (locked)
        {
            llMoveToTarget(llGetPos(), 0);
            locked = FALSE;
        }
        llResetTime();
    }

    timer()
    {
        if ((!locked) && (llGetTime() > LOCKTIME))
        {
            llMoveToTarget(llGetPos(), 0.2);
            locked = TRUE;
        }
    }
}
