// :SHOW:1
// :CATEGORY:Fire
// :NAME:Realfire by Rene
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting
// :CREATED:2015-06-11 14:37:20
// :EDITED:2015-06-12  16:41:13
// :ID:1078
// :NUM:1759
// :REV:1.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Remote control (secondary switch) for RealFire
// :CODE:
//:LICENSE: CC0 (Public Domain). To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.For more information, see http://creativecommons.org/publicdomain/zero/1.0/.

// Remote control (secondary switch) for RealFire
//
// Drop this in an external prim you want to use as an extra on/off/menu switch
// Note: only useful if you need an external switch for a single fire
//
// A switch can be bound to a fire by entering the same word in the description of both prims
// Alternatively, you can use the network switch to control up to 9 fires

string title = "Remote Control";   // title
string version = "1.1";            // version
integer silent = TRUE;             // silent startup

// Constants

integer remoteChannel = -975102;   // remote channel
string separator = ";;";           // separator for region messages

// Functions

string getGroup()
{
	string str = llStringTrim(llGetObjectDesc(), STRING_TRIM);
	if (llToLower(str) == "(no description)" || str == "") str = "Default";
	return str;
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
		llResetTime();
	}

	touch_end(integer total_number)
	{
		key user = llDetectedKey(0);
		string command;

		if (llGetTime() > 1.0) command = "menu";
		else command = "switch";

		list msgList = [getGroup(), command, user];
		string msgData = llDumpList2String(msgList, separator);
		llRegionSay(remoteChannel, msgData);
	}
}
