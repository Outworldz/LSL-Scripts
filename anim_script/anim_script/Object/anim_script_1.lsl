// :CATEGORY:Animation
// :NAME:anim_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:36
// :NUM:49
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// anim script.lsl
// :CODE:

string anim = "boomboxin2";

integer attached = FALSE;  
integer permissions = FALSE;

default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION);
    }
    
    run_time_permissions(integer permissions)
    {
        if (permissions > 0)
        {
            llStartAnimation(anim);
            attached = TRUE;
            permissions = TRUE;
        }
    }

    attach(key attachedAgent)
    {
        if (attachedAgent != NULL_KEY)
        {
            attached = TRUE;
            
            if (!permissions)
            {
                llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION);   
            }
        }
        
        else
        {
            attached = FALSE;
            llStopAnimation(anim);
        }
    }
}

// END //
