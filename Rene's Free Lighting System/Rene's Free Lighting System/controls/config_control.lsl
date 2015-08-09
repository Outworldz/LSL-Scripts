// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:37:37
// :EDITED:2015-06-12  12:30:32
// :ID:1079
// :NUM:1770
// :REV:1.0.1
// :WORLD:Opensim
// :DESCRIPTION:
// Configuration Control:  Menu-controlled lighting system with many features
// :CODE:
// :LICENSE: CC0 (Public Domain)

// Rene's Free Lighting System - Configuration Control
//
// Author: Rene10957 Resident
// Date: 24-08-2014
//
// Drop this in every light bulb, instead of the light script
// Make sure the switch is in a separate prim (not root)
// Remove after use
// License: CC0 (Public Domain).
// To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.
// For more information, see http://creativecommons.org/publicdomain/zero/1.0/.


//////////////////////////////////////////
// Please read user manual before using //
//////////////////////////////////////////

string title = "Configuration Control";   // title
string version = "1.0.1.";                // version

// Constants

integer pluginChannel = 10957;            // plugin channel
integer switchChannel = -10957;           // switch channel

// Variables

list onList;
list offList;
vector color;
vector primColor;
string intensity;
string radius;
string falloff;
string alpha;
string glow;
string fullbright;
string red;
string green;
string blue;
string primRed;
string primGreen;
string primBlue;

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

	red = roundDecimals(color.x, 2);
	green = roundDecimals(color.y, 2);
	blue = roundDecimals(color.z, 2);

	primRed = roundDecimals(primColor.x, 2);
	primGreen = roundDecimals(primColor.y, 2);
	primBlue = roundDecimals(primColor.z, 2);

	llSetPrimitiveParams([
		PRIM_POINT_LIGHT, on, color, (float)intensity, (float)radius, (float)falloff,
		PRIM_COLOR, ALL_SIDES, primColor, (float)alpha,
		PRIM_GLOW, ALL_SIDES, (float)glow,
		PRIM_FULLBRIGHT, ALL_SIDES, (integer)fullbright]);

	if (on) onList = [red, green, blue, intensity, radius, falloff, alpha, glow, fullbright,
		primRed, primGreen, primBlue];
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
		if (llGetSubString(llGetObjectDesc(), 0, 3) == "#LS#") llSetObjectDesc("(No Description)");
		llMessageLinked(LINK_ALL_OTHERS, pluginChannel, "off", llGetOwner());  // request information from switch
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
