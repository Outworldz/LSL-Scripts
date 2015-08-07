// :SHOW:1
// :CATEGORY:Fire
// :NAME:Realfire by Rene
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting
// :CREATED:2015-06-11 14:37:23
// :EDITED:2015-06-12  11:25:11
// :ID:1078
// :NUM:1761
// :REV:1.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// RGB to LSL color conversion
// :CODE:
//:LICENSE: CC0 (Public Domain). To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.For more information, see http://creativecommons.org/publicdomain/zero/1.0/.
// Smoke control (smoke without fire) for RealFire
//
// Author: Rene10957 Resident
// Date: 02-02-2014
//
// Use together with smoke script and drop in the same prim
// No other scripts are needed

string title = "Smoke Control";   // title
string version = "1.1";           // version
integer silent = TRUE;            // silent startup

// Constants

integer smokeChannel = -15790;    // smoke channel
integer on = FALSE;               // smoke on/off

// Functions

toggleSmoke()
{
	if (on) sendMessage(0); else sendMessage(100);
	on = !on;
}

sendMessage(integer number)
{
	llMessageLinked(LINK_THIS, smokeChannel, (string)number, "");
}

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
		toggleSmoke();
	}
}
