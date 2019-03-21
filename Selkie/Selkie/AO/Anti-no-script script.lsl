// :CATEGORY:AO
// :NAME:Selkie
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:02
// :ID:737
// :NUM:1006
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// no script script
// :CODE:

// Author: Fred Beckhusen (Ferd Frederix)
// Lets any attachment with scripts work in a no-script zone.

// Downloaded from : http://www.outworldz.com/cgi/freescripts.plx?ID=1644

// This program is free software; you can redistribute it and/or modify it.
// Additional Licenes may apply that prevent you from selling this code
// You must leave any author credits and any headers intact in any script you use or publish.
///////////////////////////////////////////////////////////////////////////////////////////////////
// If you don't like these restrictions and licenses, then don't use these scripts.
//////////////////////// ORIGINAL AUTHORS CODE BEGINS ////////////////////////////////////////////


// The Script
//
//
// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com
// author Fred Beckhusen (Ferd Frederix)
//

// anti-no-script script
// makes attached prims into a vehicle so they work in no-script zones.
// If you attach the prim while in a no-script zone, it won't work.  Fly up 100 meters or so and it will start.
// Works only when in the root prim.

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



