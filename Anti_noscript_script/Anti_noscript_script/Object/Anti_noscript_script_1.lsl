// :CATEGORY:Attachment
// :NAME:Anti_noscript_script
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:47
// :ID:41
// :NUM:54
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Anti no script script makes attachments run in no-script zones
// :CODE:
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
// author Ferd Frederix
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

   









