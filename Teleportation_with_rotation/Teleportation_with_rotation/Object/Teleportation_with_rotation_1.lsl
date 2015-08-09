// :CATEGORY:Teleport
// :NAME:Teleportation_with_rotation
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:06
// :ID:874
// :NUM:1234
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Edit the variable targetPos to set the target position you will end up at.  I also set the prim to from the normal 'touch' to 'sit'.  One click and you teleport
// :CODE:

vector targetPos = <13, 119, 40>; //The target location

reset()
{
    vector target;
    
    target = (targetPos- llGetPos()) * (ZERO_ROTATION / llGetRot());
    llSitTarget(target, ZERO_ROTATION);
    llSetSitText(llGetObjectName());
}
default
{
    state_entry()
    {
        reset();
    }
    
    on_rez(integer startup_param)
    {
        reset();
    }
    
    changed(integer change)
    {
        llUnSit(llAvatarOnSitTarget());
        reset();
    }    
}

// END //
