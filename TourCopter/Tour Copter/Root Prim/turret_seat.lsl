// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1305
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:

﻿// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com
// tour copter script
// Turret seat
//
//Revisions:
// 1/28/2010 initial release


key sitting = NULL_KEY;

default
{
	state_entry()
	{

	}

	changed(integer change)
	{
		key sitter = llAvatarOnSitTarget();

		if (sitter != NULL_KEY && sitting == NULL_KEY)
		{
			// Start tracking the avi for turret gun movement
			llMessageLinked(LINK_SET, 255, "gun-aim", sitter);
			llRequestPermissions(sitter, PERMISSION_TAKE_CONTROLS);
			sitting = sitter;
		}
		else if (sitter == NULL_KEY && sitting != NULL_KEY)
		{
			llMessageLinked(LINK_SET, 255, "gun-stop", NULL_KEY);
			llReleaseControls();
			sitting = NULL_KEY;
		}
	}

	run_time_permissions(integer perms)
	{
		if (perms & PERMISSION_TAKE_CONTROLS)
		{
			llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
		}
		else
		{
			llReleaseControls();
		}
	}

	control(key id, integer level, integer edge)
	{
		if (level & CONTROL_ML_LBUTTON && edge & CONTROL_ML_LBUTTON)
		{
			if (llGetTime() > 0.6) {
				llMessageLinked(LINK_ALL_CHILDREN, 255, "bullet", id);
				llResetTime();
			}
		}
	}
}

