// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:56
// :EDITED:2015-06-12  12:30:32
// :ID:1079
// :NUM:1789
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Nightlight switch:  drop this script into the same prim where the SWITCH is located
// :CODE:
// :LICENSE: CC0 (Public Domain)

// Night light plugin for Rene's Free Lighting System
// A simple example script for creating your own plugin
//
// Automatically switches on at sunset and off at sunrise

/////////////////////////////////////////////////////////////////////////////////
// HOW TO USE: drop this script into the same prim where the SWITCH is located //
/////////////////////////////////////////////////////////////////////////////////

key owner;                // object owner
integer number = 10957;   // number part of link message

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
