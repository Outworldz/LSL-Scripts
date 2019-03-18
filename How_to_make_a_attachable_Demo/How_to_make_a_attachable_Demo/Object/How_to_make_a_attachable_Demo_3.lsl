// :CATEGORY:Defense
// :NAME:How_to_make_a_attachable_Demo
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-05-02 21:33:38.517
// :EDITED:2013-09-18 15:38:55
// :ID:389
// :NUM:539
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// / This example illustrates how to handle permissions before and after llAttachToAvatarTemp has been called. Because ownership changes when the object is attached, the initial PERMISSION_ATTACH is revoked and new permissions need to be requested.// // Copyright © 2009 Linden Research, Inc. Licensed under Creative Commons Attribution-Share Alike 3.0//  
// :CODE:

integer gAttach = TRUE;
 
default
{
 
    touch_start(integer num)
    {
        if (gAttach)  // Object has not been attached yet
        {
            llRequestPermissions(llDetectedKey(0),PERMISSION_ATTACH);
            gAttach = FALSE;
        }
        else   // Object has been attached, but you still need PERMISSION_ATTACH in order to detach the object
        {
            if (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION | PERMISSION_ATTACH)
            {
                llDetachFromAvatar();  // Note that the object vanishes when detached, so there is no need to set gAttach = TRUE again
            }
        }
    }
 
    attach(key id)
    {
        if (id)  // Object has been attached, so request permissions again
        {
            llRequestPermissions(id,PERMISSION_ATTACH | PERMISSION_TRIGGER_ANIMATION);
        }
    }
 
    run_time_permissions (integer perm)
    {
        if (!gAttach)  //First time
        {
            if (perm & PERMISSION_ATTACH)
            {
                gAttach = TRUE;
                llAttachToAvatarTemp(ATTACH_HEAD);  // Initial PERMISSION_ATTACH is revoked at this point
            }
        }
        else  // Second time
        {
            if (perm & PERMISSION_ATTACH | PERMISSION_TRIGGER_ANIMATION)
            {
                llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION,0));
            }
        }
    }
}
