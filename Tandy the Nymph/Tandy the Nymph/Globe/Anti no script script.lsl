// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1214
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:


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

