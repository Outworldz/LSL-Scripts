// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:35
// :EDITED:2015-06-12  16:41:14
// :ID:1079
// :NUM:1778
// :REV:1.1
// :WORLD:Opensim
// :DESCRIPTION:
// Drop this in an external prim you want to use as an extra on/off/menu switch
// :CODE:
// :LICENSE: CC0 (Public Domain)
// Remote control (secondary switch) for Rene's Free Lighting System
//
// Author: Rene10957 Resident
// Date: 24-01-2014
//
// Drop this in an external prim you want to use as an extra on/off/menu switch
// Note: only useful if you need multiple switches for the same light group in REGION mode
// License: CC0 (Public Domain).
// To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.
// For more information, see http://creativecommons.org/publicdomain/zero/1.0/.


string title = "Remote Control";   // title
string version = "1.1";            // version
integer silent = TRUE;             // silent startup

// Constants

integer remoteChannel = -975104;   // remote channel
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
