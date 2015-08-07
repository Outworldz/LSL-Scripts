
// no script script

default
{
    state_entry()
    {
        llReleaseControls();
        llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS );
    }
    

    
     
    run_time_permissions(integer perm)
    {
        integer hasPerms = llGetPermissions();
        
        llTakeControls( 0 , FALSE, TRUE);

    }

   
    
    attach(key id)
    {
        if(id)//tests if it is a valid key and not NULL_KEY
        {
            llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS );
        }
        else
        {
            llReleaseControls();    // detached
        }
    }

    
}
