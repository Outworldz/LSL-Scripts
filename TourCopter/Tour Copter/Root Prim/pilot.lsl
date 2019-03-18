// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1299
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

/// Pilot interface
// This script should be in the root prim.
// This script does all the listening for the vehicle.
// This script sends a message on touch with the string "touch" and the key of the person touching.

integer channel = 543;
integer power;

key pilot;

string trim(string input)
{
	return llDumpList2String(llParseString2List(input, [" "], []), " ");
}

default
{
	state_entry()
	{
		llCollisionSound("", 0.0);
		llListen(channel,"","","");

		power = FALSE;
		pilot = NULL_KEY;
	}

	on_rez(integer sparam)
	{
		llResetScript();
	}

	touch_start(integer n)
	{
		llMessageLinked(LINK_ALL_CHILDREN, 0, "touched", llDetectedKey(0));
	}

	listen(integer channel, string name, key id, string message)
	{
		message = trim(message);
		message = llToLower(message);
		if (message == "start" && !power )
		{
			power = TRUE;
			llWhisper(0, "/me Online.");
			llMessageLinked(LINK_SET, 0, "on", NULL_KEY);
			llMessageLinked(LINK_SET, 0, "start", NULL_KEY);
		}
		else if (message == "stop"  && power)
		{
			power = FALSE;
			llWhisper(0, "/me Powering Down");
			llMessageLinked(LINK_SET, 0, "stop", NULL_KEY);
			llMessageLinked(LINK_SET, 0, "off", NULL_KEY);

		} else if (message == "displayon") {
				llMessageLinked(LINK_SET, 0, "display on", NULL_KEY);
		} else if (message == "displayoff") {
				llMessageLinked(LINK_SET, 0, "display off", NULL_KEY);
		} else if (message == "unsit" ) {
				llMessageLinked(LINK_SET, 0, "unsit", NULL_KEY);
		} else if (message == "help") {
				llGiveInventory(id, "Help");
		} else if (llStringLength(message) == 1 && (string)((integer)message) == message) {
				llMessageLinked(LINK_SET, (integer)message, "set throttle", NULL_KEY);
		}
		else if (message == "demo")
		{

			llSay(0,"DEMO START");

			list demos;
			demos +=  "cannon-on";
			demos +=  "gun-aim";
			demos +=  "fire";
			demos +=  "bullet";
			demos +=  "fire-laser";
			demos +=  "gun-stop";
			demos +=  "cannon-off";
			demos +=  "bomb";
			demos +=  "start";
			demos +=  "display on";
			demos +=  "throttle";
			demos +=  "afterburner";
			demos +=  "afterburneroff";
			demos +=  "on";
			demos +=  "stop";
			demos +=  "off";
			demos +=  "unsit";

			integer i;
			integer max = llGetListLength(demos);
			for (i = 0; i < max; i++)
			{
				llSay(0,llList2String(demos,i));
				llMessageLinked(LINK_SET,10,llList2String(demos,i),NULL_KEY);
				llSleep(5.0);

			}
			llSay(0,"DEMO COMPLETED");
		}
	}

	link_message(integer sender, integer num, string str, key id)
	{
		if (str == "pilot" && id == NULL_KEY)
		{
			pilot = NULL_KEY;
			power = FALSE;
		}
		else if (str == "pilot" && id != NULL_KEY)
		{
			pilot = id;
			power = TRUE;
		}
	}
}

