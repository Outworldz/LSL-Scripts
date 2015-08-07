// :SHOW:1
// :CATEGORY:Fire
// :NAME:Realfire by Rene
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting
// :CREATED:2015-06-11 14:36:47
// :EDITED:2015-06-12  11:25:11
// :ID:1078
// :NUM:1754
// :REV:1.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Link control (secondary switch) for RealFire
// :CODE:
//:LICENSE: CC0 (Public Domain). To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.For more information, see http://creativecommons.org/publicdomain/zero/1.0/.

// Link control (secondary switch) for RealFire
//
//
// Drop this in any prim (within the same linkset) you want to use as an on/off/menu switch
// Note: only useful if you want to use a different prim as a switch (other than the fire prim)

string title = "Link Control";   // title
string version = "1.1";          // version
integer silent = TRUE;           // silent startup

// Constants

integer msgNumber = 10959;       // number part of link message

default
{
	state_entry()
	{
		if (!silent) llWhisper(0, title + " " + version + " ready");
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	touch_start(integer total_number)
	{
		llResetTime();
	}

	touch_end(integer total_number)
	{
		key user = llDetectedKey(0);

		if (llGetTime() > 1.0) {
			llMessageLinked(LINK_ALL_OTHERS, msgNumber, "menu", user);
		}
		else {
			llMessageLinked(LINK_ALL_OTHERS, msgNumber, "switch", user);
		}
	}
}
