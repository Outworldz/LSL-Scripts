// :CATEGORY:HUD
// :NAME:Auto_attach
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:61
// :NUM:88
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Auto attach.lsl
// :CODE:

//-- rez object on ground, drop in this script, it will request permissions to attach,
//-- and then attach to the bottomif permission is granted. if permission is denied,
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
 
  
}// END //
