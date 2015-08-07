// :CATEGORY:Invisibility
// :NAME:Prims_Visible_When_Running
// :AUTHOR:mangowylder
// :CREATED:2011-04-18 14:38:37.010
// :EDITED:2013-09-18 15:39:00
// :ID:657
// :NUM:894
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Prims_Visible_When_Running
// :CODE:
// Script to turn linked prims visible when running and invisible otherwise.
//
// The object will be invisible when you wear it so if you need to see it
// while not running, toggle CTRL-ALT-T
//
// hex values per http://wiki.secondlife.com/wiki/LlGetAgentInfo
// The above wiki shows AGENT_WALKING as 0x0080 (128)
// My testing shows that AGENT_WALKING is 0x0086 (134)
// Running a modified version of llGetAgentInfo test script returns 134 for AGENT_WALKING
// I just added an LLOwnerSay to the AGENT_WALKING (after line 74) part to snag the value.
// llInstantMessage(llGetOwner(), (string) info);
// I took off everything except my shape, skin, eyes and Phoenix #LSL<->Client Bridge v0.12
// S.Count on myself shows one script running which would be the Phoenix #LSL<->Client Bridge v0.12
// I wonder if that could cause the discrepency?
// the llGetAgentInfo test script can be found at...
// http://wiki.secondlife.com/wiki/LlGetAgentInfo_Test
//
// I'd credit the original author but I don't know who it is.
//
// Comments by Mango Wylder

integer runningstate;

default
{
	state_entry()
	{
		llSetTimerEvent(1);
	}
	on_rez(integer sparam){
		llResetScript();
	}

	timer()
	{
		integer buf = llGetAgentInfo(llGetOwner());
		// Need the && here because buf will be equal to AGENT_ALWAYS_RUN 0x1000(4096) and
		// AGENT_WALKING 0x0080 (128)
		// I was expecting to see buf = 4224 (4096 + 128)
		// but buf equals 4230 = 4096 + 134 (128 + 6) see above
		// So this works as well
		// Do not hard code values like this. It's just for testing purposes.
		// if (buf == 4230) runningstate=TRUE; else runningstate=FALSE;
		if (buf & AGENT_ALWAYS_RUN && buf & AGENT_WALKING) runningstate=TRUE; else runningstate=FALSE;
		// Be careful about uncommenting out the line below as it well be VERY SPAMMY!!!
		// llOwnerSay((string) buf);
		//True = 1 so 100% visible. False = 0 so 100% invisible
		llSetLinkAlpha(LINK_SET,runningstate,ALL_SIDES);
	}
}
