// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:57
// :EDITED:2015-06-12  12:30:32
// :ID:1079
// :NUM:1790
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Proximity Switch:  drop this script into the same prim where the SWITCH is located
// :CODE:
// :LICENSE: CC0 (Public Domain)
// Proximity light plugin for Rene's Free Lighting System
// A simple example script for creating your own plugin
//
// Automatically switches on when an avatar comes within 10 meters
// Automatically switches off after one minute when no avatars are in range

/////////////////////////////////////////////////////////////////////////////////
// HOW TO USE: drop this script into the same prim where the SWITCH is located //
/////////////////////////////////////////////////////////////////////////////////

key owner;                // object owner
integer number = 10957;   // number part of link message
float range = 10.0;       // scan range in meters
float rate = 10.0;        // scan rate in seconds

default
{
	state_entry()
	{
		owner = llGetOwner();
		llSensorRepeat("", "", AGENT_BY_USERNAME, range, PI, rate);
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	sensor(integer total_number)
	{
		rate = 60.0;
		llMessageLinked(LINK_THIS, number, "on", owner);
		llSensorRemove();
		llSensorRepeat("", "", AGENT_BY_USERNAME, range, PI, rate);
	}

	no_sensor()
	{
		rate = 10.0;
		llMessageLinked(LINK_THIS, number, "off", owner);
		llSensorRemove();
		llSensorRepeat("", "", AGENT_BY_USERNAME, range, PI, rate);
	}
}
