// :CATEGORY:Defense
// :NAME:AntiPush
// :AUTHOR:Sapphire Bombay
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:45
// :NUM:63
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Anti-Push.lsl
// :CODE:

// AntiPush Script V1.0
// Created 11/17/2003 by Sapphire Bombay
// Last Updated 11/17/2003
// Concept adapted from Huns Valen
// Freely donated to the public domain

integer locked;         // TRUE if avatar is damping to current position
float LOCKWAIT = 1.0;   // if you don't move for this period of time, you lock into place

default
{
    state_entry()
    {
    }

    // request controls & prime locked condition    
    on_rez(integer start_param)
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
        locked = FALSE;
    }
    
    // if user accepts, trap control events and also allow them to pass on to the avatar for movement:
    // 
    // llTakeControls(integer controls, integer accept, integer pass_on);
    //
    // If (accept == (controls & input)), send input to object. If the boolean pass_on is TRUE, also send input to avatar.

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
            // set timer to periodically check the time since the last control input
            llSetTimerEvent(1);
        }
    }
    
    // called any time a user moves.  release the damping if the avatar is locked.  reset the time since last movement.
    control(key id, integer level, integer edge)
    {
        if (locked)
        {
            llMoveToTarget(llGetPos(), 0);
            locked = FALSE;
            //llWhisper(0, "unlocked");            
        }
        llResetTime();
    }  
    
    // if the avatar is not already locked and it has been longer than the wait time since the last movement then lock the avatar
    timer()
    {
        if ((!locked) && (llGetTime() > LOCKWAIT))
        {
            llMoveToTarget(llGetPos(), 0.2);
            locked = TRUE;
            //llWhisper(0, "locked");            
        }
    }
}
// END //
