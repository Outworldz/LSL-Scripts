// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1296
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
// linked gun
//
//Revisions:
// 1/28/2010 initial release


float SPEED = 80;
integer LIFETIME = 4;
vector vel;
vector pos;
vector cpos;
rotation rot;


default
{
	state_entry()
	{

	}
	link_message(integer sender_num, integer num, string str, key id)
	{
		if (str == "bullet")
		{
			rot = llGetRot();
			pos = llGetPos();
			cpos = pos + <0.005, -0.008, 1.0> * rot;
			vel = llRot2Up(rot) * SPEED;
			llRezObject("Bullet", cpos, vel, rot, LIFETIME);
			llTriggerSound("c9b42c7b-4489-0a81-3b4b-0031412cf49a",1.0);

		}
	}
}

