// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:37
// :EDITED:2015-06-12  12:30:32
// :ID:1079
// :NUM:1779
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// Drop this into the same prim where the SWITCH is located
// :CODE:
// :LICENSE: CC0 (Public Domain)
// Remote receiver for Rene's Free Lighting System
//
// Author: Rene10957 Resident
// Date: 24-01-2014
//
// Drop this into the same prim where the SWITCH is located
// Note: only useful if you are also using the remote control script
// License: CC0 (Public Domain).
// To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.
// For more information, see http://creativecommons.org/publicdomain/zero/1.0/.


string title = "Remote Receiver";   // title
string version = "1.1";             // version
integer silent = TRUE;              // silent startup

// Constants

integer remoteChannel = -975104;    // remote channel
integer msgNumber = 10957;          // number part of link message
string separator = ";;";            // separator for region messages

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
		llListen(remoteChannel, "", "", "");
		if (!silent) llWhisper(0, title + " " + version + " ready");
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	listen(integer channel, string name, key id, string msg)
	{
		if (channel != remoteChannel) return;

		list msgList = llParseString2List(msg, [separator], []);
		string group = llList2String(msgList, 0);
		string command = llList2String(msgList, 1);
		key user = (key)llList2String(msgList, 2);

		if (llToLower(group) == llToLower(getGroup())) llMessageLinked(LINK_THIS, msgNumber, command, user);
	}
}
