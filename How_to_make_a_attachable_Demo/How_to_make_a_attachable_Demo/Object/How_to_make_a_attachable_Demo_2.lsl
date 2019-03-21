// :CATEGORY:Defense
// :NAME:How_to_make_a_attachable_Demo
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-05-02 21:33:38.517
// :EDITED:2013-09-18 15:38:55
// :ID:389
// :NUM:538
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This example can demonstrate ownership transfer of an object on a temporary basis using llAttachToAvatarTemp().   Whoever touches will be asked for permission to attach, and upon granting permission will have the item attach, but not appear in Inventory.// // Copyright © 2009 Linden Research, Inc. Licensed under Creative Commons Attribution-Share Alike 3.0
// :CODE:
default
{
    touch_start(integer num_touches)
    {
        llRequestPermissions( llDetectedKey(0), PERMISSION_ATTACH );
    }
 
    run_time_permissions( integer vBitPermissions )
    {
        if( vBitPermissions & PERMISSION_ATTACH )
        {
            llAttachToAvatarTemp( ATTACH_LHAND );
        }
        else
        {
            llOwnerSay( "Permission to attach denied" );
        }
    }
 
    on_rez(integer rez)
    {
        if(!llGetAttached())
        { //reset the script if it's not attached.
            llResetScript();
        }
    }
}
