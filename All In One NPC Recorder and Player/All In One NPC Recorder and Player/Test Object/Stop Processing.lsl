// :SHOW:1
// :CATEGORY:NPC
// :NAME:All In One NPC Recorder and Player
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-07-17 13:16:10
<<<<<<< HEAD
// :EDITED:2016-07-10  09:24:25
=======
>>>>>>> f0df6f03553fbf82e10f35590fcf71af838ab4be
// :ID:27
// :NUM:1809
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// sample Stop processing script for NPC
// :CODE:

default
{
	state_entry() {
		llSetText("Click to make the NPC stop processing commands",<1,1,1>,1.0);
	}

	touch_start(integer total_number)
	{
		llMessageLinked(LINK_ROOT,0, "@stop","");
	}
}
