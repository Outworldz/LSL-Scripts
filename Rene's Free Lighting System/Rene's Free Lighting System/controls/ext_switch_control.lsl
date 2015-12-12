// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:39:48
// :EDITED:2015-06-12  16:41:14
// :ID:1079
// :NUM:1770
// :REV:1.0
// :WORLD:Opensim
// :DESCRIPTION:
//  Drop in any prim and touch for on/off
// :CODE:
// :LICENSE: CC0 (Public Domain)

// Rene's Free Lighting System - Extended Switch Control
//
// Author: Rene10957 Resident
// Date: 21-03-2014
//
// Drop in any prim and touch for on/off
// License: CC0 (Public Domain).
// To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.
// For more information, see http://creativecommons.org/publicdomain/zero/1.0/.


//////////////////////////////////////////
// Please read user manual before using //
//////////////////////////////////////////

string title = "Extended Switch Control";   // title
string version = "1.0";                     // version
integer silent = TRUE;                      // silent startup

// Constants

integer switchChannel = -10957;             // switch channel

// Variables

integer on = FALSE;                         // on-off switch

// Functions

switchLight()
{
	vector color;
	vector primColor;
	vector particleColor;
	float intensity;
	float radius;
	float falloff;
	float alpha;
	float glow;
	integer fullbright;
	integer particleSize;
	string particleTexture;
	string desc = llGetObjectDesc();

	if (llGetSubString(desc, 0, 3) == "#LS#") {
		list configList = llParseStringKeepNulls(desc, [";"], []);
		if (on) {
			color.x = (float)llList2String(configList, 1);
			color.y = (float)llList2String(configList, 2);
			color.z = (float)llList2String(configList, 3);
			intensity = (float)llList2String(configList, 4);
			radius = (float)llList2String(configList, 5);
			falloff = (float)llList2String(configList, 6);
			alpha = (float)llList2String(configList, 7);
			glow = (float)llList2String(configList, 8);
			fullbright = (integer)llList2String(configList, 9);
			primColor.x = (float)llList2String(configList, 10);
			primColor.y = (float)llList2String(configList, 11);
			primColor.z = (float)llList2String(configList, 12);
			particleColor.x = (float)llList2String(configList, 13);
			particleColor.y = (float)llList2String(configList, 14);
			particleColor.z = (float)llList2String(configList, 15);
			particleSize = (integer)llList2String(configList, 16);
			particleTexture = llList2String(configList, 17);
		}
		else {
			color.x = (float)llList2String(configList, 18);
			color.y = (float)llList2String(configList, 19);
			color.z = (float)llList2String(configList, 20);
			alpha = (float)llList2String(configList, 21);
			glow = 0.0;
			fullbright = FALSE;
			primColor = color;
		}

		list sendList = ["Default", on, color, intensity, radius, falloff, alpha, glow, fullbright,
			primColor, particleColor, particleSize, 999, particleTexture, on];
		string sendMsg = llList2CSV(sendList);
		llMessageLinked(LINK_ALL_OTHERS, switchChannel, sendMsg, "");
	}
}

default
{
	state_entry()
	{
		switchLight();
		if (!silent) llWhisper(0, title + " " + version + " ready");
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	touch_start(integer total_number)
	{
		on = !on;
		switchLight();
	}
}
