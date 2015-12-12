// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:33
// :EDITED:2015-06-12  16:41:14
// :ID:1079
// :NUM:1777
// :REV:2.2.1
// :WORLD:Opensim
// :DESCRIPTION:
// Drop this into the same prim where the SWITCH is located
// :CODE:
// :LICENSE: CC0 (Public Domain)

// Network receiver for Rene's Free Lighting System
//
// Author: Rene10957 Resident
// Date: 05-10-2014
//
// Drop this into the same prim where the SWITCH is located
// Note: only useful if you are also using the network control script
// License: CC0 (Public Domain).
// To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.
// For more information, see http://creativecommons.org/publicdomain/zero/1.0/.


string title = "Network Receiver";   // title
string version = "2.2.1";            // version
integer linkSet = FALSE;             // REGION mode
integer silent = TRUE;               // silent startup

// Constants

integer remoteChannel = -975103;     // remote channel
integer replyChannel = -975105;      // reply channel
integer msgNumber = 10957;           // number part of link message
string separator = ";;";             // separator for link or region messages

// Variables

key owner;                           // object owner

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
		owner = llGetOwner();
		if (linkSet) {
			version += "-LINKSET";
		}
		else {
			version += "-REGION";
			llListen(remoteChannel, "", "", "");
		}
		if (!silent) llWhisper(0, title + " " + version + " ready");
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	link_message(integer sender_number, integer number, string msg, key id)
	{
		if (number != remoteChannel) return;
		if (msg == "PING") {
			llRegionSayTo(id, replyChannel, getGroup());
			return;
		}
		list msgList = llParseString2List(msg, [separator], []);
		key target = (key)llList2String(msgList, 0);
		string command = llList2String(msgList, 1);
		key user = (key)llList2String(msgList, 2);
		if (target == llGetKey()) llMessageLinked(LINK_THIS, msgNumber, command, user);
	}

	listen(integer channel, string name, key id, string msg)
	{
		if (channel != remoteChannel) return;
		if (llGetOwnerKey(id) != owner) return;
		if (msg == "PING") {
			llRegionSayTo(id, replyChannel, getGroup());
			return;
		}
		list msgList = llParseString2List(msg, [separator], []);
		string command = llList2String(msgList, 1);
		key user = (key)llList2String(msgList, 2);
		llMessageLinked(LINK_THIS, msgNumber, command, user);
	}
}
