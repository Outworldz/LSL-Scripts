// :SHOW:1
// :CATEGORY:Fire
// :NAME:Realfire by Rene
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting
// :CREATED:2015-06-11 14:37:21
// :EDITED:2015-06-12  16:41:13
// :ID:1078
// :NUM:1760
// :REV:1.2
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Remote receiver for RealFire
// :CODE:
//:LICENSE: CC0 (Public Domain). To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.For more information, see http://creativecommons.org/publicdomain/zero/1.0/.

// Remote receiver for RealFire
//

// Drop this into the same prim where the FIRE SCRIPT is located
// Note: only useful if you are also using the remote control script

string title = "Remote Receiver";   // title
string version = "1.2";             // version
integer silent = TRUE;              // silent startup

// Constants

integer remoteChannel = -975102;    // remote channel
integer msgNumber = 10959;          // number part of link message
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

		if (group == getGroup() || group == "Default" || getGroup() == "Default") {
			llMessageLinked(LINK_THIS, msgNumber, command, user);
		}
	}
}
