// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:38:41
// :EDITED:2015-06-12  12:30:32
// :ID:1079
// :NUM:1770
// :REV:1.0.1
// :WORLD:Opensim
// :DESCRIPTION:
// Extended Configuration Control
// :CODE:
// :LICENSE: CC0 (Public Domain)

// Rene's Free Lighting System - Extended Configuration Control
//
// Author: Rene10957 Resident
// Date: 24-08-2014
//
// Drop this in a separate prim (not root) together with the switch
// Remove after use
// License: CC0 (Public Domain).
// To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.
// For more information, see http://creativecommons.org/publicdomain/zero/1.0/.


//////////////////////////////////////////
// Please read user manual before using //
//////////////////////////////////////////

string title = "Extended Configuration Control";   // title
string version = "1.0.1";                          // version

// Constants

integer pluginChannel = 10957;                     // plugin channel
integer switchChannel = -10957;                    // switch channel

// Variables

list onList;
list offList;
vector color;
vector primColor;
vector particleColor;
string intensity;
string radius;
string falloff;
string alpha;
string glow;
string fullbright;
string particleSize;
string particleTexture;
string red;
string green;
string blue;
string primRed;
string primGreen;
string primBlue;
string partRed;
string partGreen;
string partBlue;

// Functions

string roundDecimals(float number, float decimals)
{
	integer intNumber = llRound(number * llPow(10, decimals));  // move decimal point to the right and round
	float fltNumber = (float)intNumber / llPow(10, decimals);   // move it back to the left
	string strNumber = (string)fltNumber;                       // cast to string
	string end = llGetSubString(strNumber, -1, -1);
	while (end == "0") {                                        // remove trailing zeroes
		strNumber = llDeleteSubString(strNumber, -1, -1);
		end = llGetSubString(strNumber, -1, -1);
	}
	if (end == ".") {
		return llGetSubString(strNumber, 0, -2);
	}
	else {
		if (llGetSubString(strNumber, 0, 0) == "0") return llGetSubString(strNumber, 1, -1);
		else return strNumber;
	}
}

storeData(string msg)
{
	list msgList = llCSV2List(msg);
	integer on = (integer)llList2String(msgList, 1);
	color = (vector)llList2String(msgList, 2);
	intensity = roundDecimals((float)llList2String(msgList, 3), 2);
	radius = roundDecimals((float)llList2String(msgList, 4), 2);
	falloff = roundDecimals((float)llList2String(msgList, 5), 2);
	alpha = roundDecimals((float)llList2String(msgList, 6), 2);
	glow = roundDecimals((float)llList2String(msgList, 7), 2);
	fullbright = llList2String(msgList, 8);
	primColor = (vector)llList2String(msgList, 9);
	particleColor = (vector)llList2String(msgList, 10);
	particleSize = llList2String(msgList, 11);
	particleTexture = llList2String(msgList, 13);

	red = roundDecimals(color.x, 2);
	green = roundDecimals(color.y, 2);
	blue = roundDecimals(color.z, 2);

	primRed = roundDecimals(primColor.x, 2);
	primGreen = roundDecimals(primColor.y, 2);
	primBlue = roundDecimals(primColor.z, 2);

	partRed = roundDecimals(particleColor.x, 2);
	partGreen = roundDecimals(particleColor.y, 2);
	partBlue = roundDecimals(particleColor.z, 2);

	// Since the description differs from other prims, switch-to-light communication will fail.
	// Solution: fake the switch message and pretend this is the default group.

	list sendList = ["Default", on, color, intensity, radius, falloff, alpha, glow, fullbright,
		primColor, particleColor, particleSize, 999, particleTexture, on];
	string sendMsg = llList2CSV(sendList);
	llMessageLinked(LINK_ALL_OTHERS, switchChannel, sendMsg, "");

	if (on) onList = [red, green, blue, intensity, radius, falloff, alpha, glow, fullbright,
		primRed, primGreen, primBlue, partRed, partGreen, partBlue, particleSize, particleTexture];
	else offList = [red, green, blue, alpha];

	if (llGetListLength(onList) > 0 && llGetListLength(offList) > 0) {
		string desc = llDumpList2String(["#LS#"] + onList + offList, ";");
		llSetObjectDesc(desc);
	}
}

default
{
	state_entry()
	{
		integer i;
		integer number = llGetNumberOfPrims();
		list descList;
		string desc;

		for (i = number; i >= 0; --i) {
			descList = llGetLinkPrimitiveParams(i, [PRIM_DESC]);
			desc = llList2String(descList, 0);
			if (llGetSubString(desc, 0, 3) == "#LS#") llSetLinkPrimitiveParamsFast(i, [PRIM_DESC,"(No Description)"]);
		}

		llMessageLinked(LINK_THIS, pluginChannel, "off", llGetOwner());  // request information from switch
		llWhisper(0, title + " " + version + " ready");
		llOwnerSay("Please remove the script after use");
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	link_message(integer sender_number, integer number, string msg, key id)
	{
		if (number == switchChannel) storeData(msg);
	}
}
