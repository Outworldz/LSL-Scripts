// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1291
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
// blade strike sound
//
//Revisions:
// 1/28/2010 initial release


vector local_pos;
float mass;
integer i;

integer on = FALSE;

default
{
	link_message(integer sender, integer num, string str, key id)
	{
		if (str == "start") {
			on = TRUE;
		} else if (str == "stop") {
			on = FALSE;
		}
	}

	collision_start(integer n)
	{
		if (!on) return;

		for (i = 0; i < n && i < 3; i += 1) {
			if (llDetectedLinkNumber(i) == llGetLinkNumber()) {
				mass = llGetObjectMass(llDetectedKey(i));
				if ((llDetectedType(i) & AGENT) == AGENT) {
					local_pos = llDetectedPos(i) - llGetPos();
					llTriggerSound(llList2Key(["5da4aa20-7c19-7a06-0b9a-867dfa45bc72", "aeaa0bcb-8671-3515-8020-1e9ea14b57dd", "fb379090-42f3-f6b2-70a4-269d379b8e2b"], llFloor(llFrand(2.99999))), 0.2 + llVecMag(local_pos) / 4.0);
				} else if (llDetectedVel(i) != ZERO_VECTOR && mass > 1.0) {
						local_pos = llDetectedPos(i) - llGetPos();
					llTriggerSound(llList2Key(["5da4aa20-7c19-7a06-0b9a-867dfa45bc72", "aeaa0bcb-8671-3515-8020-1e9ea14b57dd", "fb379090-42f3-f6b2-70a4-269d379b8e2b"], llFloor(llFrand(2.99999))), 0.2 + llVecMag(local_pos) / 4.0);
				}
			}
		}
	}
}

