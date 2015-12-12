// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:20
// :EDITED:2015-06-12  16:41:14
// :ID:1079
// :NUM:1773
// :REV:1.2
// :WORLD:Opensim
// :DESCRIPTION:
// Link receiver for Rene's Free Lighting System
// :CODE:
// :LICENSE: CC0 (Public Domain)


//
// Author: Rene10957 Resident
// Date: 24-01-2014
//
// Drop this into the same prim where the SWITCH is located
// Note: only useful if you are also using the link control script
// License: CC0 (Public Domain).
// To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.
// For more information, see http://creativecommons.org/publicdomain/zero/1.0/.


string title = "Link Receiver";   // title
string version = "1.2";           // version
integer silent = TRUE;            // silent startup

// Constants

integer msgIn = -975104;          // number part of incoming link message
integer msgOut = 10957;           // number part of outgoing link message
string separator = ";;";          // separator for link messages

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

	link_message(integer sender_number, integer number, string msg, key id)
	{
		if (number != msgIn) return;

		list msgList = llParseString2List(msg, [separator], []);
		string group = llList2String(msgList, 0);
		string command = llList2String(msgList, 1);
		key user = (key)llList2String(msgList, 2);

		if (llToLower(group) == llToLower(getGroup())) llMessageLinked(LINK_THIS, msgOut, command, user);
	}
}
