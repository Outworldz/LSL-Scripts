// :CATEGORY:Pose Balls
// :NAME:Regular_Sit_Script
// :AUTHOR:Ben Linden
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:689
// :NUM:938
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Regular Sit Script.lsl
// :CODE:

// Quick and dirty regularsit
// Ben Linden


default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }
    
    on_rez(integer param)
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        
    }
    
    run_time_permissions(integer perms)
    {
        if(perms)
        {
            llSetTimerEvent(1.0);
        }
        else
        {
            llSetTimerEvent(0.0);
        }
    }

    timer()
    {
        if(llGetAnimation(llGetOwner()) == "Sitting")
        {
            llStopAnimation("sit");
            llStartAnimation("sit_generic");
        }
        else
        {
            llStopAnimation("sit_generic");
        }
    }
}
// END //
