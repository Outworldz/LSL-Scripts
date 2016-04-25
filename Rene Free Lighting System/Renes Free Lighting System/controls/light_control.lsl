// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:08
// :EDITED:2016-03-30  20:29:28
// :ID:1079
// :NUM:1771
// :REV:1.1
// :WORLD:Opensim
// :DESCRIPTION:
// Light Control (light without bulbs)
// :CODE:
// :LICENSE: CC0 (Public Domain)

// Rene's Free Lighting System - Light Control (light without bulbs)
//
// Author: Rene10957 Resident
// Date: 21-03-2014
//
// Use together with switch and drop in the same prim
// No other scripts are needed
// License: CC0 (Public Domain).
// To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.
// For more information, see http://creativecommons.org/publicdomain/zero/1.0/.


//////////////////////////////////////////
// Please read user manual before using //
//////////////////////////////////////////

string title = "Light Control";   // title
string version = "1.1";           // version
integer silent = TRUE;            // silent startup

// Constants

integer switchChannel = -10957;   // switch channel

// Functions

string getGroup(integer link)
{
	list desc = llGetLinkPrimitiveParams(link, [PRIM_DESC]);
	string str = llToLower(llStringTrim(llList2String(desc, 0), STRING_TRIM));
	if (str == "(no description)" || str == "") str = "default";
	return str;
}

unpackMessage(string msg)
{
	list msgList = llCSV2List(msg);
	string group = llToLower(llList2String(msgList, 0));
	integer on = (integer)llList2String(msgList, 1);
	vector color = (vector)llList2String(msgList, 2);
	float intensity = (float)llList2String(msgList, 3);
	float radius = (float)llList2String(msgList, 4);
	float falloff = (float)llList2String(msgList, 5);
	float alpha = (float)llList2String(msgList, 6);
	float glow = (float)llList2String(msgList, 7);
	integer fullbright = (integer)llList2String(msgList, 8);
	vector primColor = (vector)llList2String(msgList, 9);

	integer i;
	integer number = llGetNumberOfPrims();
	integer link = llGetLinkNumber();

	for (i = number; i >= 0; --i) {
		if (group == getGroup(i)) {
			if (i != link || i < 2) {
				llSetLinkPrimitiveParamsFast(i, [
					PRIM_POINT_LIGHT, on, color, intensity, radius, falloff,
					PRIM_COLOR, ALL_SIDES, primColor, alpha,
					PRIM_GLOW, ALL_SIDES, glow,
					PRIM_FULLBRIGHT, ALL_SIDES, fullbright]);
			}
		}
	}
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
		if (number == switchChannel) unpackMessage(msg);
	}
}
