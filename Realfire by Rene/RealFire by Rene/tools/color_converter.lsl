// :SHOW:1
// :CATEGORY:Fire
// :NAME:Realfire by Rene
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting
// :CREATED:2015-06-11 14:37:35
// :EDITED:2015-06-12  16:41:14
// :ID:1078
// :NUM:1769
// :REV:3.0.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// RGB to LSL color conversion
// :CODE:
//:LICENSE: CC0 (Public Domain). To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.For more information, see http://creativecommons.org/publicdomain/zero/1.0/.

// Rez a cube, drop the script in it and touch it
// Enter the resulting color vector into the notecard next to "topColor" and/or "bottomColor"

string title = "Color converter";   // title
string version = "1.0";             // version

// Variables

integer boxChannel;                 // text box channel
integer boxHandle;                  // handle for text box listener

default
{
	state_entry()
	{
		llWhisper(0, title + " " + version + " ready");
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	touch_start(integer total_number)
	{
		boxChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
		llListenRemove(boxHandle);
		boxHandle = llListen(boxChannel, "", "", "");
		llSetTimerEvent(0);
		llSetTimerEvent(120);
		llTextBox(llDetectedKey(0), "\nEnter RGB color as <R,G,B>\ne.g. <255,0,0> for red", boxChannel);
	}

	listen(integer channel, string name, key id, string msg)
	{
		if (channel != boxChannel) return;
		llSetTimerEvent(0);
		llListenRemove(boxHandle);

		vector rgb = (vector)msg;
		vector lsl = rgb / 255.0;
		vector per = lsl * 100.0;
		per.x = (float)llRound(per.x);
		per.y = (float)llRound(per.y);
		per.z = (float)llRound(per.z);

		llOwnerSay("RGB color = " + "< " + (string)((integer)rgb.x) + ", " +
			(string)((integer)rgb.y) + ", " + (string)((integer)rgb.z) + " >");
		llOwnerSay("LSL color = " + "< " + (string)lsl.x + ", " +
			(string)lsl.y + ", " + (string)lsl.z + " >");
		llOwnerSay("Notecard color = " + "< " + (string)((integer)per.x) + ", " +
			(string)((integer)per.y) + ", " + (string)((integer)per.z) + " >");
	}

	timer()
	{
		llSetTimerEvent(0);
		llListenRemove(boxHandle);
		llOwnerSay("Text box timeout");
	}
}
