// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:39
// :EDITED:2015-06-12  16:41:14
// :ID:1079
// :NUM:1780
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Drop in any prim and touch for on/off
// :CODE:

// Each prim in a link set that has a Description of #LS# will become a light. This is the switch

//:LICENSE: CC0 (Public Domain)

// Rene's Free Lighting System - Switch Control
//
// Drop in any prim and touch for on/off
// No switch or light scripts are needed
// License: CC0 (Public Domain).
// To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.
// For more information, see http://creativecommons.org/publicdomain/zero/1.0/.


//////////////////////////////////////////
// Please read user manual before using //
//////////////////////////////////////////

string title = "Switch Control";   // title
string version = "1.0";            // version
integer silent = TRUE;             // silent startup

// Variables

integer on = FALSE;                // on-off switch

// Functions

switchLight()
{
	string desc;
	list descList;
	list configList;
	vector color;
	vector primColor;
	float intensity;
	float radius;
	float falloff;
	float alpha;
	float glow;
	integer fullbright;

	integer i;
	integer number = llGetNumberOfPrims();

	for (i = number; i >= 0; --i) {
		descList = llGetLinkPrimitiveParams(i, [PRIM_DESC]);
		desc = llList2String(descList, 0);
		if (llGetSubString(desc, 0, 3) == "#LS#") {
			configList = llParseStringKeepNulls(desc, [";"], []);
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
			}
			else {
				color.x = (float)llList2String(configList, 13);
				color.y = (float)llList2String(configList, 14);
				color.z = (float)llList2String(configList, 15);
				alpha = (float)llList2String(configList, 16);
				glow = 0.0;
				fullbright = FALSE;
				primColor = color;
			}
			llSetLinkPrimitiveParamsFast(i, [
				PRIM_POINT_LIGHT, on, color, intensity, radius, falloff,
				PRIM_COLOR, ALL_SIDES, primColor, alpha,
				PRIM_GLOW, ALL_SIDES, glow,
				PRIM_FULLBRIGHT, ALL_SIDES, fullbright]);
		}
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
