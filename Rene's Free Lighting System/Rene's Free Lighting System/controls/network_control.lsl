// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:21
// :EDITED:2015-06-12  16:41:14
// :ID:1079
// :NUM:1774
// :REV:2.3.2
// :WORLD:Opensim
// :DESCRIPTION:
// Drop this in any prim you want to use as a control panel
// :CODE:
// :LICENSE: CC0 (Public Domain)
// Network control for Rene's Free Lighting System
//
// Author: Rene10957 Resident
// Date: 05-10-2014
//
// Drop this in any prim you want to use as a control panel
// License: CC0 (Public Domain).
// To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.
// For more information, see http://creativecommons.org/publicdomain/zero/1.0/.


string title = "Network Control";   // title
string version = "2.3.2";           // version
integer linkSet = TRUE;             // LINKSET mode
integer silent = TRUE;              // silent startup

// Constants

float cDialogTime = 120.0;          // dialog timeout = 2 minutes
float cReplyTime = 1.0;             // reply timeout = 1 second
integer remoteChannel = -975103;    // remote channel (send)
integer replyChannel = -975105;     // reply channel (receive)
string separator = ";;";            // separator for link or region messages

// Variables

float time;                         // timer interval for multiple timers
float vReplyTime;                   // variable timeout for node discovery, ranging from 1 to 2 sec.
integer dialogChannel;              // dialog channel
integer dialogHandle;               // handle for dialog listener
integer replyHandle;                // handle for reply listener
key owner;                          // object owner
key user;                           // key of last avatar to touch object
list networkNodes;                  // strided list of network nodes (object key, object name)
list menuButtons;                   // menu buttons (object names)

// Functions

list orderButtons(list buttons)
{
	return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) + llList2List(buttons, -9, -7);
}

float setTimer(float sec)
{
	llSetTimerEvent(0.0);
	llSetTimerEvent(sec);
	return sec;
}

discoverNodes(key id)
{
	llWhisper(0, "Discovering network nodes...");
	networkNodes = [];
	llListenRemove(replyHandle);
	replyHandle = llListen(replyChannel, "", "", "");
	float pctlag = 100.0 * (1.0 - llGetRegionTimeDilation());  // try to work around time dilation
	vReplyTime = cReplyTime + cReplyTime / 100.0 * pctlag;  // (more lag = longer timeout)
	time = setTimer(vReplyTime);
	if (linkSet) llMessageLinked(LINK_ALL_OTHERS, remoteChannel, "PING", llGetKey());
	else llRegionSay(remoteChannel, "PING");
}

menuDialog (key id)
{
	dialogChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
	llListenRemove(dialogHandle);
	dialogHandle = llListen(dialogChannel, "", "", "");
	time = setTimer(cDialogTime);
	llDialog(id, title + " " + version, menuButtons, dialogChannel);
}

default
{
	state_entry()
	{
		owner = llGetOwner();
		if (linkSet) version += "-LINKSET";
		else version += "-REGION";
		if (!silent) llWhisper(0, title + " " + version + " ready");
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	touch_start(integer total_number)
	{
		user = llDetectedKey(0);
		if (llGetListLength(networkNodes) == 0) discoverNodes(user);
		else menuDialog(user);
	}

	listen(integer channel, string name, key id, string msg)
	{
		integer length = llGetListLength(networkNodes) / 2;

		if (channel == replyChannel) {
			if (llGetOwnerKey(id) != owner) return;
			if (length > 8) return;
			string shortName = llGetSubString(msg, 0, 23);
			networkNodes += [id, shortName];
		}
		else if (channel == dialogChannel) {
			llSetTimerEvent(0);
			llListenRemove(dialogHandle);
			integer i;
			integer index;
			key target;
			list msgList;
			string msgData;
			if (msg == "On") {
				for (i = 0; i < length; ++i) {
					target = llList2Key(networkNodes, i * 2);
					msgList = [target, "on", id];  // id = user who opened the dialog
					msgData = llDumpList2String(msgList, separator);
					if (linkSet) llMessageLinked(LINK_ALL_OTHERS, remoteChannel, msgData, "");
					else llRegionSayTo(target, remoteChannel, msgData);
				}
				menuDialog(id);
			}
			else if (msg == "Off") {
				for (i = 0; i < length; ++i) {
					target = llList2Key(networkNodes, i * 2);
					msgList = [target, "off", id];  // id = user who opened the dialog
					msgData = llDumpList2String(msgList, separator);
					if (linkSet) llMessageLinked(LINK_ALL_OTHERS, remoteChannel, msgData, "");
					else llRegionSayTo(target, remoteChannel, msgData);
				}
				menuDialog(id);
			}
			else if (msg == "Discover") {
				discoverNodes(id);
			}
			else {
				index = llListFindList(networkNodes, [msg]);
				if (index > -1) {
					target = llList2Key(networkNodes, index - 1);
					msgList = [target, "menu", id];  // id = user who opened the dialog
					msgData = llDumpList2String(msgList, separator);
					if (linkSet) llMessageLinked(LINK_ALL_OTHERS, remoteChannel, msgData, "");
					else llRegionSayTo(target, remoteChannel, msgData);
				}
				else {
					llInstantMessage(id, "Unexpected error during object key lookup");
					menuDialog(id);
				}
			}
		}
	}

	timer()
	{
		llSetTimerEvent(0);
		if (time == cDialogTime) {  // dialog timeout
			llListenRemove(dialogHandle);
		}
		else if (time == vReplyTime) {  // remote timeout (variable!)
			integer length = llGetListLength(networkNodes) / 2;
			if (length == 1) llWhisper(0, "Node discovery completed (" + (string)length + " node)");
			else llWhisper(0, "Node discovery completed (" + (string)length + " nodes)");
			llListenRemove(replyHandle);
			if (length > 0) {
				menuButtons = llList2ListStrided(networkNodes, 1, -1, 2);
				menuButtons = llListSort(menuButtons, 1, TRUE);  // sort ascending
				menuButtons = orderButtons(menuButtons);         // reverse row order
				menuButtons = ["On", "Off", "Discover"] + menuButtons;
				if (user) menuDialog(user);
			}
		}
	}
}
