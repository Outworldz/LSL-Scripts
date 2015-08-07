// :SHOW:1
// :CATEGORY:Fire
// :NAME:Realfire by Rene
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting
// :CREATED:2015-06-11 14:37:24
// :EDITED:2015-06-12  11:25:11
// :ID:1078
// :NUM:1762
// :REV:1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// A simple example script for creating your own plugin
// :CODE:
//:LICENSE: CC0 (Public Domain). To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.For more information, see http://creativecommons.org/publicdomain/zero/1.0/.
// Night fire plugin for RealFire
// A simple example script for creating your own plugin
//
// Automatically switches on at sunset and off at sunrise

///////////////////////////////////////////////////////////////////////////////
// HOW TO USE: drop this into the same prim where the FIRE SCRIPT is located //
///////////////////////////////////////////////////////////////////////////////

key owner;                // object owner
integer number = 10959;   // number part of link message

default
{
	state_entry()
	{
		owner = llGetOwner();
		llSetTimerEvent(300);
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	timer()
	{
		vector sun = llGetSunDirection();
		if (sun.z < 0) llMessageLinked(LINK_THIS, number, "on", owner);
		else llMessageLinked(LINK_THIS, number, "off", owner);
	}
}
