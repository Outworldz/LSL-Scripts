// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1295
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
// bombs
//has 2 objects, Bomb ver 1 and Bullet
// Ejection
//
//Revisions:
// 1/28/2010 initial release

default
{


	link_message(integer sender, integer num, string message, key id)
	{
		if (message=="bomb")
		{
			rotation    my_rot = llGetRot();
			vector      my_fwd = llRot2Fwd(my_rot);
			vector pos = llGetPos();
			rotation rot = llGetRot();
			vector offset = <0.7, 0.4, 0.0>;
			vector vel = <0.0,3.0,0.0>*llGetRot() + llGetVel();
			offset *= rot;
			pos += offset;
			llRezObject("Bomb ver 1", pos, vel, my_rot, 1);
			llTriggerSound("01ef193d-09c6-47f3-8ae3-b36e689599e8",1);
			llStopPointAt();
		}
	}
}
