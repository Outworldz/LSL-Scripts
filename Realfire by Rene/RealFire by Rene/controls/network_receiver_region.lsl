// :SHOW:1
// :CATEGORY:Fire
// :NAME:Realfire by Rene
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting
// :CREATED:2015-06-11 14:37:17
// :EDITED:2015-06-12  11:25:11
// :ID:1078
// :NUM:1758
// :REV:2.2.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Network receiver for RealFire
// :CODE:
//:LICENSE: CC0 (Public Domain). To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.For more information, see http://creativecommons.org/publicdomain/zero/1.0/.
// 
// Network receiver for RealFire
// Drop this into the same prim where the FIRE SCRIPT is located
// Note: only useful if you are also using the network control script

string title = "Network Receiver";   // title
string version = "2.2.1";            // version
integer linkSet = FALSE;             // REGION mode
integer silent = TRUE;               // silent startup

// Constants

integer remoteChannel = -975101;     // remote channel
integer replyChannel = -975106;      // reply channel
integer msgNumber = 10959;           // number part of link message
string separator = ";;";             // separator for link or region messages

// Variables

key owner;                           // object owner

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
			llRegionSayTo(id, replyChannel, "DATA");
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
			llRegionSayTo(id, replyChannel, "DATA");
			return;
		}
		list msgList = llParseString2List(msg, [separator], []);
		string command = llList2String(msgList, 1);
		key user = (key)llList2String(msgList, 2);
		llMessageLinked(LINK_THIS, msgNumber, command, user);
	}
}
