// :CATEGORY:Defense
// :NAME:How_to_make_a_attachable_Demo
// :AUTHOR:Ferd Frederix
// :CREATED:2013-05-02 21:33:38.517
// :EDITED:2013-09-18 15:38:55
// :ID:389
// :NUM:537
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// For objects that do not need permissions to be used.
// :CODE:
default
{
    state_entry()
    {
        llRequestPermissions( llGetOwner(), PERMISSION_ATTACH );
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
 
    attach(key AvatarKey)
    {
        if(AvatarKey)
        {//event is called on both attach and detach, but Key is only valid on attach
            integer test = llGetAttached();
            if (test) {
                llOwnerSay( "The object is attached" );
            } else {
                llOwnerSay( "The object is not attached");
            }
        }
    }
}