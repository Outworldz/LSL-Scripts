// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1298
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
//
//Revisions:
// 1/28/2010 initial release

// Seat
// Pilot Sit
// This script sets the pilot's seat sit target and camera.  A link message is sent when the pilot sits or unsits.
// The string of the link message is "pilot".  The key of the pilot will be sent if the pilot just sat, or NULL_KEY if the pilot just got up.

// This is the animation to be run when the pilot sits.  if it's equal to "", then the default sit animation will be used.
string sit_anim = "recline sit";
// This is the sit target offset.
vector sit_offset = <0.07700, -0.52750, -0.39870>;
// This is the sit rotation.
rotation sit_rotation = <0.70779, -0.00319, -0.00288, 0.70641>;
// This is where the pilot camera is relative to the pilot seat.
vector camera_position = <-10.0, -5.0, .01>;
// This is where the pilot camera is looking.
vector camera_target = <4.5, 0.01, 0.01>;

key pilot;

default
{
	state_entry()
	{
		llSitTarget(sit_offset, sit_rotation);
		llSetCameraEyeOffset(camera_position);
		llSetCameraAtOffset(camera_target);
		pilot = NULL_KEY;
		llMessageLinked(LINK_SET, 0, "pilot", NULL_KEY);
	}

	changed(integer change)
	{
		key sitting = llAvatarOnSitTarget();
		if (change == CHANGED_LINK)
		{
			if (sitting != NULL_KEY && pilot == NULL_KEY)
			{
				pilot = sitting;
				llMessageLinked(LINK_SET, 0, "half", NULL_KEY); // half blades

				// llMessageLinked(1, 0, "llWhisper", "/me Pilot " + llKey2Name(sitting));  // odd way to do a whisper

				llMessageLinked(LINK_SET, 0, "pilot", pilot);		// say pilot ID on id

				if (sit_anim != "")
					llRequestPermissions(pilot, PERMISSION_TRIGGER_ANIMATION);
			}
			else if (sitting == NULL_KEY && pilot != NULL_KEY)
			{
				if ((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) == PERMISSION_TRIGGER_ANIMATION && llGetPermissionsKey() == pilot)
					llStopAnimation("recline sit");
				pilot = NULL_KEY;
				llMessageLinked(LINK_SET, 0, "pilot", NULL_KEY);
			}
		}
	}
	run_time_permissions(integer permissions)
	{

		if ((permissions & PERMISSION_TRIGGER_ANIMATION) == PERMISSION_TRIGGER_ANIMATION)
			llStartAnimation(sit_anim);

	}

	link_message(integer sender_num, integer num, string message, key id)
	{

		if (message == "unsit" )
		{
			if ( ((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) == PERMISSION_TRIGGER_ANIMATION) && llGetPermissionsKey() == pilot)
			{
				llStopAnimation("recline sit");
				llMessageLinked(LINK_SET, 0, "pilot", NULL_KEY);
				llUnSit(pilot);
			}
		}
	}
}
