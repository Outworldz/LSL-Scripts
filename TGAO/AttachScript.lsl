integer DefaultAttachPoint = ATTACH_HUD_CENTER_2;

default
{
    state_entry()
    {
        llRequestPermissions( llGetOwner(), PERMISSION_ATTACH );
    }
 
    run_time_permissions( integer vBitPermissions )
    {
        if ( vBitPermissions & PERMISSION_ATTACH )     
            llAttachToAvatar( DefaultAttachPoint );     
        else     
            llOwnerSay( "Permission to attach denied" );
    }
 
    on_rez(integer rez)
    {
        if (!llGetAttached())        //reset the script if it's not attached.
            llResetScript();      
    }
 
    attach(key id)
    {
        // The attach event is called on both attach and detach, but 'id' is only valid on attach
        if (id){
            llOwnerSay( "The object is attached to " + llKey2Name(id) );
        }else {
            llOwnerSay( "The object is not attached");
        }
    }
}