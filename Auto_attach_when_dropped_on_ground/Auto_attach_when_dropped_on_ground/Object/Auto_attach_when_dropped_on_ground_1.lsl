// :CATEGORY:AO
// :NAME:Auto_attach_when_dropped_on_ground
// :AUTHOR:Ferd Frederix
// :CREATED:2011-06-06 14:17:56.600
// :EDITED:2013-09-18 15:38:48
// :ID:62
// :NUM:89
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Auto attaches anything to HUD_BOTTOm when dropped on the ground
// :CODE:
//-- rez object on ground, drop in this script, it will request permissions to attach,
//-- and then attach to the bottom if permission is granted. if permission is denied,
//-- then the script complains.

default
{
    state_entry()
    {
        llRequestPermissions( llGetOwner(), PERMISSION_ATTACH );
    }

    run_time_permissions( integer vBitPermissions )
    {
        if (PERMISSION_ATTACH & vBitPermissions)
        {
            llAttachToAvatar( ATTACH_HUD_BOTTOM );
        }
        else
        {
            llOwnerSay( "You must attach this as a HUD" );
        }
    }

    on_rez(integer rez)
    {
        if(!llGetAttached())
        { //reset the script if it's not attached.
            llResetScript();
        }
    }

