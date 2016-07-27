// :SHOW:1
// :CATEGORY:NPC
// :NAME:All In One NPC Recorder and Player
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-07-17 13:15:49
<<<<<<< HEAD
// :EDITED:2016-07-10  09:24:25
=======
>>>>>>> f0df6f03553fbf82e10f35590fcf71af838ab4be
// :ID:27
// :NUM:1808
// :REV:3
// :WORLD:Second Life
// :DESCRIPTION:
// Sample collision script for NPC animator
// :CODE:
// rev 3: added on_rez()  and STATUS_PHANTOM to state_entry - otherwise reset on Linux boxes did no collide any more.
default
{
	state_entry()
	{
		llSetStatus(STATUS_PHANTOM,FALSE);
		llVolumeDetect(FALSE);
		llSleep(0.1);
		llVolumeDetect(TRUE);
	}

	collision_start(integer n) {
		llMessageLinked(LINK_SET,0, "@animate=someanimation|10","");
		llSetTimerEvent(5);
	}
	timer()
	{
		llMessageLinked(LINK_SET,0, "@animate=Stand|1","");
		llSetTimerEvent(0);
	}

	changed(integer what)
	{
		if (what & CHANGED_REGION_START)
		{
			llResetScript();
		}
	}
	on_rez(integer p)
	{
		llResetScript();
	}
}
