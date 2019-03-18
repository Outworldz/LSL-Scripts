// :CATEGORY:Defense
// :NAME:How_to_make_a_attachable_Demo
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-05-02 21:33:38.517
// :EDITED:2013-09-18 15:38:55
// :ID:389
// :NUM:540
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// An alternative solution:  Because ownership changes when the object is attached, the initial PERMISSION_ATTACH is revoked and new permissions need to be requested.// //  Copyright © 2009 Linden Research, Inc. Licensed under Creative Commons Attribution-Share Alike 3.0
// :CODE:
default
{
    touch_start(integer num)
    {
        if (!llGetAttached()) llRequestPermissions( llDetectedKey(0), PERMISSION_ATTACH);
        else if ( llGetPermissions() & PERMISSION_ATTACH) llDetachFromAvatar();
    }
    attach(key id)
    {
        if (id) llRequestPermissions( id, PERMISSION_ATTACH | PERMISSION_TRIGGER_ANIMATION);
    }
    run_time_permissions (integer perm)
    {
        if (!llGetAttached() && (perm & PERMISSION_ATTACH)) llAttachToAvatarTemp( ATTACH_NOSE);
        if (perm & PERMISSION_TRIGGER_ANIMATION) llStartAnimation( llGetInventoryName( INVENTORY_ANIMATION, 0));
    }
}
