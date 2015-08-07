// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:52
// :EDITED:2015-06-12  12:30:32
// :ID:1079
// :NUM:1786
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// RGB to LSL color conversion
// :CODE:
// :LICENSE: CC0 (Public Domain)

// Rene's Free Lighting System - RGB to LSL color conversion
//
// Author: Rene10957 Resident
// Date: 12-01-2014
//
// Rez a cube, drop the script in it and touch it
// Enter the resulting color vector into the notecard next to "colorOn" or "colorOff"

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
