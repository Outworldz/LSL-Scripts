// :SHOW:1
// :CATEGORY:NPC
// :NAME:All In One NPC Recorder and Player
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2015-07-17 13:16:29
<<<<<<< HEAD
// :EDITED:2016-07-10  09:24:25
=======
>>>>>>> f0df6f03553fbf82e10f35590fcf71af838ab4be
// :ID:27
// :NUM:1810
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// Sample touch to go script for all in one NPC animator
// :CODE:

default
{
	state_entry() {
		llSetText("Click to make the NPC continue processing commands",<1,1,1>,1.0);
	}

	touch_start(integer total_number)
	{
		llMessageLinked(LINK_ROOT,0, "@go","");
	}
}
